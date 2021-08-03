import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:marketplace_service_provider/core/network/api/dio_base_service.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/login/model/login_response.dart';
import 'package:marketplace_service_provider/src/model/store_response_model.dart';
import 'package:marketplace_service_provider/src/network/app_network_constants.dart';
import 'package:marketplace_service_provider/src/network/components/common_network_utils.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/singleton/store_config_singleton.dart';
import 'package:marketplace_service_provider/src/singleton/versio_api_singleton.dart';

class LoginNetworkRepository extends DioBaseService {
  static LoginNetworkRepository _instance;
  static const _login = '/runner_authentication/login';

  LoginNetworkRepository._() : super(AppNetworkConstants.baseUrl);

  static LoginNetworkRepository get instance =>
      _instance ??= LoginNetworkRepository._();

  String apiPath(String storeId, String path) =>
      '$storeId${AppNetworkConstants.baseRoute}$path';

  Future<LoginResponse> loginApi(String phoneNumber,String mPin) async {
    try {
      Map<String, dynamic> param = getIt.get<CommonNetworkUtils>().getDeviceParams();
      param['phone'] = phoneNumber;
      param['pin'] = mPin;
      var response = await post(apiPath(StoreConfigurationSingleton.instance.configModel.storeId, _login), param);
      LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(response));
      return loginResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
