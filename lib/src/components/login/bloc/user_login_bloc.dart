import 'dart:async';
import 'package:rxdart/rxdart.dart';

enum UserLoginAction {PerformLogged}

class UserLoginBloc{

  //This StreamController is used to update the state of widgets
  PublishSubject<String> _stateStreamController = new PublishSubject();
  StreamSink<String> get _userModelSink => _stateStreamController.sink;
  Stream<String> get userModelStream => _stateStreamController.stream;

  //user input event StreamController
  PublishSubject<UserLoginAction> _eventStreamController = new PublishSubject();
  StreamSink<UserLoginAction> get eventSink => _eventStreamController.sink;
  Stream<UserLoginAction> get _eventStream => _eventStreamController.stream;

  UserLoginBloc() {
    _eventStream.listen((event) async {
      if (event == UserLoginAction.PerformLogged){
        //UserLoginModel userLoginModel = await UserProvider.getUser();
        //_userModelSink.add(userLoginModel);
      }

    });
  }

  void dispose(){
    _stateStreamController.close();
    _eventStreamController.close();
  }

}