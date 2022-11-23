import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
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
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notification_plugin/flutter_notification_plugin.dart';

// import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/provider/booking_provider.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/dashboard_screen.dart';
import 'package:marketplace_service_provider/src/components/login/ui/login_screen.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/placemark_model.dart';
import 'package:marketplace_service_provider/src/components/side_menu/model/duty_status_observer.dart';
import 'package:marketplace_service_provider/src/components/version_api/repository/version_repository.dart';
import 'package:marketplace_service_provider/src/model/app_theme_color.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/model/config_model.dart';
import 'package:marketplace_service_provider/src/model/store_response_model.dart';
import 'package:marketplace_service_provider/src/network/add%20product/app_network.dart';
import 'package:marketplace_service_provider/src/notification/notification_service.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/utils/callbacks.dart';
import 'package:marketplace_service_provider/src/widgets/no_network_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/dimensions/size_config.dart';
import 'core/dimensions/size_custom_config.dart';
import 'core/network/connectivity/network_connection_observer.dart';
import 'src/components/dashboard/model/reminder_order_count_response.dart';
import 'src/components/dashboard/repository/dashboard_repository.dart';
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

const platform = MethodChannel('ios/locationUpdate');

const pushChannel = MethodChannel('pushMethod');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await FlutterNotificationPlugin.stopForegroundService();
    initAlarm();
    initReminderAlarm();
  } else if (Platform.isIOS) {
    initAlarm();
    initReminderAlarm();
  }
  serviceLocator();
  //initialization of shared preferences
  await AppSharedPref.instance.init();
  AppNetwork.init();
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  await Firebase.initializeApp();

  if (Platform.isAndroid) {
    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    NotificationService.initialize(_navigatorKey);
  }

  firebaseCloudMessagingListeners();

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
      await AppSharedPref.instance.setDeviceId(androidDeviceInfo.id);
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

    // SingletonServiceLocations.instance.serviceLocationResponse = await getIt.get<VersionAuthRepository>().serviceLocationsApi();
    setStoreCurrency(storeResponse, configObject);
    // fixme:: app dynamic colors
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
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider<BookingProvider>(create: (_) => BookingProvider()),
    ], child: MyApp(shouldForceUpdate, _navigatorKey)));
  } else {
    runApp(NoNetworkApp(_navigatorKey));
  }
}

void firebaseCloudMessagingListeners() {
  // var android = new AndroidInitializationSettings('drawable/ic_notification');
  // var ios = new IOSInitializationSettings();
  // var platform = new InitializationSettings(android: android,iOS: ios);
  // flutterLocalNotificationsPlugin.initialize(platform);

  //Getting the token from FCM
  FirebaseMessaging.instance.getToken().then((token) {
    print("this is tokennnnnnnnnnnnnn $token");
  });

  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: false,
  );
}

Future<void> initAlarm() async {
  await AppSharedPref.instance.init();
  AppConstants.isLoggedIn = await AppSharedPref.instance.isLoggedIn();
  //TODO: check user is login or not
  LocationPermission permissionStatus = await Geolocator.checkPermission();

  print(permissionStatus);

  if (permissionStatus == LocationPermission.denied ||
      permissionStatus == LocationPermission.deniedForever) {
    await GeolocatorPlatform.instance.requestPermission();

    initAlarm();
  }

  if (AppConstants.isLoggedIn &&
          permissionStatus == LocationPermission.always ||
      permissionStatus == LocationPermission.whileInUse) {
    print('===isLoggedIn===and =permissionStatus=always=whileInUse');
    _locationTimer();
    // Register the UI isolate's SendPort to allow for communication from the
    // background isolate.
    /*IsolateNameServer.registerPortWithName(
      port.sendPort,
      isolateName,
    );
    if (Platform.isAndroid) {
      await AndroidAlarmManager.initialize();
      try {
        port.listen((_) async {
          print("-------port.listen-------------");
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          debugPrint("----getCurrentPosition----- $position");

        });
      } catch (e) {
        print(e);
      }

      await AndroidAlarmManager.periodic(
          Duration(seconds: 20), 0, handleBackgroundFunction,
          rescheduleOnReboot: true, wakeup: true);
    }
    // Register for events from the background isolate. These messages will
    // always coincide with an alarm firing.
    else if (Platform.isIOS) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      debugPrint("----getCurrentPosition----- $position");
      Timer.periodic(
          Duration(seconds: 15), (Timer t) => handleBackgroundFunction());
    }*/
  }
}

Future<void> initReminderAlarm() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.reload();
  bool isLoggedIn =
      pref.getBool(AppSharePrefConstants.prefKeyIsLoggedIn) ?? false;
  bool isReminderAlarmEnabled =
      pref.getBool(AppSharePrefConstants.prefKeyAppReminderAlarm) ?? false;

  if (Platform.isAndroid && isLoggedIn && isReminderAlarmEnabled) {
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
        Duration(seconds: 90), 1, handleReminderAlarm,
        rescheduleOnReboot: true, wakeup: true);
  } else if (Platform.isIOS && isLoggedIn) {
    IsolateNameServer.registerPortWithName(
      port2.sendPort,
      isolateName2,
    );

    try {
      port.listen((_) async {
        print("-------port.listen-------------");
      });
    } catch (e) {
      print(e);
    }

    Timer.periodic(Duration(seconds: 90), (Timer t) => handleReminderAlarm());
  }
}

Future<void> handleReminderAlarm() async {
  uiSendPort2 ??= IsolateNameServer.lookupPortByName(isolateName2);
  uiSendPort2?.send("");
  print('handleReminderAlarm ${DateTime.now()}');
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.reload();
  AppConstants.isLoggedIn =
      pref.getBool(AppSharePrefConstants.prefKeyIsLoggedIn) ?? false;
  if (AppConstants.isLoggedIn) {
    String userId = pref.getString(AppSharePrefConstants.prefKeyAppUserId);
    DashboardRepository repository = DashboardRepository();
    ConfigModel configModel = await getConfigureModel();
    ReminderOrderCountResponse reminderResponse = await repository.ordersCount(
        storeId: configModel.storeId, userId: userId);
    if (reminderResponse != null && reminderResponse.success) {
      if (int.parse(reminderResponse.orderCountManual) > 0 ||
          int.parse(reminderResponse.orderCountAuto) > 0) {
        if (Platform.isIOS) {
          pushChannel.invokeMethod('pushParams', [1]);
        } else if (Platform.isAndroid) {
          startForegroundService('You have pending orders');
          if (eventBus != null) eventBus.fire(RefreshEvent());
        }
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

dismissReminderAlarm() async {
  // await FlutterNotificationPlugin.setServiceMethod(serviceMethod);
}

cancelAllAlarm() {
  if (Platform.isAndroid) AndroidAlarmManager.cancel(0);
}

Future<void> _getLocationIOS() async {
  String locationIOSCurrent;
  try {
    final List<Object> result =
        await platform.invokeMethod('getLocationBackground');
    print(result);
    locationIOSCurrent = 'Location current $result % .';
  } on PlatformException catch (e) {
    locationIOSCurrent = "Failed to get location: '${e.message}'.";
  }
  print(locationIOSCurrent);
}

Timer _timer;

void _locationTimer() {
  var duration = Duration(seconds: 20);
  _timer = new Timer.periodic(
    duration,
    (Timer timer) {
      handleBackgroundFunction();
    },
  );
}

// The background
SendPort uiSendPort;
SendPort uiSendPort2;
//Only for use android Platform
Future<void> handleBackgroundFunction() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.reload();
  //final DateTime now = DateTime.now();
  //final int isolateId = Isolate.current.hashCode;
  // if(LocationPermission.always==Geolocator.checkPermission()){
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  debugPrint("----getCurrentPosition----- $position");
  // This will be null if we're running in the background.
  //uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
  //uiSendPort?.send("");
  // AppConstants.isLoggedIn = await AppSharedPref.instance.isLoggedIn();
  AppConstants.isLoggedIn =
      pref?.getBool(AppSharePrefConstants.prefKeyIsLoggedIn) ?? false;
  print("==isLoggedIn== ${AppConstants.isLoggedIn}");
  if (AppConstants.isLoggedIn) {
    // String userId = AppSharedPref.instance.getUserId();
    String userId = pref?.getString(AppSharePrefConstants.prefKeyAppUserId);
    DashboardRepository repository = DashboardRepository();
    String address = 'N/A';
    try {
      PlacemarkModel placemarkModel =
          await AppUtils.getPlace(position.latitude, position.longitude);
      address = placemarkModel.address;
    } catch (e) {
      debugPrint(e);
    }
    ConfigModel configModel = await getConfigureModel();

    BaseResponse baseResponse = await repository.updateRunnerLatlng(
        userId: userId,
        lat: '${position.latitude}',
        lng: '${position.longitude}',
        address: address,
        storeID: configModel.storeId);
    if (baseResponse != null && baseResponse.success) {
      print(
          'user id ${userId} getCurrentPosition ===reseResponse updating lat lng==== ${baseResponse}');
    }
  }
}

Future<ConfigModel> getConfigureModel() async {
  String jsonResult = await loadAsset();
  final parsed = json.decode(jsonResult);
  ConfigModel configObject = ConfigModel.fromJson(parsed);
  return configObject;
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
      if (Platform.isAndroid) {
        if (event.event == 'start') {
          initAlarm();
        } else if (event.event == 'cancel') {
          cancelAllAlarm();
        }
      }
    });

    eventBus.on<ReminderAlarmEvent>().listen((event) {
      if (Platform.isAndroid) {
        if (event.event == ReminderAlarmEvent.start) {
          initReminderAlarm();
        } else if (event.event == ReminderAlarmEvent.cancel) {
          cancelReminderAlarm();
        } else if (event.event == ReminderAlarmEvent.notificationDismiss) {
          dismissReminderNotification();
        }
      }
    });
  }

  void dismissReminderNotification() async {
    await FlutterNotificationPlugin.stopForegroundService();
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
      builder: EasyLoading.init(),
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
