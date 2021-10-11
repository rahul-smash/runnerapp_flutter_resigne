// To parse this JSON data, do
//
//     final pendingSummaryResponse = pendingSummaryResponseFromJson(jsonString);

import 'dart:convert';

class PendingSummaryResponse {
  PendingSummaryResponse({
    this.success,
    this.summery,
    this.pendingPayouts,
    this.totalRecord,
    this.displayDate,
    this.keysList,
  });

  bool success;
  Summery summery;
  Map<String, List<PendingPayout>> pendingPayouts;
  String totalRecord;
  String displayDate;
  List<String> keysList;

  PendingSummaryResponse copyWith({
    bool success,
    Summery summery,
    Map<String, List<PendingPayout>> pendingPayouts,
    String totalRecord,
    String displayDate,
    List<String> keysList,
  }) =>
      PendingSummaryResponse(
        success: success ?? this.success,
        summery: summery ?? this.summery,
        pendingPayouts: pendingPayouts ?? this.pendingPayouts,
        totalRecord: totalRecord ?? this.totalRecord,
        displayDate: displayDate ?? this.displayDate,
        keysList: keysList ?? this.keysList,
      );

  factory PendingSummaryResponse.fromRawJson(String str) =>
      PendingSummaryResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PendingSummaryResponse.fromJson(Map<String, dynamic> json) {
    List<String> keysList = List.empty(growable: true);
    return PendingSummaryResponse(
      success: json["success"] == null ? null : json["success"],
      summery:
          json["summery"] == null ? null : Summery.fromJson(json["summery"]),
      pendingPayouts:
          json["pendingPayouts"] == null || json["pendingPayouts"] is List
              ? null
              : Map.from(json["pendingPayouts"]).map((k, v) {
                  keysList.add(k);
                  return MapEntry<String, List<PendingPayout>>(
                      k,
                      List<PendingPayout>.from(
                          v.map((x) => PendingPayout.fromJson(x))));
                }),
      totalRecord:
          json["totalRecord"] == null ? null : json["totalRecord"].toString(),
      displayDate:
          json["display_date"] == null ? null : json["display_date"].toString(),
      keysList: keysList,
    );
  }

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
  PendingPayout(
      {this.orderId,
      this.totalAmount,
      this.paymentMethod,
      this.cashDeposit,
      this.runnerPayout,
      this.bookingDateTime,
      this.bookingCompletedDate,
      this.categoryTitle,
      this.orderAmount});

  String orderId;
  String totalAmount;
  String paymentMethod;
  String cashDeposit;
  String runnerPayout;
  DateTime bookingDateTime;
  DateTime bookingCompletedDate;
  String categoryTitle;
  String orderAmount;

  PendingPayout copyWith(
          {String orderId,
          String totalAmount,
          String paymentMethod,
          String cashDeposit,
          String runnerPayout,
          DateTime bookingDateTime,
          DateTime bookingCompletedDate,
          String categoryTitle,
          String orderAmount}) =>
      PendingPayout(
          orderId: orderId ?? this.orderId,
          totalAmount: totalAmount ?? this.totalAmount,
          paymentMethod: paymentMethod ?? this.paymentMethod,
          cashDeposit: cashDeposit ?? this.cashDeposit,
          runnerPayout: runnerPayout ?? this.runnerPayout,
          bookingDateTime: bookingDateTime ?? this.bookingDateTime,
          bookingCompletedDate:
              bookingCompletedDate ?? this.bookingCompletedDate,
          categoryTitle: categoryTitle ?? this.categoryTitle,
          orderAmount: orderAmount ?? this.orderAmount);

  factory PendingPayout.fromRawJson(String str) =>
      PendingPayout.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PendingPayout.fromJson(Map<String, dynamic> json) {
    return PendingPayout(
      orderId: json["order_id"] == null ? null : json["order_id"],
      totalAmount: json["total_amount"] == null ? null : json["total_amount"],
      paymentMethod:
          json["payment_method"] == null ? null : json["payment_method"],
      cashDeposit: json["cash_deposit"] == null ? null : json["cash_deposit"],
      runnerPayout:
          json["runner_payout"] == null ? null : json["runner_payout"],
      bookingDateTime: json["booking_date_time"] == null
          ? null
          : DateTime.parse(json["booking_date_time"]),
      bookingCompletedDate: json["booking_completed_date"] == null
          ? null
          : DateTime.parse(json["booking_completed_date"]),
      categoryTitle:
          json["category_title"] == null ? null : json["category_title"],
      orderAmount: json["order_amount"] == null ? null : json["order_amount"],
    );
  }

  Map<String, dynamic> toJson() => {
        "order_id": orderId == null ? null : orderId,
        "total_amount": totalAmount == null ? null : totalAmount,
        "payment_method": paymentMethod == null ? null : paymentMethod,
        "cash_deposit": cashDeposit == null ? null : cashDeposit,
        "runner_payout": runnerPayout == null ? null : runnerPayout,
        "booking_date_time":
            bookingDateTime == null ? null : bookingDateTime.toIso8601String(),
        "booking_completed_date": bookingCompletedDate == null
            ? null
            : "${bookingCompletedDate.year.toString().padLeft(4, '0')}-${bookingCompletedDate.month.toString().padLeft(2, '0')}-${bookingCompletedDate.day.toString().padLeft(2, '0')}",
        "category_title": categoryTitle == null ? null : categoryTitle,
        "order_amount": orderAmount == null ? null : orderAmount,
      };
}

class Summery {
  Summery({
    this.totalEarning,
    this.totalBookings,
  });

  String totalEarning;
  String totalBookings;

  Summery copyWith({
    String totalEarning,
    String totalBookings,
  }) =>
      Summery(
        totalEarning: totalEarning ?? this.totalEarning,
        totalBookings: totalBookings ?? this.totalBookings,
      );

  factory Summery.fromRawJson(String str) => Summery.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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
