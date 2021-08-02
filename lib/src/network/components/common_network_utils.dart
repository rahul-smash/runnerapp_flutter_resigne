import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';

class CommonNetworkUtils{

  CommonNetworkUtils();

  Map<String, dynamic> getDeviceParams(){
    String deviceId = AppSharedPref.instance.getDeviceId();
    String deviceToken = AppSharedPref.instance.getDeviceToken();
    String platform = AppSharedPref.instance.getDevicePlatform();

    Map<String, dynamic> param = {
      'device_id': deviceId,
      'device_token': deviceToken,
      'platform': platform
    };
    return param;
  }


}