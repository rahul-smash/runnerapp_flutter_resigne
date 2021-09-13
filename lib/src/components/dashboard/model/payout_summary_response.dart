// To parse this JSON data, do
//
//     final payoutSummaryResponse = payoutSummaryResponseFromJson(jsonString);

import 'dart:convert';

class PayoutSummaryResponse {
  PayoutSummaryResponse({
    this.success,
    this.summery,
  });

  bool success;
  Summery summery;

  PayoutSummaryResponse copyWith({
    bool success,
    Summery summery,
  }) =>
      PayoutSummaryResponse(
        success: success ?? this.success,
        summery: summery ?? this.summery,
      );

  factory PayoutSummaryResponse.fromRawJson(String str) => PayoutSummaryResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PayoutSummaryResponse.fromJson(Map<String, dynamic> json) => PayoutSummaryResponse(
    success: json["success"] == null ? null : json["success"],
    summery: json["summery"] == null ? null : Summery.fromJson(json["summery"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "summery": summery == null ? null : summery.toJson(),
  };
}

class Summery {
  Summery({
    this.pendingPayout,
    this.completedPayout,
    this.deposite,
  });

  Payout pendingPayout;
  Payout completedPayout;
  Deposite deposite;

  Summery copyWith({
    Payout pendingPayout,
    Payout completedPayout,
    Deposite deposite,
  }) =>
      Summery(
        pendingPayout: pendingPayout ?? this.pendingPayout,
        completedPayout: completedPayout ?? this.completedPayout,
        deposite: deposite ?? this.deposite,
      );

  factory Summery.fromRawJson(String str) => Summery.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Summery.fromJson(Map<String, dynamic> json) => Summery(
    pendingPayout: json["pending_payout"] == null ? null : Payout.fromJson(json["pending_payout"]),
    completedPayout: json["completed_payout"] == null ? null : Payout.fromJson(json["completed_payout"]),
    deposite: json["deposite"] == null ? null : Deposite.fromJson(json["deposite"]),
  );

  Map<String, dynamic> toJson() => {
    "pending_payout": pendingPayout == null ? null : pendingPayout.toJson(),
    "completed_payout": completedPayout == null ? null : completedPayout.toJson(),
    "deposite": deposite == null ? null : deposite.toJson(),
  };
}

class Payout {
  Payout({
    this.bookingCount,
    this.bookingPayout,
    this.lastUpdated,
  });

  String bookingCount;
  String bookingPayout;
  String lastUpdated;

  Payout copyWith({
    String bookingCount,
    String bookingPayout,
    String lastUpdated,
  }) =>
      Payout(
        bookingCount: bookingCount ?? this.bookingCount,
        bookingPayout: bookingPayout ?? this.bookingPayout,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );

  factory Payout.fromRawJson(String str) => Payout.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Payout.fromJson(Map<String, dynamic> json) => Payout(
    bookingCount: json["booking_count"] == null ? null : json["booking_count"],
    bookingPayout: json["booking_payout"] == null ? null : json["booking_payout"],
    lastUpdated: json["last_updated"] == null ? null : json["last_updated"],
  );

  Map<String, dynamic> toJson() => {
    "booking_count": bookingCount == null ? null : bookingCount,
    "booking_payout": bookingPayout == null ? null : bookingPayout,
    "last_updated": lastUpdated == null ? null : lastUpdated,
  };
}

class Deposite {
  Deposite({
    this.depositePercentage,
    this.cashInHand,
    this.lastUpdated,
    this.cashLimit,
  });

  String depositePercentage;
  String cashInHand;
  String lastUpdated;
  String cashLimit;

  Deposite copyWith({
    String depositePercentage,
    String cashInHand,
    String lastUpdated,
    String cashLimit,
  }) =>
      Deposite(
        depositePercentage: depositePercentage ?? this.depositePercentage,
        cashInHand: cashInHand ?? this.cashInHand,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        cashLimit: cashLimit ?? this.cashLimit,
      );

  factory Deposite.fromRawJson(String str) => Deposite.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Deposite.fromJson(Map<String, dynamic> json) => Deposite(
    depositePercentage: json["deposite_percentage"] == null ? null : json["deposite_percentage"],
    cashInHand: json["cash_in_hand"] == null ? null : json["cash_in_hand"],
    lastUpdated: json["last_updated"] == null ? null : json["last_updated"],
    cashLimit: json["cash_limit"] == null ? null : json["cash_limit"],
  );

  Map<String, dynamic> toJson() => {
    "deposite_percentage": depositePercentage == null ? null : depositePercentage,
    "cash_in_hand": cashInHand == null ? null : cashInHand,
    "last_updated": lastUpdated == null ? null : lastUpdated,
    "cash_limit": cashLimit == null ? null : cashLimit,
  };
}
