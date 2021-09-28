// To parse this JSON data, do
//
//     final depositHistoryDetails = depositHistoryDetailsFromJson(jsonString);

import 'dart:convert';

DepositHistoryDetails depositHistoryDetailsFromJson(String str) =>
    DepositHistoryDetails.fromJson(json.decode(str));

String depositHistoryDetailsToJson(DepositHistoryDetails data) =>
    json.encode(data.toJson());

class DepositHistoryDetails {
  DepositHistoryDetails({
    this.success,
    this.depositSunnery,
    this.deposits,
  });

  bool success;
  DepositSunnery depositSunnery;
  List<Deposit> deposits;

  factory DepositHistoryDetails.fromJson(Map<String, dynamic> json) =>
      DepositHistoryDetails(
        success: json["success"] == null ? null : json["success"],
        depositSunnery: json["depositSunnery"] == null
            ? null
            : DepositSunnery.fromJson(json["depositSunnery"]),
        deposits: json["deposits"] == null
            ? null
            : List<Deposit>.from(
                json["deposits"].map((x) => Deposit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "depositSunnery":
            depositSunnery == null ? null : depositSunnery.toJson(),
        "deposits": deposits == null
            ? null
            : List<dynamic>.from(deposits.map((x) => x.toJson())),
      };
}

class DepositSunnery {
  DepositSunnery({
    this.id,
    this.totalOrders,
    this.totalOrdersAmount,
    this.dateTime,
  });

  String id;
  String totalOrders;
  String totalOrdersAmount;
  DateTime dateTime;

  factory DepositSunnery.fromJson(Map<String, dynamic> json) => DepositSunnery(
        id: json["id"] == null ? null : json["id"],
        totalOrders: json["total_orders"] == null ? null : json["total_orders"],
        totalOrdersAmount: json["total_orders_amount"] == null
            ? null
            : json["total_orders_amount"],
        dateTime: json["date_time"] == null
            ? null
            : DateTime.parse(json["date_time"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "total_orders": totalOrders == null ? null : totalOrders,
        "total_orders_amount":
            totalOrdersAmount == null ? null : totalOrdersAmount,
        "date_time": dateTime == null ? null : dateTime.toIso8601String(),
      };
}

class Deposit {
  Deposit({
    this.orderId,
    this.cashCollected,
    this.displayOrderId,
    this.categoryTitle,
  });

  String orderId;
  String cashCollected;
  String displayOrderId;
  String categoryTitle;

  factory Deposit.fromJson(Map<String, dynamic> json) => Deposit(
        orderId: json["order_id"] == null ? null : json["order_id"],
        cashCollected:
            json["cash_collected"] == null ? null : json["cash_collected"],
        displayOrderId:
            json["display_order_id"] == null ? null : json["display_order_id"],
        categoryTitle:
            json["category_title"] == null ? null : json["category_title"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId == null ? null : orderId,
        "cash_collected": cashCollected == null ? null : cashCollected,
        "display_order_id": displayOrderId == null ? null : displayOrderId,
        "category_title": categoryTitle == null ? null : categoryTitle,
      };
}
