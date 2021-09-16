import 'package:marketplace_service_provider/src/components/login/model/login_response.dart';

abstract class AppSharePrefInterface {
  Future<bool> setMobileNumber(String mobileNumber);

  String getMobileNumber();

  Future<bool> setDeviceId(String deviceId);

  String getDeviceId();

  Future<bool> setLoggedIn(bool value);

  Future<bool> isLoggedIn();

  Future<bool> setApiVersion(String apiVersion);

  String getApiVersion();

  Future<bool> setAppName(String appName);

  String getAppName();

  Future<bool> setAppVersion(String appVersion);

  String getAppVersion();

  Future<bool> setAppLanguage(String appLanguage);

  String getAppLanguage();

  Future<bool> saveUser(LoginResponse userJson);

  Future<bool> saveDutyStatus(String status);

  String getDutyStatus();

  Future<bool> setReminderAlarm(bool status);

  bool isReminderAlarmEnabled();
}
