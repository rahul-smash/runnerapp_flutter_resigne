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

class LoginNetworkRepository extends DioBaseService {

  static LoginNetworkRepository _instance;

  static const _login = '/runner_authentication/login';
  static const _sendOTP = '/runner_authentication/sendOTP';
  static const _registration = '/runner_authentication/registration';
  static const _setPin = '/runner_authentication/setPin';

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

  Future<BaseResponse> sendOtpApi(String _phone) async {
    String storeId = StoreConfigurationSingleton.instance.configModel.storeId;
    Map<String, dynamic> param = getIt.get<CommonNetworkUtils>().getDeviceParams();
    param['phone'] = _phone;
    try {
      var response = await post(apiPath(storeId, _sendOTP), param);
      BaseResponse baseResponse = BaseResponse.fromJson(jsonDecode(response));
      return baseResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }


  Future<RegisterResponse> registerApi(String first_name, String last_name, String registeredAs, String phone, String otp) async {
    String storeId = StoreConfigurationSingleton.instance.configModel.storeId;
    Map<String, dynamic> param = getIt.get<CommonNetworkUtils>().getDeviceParams();
    param['first_name'] = first_name;
    param['last_name'] = last_name;
    param['phone'] = phone;
    param['otp'] = otp;
    param['registered_as'] = registeredAs;
    try {
      var response = await post(apiPath(storeId, _registration), param);
      RegisterResponse baseResponse = RegisterResponse.fromJson(jsonDecode(response));
      return baseResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<BaseResponse> setMpinApi(String mPin, String userId) async {
    String storeId = StoreConfigurationSingleton.instance.configModel.storeId;
    Map<String, dynamic> param = getIt.get<CommonNetworkUtils>().getDeviceParams();
    param['pin'] = mPin;
    param['confirm_pin'] = mPin;
    param['user_id'] = userId;
    try {
      var response = await post(apiPath(storeId, _setPin), param);
      BaseResponse baseResponse = BaseResponse.fromJson(jsonDecode(response));
      return baseResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

}
