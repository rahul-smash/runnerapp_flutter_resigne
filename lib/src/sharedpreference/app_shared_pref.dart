
import 'dart:convert';

import 'package:marketplace_service_provider/core/sharedpreference/base_shared_pref.dart';
import 'package:marketplace_service_provider/src/components/login/model/login_response.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref_constants.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref_interface.dart';
import 'package:marketplace_service_provider/src/singleton/login_user_singleton.dart';

class AppSharedPref extends BaseSharedPreference implements AppSharePrefInterface {
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
  Future<bool> isLoggedIn() async {
    bool IsLoggedIn = sharepref?.getBool(AppSharePrefConstants.prefKeyIsLoggedIn) ?? false;
    if(IsLoggedIn){
      await getUser();
      return IsLoggedIn;
    }else{
      return IsLoggedIn;
    }
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
    return sharepref?.getString(AppSharePrefConstants.prefKeyAppVersion);
  }

  @override
  Future<bool> setAppLanguage(String appLanguage) async{
    return await sharepref?.setString(
        AppSharePrefConstants.prefKeyAppLanguage, appLanguage);
  }

  @override
  Future<bool> saveUser(LoginResponse model) async {
    dynamic userResponse = model.toJson();
    String jsonString = jsonEncode(userResponse);
    return await sharepref?.setString(
        AppSharePrefConstants.prefKeyAppSaveUser, jsonString);
  }

  @override
  Future<LoginResponse> getUser() async {
    Map<String, dynamic> userMap = await json.decode(sharepref?.getString(AppSharePrefConstants.prefKeyAppSaveUser));
    var user = LoginResponse.fromJson(userMap);
    LoginUserSingleton.instance.loginResponse = user;
    return user;
  }
}
