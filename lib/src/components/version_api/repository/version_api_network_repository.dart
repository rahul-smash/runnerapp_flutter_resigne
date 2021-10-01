import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:marketplace_service_provider/core/network/api/dio_base_service.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/version_api/model/service_location_response.dart';
import 'package:marketplace_service_provider/src/model/store_response_model.dart';
import 'package:marketplace_service_provider/src/network/app_network_constants.dart';
import 'package:marketplace_service_provider/src/network/components/common_network_utils.dart';
import 'package:marketplace_service_provider/src/singleton/singleton_service_locations.dart';
import 'package:marketplace_service_provider/src/singleton/versio_api_singleton.dart';

class VersionApiNetworkRepository extends DioBaseService {
  static VersionApiNetworkRepository _instance;
  static const _version = '/version';
  static const _getLocations = '/runner_authentication/getLocations';

  VersionApiNetworkRepository._() : super(AppNetworkConstants.baseUrl);

  static VersionApiNetworkRepository get instance =>
      _instance ??= VersionApiNetworkRepository._();

  String apiPath(String storeId, String path) =>
      '$storeId${AppNetworkConstants.baseRouteV2}$path';

  Future<StoreResponse> versionApi(String storeId) async {
    try {
      var response = await post(apiPath(storeId, _version),
          getIt.get<CommonNetworkUtils>().getDeviceParams());
      VersionApiSingleton.instance.storeResponse =
          StoreResponse.fromJson(jsonDecode(response));
      return VersionApiSingleton.instance.storeResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<ServiceLocationResponse> serviceLocationsApi(String storeId) async {
    try {
      var response = await get(apiPath(storeId, _getLocations),
          getIt.get<CommonNetworkUtils>().getDeviceParams());
      SingletonServiceLocations.instance.serviceLocationResponse =
          ServiceLocationResponse.fromJson(jsonDecode(response));
      return SingletonServiceLocations.instance.serviceLocationResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
