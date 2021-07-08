import 'package:shared_preferences/shared_preferences.dart';
import 'package:valueappz_feature_component/core/sharedpreference/base_shared_pref_constants.dart';
import 'package:valueappz_feature_component/core/sharedpreference/base_shared_pref_interface.dart';

abstract class BaseSharedPreference implements BaseSharedPrefInterface {
  SharedPreferences sharepref;

  Future<void> init() async {
    sharepref ??= await SharedPreferences.getInstance();
  }

  @override
  String getDeviceToken() {
    return sharepref?.getString(BaseSharedPrefConstants.prefKeyDeviceToken);
  }

  @override
  Future<bool> setDeviceToken(String deviceToken) async {
    return await sharepref?.setString(
        BaseSharedPrefConstants.prefKeyDeviceToken, deviceToken);
  }

  @override
  String getDevicePlatform() {
    return sharepref?.getString(BaseSharedPrefConstants.prefKeyDevicePlatform);
  }

  @override
  Future<bool> setDevicePlatform(String devicePlatform) async {
    return await sharepref?.setString(
        BaseSharedPrefConstants.prefKeyDevicePlatform, devicePlatform);
  }
}
