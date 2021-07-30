import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/src/model/config_model.dart';
import 'package:marketplace_service_provider/src/model/store_response_model.dart';
import 'package:marketplace_service_provider/src/network/app_network_repository.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';

import 'src/components/authentication/login/login_screen.dart';
import 'src/components/authentication/signUp/registration_complete_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialization of shared preferences
  await AppSharedPref.instance.init();

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AppConstants.isLoggedIn = AppSharedPref.instance.isLoggedIn();
  await AppSharedPref.instance
      .setDevicePlatform(Platform.isIOS ? AppConstants.iOS : 'Android');

  String jsonResult = await loadAsset();
  final parsed = json.decode(jsonResult);
  ConfigModel configObject = ConfigModel.fromJson(parsed);

  if (Platform.isIOS) {
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    await AppSharedPref.instance.setDeviceId(iosDeviceInfo.identifierForVendor);
  } else {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    await AppSharedPref.instance.setDeviceId(androidDeviceInfo.androidId);
  }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await AppUtils.getDeviceInfo();
  String token = await FirebaseMessaging.instance.getAPNSToken();

  bool isNetWorkAvailable = await AppUtils.isNetworkAvailable();
  if (isNetWorkAvailable) {
    StoreResponse storeData =
        await AppNetworkRepository.instance.versionApi(configObject.storeId);
    runApp(MyApp());
  } else {
    runApp(NoNetworkApp());
  }
}

class NoNetworkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return getMaterialApp(Scaffold(body: NoNetworkClass()));
  }
}

class NoNetworkClass extends StatefulWidget {
  @override
  _NoNetworkClassState createState() => _NoNetworkClassState();
}

class _NoNetworkClassState extends BaseState<NoNetworkClass> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _noNetWorkDialog();
    });
  }

  @override
  Widget builder(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              AppConstants.staticSplash,
            ),
            fit: BoxFit.fill),
      ),
    );
  }

  void _noNetWorkDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Alert"),
        content: Text("No intenet connection"),
        actions: <Widget>[
          TextButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return getMaterialApp(LoginScreen());
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
