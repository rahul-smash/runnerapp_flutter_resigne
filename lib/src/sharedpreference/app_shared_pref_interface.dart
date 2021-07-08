abstract class AppSharePrefInterface {
  Future<bool> setMobileNumber(String mobileNumber);

  String getMobileNumber();

  Future<bool> setDeviceId(String deviceId);

  String getDeviceId();

  Future<bool> setLoggedIn(bool value);

  bool isLoggedIn();

  Future<bool> setAdminLogin(bool value);

  bool isAdminLogin();

  Future<bool> setApiVersion(String apiVersion);

  String getApiVersion();

  Future<bool> setAppName(String appName);

  String getAppName();

  Future<bool> setAppVersion(String appVersion);

  String getAppVersion();
}
