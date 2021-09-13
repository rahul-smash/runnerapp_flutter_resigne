// To parse this JSON data, do
//
//     final depositResponse = depositResponseFromJson(jsonString);

import 'dart:convert';

class DepositResponse {
  DepositResponse({
    this.success,
    this.summery,
    this.cashCollection,
    this.totalRecord,
  });

  bool success;
  Summery summery;
  List<CashCollection> cashCollection;
  int totalRecord;

  DepositResponse copyWith({
    bool success,
    Summery summery,
    List<CashCollection> cashCollection,
    int totalRecord,
  }) =>
      DepositResponse(
        success: success ?? this.success,
        summery: summery ?? this.summery,
        cashCollection: cashCollection ?? this.cashCollection,
        totalRecord: totalRecord ?? this.totalRecord,
      );

  factory DepositResponse.fromRawJson(String str) => DepositResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DepositResponse.fromJson(Map<String, dynamic> json) => DepositResponse(
    success: json["success"] == null ? null : json["success"],
    summery: json["summery"] == null ? null : Summery.fromJson(json["summery"]),
    cashCollection: json["cashCollection"] == null ? null : List<CashCollection>.from(json["cashCollection"].map((x) => CashCollection.fromJson(x))),
    totalRecord: json["totalRecord"] == null ? null : json["totalRecord"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "summery": summery == null ? null : summery.toJson(),
    "cashCollection": cashCollection == null ? null : List<dynamic>.from(cashCollection.map((x) => x.toJson())),
    "totalRecord": totalRecord == null ? null : totalRecord,
  };
}

class CashCollection {
  CashCollection({
    this.orderId,
    this.cashCollected,
    this.cashCollectionDateTime,
    this.displayOrderId,
    this.categoryTitle,
  });

  String orderId;
  String cashCollected;
  DateTime cashCollectionDateTime;
  String displayOrderId;
  String categoryTitle;

  CashCollection copyWith({
    String orderId,
    String cashCollected,
    DateTime cashCollectionDateTime,
    String displayOrderId,
    String categoryTitle,
  }) =>
      CashCollection(
        orderId: orderId ?? this.orderId,
        cashCollected: cashCollected ?? this.cashCollected,
        cashCollectionDateTime: cashCollectionDateTime ?? this.cashCollectionDateTime,
        displayOrderId: displayOrderId ?? this.displayOrderId,
        categoryTitle: categoryTitle ?? this.categoryTitle,
      );

  factory CashCollection.fromRawJson(String str) => CashCollection.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CashCollection.fromJson(Map<String, dynamic> json) => CashCollection(
    orderId: json["order_id"] == null ? null : json["order_id"],
    cashCollected: json["cash_collected"] == null ? null : json["cash_collected"],
    cashCollectionDateTime: json["cash_collection_date_time"] == null ? null : DateTime.parse(json["cash_collection_date_time"]),
    displayOrderId: json["display_order_id"] == null ? null : json["display_order_id"],
    categoryTitle: json["category_title"] == null ? null : json["category_title"],
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId == null ? null : orderId,
    "cash_collected": cashCollected == null ? null : cashCollected,
    "cash_collection_date_time": cashCollectionDateTime == null ? null : cashCollectionDateTime.toIso8601String(),
    "display_order_id": displayOrderId == null ? null : displayOrderId,
    "category_title": categoryTitle == null ? null : categoryTitle,
  };
}

class Summery {
  Summery({
    this.cashInHand,
    this.cashLimit,
    this.depositPercentage,
  });

  String cashInHand;
  String cashLimit;
  String depositPercentage;

  Summery copyWith({
    String cashInHand,
    String cashLimit,
    String depositPercentage,
  }) =>
      Summery(
        cashInHand: cashInHand ?? this.cashInHand,
        cashLimit: cashLimit ?? this.cashLimit,
        depositPercentage: depositPercentage ?? this.depositPercentage,
      );

  factory Summery.fromRawJson(String str) => Summery.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Summery.fromJson(Map<String, dynamic> json) => Summery(
    cashInHand: json["cash_in_hand"] == null ? null : json["cash_in_hand"],
    cashLimit: json["cash_limit"] == null ? null : json["cash_limit"],
    depositPercentage: json["deposit_percentage"] == null ? null : json["deposit_percentage"],
  );

  Map<String, dynamic> toJson() => {
    "cash_in_hand": cashInHand == null ? null : cashInHand,
    "cash_limit": cashLimit == null ? null : cashLimit,
    "deposit_percentage": depositPercentage == null ? null : depositPercentage,
  };
}
