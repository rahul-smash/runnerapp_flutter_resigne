import 'package:flutter/material.dart';

abstract class AuthenticationRepository {

  Future<void> signUp({@required String phoneNumber, @required String mPin});

  /// Authenticates a user using his [username] and [password]
  Future<void> loginUser({@required String phoneNumber,@required String mPin});

}
