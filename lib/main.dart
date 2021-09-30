import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_plugin/flutter_notification_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/dashboard_screen.dart';
import 'package:marketplace_service_provider/src/components/login/ui/login_screen.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/placemark_model.dart';
import 'package:marketplace_service_provider/src/components/side_menu/model/duty_status_observer.dart';
import 'package:marketplace_service_provider/src/components/version_api/repository/version_repository.dart';
import 'package:marketplace_service_provider/src/model/app_theme_color.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/model/config_model.dart';
import 'package:marketplace_service_provider/src/model/store_response_model.dart';
import 'package:marketplace_service_provider/src/notification/notification_service.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/utils/callbacks.dart';
import 'package:marketplace_service_provider/src/widgets/no_network_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'core/dimensions/size_config.dart';
import 'core/dimensions/size_custom_config.dart';
import 'core/network/connectivity/network_connection_observer.dart';
import 'src/components/dashboard/repository/dashboard_repository.dart';
import 'src/components/login/model/login_response.dart';
import 'src/singleton/singleton_service_locations.dart';
import 'src/singleton/store_config_singleton.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'isolate';
const String isolateName2 = 'isolate2';

/// A port used to communicate from a background isolate to the UI isolate.
final ReceivePort port = ReceivePort();
final ReceivePort port2 = ReceivePort();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterNotificationPlugin.stopForegroundService();
  initAlarm();
  initReminderAlarm();
  serviceLocator();
  //initialization of shared preferences
  await AppSharedPref.instance.init();
  await Firebase.initializeApp();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  NotificationService.initialize(_navigatorKey);

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AppConstants.isLoggedIn = await AppSharedPref.instance.isLoggedIn();
  if (AppConstants.isLoggedIn) {
    getIt
        .get<DutyStatusObserver>()
        .changeStatus(AppSharedPref.instance.getDutyStatus());
  }
  if (kIsWeb) {
    await AppSharedPref.instance.setDevicePlatform(AppConstants.web);
  } else {
    if (Platform.isAndroid) {
      await AppSharedPref.instance.setDevicePlatform(AppConstants.android);
    } else if (Platform.isIOS) {
      await AppSharedPref.instance.setDevicePlatform(AppConstants.iOS);
    }
  }
  String jsonResult = await loadAsset();
  final parsed = json.decode(jsonResult);
  ConfigModel configObject = ConfigModel.fromJson(parsed);
  StoreConfigurationSingleton.instance.configModel = configObject;

  if (kIsWeb) {
    await AppSharedPref.instance.setDeviceId("12345678");
  } else {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      await AppSharedPref.instance.setDeviceId(androidDeviceInfo.androidId);
    } else {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      await AppSharedPref.instance
          .setDeviceId(iosDeviceInfo.identifierForVendor);
    }
  }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await AppUtils.getDeviceInfo();

  if (!getIt.get<NetworkConnectionObserver>().offline) {
    StoreResponse storeResponse =
        await getIt.get<VersionAuthRepository>().versionApi();

    SingletonServiceLocations.instance.serviceLocationResponse =
        await getIt.get<VersionAuthRepository>().serviceLocationsApi();
    setStoreCurrency(storeResponse, configObject);
    setAppThemeColors(storeResponse.brand.appThemeColor);
    List<ForceDownload> forceDownload = storeResponse.brand.forceDownload;
    PackageInfo packageInfo = await AppUtils.getAppVersionDetails();
    String version = packageInfo.version;

    int index1 = version.lastIndexOf(".");
    //print("--substring--${version.substring(0,index1)} ");
    double currentVesrion = double.parse(version.substring(0, index1).trim());
    double apiVesrion = 1.0;
    try {
      if (Platform.isIOS) {
        apiVesrion = double.parse(
            forceDownload[0].iosAppVersion.substring(0, index1).trim());
      } else {
        apiVesrion = double.parse(
            forceDownload[0].androidAppVerison.substring(0, index1).trim());
      }
    } catch (e) {
      //print("-apiVesrion--catch--${e}----");
    }
    bool shouldForceUpdate = false;
    if (apiVesrion > currentVesrion) {
      shouldForceUpdate = true;
    } else {
      shouldForceUpdate = false;
    }
    runApp(MyApp(shouldForceUpdate, _navigatorKey));
  } else {
    runApp(NoNetworkApp(_navigatorKey));
  }
}

Future<void> initAlarm() async {
  await AppSharedPref.instance.init();
  AppConstants.isLoggedIn = await AppSharedPref.instance.isLoggedIn();
  //TODO: check user is login or not
  LocationPermission permissionStatus = await Geolocator.checkPermission();
  if (Platform.isAndroid &&
          AppConstants.isLoggedIn &&
          permissionStatus == LocationPermission.always ||
      permissionStatus == LocationPermission.whileInUse) {
    // Register the UI isolate's SendPort to allow for communication from the
    // background isolate.
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      isolateName,
    );
    await AndroidAlarmManager.initialize();
    // Register for events from the background isolate. These messages will
    // always coincide with an alarm firing.
    try {
      port.listen((_) async {
        print("-------port.listen-------------");
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        debugPrint("----getCurrentPosition----- $position");
        // await AppSharedPref.instance.isLoggedIn();
        // if (AppConstants.isLoggedIn) {
        //   LoginResponse loginResponse = LoginUserSingleton.instance.loginResponse;
        //   await getIt.get<DashboardRepository>().updateRunnerLatlng(
        //       userId: loginResponse.data.id,
        //       lat: '${position.latitude}',
        //       lng: '${position.longitude}',
        //       address: "address");
        // }
      });
    } catch (e) {
      print(e);
    }
    await AndroidAlarmManager.periodic(
        Duration(seconds: 20), 0, handleBackgroundFunction,
        rescheduleOnReboot: true, wakeup: true);
  }
}

Future<void> initReminderAlarm() async {
  bool isLoggedIn = await AppSharedPref.instance.isLoggedIn();
  print(
      "isAndroid ${Platform.isAndroid} IsLoggedIn $isLoggedIn IsReminderEnabled ${AppSharedPref.instance.isReminderAlarmEnabled()}");
  if (Platform.isAndroid && AppSharedPref.instance.isReminderAlarmEnabled()) {
    IsolateNameServer.registerPortWithName(
      port2.sendPort,
      isolateName2,
    );
    await AndroidAlarmManager.initialize();
    try {
      port.listen((_) async {
        print("-------port.listen-------------");
      });
    } catch (e) {
      print(e);
    }
    await AndroidAlarmManager.periodic(
        Duration(seconds: 20), 1, handleReminderAlarm,
        rescheduleOnReboot: true, wakeup: true);
  }
}

Future<void> handleReminderAlarm() async {
  uiSendPort2 ??= IsolateNameServer.lookupPortByName(isolateName2);
  uiSendPort2?.send("");
  print('handleReminderAlarm ${DateTime.now()}');
  AppConstants.isLoggedIn = await AppSharedPref.instance.isLoggedIn();
  if (AppConstants.isLoggedIn) {
    LoginResponse loginResponse = await AppSharedPref.instance.getUser();
    DashboardRepository repository = DashboardRepository();
    // fixme:: store is null here
    // String storeId = StoreConfigurationSingleton.instance.configModel.storeId;
    Map<String, dynamic> order = await repository.ordersCount(
        storeId: '1', userId: loginResponse.data.id);
    if (order != null && order["success"]) {
      if (order["order_count"] > 0) {
        startForegroundService(order["message"]);
      }
    }
  }
}

void startForegroundService(String message) async {
  // await FlutterNotificationPlugin.setServiceMethodInterval(seconds: 5);
  await FlutterNotificationPlugin.startForegroundService(
      holdWakeLock: false,
      onStarted: () {
        print("Foreground on Started");
      },
      onStopped: () {
        print("Foreground on Stopped");
      },
      title: "Booking Reminder",
      content: message,
      iconName: "ic_notification",
      stopAction: true,
      stopIcon: "ic_notification",
      stopText: "Dismiss",
      sound: 'order_recieved');
}

cancelReminderAlarm() async {
  if (Platform.isAndroid) AndroidAlarmManager.cancel(1);
  await FlutterNotificationPlugin.stopForegroundService();
}

cancelAllAlarm() {
  if (Platform.isAndroid) AndroidAlarmManager.cancel(0);
}

// The background
SendPort uiSendPort;
SendPort uiSendPort2;
//Only for use android Platform
Future<void> handleBackgroundFunction() async {
  await AppSharedPref.instance.init();
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  // if(LocationPermission.always==Geolocator.checkPermission()){
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  debugPrint("----getCurrentPosition----- $position");
  // This will be null if we're running in the background.
  uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
  uiSendPort?.send("");
  AppConstants.isLoggedIn = await AppSharedPref.instance.isLoggedIn();
  print(
      "======[$now]===== Hello, world! isolate=${isolateId} ${AppConstants.isLoggedIn}");
  if (AppConstants.isLoggedIn) {
    LoginResponse loginResponse = await AppSharedPref.instance.getUser();
    DashboardRepository repository = DashboardRepository();
    String address = 'N/A';
    try {
      PlacemarkModel placemarkModel =
          await AppUtils.getPlace(position.latitude, position.longitude);
      address = placemarkModel.address;
    } catch (e) {
      debugPrint(e);
    }
    BaseResponse baseResponse = await repository.updateRunnerLatlng(
        userId: loginResponse.data.id,
        lat: '${position.latitude}',
        lng: '${position.longitude}',
        address: address);
    if (baseResponse != null && baseResponse.success) {
      print(
          'getCurrentPosition ===reseResponse updating lat lng====${baseResponse}');
    }
  }

  // }
}

/*Setting Store Currency*/
void setStoreCurrency(StoreResponse storeResponse, ConfigModel configObject) {
  if (storeResponse.brand.showCurrency == "symbol") {
    if (storeResponse.brand.currency.isNotEmpty) {
      AppConstants.currency =
          AppUtils.removeAllHtmlTags(storeResponse.brand.currency);
    } else {
      AppConstants.currency = configObject.currency;
    }
  } else {
    if (storeResponse.brand.currency.isNotEmpty) {
      AppConstants.currency =
          AppUtils.removeAllHtmlTags(storeResponse.brand.currency);
    } else {
      AppConstants.currency = configObject.currency;
    }
  }
}

void setAppThemeColors(AppThemeColor appThemeColor) {
  AppTheme.primaryColor = AppUtils.colorGeneralization(
      AppTheme.primaryColor, appThemeColor.primaryColor);

  AppTheme.primaryColorDark = AppUtils.colorGeneralization(
      AppTheme.primaryColorDark, appThemeColor.primaryDarkColor);

  AppTheme.backgroundColor = AppUtils.colorGeneralization(
      AppTheme.backgroundColor, appThemeColor.backgroundColor);

  AppTheme.mainTextColor = AppUtils.colorGeneralization(
      AppTheme.mainTextColor, appThemeColor.mainTextColor);

  AppTheme.subHeadingTextColor = AppUtils.colorGeneralization(
      AppTheme.subHeadingTextColor, appThemeColor.subHeadingTextColor);

  AppTheme.optionTotalEarningColor = AppUtils.colorGeneralization(
      AppTheme.optionTotalEarningColor, appThemeColor.option1Color);

  AppTheme.optionTotalBookingBgColor = AppUtils.colorGeneralization(
      AppTheme.optionTotalBookingBgColor, appThemeColor.option2Color);

  AppTheme.optionTotalCustomerBgColor = AppUtils.colorGeneralization(
      AppTheme.optionTotalCustomerBgColor, appThemeColor.option2Color);

  AppTheme.errorRed =
      AppUtils.colorGeneralization(AppTheme.errorRed, appThemeColor.errorColor);
}

class MyApp extends StatelessWidget {
  GlobalKey<NavigatorState> navigatorKey;
  bool shouldForceUpdate = false;

  MyApp(this.shouldForceUpdate, this.navigatorKey);

  @override
  Widget build(BuildContext context) {
    return getMaterialApp(MainWidget(shouldForceUpdate), navigatorKey);
    // return getMaterialApp(LocationServiceChecking(), navigatorKey);
  }
}

class MainWidget extends StatefulWidget {
  bool shouldForceUpdate = false;

  MainWidget(this.shouldForceUpdate);

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  @override
  void initState() {
    super.initState();
    eventBus.on<AlarmEvent>().listen((event) {
      if (event.event == 'start') {
        initAlarm();
      } else if (event.event == 'cancel') {
        cancelAllAlarm();
      }
    });

    eventBus.on<ReminderAlarmEvent>().listen((event) {
      if (event.event == 'start') {
        initReminderAlarm();
      } else if (event.event == 'cancel') {
        cancelReminderAlarm();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeCustomConfig().init(AppUtils.getDeviceHeight(context),
        AppUtils.getDeviceWidth(context), Orientation.portrait);
    SizeConfig().init(context);
    return Scaffold(
        body: AppConstants.isLoggedIn
            ? DashboardScreen(shouldForceUpdate: widget.shouldForceUpdate)
            : LoginScreen(shouldForceUpdate: widget.shouldForceUpdate));
  }
}

getMaterialApp(
  dynamic child,
  GlobalKey<NavigatorState> navigatorKey,
) {
  return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      navigatorKey: navigatorKey,
      theme: AppTheme.theme,
      home: child);
}

Future<String> loadAsset() async {
  return await rootBundle.loadString(AppConstants.configFile);
}

class NoNetworkApp extends StatelessWidget {
  GlobalKey<NavigatorState> navigatorKey;

  NoNetworkApp(this.navigatorKey);

  @override
  Widget build(BuildContext context) {
    return getMaterialApp(Scaffold(body: NoNetworkClass()), navigatorKey);
  }
}
