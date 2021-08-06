import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/dashboard_screen.dart';
import 'package:marketplace_service_provider/src/components/login/ui/login_screen.dart';
import 'package:marketplace_service_provider/src/components/version_api/repository/version_repository.dart';
import 'package:marketplace_service_provider/src/model/config_model.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/no_network_widget.dart';
import 'core/dimensions/size_config.dart';
import 'core/dimensions/size_custom_config.dart';
import 'core/network/connectivity/network_connection_observer.dart';
import 'src/singleton/singleton_service_locations.dart';
import 'src/singleton/store_config_singleton.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  serviceLocator();
  //initialization of shared preferences
  await AppSharedPref.instance.init();

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AppConstants.isLoggedIn = await AppSharedPref.instance.isLoggedIn();
  if (kIsWeb) {
    await AppSharedPref.instance.setDevicePlatform(AppConstants.web);
  }else{
    if(Platform.isAndroid){
      await AppSharedPref.instance.setDevicePlatform(AppConstants.android);
    }else if(Platform.isIOS){
      await AppSharedPref.instance.setDevicePlatform(AppConstants.iOS);
    }

  }
  String jsonResult = await loadAsset();
  final parsed = json.decode(jsonResult);
  ConfigModel configObject = ConfigModel.fromJson(parsed);
  StoreConfigurationSingleton.instance.configModel = configObject;

  if (kIsWeb) {
    await AppSharedPref.instance.setDeviceId("12345678");
  }else{
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      await AppSharedPref.instance.setDeviceId(androidDeviceInfo.androidId);
    } else {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      await AppSharedPref.instance.setDeviceId(iosDeviceInfo.identifierForVendor);
    }
  }


  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await AppUtils.getDeviceInfo();
  if (!getIt.get<NetworkConnectionObserver>().offline) {
    await getIt.get<VersionAuthRepository>().versionApi();
    SingletonServiceLocations.instance.serviceLocationResponse = await getIt.get<VersionAuthRepository>().serviceLocationsApi();
    runApp(MyApp());
  } else {
    runApp(NoNetworkApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return getMaterialApp(MainWidget());
  }
}

class MainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeCustomConfig().init(
        AppUtils.getDeviceHeight(context), AppUtils.getDeviceWidth(context), Orientation.portrait);
    SizeConfig().init(context);
    return Scaffold(body: AppConstants.isLoggedIn ? LoginScreen(): LoginScreen());
  }
}

getMaterialApp(dynamic child) {
  return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: AppTheme.theme,
      home: child);
}

Future<String> loadAsset() async {
  return await rootBundle.loadString(AppConstants.configFile);
}

class NoNetworkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return getMaterialApp(Scaffold(body: NoNetworkClass()));
  }
}
