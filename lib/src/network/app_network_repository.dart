import 'dart:convert';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:marketplace_service_provider/core/network/api/dio_base_service.dart';
import 'package:marketplace_service_provider/src/model/store_response_model.dart';
import 'package:marketplace_service_provider/src/network/app_network_constants.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/singleton/store_data_singleton.dart';

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
      StoreDataSingleton.instance.storeData = storeData;
      return storeData;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
