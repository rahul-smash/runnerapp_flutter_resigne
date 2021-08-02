import 'package:flutter/material.dart';
import 'authentication_repository.dart';

class UserRepository extends AuthenticationRepository {

  // singleton
  static UserRepository _instance = UserRepository._internal();
  UserRepository._internal();
  factory UserRepository() => _instance;

  @override
  Future<void> register({@required String firstName,@required String lastName,
    @required String email,@required String password}) {
    // TODO: implement
  }

  /// Authenticates a user using his [username] and [password]
  @override
  Future<void> authenticate(
      {@required String email, @required String password}) {
    // TODO: implement
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