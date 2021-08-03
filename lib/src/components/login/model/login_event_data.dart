import 'package:marketplace_service_provider/src/components/login/bloc/user_login_bloc.dart';

class LoginEventData{
  UserLoginAction userLoginAction;
  String phoneNumber;
  String mPin;
  LoginEventData(this.userLoginAction, this.phoneNumber, this.mPin);
}

class LoginStreamOutput{
  bool showLoader;
  LoginStreamOutput(this.showLoader);
}