import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:valueappz_feature_component/src/model/store_response_model.dart';
import 'package:valueappz_feature_component/src/utils/app_constants.dart';

class SharedPrefs {
  static void saveStore(StoreModel model) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    dynamic storeResponse = model.toJson();
    String jsonString = jsonEncode(storeResponse);
    sharedUser.setString('store', jsonString);
  }

  static Future<StoreModel> getStore() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    Map<String, dynamic> storeMap = json.decode(sharedUser.getString('store'));
    var user = StoreModel.fromJson(storeMap);
    return user;
  }

  static void setUserLoggedIn(bool loggedIn) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    sharedUser.setBool('isLoggedIn', loggedIn);
    AppConstants.isLoggedIn = loggedIn;
  }

  static Future<bool> isUserLoggedIn() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    return sharedUser.getBool('isLoggedIn') ?? false;
  }

  static Future storeSharedValue(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future removeKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static Future<String> getStoreSharedValue(String key) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    return sharedUser.getString(key);
  }

  static void saveAPiDetailsVersion(String version) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    sharedUser.setString('api_details_version', version);
  }

  static Future<String> getAPiDetailsVersion() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    String version = sharedUser.getString('api_details_version');
    return version;
  }
}
