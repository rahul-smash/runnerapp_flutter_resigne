import 'package:marketplace_service_provider/src/components/service_location/bloc/save_location_bloc.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';

class LocationEventData{
  String locationId;
  String userId;
  LocationAction locationAction;
  int selectedIndex;
  LocationEventData(this.locationId, this.userId,this.locationAction,{this.selectedIndex});
}

class LocationStreamOutput{
  bool showLoader;
  BaseResponse baseResponse;
  int selectedIndex;
  LocationStreamOutput({this.showLoader, this.baseResponse,this.selectedIndex});
}