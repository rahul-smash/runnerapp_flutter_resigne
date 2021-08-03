import 'dart:async';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/service_location/model/location_event_data.dart';
import 'package:marketplace_service_provider/src/components/service_location/repository/service_location_auth_repository.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:rxdart/rxdart.dart';

enum LocationAction {SaveLocation}

class SaveLocationBloc{

  //This StreamController is used to update the state of widgets
  PublishSubject<BaseResponse> _stateStreamController = new PublishSubject();
  StreamSink<BaseResponse> get _locationSink => _stateStreamController.sink;
  Stream<BaseResponse> get userModelStream => _stateStreamController.stream;

  //user input event StreamController
  PublishSubject<LocationEventData> _eventStreamController = new PublishSubject();
  StreamSink<LocationEventData> get eventSink => _eventStreamController.sink;
  Stream<LocationEventData> get _eventStream => _eventStreamController.stream;

  SaveLocationBloc() {
    _eventStream.listen((event) async {
      LocationEventData locationEventData = event;
      if(locationEventData.locationAction == LocationAction.SaveLocation){
        BaseResponse baseResponse = await getIt.get<ServiceLocationAuthRepository>().saveLocation(
          userId: locationEventData.userId,locationId: locationEventData.locationId
        );
        //_locationSink.add(LoginStreamOutput(showLoader: false,loginResponse: loginResponse));
      }
    });
  }

  void dispose(){
    _stateStreamController.close();
    _eventStreamController.close();
  }


}