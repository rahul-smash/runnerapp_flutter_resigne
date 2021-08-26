import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/dashboard_screen.dart';
import 'package:marketplace_service_provider/src/components/login/ui/login_screen.dart';
import 'package:marketplace_service_provider/src/components/side_menu/model/duty_status_observer.dart';
import 'package:marketplace_service_provider/src/components/version_api/repository/version_repository.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'core/dimensions/size_config.dart';
import 'core/dimensions/size_custom_config.dart';
import 'core/network/connectivity/network_connection_observer.dart';
import 'src/components/dashboard/repository/dashboard_repository.dart';
import 'src/components/login/model/login_response.dart';
import 'src/singleton/login_user_singleton.dart';
import 'src/singleton/singleton_service_locations.dart';
import 'src/singleton/store_config_singleton.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'isolate';

/// A port used to communicate from a background isolate to the UI isolate.
final ReceivePort port = ReceivePort();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initAlarm();
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
    runApp(MyApp(_navigatorKey));
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

cancelAllAlarm() {
  if (Platform.isAndroid) AndroidAlarmManager.cancel(0);
}

// The background
SendPort uiSendPort;
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
    BaseResponse baseResponse = await repository.updateRunnerLatlng(
        userId: loginResponse.data.id,
        lat: '${position.latitude}',
        lng: '${position.longitude}',
        address: "address");
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

class MyApp extends StatelessWidget {
  GlobalKey<NavigatorState> navigatorKey;

  MyApp(this.navigatorKey);

  @override
  Widget build(BuildContext context) {
    return getMaterialApp(MainWidget(), navigatorKey);
    // return getMaterialApp(LocationServiceChecking(), navigatorKey);
  }
}

class MainWidget extends StatefulWidget {
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
  }

  @override
  Widget build(BuildContext context) {
    SizeCustomConfig().init(AppUtils.getDeviceHeight(context),
        AppUtils.getDeviceWidth(context), Orientation.portrait);
    SizeConfig().init(context);
    return Scaffold(
        body: AppConstants.isLoggedIn ? DashboardScreen() : LoginScreen());
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
