import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
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
import 'src/singleton/store_config_singleton.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  serviceLocator();
  //initialization of shared preferences
  await AppSharedPref.instance.init();

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AppConstants.isLoggedIn = AppSharedPref.instance.isLoggedIn();
  await AppSharedPref.instance
      .setDevicePlatform(Platform.isIOS ? AppConstants.iOS : 'Android');

  String jsonResult = await loadAsset();
  final parsed = json.decode(jsonResult);
  ConfigModel configObject = ConfigModel.fromJson(parsed);
  StoreConfigurationSingleton.instance.configModel = configObject;
  if (Platform.isIOS) {
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    await AppSharedPref.instance.setDeviceId(iosDeviceInfo.identifierForVendor);
  } else {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    await AppSharedPref.instance.setDeviceId(androidDeviceInfo.androidId);
  }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await AppUtils.getDeviceInfo();
  if (!getIt.get<NetworkConnectionObserver>().offline) {
    await getIt.get<VersionAuthRepository>().versionApi();
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
    return Scaffold(body: LoginScreen());
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
