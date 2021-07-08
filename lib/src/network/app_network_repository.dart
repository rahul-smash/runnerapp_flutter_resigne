import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:valueappz_feature_component/core/network/api/dio_base_service.dart';
import 'package:valueappz_feature_component/src/model/store_response_model.dart';
import 'package:valueappz_feature_component/src/network/app_network_constants.dart';
import 'package:valueappz_feature_component/src/sharedpreference/app_shared_pref.dart';

class AppNetworkRepository extends DioBaseService {
  static AppNetworkRepository _instance;
  static const _version = '/version';

  AppNetworkRepository._() : super(AppNetworkConstants.baseUrl);

  static AppNetworkRepository get instance =>
      _instance ??= AppNetworkRepository._();

  String apiPath(String storeId, String path) =>
      '$storeId${AppNetworkConstants.baseRoute}$path';

  Future<StoreResponse> versionApi(String storeId) async {
    String deviceId = AppSharedPref.instance.getDeviceId();
    String deviceToken = AppSharedPref.instance.getDeviceToken();
    String platform = AppSharedPref.instance.getDevicePlatform();

    Map<String, dynamic> param = {
      'device_id': deviceId,
      'device_token': deviceToken,
      'platform': platform
    };

    try {
      var response = await post(apiPath(storeId, _version), param);
      StoreResponse storeData = StoreResponse.fromJson(jsonDecode(response));
      String version = AppSharedPref.instance.getApiVersion();
      debugPrint("older version is $version");
      if (version != storeData.store.version) {
        debugPrint(
            "version not matched older version is $version and new version is ${storeData.store.version}.");
        AppSharedPref.instance.setApiVersion(storeData.store.version);
        // fixme: clear database
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
