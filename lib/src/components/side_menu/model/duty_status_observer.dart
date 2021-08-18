import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';

class DutyStatusObserver extends ChangeNotifier {

  String status = "0"; // 0=>off duty, 1=>on duty

  DutyStatusObserver({String status});

  void changeStatus(String status) {
    this.status = status;
    notifyListeners();
  }

}