import 'package:marketplace_service_provider/core/sharedpreference/base_shared_pref.dart';
import 'package:marketplace_service_provider/src/components/login/model/login_response.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref_constants.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref_interface.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';

class AppSharedPref extends BaseSharedPreference
    implements AppSharePrefInterface {
  static AppSharedPref _instance;

  AppSharedPref._();

  static AppSharedPref get instance => _instance ??= AppSharedPref._();

  @override
  String getUserMobileNumber() {
    return sharepref?.getString(AppSharePrefConstants.prefKeyUserMobile);
  }

  @override
  Future<bool> setUserMobileNumber(String mobileNumber) async {
    return await sharepref?.setString(
        AppSharePrefConstants.prefKeyUserMobile, mobileNumber);
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
  Future<bool> isLoggedIn() async {
    return sharepref?.getBool(AppSharePrefConstants.prefKeyIsLoggedIn) ?? false;
  }

  @override
  Future<bool> setLoggedIn(bool value) async {
    return await sharepref?.setBool(
        AppSharePrefConstants.prefKeyIsLoggedIn, value);
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

  @override
  String getAppLanguage() {
    return sharepref?.getString(AppSharePrefConstants.prefKeyAppLanguage);
  }

  @override
  Future<bool> setAppLanguage(String appLanguage) async {
    return await sharepref?.setString(
        AppSharePrefConstants.prefKeyAppLanguage, appLanguage);
  }

  Future<bool> setAppUser(LoginResponse model) async {
    await setUserId(model?.data?.id);
    await setUserName(model?.data?.fullName);
    await setUserLastName(model?.data?.lastName);
    await setUserMobileNumber(model?.data?.phone);
    await setUserEmail(model?.data?.email);
    await setUserRating(model?.data?.rating);
    await setUserProfileImage(model?.data?.profileImage);
    await setDutyStatus(model?.data?.onDuty);
    return Future.value(true);
  }

  @override
  String getDutyStatus() {
    return sharepref?.getString(AppSharePrefConstants.prefKeyAppUserDutyStatus);
  }

  @override
  Future<bool> setDutyStatus(String status) async {
    return await sharepref?.setString(
        AppSharePrefConstants.prefKeyAppUserDutyStatus, status);
  }

  @override
  bool isReminderAlarmEnabled() {
    return sharepref?.getBool(AppSharePrefConstants.prefKeyAppReminderAlarm) ??
        false;
  }

  @override
  Future<bool> setReminderAlarm(bool status) async {
    return await sharepref?.setBool(
        AppSharePrefConstants.prefKeyAppReminderAlarm, status);
  }

  @override
  String getUserEmail() {
    return sharepref?.getString(AppSharePrefConstants.prefKeyAppUserEmail);
  }

  @override
  String getUserId() {
    return sharepref?.getString(AppSharePrefConstants.prefKeyAppUserId);
  }

  @override
  String getUserLastName() {
    return sharepref?.getString(AppSharePrefConstants.prefKeyAppUserLastName);
  }

  @override
  String getUserName() {
    return sharepref?.getString(AppSharePrefConstants.prefKeyAppUserName);
  }

  @override
  String getUserProfileImage() {
    return sharepref?.getString(AppSharePrefConstants.prefKeyAppUserProfile);
  }

  @override
  String getUserRating() {
    return sharepref?.getString(AppSharePrefConstants.prefKeyAppUserRating);
  }

  @override
  Future<bool> setUserEmail(String userEmail) async {
    return await sharepref?.setString(
        AppSharePrefConstants.prefKeyAppUserEmail, userEmail);
  }

  @override
  Future<bool> setUserId(String userId) async {
    return await sharepref?.setString(
        AppSharePrefConstants.prefKeyAppUserId, userId);
  }

  @override
  Future<bool> setUserLastName(String userLastName) async {
    return await sharepref?.setString(
        AppSharePrefConstants.prefKeyAppUserLastName, userLastName);
  }

  @override
  Future<bool> setUserName(String userName) async {
    return await sharepref?.setString(
        AppSharePrefConstants.prefKeyAppUserName, userName);
  }

  @override
  Future<bool> setUserProfileImage(String userImage) async {
    return await sharepref?.setString(
        AppSharePrefConstants.prefKeyAppUserProfile, userImage);
  }

  @override
  Future<bool> setUserRating(String userRating) async {
    return await sharepref?.setString(
        AppSharePrefConstants.prefKeyAppUserRating, userRating);
  }

  @override
  String getLocationId() {
    return sharepref?.getString(AppSharePrefConstants.prefKeyAppLocationId);
  }

  @override
  Future<bool> setLocationId(String locationId) async {
    return await sharepref?.setString(
        AppSharePrefConstants.prefKeyAppLocationId, locationId);
  }

  String getStoreCurrency() {
    return sharepref
        ?.getString(AppConstants.VALUEAPPZ_ADMIN_STORE_CURRENCY) ??
        "";
  }

  void setStoreCurrency(String value) {
    sharepref?.setString(
        AppConstants.VALUEAPPZ_ADMIN_STORE_CURRENCY, value);
  }

}
