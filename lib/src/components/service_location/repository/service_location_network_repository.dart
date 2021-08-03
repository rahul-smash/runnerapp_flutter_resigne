import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:marketplace_service_provider/core/network/api/dio_base_service.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/login/model/login_response.dart';
import 'package:marketplace_service_provider/src/components/signUp/model/register_response.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/model/store_response_model.dart';
import 'package:marketplace_service_provider/src/network/app_network_constants.dart';
import 'package:marketplace_service_provider/src/network/components/common_network_utils.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/singleton/store_config_singleton.dart';
import 'package:marketplace_service_provider/src/singleton/versio_api_singleton.dart';

class ServiceLocationNetworkRepository extends DioBaseService {

  static ServiceLocationNetworkRepository _instance;

  static const _saveLocation = '/runner_authentication/saveLocation';

  ServiceLocationNetworkRepository._() : super(AppNetworkConstants.baseUrl);

  static ServiceLocationNetworkRepository get instance =>
      _instance ??= ServiceLocationNetworkRepository._();

  String apiPath(String storeId, String path) =>
      '$storeId${AppNetworkConstants.baseRoute}$path';

  Future<BaseResponse> saveLocationApi(String location_id,String user_id) async {
    try {
      Map<String, dynamic> param = getIt.get<CommonNetworkUtils>().getDeviceParams();
      param['location_id'] = location_id;
      param['user_id'] = user_id;
      var response = await post(apiPath(StoreConfigurationSingleton.instance.configModel.storeId, _saveLocation), param);
      BaseResponse loginResponse = BaseResponse.fromJson(jsonDecode(response));
      return loginResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

}
