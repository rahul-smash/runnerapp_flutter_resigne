import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_details_response.dart';
import 'package:provider/provider.dart';

class BookingProvider extends  ChangeNotifier {
  BookingDetailsResponse bookingDetailsResponse;
  int quantity=0;

  updateQuantity(value) {
    quantity = value;
    notifyListeners();
  }
}

