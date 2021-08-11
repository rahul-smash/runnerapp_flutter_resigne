import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marketplace_service_provider/src/model/device_info.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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

  static loadImageFromUrl(String imgURL){

    return Image.network(imgURL, fit: BoxFit.cover,width: 100,height: 100,
      loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
        if (loadingProgress == null)
          return Container();
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null ?
            loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                : null,
          ),
        );
      },
    );
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
      param['platform'] = 'web';
    }else{
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
        themeData: Theme.of(context)
            .copyWith(accentColor: AppTheme.primaryColor),
        overlayColor: Color(0x99E8EAF6));
  }

  static void hideLoader(BuildContext context) {
    Loader.hide();
  }

  static bool equalsIgnoreCase(String string1, String string2) {
    return string1?.toLowerCase() == string2?.toLowerCase();
  }
  static Widget showSpinner() {
    return Center(
      child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(
              AppTheme.theme.primaryColor)),
    );
  }

  static Future<DateTime> selectDate(
      BuildContext context, {
        bool isStartIndex,
        bool isEndIndex,
      }) async {
    DateTime selectedDate = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        currentDate: DateTime.now(),
        firstDate: DateTime(1970, 1),
        lastDate: DateTime.now()
    );
    print(picked);
    if (picked != null)
      //dayName = DateFormat('DD-MM-yyyy').format(selectedDate);
      return picked;
  }
  static getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
  }

  static Future<TimeOfDay> selectTime(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay.now();
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });
    if (picked_s != null && picked_s != selectedTime )
      selectedTime = picked_s;
    return selectedTime;
  }

}
