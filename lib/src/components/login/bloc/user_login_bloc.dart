import 'dart:async';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/login/model/login_event_data.dart';
import 'package:marketplace_service_provider/src/components/login/model/login_response.dart';
import 'package:marketplace_service_provider/src/components/login/repository/user_authentication_repository.dart';
import 'package:rxdart/rxdart.dart';

enum UserLoginAction {PerformLoggin}

class UserLoginBloc{

  //This StreamController is used to update the state of widgets
  PublishSubject<LoginStreamOutput> _stateStreamController = new PublishSubject();
  StreamSink<LoginStreamOutput> get _userLoginSink => _stateStreamController.sink;
  Stream<LoginStreamOutput> get userModelStream => _stateStreamController.stream;

  //user input event StreamController
  PublishSubject<LoginEventData> _eventStreamController = new PublishSubject();
  StreamSink<LoginEventData> get eventSink => _eventStreamController.sink;
  Stream<LoginEventData> get _eventStream => _eventStreamController.stream;

  UserLoginBloc() {
    _eventStream.listen((event) async {
      LoginEventData loginEventData = event;
      if (loginEventData.userLoginAction == UserLoginAction.PerformLoggin){
        _userLoginSink.add(LoginStreamOutput(showLoader: true,loginResponse: null));
        LoginResponse loginResponse = await getIt.get<UserAuthenticationRepository>().loginUser(phoneNumber: loginEventData.phoneNumber,
            mPin: loginEventData.mPin);
        _userLoginSink.add(LoginStreamOutput(showLoader: false,loginResponse: loginResponse));
      }
    });
  }

  void dispose(){
    _stateStreamController.close();
    _eventStreamController.close();
  }

}