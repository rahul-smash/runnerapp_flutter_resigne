import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/dashboard_screen.dart';
import 'package:marketplace_service_provider/src/components/login/ui/login_screen.dart';
import 'package:marketplace_service_provider/src/components/side_menu/model/duty_status_observer.dart';
import 'package:marketplace_service_provider/src/components/version_api/repository/version_repository.dart';
import 'package:marketplace_service_provider/src/model/config_model.dart';
import 'package:marketplace_service_provider/src/model/store_response_model.dart';
import 'package:marketplace_service_provider/src/notification/notification_service.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/location_service_checking.dart';
import 'package:marketplace_service_provider/src/widgets/no_network_widget.dart';
import 'core/dimensions/size_config.dart';
import 'core/dimensions/size_custom_config.dart';
import 'core/network/connectivity/network_connection_observer.dart';
import 'src/singleton/singleton_service_locations.dart';
import 'src/singleton/store_config_singleton.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

class MainWidget extends StatelessWidget {
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
