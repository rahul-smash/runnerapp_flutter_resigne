import 'dart:async';

import 'package:marketplace_service_provider/src/components/login/model/login_response.dart';
import 'package:marketplace_service_provider/src/components/login/repository/login_network_repository.dart';
import 'package:rxdart/rxdart.dart';

enum LoginState { progress, failed, success }

abstract class Result<S, T> {
  S state;
  T data;
}

class LoginResult extends Result<LoginState, LoginResponse> {}

class LoginBloc {
  PublishSubject<LoginResult> _loginController = new PublishSubject();

  set loginStateSink(LoginResult loginState) =>
      _loginController.sink.add(loginState);

  Stream<LoginResult> get loginStateStream => _loginController.stream;

  Future<void> perfromLogin({String mNumber, String mPin}) async {
    loginStateSink = LoginResult()..state = LoginState.progress;

    LoginResponse loginResponse =
        await LoginNetworkRepository.instance.loginApi(mNumber, mPin);
    print('@@loginResponse-'+loginResponse.toString());
    print('@@loginResponse-'+LoginNetworkRepository.instance.loginApi(mNumber, mPin).toString());

    loginStateSink = new LoginResult()
      ..state = loginResponse.success ? LoginState.success : LoginState.failed
      ..data = loginResponse;
  }
  Future<void> perfromUserLogin({String email, String password}) async {
    loginStateSink = LoginResult()..state = LoginState.progress;

    LoginResponse loginResponse =
        await LoginNetworkRepository.instance.userloginApi(email, password);
    print('@@userLoginResponse-'+loginResponse.toString());
    print('@@userLoginResponse-'+LoginNetworkRepository.instance.userloginApi(email, password).toString());

    loginStateSink = new LoginResult()
      ..state = loginResponse.success ? LoginState.success : LoginState.failed
      ..data = loginResponse;
  }

  void dispose() {
    _loginController.close();
  }
}
