// To parse this JSON data, do
//
//     final duePayoutResponse = duePayoutResponseFromJson(jsonString);

import 'dart:convert';

DuePayoutResponse duePayoutResponseFromJson(String str) =>
    DuePayoutResponse.fromJson(json.decode(str));

String duePayoutResponseToJson(DuePayoutResponse data) =>
    json.encode(data.toJson());

class DuePayoutResponse {
  DuePayoutResponse({
    this.success,
    this.summery,
    this.pendingPayouts,
    this.totalRecord,
    this.displayDate,
  });

  bool success;
  Summery summery;
  Map<String, List<PendingPayout>> pendingPayouts;
  int totalRecord;
  int displayDate;

  factory DuePayoutResponse.fromJson(Map<String, dynamic> json) =>
      DuePayoutResponse(
        success: json["success"] == null ? null : json["success"],
        summery:
            json["summery"] == null ? null : Summery.fromJson(json["summery"]),
        pendingPayouts: json["pendingPayouts"] == null
            ? null
            : Map.from(json["pendingPayouts"]).map((k, v) =>
                MapEntry<String, List<PendingPayout>>(
                    k,
                    List<PendingPayout>.from(
                        v.map((x) => PendingPayout.fromJson(x))))),
        totalRecord: json["totalRecord"] == null ? null : json["totalRecord"],
        displayDate: json["display_date"] == null ? null : json["display_date"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "summery": summery == null ? null : summery.toJson(),
        "pendingPayouts": pendingPayouts == null
            ? null
            : Map.from(pendingPayouts).map((k, v) => MapEntry<String, dynamic>(
                k, List<dynamic>.from(v.map((x) => x.toJson())))),
        "totalRecord": totalRecord == null ? null : totalRecord,
        "display_date": displayDate == null ? null : displayDate,
      };
}

class PendingPayout {
  PendingPayout({
    this.orderId,
    this.totalAmount,
    this.runnerPayout,
    this.orderAmount,
    this.paymentMethod,
    this.cashDeposit,
    this.bookingDateTime,
    this.bookingCompletedDate,
    this.categoryTitle,
  });

  String orderId;
  String totalAmount;
  String runnerPayout;
  String orderAmount;
  String paymentMethod;
  String cashDeposit;
  DateTime bookingDateTime;
  DateTime bookingCompletedDate;
  String categoryTitle;

  factory PendingPayout.fromJson(Map<String, dynamic> json) => PendingPayout(
        orderId: json["order_id"] == null ? null : json["order_id"],
        totalAmount: json["total_amount"] == null ? null : json["total_amount"],
        runnerPayout:
            json["runner_payout"] == null ? null : json["runner_payout"],
        orderAmount: json["order_amount"] == null ? null : json["order_amount"],
        paymentMethod:
            json["payment_method"] == null ? null : json["payment_method"],
        cashDeposit: json["cash_deposit"] == null ? null : json["cash_deposit"],
        bookingDateTime: json["booking_date_time"] == null
            ? null
            : DateTime.parse(json["booking_date_time"]),
        bookingCompletedDate: json["booking_completed_date"] == null
            ? null
            : DateTime.parse(json["booking_completed_date"]),
        categoryTitle:
            json["category_title"] == null ? null : json["category_title"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId == null ? null : orderId,
        "total_amount": totalAmount == null ? null : totalAmount,
        "runner_payout": runnerPayout == null ? null : runnerPayout,
        "order_amount": orderAmount == null ? null : orderAmount,
        "payment_method": paymentMethod == null ? null : paymentMethod,
        "cash_deposit": cashDeposit == null ? null : cashDeposit,
        "booking_date_time":
            bookingDateTime == null ? null : bookingDateTime.toIso8601String(),
        "booking_completed_date": bookingCompletedDate == null
            ? null
            : "${bookingCompletedDate.year.toString().padLeft(4, '0')}-${bookingCompletedDate.month.toString().padLeft(2, '0')}-${bookingCompletedDate.day.toString().padLeft(2, '0')}",
        "category_title": categoryTitle == null ? null : categoryTitle,
      };
}

class Summery {
  Summery({
    this.totalEarning,
    this.totalBookings,
  });

  String totalEarning;
  String totalBookings;

  factory Summery.fromJson(Map<String, dynamic> json) => Summery(
        totalEarning:
            json["total_earning"] == null ? null : json["total_earning"],
        totalBookings:
            json["total_bookings"] == null ? null : json["total_bookings"],
      );

  Map<String, dynamic> toJson() => {
        "total_earning": totalEarning == null ? null : totalEarning,
        "total_bookings": totalBookings == null ? null : totalBookings,
      };
}
