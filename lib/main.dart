import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:valueappz_feature_component/src/model/config_model.dart';
import 'package:valueappz_feature_component/src/model/store_response_model.dart';
import 'package:valueappz_feature_component/src/network/app_network_repository.dart';
import 'package:valueappz_feature_component/src/sharedpreference/SharedPrefs.dart';
import 'package:valueappz_feature_component/src/utils/app_constants.dart';
import 'package:valueappz_feature_component/src/utils/app_theme.dart';
import 'package:valueappz_feature_component/src/utils/app_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AppConstants.isLoggedIn = await SharedPrefs.isUserLoggedIn();

  bool isAdminLogin = false;
  String jsonResult = await loadAsset();
  final parsed = json.decode(jsonResult);
  ConfigModel configObject = ConfigModel.fromJson(parsed);
  if (Platform.isIOS) {
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    SharedPrefs.storeSharedValue(
        AppConstants.deviceId, iosDeviceInfo.identifierForVendor);
  } else {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    SharedPrefs.storeSharedValue(
        AppConstants.deviceId, androidDeviceInfo.androidId);
  }

  if (configObject.isGroceryApp == "true") {
    AppConstants.isRestroApp = false;
  } else {
    AppConstants.isRestroApp = true;
  }

  String branch_id =
      await SharedPrefs.getStoreSharedValue(AppConstants.branch_id);
  if (branch_id == null || branch_id.isEmpty) {
  } else if (branch_id.isNotEmpty) {
    configObject.storeId = branch_id;
  }
  //print(configObject.storeId);

  Crashlytics.instance.enableInDevMode = true;
  StoreResponse storeData =
      await AppNetworkRepository.instance.versionApi(configObject.storeId);
  setAppThemeColors(storeData.store);
  // Pass all uncaught errors to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  SharedPrefs.storeSharedValue(AppConstants.isAdminLogin, "${isAdminLogin}");

  PackageInfo packageInfo = await AppUtils.getAppVersionDetails(storeData);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await AppUtils.getDeviceInfo(storeData);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

void setAppThemeColors(StoreModel store) {
  AppThemeColors appThemeColors = store.appThemeColors;
  AppTheme.primaryColor = Color(int.parse(appThemeColors.appThemeColor));
  AppTheme.primaryColorLight = AppTheme.primaryColor.withOpacity(0.1);

  AppTheme.leftMenuHeaderBackground =
      Color(int.parse(appThemeColors.leftMenuHeaderBackgroundColor));
  AppTheme.leftMenuIconColors =
      Color(int.parse(appThemeColors.leftMenuIconColor));
  AppTheme.leftMenuBackgroundColor =
      Color(int.parse(appThemeColors.leftMenuBackgroundColor));
  AppTheme.leftMenuWelcomeTextColors =
      Color(int.parse(appThemeColors.leftMenuUsernameColor));
  AppTheme.leftMenuUsernameColors =
      Color(int.parse(appThemeColors.leftMenuUsernameColor));
  AppTheme.bottomBarIconColor =
      Color(int.parse(appThemeColors.bottomBarIconColor));
  AppTheme.bottomBarTextColor =
      Color(int.parse(appThemeColors.bottomBarTextColor));
  AppTheme.dotIncreasedColor =
      Color(int.parse(appThemeColors.dotIncreasedColor));
  AppTheme.bottomBarBackgroundColor =
      Color(int.parse(appThemeColors.bottom_bar_background_color));
  AppTheme.leftMenuLabelTextColors =
      Color(int.parse(appThemeColors.left_menu_label_Color));

  //flow
  if (store.webAppThemeColors != null) {
    WebAppThemeColors webAppThemeColors = store.webAppThemeColors;
    AppTheme.primaryColor = AppUtils.colorGeneralization(
        AppTheme.primaryColor, webAppThemeColors.webThemePrimaryColor);
    AppTheme.primaryColorLight = AppTheme.primaryColor.withOpacity(0.1);
    AppTheme.appThemeSecondary = AppUtils.colorGeneralization(
        AppTheme.appThemeSecondary, webAppThemeColors.webThemeSecondaryColor);

    AppTheme.dotIncreasedColor = AppTheme.appThemeSecondary;
    AppTheme.webThemeCategoryOpenColor = AppUtils.colorGeneralization(
        AppTheme.primaryColorLight,
        webAppThemeColors.webThemeCategoryOpenColor);
    AppTheme.stripsColor = AppUtils.colorGeneralization(
        AppTheme.stripsColor, webAppThemeColors.stripsColor);
    AppTheme.footerColor = AppUtils.colorGeneralization(
        AppTheme.footerColor, webAppThemeColors.footerColor);
    AppTheme.listingBackgroundColor = AppUtils.colorGeneralization(
        AppTheme.listingBackgroundColor,
        webAppThemeColors.listingBackgroundColor);
    AppTheme.listingBorderColor = AppUtils.colorGeneralization(
        AppTheme.listingBorderColor, webAppThemeColors.listingBorderColor);
    AppTheme.listingBoxBackgroundColor = AppUtils.colorGeneralization(
        AppTheme.listingBoxBackgroundColor,
        webAppThemeColors.listingBoxBackgroundColor);
    AppTheme.homeSubHeadingColor = AppUtils.colorGeneralization(
        AppTheme.homeSubHeadingColor, webAppThemeColors.homeSubHeadingColor);
    AppTheme.homeDescriptionColor = AppUtils.colorGeneralization(
        AppTheme.homeDescriptionColor, webAppThemeColors.homeDescriptionColor);
    AppTheme.categoryListingButtonBorderColor = AppUtils.colorGeneralization(
        AppTheme.categoryListingButtonBorderColor,
        webAppThemeColors.categoryListingButtonBorderColor);
    AppTheme.categoryListingBoxBackgroundColor = AppUtils.colorGeneralization(
        AppTheme.categoryListingBoxBackgroundColor,
        webAppThemeColors.categoryListingBoxBackgroundColor);

    AppTheme.bottomBarTextColor = AppUtils.colorGeneralization(
        AppTheme.bottomBarBackgroundColor, "#000000");
    AppTheme.bottomBarIconColor = AppTheme.primaryColor;
    AppTheme.bottomBarBackgroundColor = AppUtils.colorGeneralization(
        AppTheme.bottomBarBackgroundColor, "#ffffff");
    AppTheme.leftMenuLabelTextColors = AppUtils.colorGeneralization(
        AppTheme.leftMenuLabelTextColors, "#ffffff");
  } else {
    AppTheme.primaryColor = Color(int.parse(appThemeColors.appThemeColor));
    AppTheme.primaryColorLight = AppTheme.primaryColor.withOpacity(0.1);
  }
}

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/config/app_config.json');
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, @required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
