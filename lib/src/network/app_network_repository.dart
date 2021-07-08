import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:valueappz_feature_component/core/network/api/dio_base_service.dart';
import 'package:valueappz_feature_component/src/model/store_response_model.dart';
import 'package:valueappz_feature_component/src/network/app_network_constants.dart';
import 'package:valueappz_feature_component/src/sharedpreference/SharedPrefs.dart';
import 'package:valueappz_feature_component/src/utils/app_constants.dart';

class AppNetworkRepository extends DioBaseService {
  static AppNetworkRepository _instance;
  static const _version = '/version';

  AppNetworkRepository._() : super(AppNetworkConstants.baseUrl);

  static AppNetworkRepository get instance =>
      _instance ??= AppNetworkRepository._();

  Future<StoreResponse> versionApi(String storeId) async {
    String deviceId =
        await SharedPrefs.getStoreSharedValue(AppConstants.deviceId);
    String deviceToken =
        await SharedPrefs.getStoreSharedValue(AppConstants.deviceToken);
    var url = '$storeId${AppNetworkConstants.baseRoute}$_version';
    Map<String, dynamic> param = {
      'device_id': deviceId,
      'device_token': deviceToken,
      'platform': Platform.isIOS ? 'IOS' : 'Android'
    };
    try {
      var response = await post(url, param);
      StoreResponse storeData = StoreResponse.fromJson(jsonDecode(response));
      SharedPrefs.saveStore(storeData.store);
      String version = await SharedPrefs.getAPiDetailsVersion();
      print("older version is $version");
      if (version != storeData.store.version) {
        debugPrint(
            "version not matched older version is $version and new version is ${storeData.store.version}.");
        SharedPrefs.saveAPiDetailsVersion(storeData.store.version);
        // DatabaseHelper databaseHelper = DatabaseHelper();
        // databaseHelper.clearDataBase();
      }
      return storeData;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
