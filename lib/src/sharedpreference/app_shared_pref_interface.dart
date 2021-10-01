abstract class AppSharePrefInterface {
  Future<bool> setUserMobileNumber(String mobileNumber);

  String getUserMobileNumber();

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

  Future<bool> setDutyStatus(String status);

  String getDutyStatus();

  Future<bool> setReminderAlarm(bool status);

  bool isReminderAlarmEnabled();

  Future<bool> setUserId(String userId);

  String getUserId();

  Future<bool> setUserName(String userName);

  String getUserName();

  Future<bool> setUserLastName(String userLastName);

  String getUserLastName();

  Future<bool> setUserEmail(String userEmail);

  String getUserEmail();

  Future<bool> setUserRating(String userRating);

  String getUserRating();

  Future<bool> setUserProfileImage(String userImage);

  String getUserProfileImage();

  Future<bool> setLocationId(String locationId);

  String getLocationId();
}
