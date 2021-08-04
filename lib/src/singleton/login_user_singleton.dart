import 'package:marketplace_service_provider/src/components/login/model/login_response.dart';

class LoginUserSingleton{

  static LoginUserSingleton _instance;
  LoginResponse loginResponse;

  LoginUserSingleton._();

  static LoginUserSingleton get instance {
    return _instance ??= LoginUserSingleton._();
  }

}