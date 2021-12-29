import 'package:event_bus/event_bus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marketplace_service_provider/src/notification/notification_model.dart';

EventBus eventBus = EventBus();

class DaysSelected {
  List<String> daysList;
  String openTime;
  String closeTime;
  bool isSaveBtnPressed;

  DaysSelected(this.daysList, this.openTime, this.closeTime,
      {this.isSaveBtnPressed});
}

class OnLocationUpdate {
  LatLng selectedLocation;

  OnLocationUpdate({this.selectedLocation});
}

class AlarmEvent {
  String event;

  //for starting alarm and location update in background
  AlarmEvent.startPeriodicAlarm(this.event);

  AlarmEvent.cancelAllAlarm(this.event);
}

class ReminderAlarmEvent {
  String event;

  ReminderAlarmEvent.startPeriodicAlarm(this.event);

  ReminderAlarmEvent.cancelAllAlarm(this.event);
}

class FCMNotificationEvent {
  NotificationData data;

  FCMNotificationEvent(this.data);

  FCMNotificationEvent.runnerAllocation(this.data);

  FCMNotificationEvent.userRunnerAssigned(this.data);

  FCMNotificationEvent.orderReadyDeliveryBoy(this.data);
}
