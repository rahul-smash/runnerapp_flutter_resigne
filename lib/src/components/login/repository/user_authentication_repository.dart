import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/src/components/login/model/login_response.dart';
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
  Future<void> signUp({@required String phoneNumber,@required String mPin}) {

  }


}