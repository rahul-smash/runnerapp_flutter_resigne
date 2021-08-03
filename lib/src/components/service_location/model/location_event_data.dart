import 'package:marketplace_service_provider/src/components/service_location/bloc/save_location_bloc.dart';

class LocationEventData{
  String locationId;
  String userId;
  LocationAction locationAction;
  LocationEventData(this.locationId, this.userId,this.locationAction);
}