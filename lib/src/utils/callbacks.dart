import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class DaysSelected {
  List<String> daysList;
  String openTime;
  String closeTime;
  bool isSaveBtnPressed;
  DaysSelected(this.daysList,this.openTime, this.closeTime,{this.isSaveBtnPressed});
}