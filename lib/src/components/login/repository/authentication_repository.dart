import 'package:flutter/material.dart';

abstract class AuthenticationRepository {

  Future<void> register({@required String phoneNumber, @required String mPin});

  /// Authenticates a user using his [username] and [password]
  Future<void> authenticate({@required String phoneNumber,@required String mPin});

  /// Returns whether the [User] is authenticated.
  Future<bool> isAuthenticated();

  /// Returns the current authenticated [User].
  Future<void> getCurrentUser();

  /// Resets the password of a [User]
  Future<void> forgotPassword(String email);

  /// Logs out the [User]
  Future<void> logout();
}
