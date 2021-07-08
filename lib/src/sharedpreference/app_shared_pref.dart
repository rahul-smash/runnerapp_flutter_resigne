import 'package:valueappz_feature_component/core/sharedpreference/base_shared_pref.dart';
import 'package:valueappz_feature_component/src/sharedpreference/app_shared_pref_constants.dart';
import 'package:valueappz_feature_component/src/sharedpreference/app_shared_pref_interface.dart';

class AppSharedPref extends BaseSharedPreference
    implements AppSharePrefInterface {
  static AppSharedPref _instance;

  AppSharedPref._();

  static AppSharedPref get instance => _instance ??= AppSharedPref._();

  @override
  String getMobileNumber() {
    return sharepref?.getString(AppSharePrefConstants.prefKeyMobile);
  }

  @override
  Future<bool> setMobileNumber(String deviceToken) async {
    return await sharepref?.setString(
        AppSharePrefConstants.prefKeyMobile, deviceToken);
  }

  @override
  String getDeviceId() {
    return sharepref?.getString(AppSharePrefConstants.prefKeyDeviceId);
  }

  @override
  Future<bool> setDeviceId(String deviceId) async {
    return await sharepref?.setString(
        AppSharePrefConstants.prefKeyDeviceId, deviceId);
  }

  @override
  bool isLoggedIn() {
    return sharepref?.getBool(AppSharePrefConstants.prefKeyIsLoggedIn) ?? false;
  }

  @override
  Future<bool> setLoggedIn(bool value) async {
    return await sharepref?.setBool(
        AppSharePrefConstants.prefKeyIsLoggedIn, value);
  }

  @override
  bool isAdminLogin() {
    return sharepref?.getBool(AppSharePrefConstants.prefKeyIsAdminLogin) ??
        false;
  }

  @override
  Future<bool> setAdminLogin(bool value) async {
    return await sharepref?.setBool(
        AppSharePrefConstants.prefKeyIsAdminLogin, value);
  }

  @override
  String getApiVersion() {
    return sharepref?.getString(AppSharePrefConstants.prefKeyApiVersion);
  }

  @override
  Future<bool> setApiVersion(String apiVersion) async {
    return await sharepref?.setString(
        AppSharePrefConstants.prefKeyApiVersion, apiVersion);
  }

  @override
  String getAppName() {
    return sharepref?.getString(AppSharePrefConstants.prefKeyAppName);
  }

  @override
  Future<bool> setAppName(String appName) async {
    return await sharepref?.setString(
        AppSharePrefConstants.prefKeyAppName, appName);
  }

  @override
  String getAppVersion() {
    return sharepref?.getString(AppSharePrefConstants.prefKeyAppVersion);
  }

  @override
  Future<bool> setAppVersion(String appVersion) async {
    return await sharepref?.setString(
        AppSharePrefConstants.prefKeyAppVersion, appVersion);
  }
}
