import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:valueappz_feature_component/src/model/device_info.dart';
import 'package:valueappz_feature_component/src/model/store_response_model.dart';
import 'package:valueappz_feature_component/src/sharedpreference/SharedPrefs.dart';
import 'package:valueappz_feature_component/src/utils/app_constants.dart';

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

  static Future<PackageInfo> getAppVersionDetails(
      StoreResponse storeData) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    SharedPrefs.storeSharedValue(AppConstants.appName, packageInfo.appName);
    SharedPrefs.storeSharedValue(
        AppConstants.old_appverion, packageInfo.version);

    return packageInfo;
  }

  static void getDeviceInfo(StoreResponse storeData) async {
    DeviceInfoPlugin deviceInfo = await DeviceInfoPlugin();
    PackageInfo packageInfo = await AppUtils.getAppVersionDetails(storeData);
    String deviceId =
        await SharedPrefs.getStoreSharedValue(AppConstants.deviceId);
    String deviceToken =
        await SharedPrefs.getStoreSharedValue(AppConstants.deviceToken);
    Map<String, dynamic> param = Map();
    param['app_version'] = packageInfo.version;
    param['device_id'] = deviceId;
    param['device_token'] = deviceToken;
    if (Platform.isAndroid) {
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
    if (Platform.isIOS) {
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
    DeviceInfo.getInstance(deviceInfo: param);
  }
}
