import 'package:event_bus/event_bus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

EventBus eventBus = EventBus();

class DaysSelected {
  List<String> daysList;
  String openTime;
  String closeTime;
  bool isSaveBtnPressed;
  DaysSelected(this.daysList,this.openTime, this.closeTime,{this.isSaveBtnPressed});
}

class OnLocationUpdate {
  LatLng selectedLocation;
  OnLocationUpdate({this.selectedLocation});
}