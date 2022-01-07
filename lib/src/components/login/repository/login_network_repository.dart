import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:marketplace_service_provider/core/network/api/dio_base_service.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/login/model/forgot_password_response.dart';
import 'package:marketplace_service_provider/src/components/login/model/login_response.dart';
import 'package:marketplace_service_provider/src/components/signUp/model/register_response.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/network/app_network_constants.dart';
import 'package:marketplace_service_provider/src/network/components/common_network_utils.dart';
import 'package:marketplace_service_provider/src/singleton/store_config_singleton.dart';

class LoginNetworkRepository extends DioBaseService {
  static LoginNetworkRepository _instance;

  static const _login = '/runner_authentication/login';
  static const _userLogin='/runner_authentication/userLogin';
  static const _sendOTP = '/runner_authentication/sendOTP';
  static const _registration = '/runner_authentication/registration';
  static const _setPin = '/runner_authentication/setPin';
  static const _resetPinOTP = '/runner_authentication/resetPinOTP';
  static const _forgotPassword = '/runner_authentication/forgetPasswordEmail';
  static const _resetPassword = '/runner_authentication/resetPassword';
  static const _verifyResetPinOTP = '/runner_authentication/verifyResetPinOTP';

  LoginNetworkRepository._() : super(AppNetworkConstants.baseUrl);

  static LoginNetworkRepository get instance =>
      _instance ??= LoginNetworkRepository._();

  String apiPath(String storeId, String path) =>
      '$storeId${AppNetworkConstants.baseRouteV2}$path';

  Future<LoginResponse> loginApi(String phoneNumber, String mPin) async {
    try {
      Map<String, dynamic> param = {};
      param['phone'] = phoneNumber;
      param['pin'] = mPin;
      var data = getIt.get<CommonNetworkUtils>().getDeviceParams();
      param['app_version'] = data['app_version'];
      param['platform'] = data['platform'];
      param['device_id'] = data['device_id'];
      param['device_token'] = data['device_token'];
      param['device_brand'] = data['device_brand'];
      param['device_model'] = data['device_model'];
      param['device_os'] = data['device_os'];
      param['device_os_version'] = data['device_os_version'];
      log(param.toString());
      print('@@LoginCredentails---'+param.toString());
      var response = await post(
          apiPath(
              StoreConfigurationSingleton.instance.configModel.storeId, _login),
          param);
      LoginResponse loginResponse =
          LoginResponse.fromJson(jsonDecode(response));
      return loginResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
  Future<LoginResponse> userloginApi(String email, String password) async {
    try {
      Map<String, dynamic> param = {};
      param['email'] = email;
      param['password'] = password;
      var data = getIt.get<CommonNetworkUtils>().getDeviceParams();
      param['device_token'] = data['device_token'];
      param['platform']=Platform.isIOS ? "ios" : "android";
      log(param.toString());
      print('@@UserLoginCredentails---'+param.toString());
      var response = await post(
          apiPath(
              StoreConfigurationSingleton.instance.configModel.storeId, _userLogin),
          param);
      LoginResponse loginResponse =
      LoginResponse.fromJson(jsonDecode(response));
      return loginResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<BaseResponse> sendOtpApi(String _phone) async {
    String storeId = StoreConfigurationSingleton.instance.configModel.storeId;
    Map<String, dynamic> param =
        getIt.get<CommonNetworkUtils>().getDeviceParams();
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

  Future<BaseResponse> resetPinOtpApi(String _phone) async {
    String storeId = StoreConfigurationSingleton.instance.configModel.storeId;
    Map<String, dynamic> param =
        getIt.get<CommonNetworkUtils>().getDeviceParams();
    param['phone'] = _phone;

    try {
      print('@@resetPinOtpApi---'+param.toString());

      var response = await post(apiPath(storeId, _resetPinOTP), param);
      BaseResponse baseResponse = BaseResponse.fromJson(jsonDecode(response));
      return baseResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
  Future<ForgotPasswordResponse> forgotPassword(String email) async {
    String storeId = StoreConfigurationSingleton.instance.configModel.storeId;
    Map<String, dynamic> param =
        getIt.get<CommonNetworkUtils>().getDeviceParams();
    param['email'] = email;

    try {
      var response = await post(apiPath(storeId, _forgotPassword), param);
      ForgotPasswordResponse forgotPasswordResponse = forgotPasswordResponseFromJson(jsonDecode(json.encode(response)));
      return forgotPasswordResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
  Future<ForgotPasswordResponse> resetPassword(String password,String id) async {
    String storeId = StoreConfigurationSingleton.instance.configModel.storeId;
    Map<String, dynamic> param =
        getIt.get<CommonNetworkUtils>().getDeviceParams();
    param['password'] = password;
    param['user_id'] = id;
    try {
      var response = await post(apiPath(storeId, _resetPassword), param);
      ForgotPasswordResponse forgotPasswordResponse = forgotPasswordResponseFromJson(jsonDecode(json.encode(response)));
      return forgotPasswordResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<RegisterResponse> registerApi(String first_name, String last_name,
      String registeredAs, String phone, String otp) async {
    String storeId = StoreConfigurationSingleton.instance.configModel.storeId;
    Map<String, dynamic> param =
        getIt.get<CommonNetworkUtils>().getDeviceParams();
    param['first_name'] = first_name;
    param['last_name'] = last_name;
    param['phone'] = phone;
    param['otp'] = otp;
    param['registered_as'] = registeredAs;
    try {
      var response = await post(apiPath(storeId, _registration), param);
      RegisterResponse baseResponse =
          RegisterResponse.fromJson(jsonDecode(response));
      return baseResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<LoginResponse> setMpinApi(String mPin, String userId) async {
    String storeId = StoreConfigurationSingleton.instance.configModel.storeId;
    Map<String, dynamic> param =
        getIt.get<CommonNetworkUtils>().getDeviceParams();
    param['pin'] = mPin;
    param['confirm_pin'] = mPin;
    param['user_id'] = userId;
    try {
      print('@@_setPin---'+param.toString());
      var response = await post(apiPath(storeId, _setPin), param);
      LoginResponse baseResponse = LoginResponse.fromJson(jsonDecode(response));
      return baseResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<BaseResponse> verifyResetPinOtpApi(
      String phoneNumber, String otp) async {
    String storeId = StoreConfigurationSingleton.instance.configModel.storeId;
    Map<String, dynamic> param =
        getIt.get<CommonNetworkUtils>().getDeviceParams();
    param['phone'] = phoneNumber;
    param['otp'] = otp;
    try {
      print('@@verifyResetPinOtpApi----'+param.toString());
      var response = await post(apiPath(storeId, _verifyResetPinOTP), param);
      BaseResponse baseResponse = BaseResponse.fromJson(jsonDecode(response));
      return baseResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
