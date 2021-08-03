import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/src/components/signUp/model/register_response.dart';

abstract class AuthenticationRepository {

  /// Authenticates a user using his [username] and [password]
  Future<void> loginUser({@required String phoneNumber,@required String mPin});

  /// Authenticates a user using his [username] and [password]
  Future<RegisterResponse> registerUser({@required String first_name,@required String last_name,
    @required String registeredAs, @required String phone, @required String otp});

  Future<void> sendOtp({@required String phoneNumber});

  Future<void> setMpin({@required String mPin,@required String userId});
}
