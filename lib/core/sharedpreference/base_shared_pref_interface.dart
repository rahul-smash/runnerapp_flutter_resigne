abstract class BaseSharedPrefInterface {
  Future<bool> setDeviceToken(String deviceToken);

  String getDeviceToken();

  Future<bool> setDevicePlatform(String devicePlatform);

  String getDevicePlatform();
}
