import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marketplace_service_provider/src/model/device_info.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:html/parser.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

appPrintLog(dynamic content) {
  if (AppConstants.isLoggerOn) print(content);
}

class AppUtils {
  static Color colorGeneralization(Color passedColor, String colorString) {
    Color returnedColor = passedColor;
    if (colorString != null) {
      try {
        returnedColor = Color(int.parse(colorString.replaceAll("#", "0xff")));
      } catch (e) {
        print(e);
      }
    }
    return returnedColor;
  }

  static Future<PackageInfo> getAppVersionDetails() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    AppSharedPref.instance.setAppName(packageInfo.appName);
    AppSharedPref.instance.setAppVersion(packageInfo.version);

    return packageInfo;
  }

  static void getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = await DeviceInfoPlugin();
    PackageInfo packageInfo = await AppUtils.getAppVersionDetails();
    String deviceId = AppSharedPref.instance.getDeviceId();
    String deviceToken = AppSharedPref.instance.getDeviceToken();
    Map<String, dynamic> param = Map();
    param['app_version'] = packageInfo.version;
    param['device_id'] = deviceId;
    param['device_token'] = deviceToken;
    if (kIsWeb) {
    } else {
      if (Platform.operatingSystem == "android") {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        param['device_brand'] = androidInfo.brand;
        param['device_model'] = androidInfo.model;
        param['device_os'] = androidInfo.version.sdkInt;
        param['device_os_version'] = androidInfo.version.sdkInt;

        param['platform'] = 'android';
        param['model'] = androidInfo.model;
        param['manufacturer'] = androidInfo.manufacturer;
        param['isPhysicalDevice'] = androidInfo.isPhysicalDevice;
        param['androidId'] = androidInfo.androidId;
        param['brand'] = androidInfo.brand;
        param['device'] = androidInfo.device;
        param['display'] = androidInfo.display;
        param['version_sdkInt'] = androidInfo.version.sdkInt;
        param['version_release'] = androidInfo.version.release;
      }
      if (Platform.operatingSystem == "ios") {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        param['device_brand'] = iosInfo.model;
        param['device_model'] = iosInfo.model;
        param['device_os'] = iosInfo.systemName;
        param['device_os_version'] = iosInfo.systemVersion;

        param['platform'] = 'ios';
        param['name'] = iosInfo.name;
        param['systemName'] = iosInfo.systemName;
        param['systemVersion'] = iosInfo.systemVersion;
        param['model'] = iosInfo.model;
        param['isPhysicalDevice'] = iosInfo.isPhysicalDevice;
        param['release'] = iosInfo.utsname.release;
        param['version'] = iosInfo.utsname.version;
        param['machine'] = iosInfo.utsname.machine;
      }
    }
    DeviceInfo.getInstance(deviceInfo: param);
  }

  static void showToast(String msg, bool shortLength) {
    try {
      if (shortLength) {
        Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppTheme.toastbgColor.withOpacity(0.9),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppTheme.toastbgColor.withOpacity(0.9),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    /*if (!regex.hasMatch(value))
      return true;
    else
      return false;*/
    return regex.hasMatch(value);
  }

  static double getDeviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getDeviceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static void showLoader(BuildContext context) {
    Loader.show(context,
        isAppbarOverlay: true,
        isBottomBarOverlay: true,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: Color(0xFFFF7443),
        ),
        themeData:
            Theme.of(context).copyWith(accentColor: AppTheme.primaryColor),
        overlayColor: Color(0x99E8EAF6));
  }

  static void hideLoader(BuildContext context) {
    Loader.hide();
  }

  static bool equalsIgnoreCase(String string1, String string2) {
    return string1?.toLowerCase() == string2?.toLowerCase();
  }

  static String removeAllHtmlTags(String htmlText) {
    try {
      var document = parse(htmlText);
      String parsedString = parse(document.body.text).documentElement.text;
      return parsedString;
    } catch (e) {
      print(e);
      return "";
    }
  }

  static String noNetWorkDialog(BuildContext context, {Function onPressed}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(labelErrorAlert),
        content: Text(labelErrorNoInternet),
        actions: <Widget>[
          TextButton(
              child: Text(labelOk),
              onPressed: onPressed ??
                  () {
                    Navigator.pop(context);
                  })
        ],
      ),
    );
  }

  static launchCaller(String call) async {
    String url = "tel:${call}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // ...somewhere in your Flutter app...
  static launchWhatsApp(String number) async {
    final link = WhatsAppUnilink(
      phoneNumber: number,
      text: "",
    );
    // Convert the WhatsAppUnilink instance to a string.
    // Use either Dart's string interpolation or the toString() method.
    // The "launch" method is part of "url_launcher".
    await launch('$link');
  }

  static launchMaps(String lat, String lng) async {
    String googleUrl = 'comgooglemaps://?center=${lat},${lng}';
    String appleUrl = 'https://maps.apple.com/?sll=${lat},${lng}';
    if (await canLaunch("comgooglemaps://")) {
      print('launching com googleUrl');
      await launch(googleUrl);
    } else if (await canLaunch(appleUrl)) {
      print('launching apple url');
      await launch(appleUrl);
    } else {
      throw 'Could not launch url';
    }
  }

  static Future<void> openMap(
      String latitude, String longitude) async {

    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (Platform.isIOS) {
      googleUrl = 'https://maps.apple.com/?q=$latitude,$longitude';
    }

    print("urlll ===> ${Uri.encodeFull(googleUrl)}");
    if (await canLaunch(Uri.encodeFull(googleUrl))) {
      print("launchedd");
      await launch(Uri.encodeFull(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }
}
