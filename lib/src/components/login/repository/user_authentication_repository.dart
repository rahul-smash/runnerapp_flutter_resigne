import 'package:flutter/material.dart';
import 'authentication_repository.dart';
import 'login_network_repository.dart';

class UserAuthenticationRepository extends AuthenticationRepository {

  UserAuthenticationRepository();

  /// Authenticates a user using his [username] and [password]
  @override
  Future<void> authenticate({@required String phoneNumber,@required String mPin}) async {
    await LoginNetworkRepository.instance.loginApi(phoneNumber, mPin);
  }

  @override
  Future<void> register({@required String phoneNumber,@required String mPin}) {

  }

  /// Returns whether the [User] is authenticated.
  @override
  Future<bool> isAuthenticated() {
    // TODO: implement
  }

  /// Returns the current authenticated [User].
  @override
  Future<void> getCurrentUser() {
    // TODO: implement
  }

  /// Resets the password of a [User]
  @override
  Future<void> forgotPassword(String email) {
    // TODO: implement
  }

  /// Logs out the [User]
  @override
  Future<void> logout() {
    // TODO: implement
  }
}