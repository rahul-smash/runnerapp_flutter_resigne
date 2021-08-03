import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/src/components/login/model/login_response.dart';
import 'package:marketplace_service_provider/src/components/signUp/model/register_response.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'authentication_repository.dart';
import 'login_network_repository.dart';

class UserAuthenticationRepository extends AuthenticationRepository {

  UserAuthenticationRepository();

  /// Authenticates a user using his [username] and [password]
  @override
  Future<LoginResponse> loginUser({@required String phoneNumber,@required String mPin}) async {
    return await LoginNetworkRepository.instance.loginApi(phoneNumber, mPin);
  }

  @override
  Future<BaseResponse> sendOtp({@required String phoneNumber}) async {
    return await LoginNetworkRepository.instance.sendOtpApi(phoneNumber);
  }

  @override
  Future<RegisterResponse> registerUser({String first_name,String last_name,String registeredAs,String phone,String otp}) async {
    return await LoginNetworkRepository.instance.registerApi(first_name, last_name,registeredAs,phone,otp);
  }

  @override
  Future<BaseResponse> setMpin({String mPin, String userId}) async {
    return await LoginNetworkRepository.instance.setMpinApi(mPin,userId);
  }


}