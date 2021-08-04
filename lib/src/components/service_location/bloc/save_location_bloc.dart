import 'dart:async';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/service_location/model/location_event_data.dart';
import 'package:marketplace_service_provider/src/components/service_location/repository/service_location_auth_repository.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:rxdart/rxdart.dart';

enum LocationAction {SaveLocation,SelectCity}

class SaveLocationBloc{

  //This StreamController is used to update the state of widgets
  PublishSubject<LocationStreamOutput> _stateStreamController = new PublishSubject();
  StreamSink<LocationStreamOutput> get _locationSink => _stateStreamController.sink;
  Stream<LocationStreamOutput> get locationStream => _stateStreamController.stream;

  //user input event StreamController
  PublishSubject<LocationEventData> _eventStreamController = new PublishSubject();
  StreamSink<LocationEventData> get eventSink => _eventStreamController.sink;
  Stream<LocationEventData> get _eventStream => _eventStreamController.stream;

  SaveLocationBloc() {
    _eventStream.listen((event) async {
      LocationEventData locationEventData = event;
      if(locationEventData.locationAction == LocationAction.SaveLocation){
        _locationSink.add(LocationStreamOutput(showLoader: true,baseResponse: null));
        BaseResponse baseResponse = await getIt.get<ServiceLocationAuthRepository>().saveLocation(
          userId: locationEventData.userId,locationId: locationEventData.locationId
        );
        _locationSink.add(LocationStreamOutput(showLoader: false,baseResponse: baseResponse));
      }else if(locationEventData.locationAction == LocationAction.SelectCity){
        LocationEventData locationEventData = event;
        //print("locationEventData.selectedIndex=${locationEventData.selectedIndex}");
        _locationSink.add(LocationStreamOutput(showLoader: false,baseResponse: null,selectedIndex: locationEventData.selectedIndex));
      }
    });
  }

  void dispose(){
    _stateStreamController.close();
    _eventStreamController.close();
  }


}