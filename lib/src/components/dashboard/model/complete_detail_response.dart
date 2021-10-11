// To parse this JSON data, do
//
//     final completeDetailResponse = completeDetailResponseFromJson(jsonString);

import 'dart:convert';

class CompleteDetailResponse {
  CompleteDetailResponse({
    this.success,
    this.payoutDetail,
    this.payouts,
  });

  bool success;
  PayoutDetail payoutDetail;
  List<Payout> payouts;

  CompleteDetailResponse copyWith({
    bool success,
    PayoutDetail payoutDetail,
    List<Payout> payouts,
  }) =>
      CompleteDetailResponse(
        success: success ?? this.success,
        payoutDetail: payoutDetail ?? this.payoutDetail,
        payouts: payouts ?? this.payouts,
      );

  factory CompleteDetailResponse.fromRawJson(String str) =>
      CompleteDetailResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompleteDetailResponse.fromJson(Map<String, dynamic> json) =>
      CompleteDetailResponse(
        success: json["success"] == null ? null : json["success"],
        payoutDetail: json["payoutDetail"] == null
            ? null
            : PayoutDetail.fromJson(json["payoutDetail"]),
        payouts: json["payouts"] == null
            ? null
            : List<Payout>.from(json["payouts"].map((x) => Payout.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "payoutDetail": payoutDetail == null ? null : payoutDetail.toJson(),
        "payouts": payouts == null
            ? null
            : List<dynamic>.from(payouts.map((x) => x.toJson())),
      };
}

class PayoutDetail {
  PayoutDetail({
    this.id,
    this.runnerBatchId,
    this.totalOrders,
    this.totalOrdersAmount,
    this.totalPayout,
    this.tax,
    this.tds,
    this.dateTime,
  });

  String id;
  String runnerBatchId;
  String totalOrders;
  String totalOrdersAmount;
  String totalPayout;
  String tax;
  String tds;
  String dateTime;

  PayoutDetail copyWith({
    String id,
    String runnerBatchId,
    String totalOrders,
    String totalOrdersAmount,
    String totalPayout,
    String tax,
    String tds,
    String dateTime,
  }) =>
      PayoutDetail(
        id: id ?? this.id,
        runnerBatchId: runnerBatchId ?? this.runnerBatchId,
        totalOrders: totalOrders ?? this.totalOrders,
        totalOrdersAmount: totalOrdersAmount ?? this.totalOrdersAmount,
        totalPayout: totalPayout ?? this.totalPayout,
        tax: tax ?? this.tax,
        tds: tds ?? this.tds,
        dateTime: dateTime ?? this.dateTime,
      );

  factory PayoutDetail.fromRawJson(String str) =>
      PayoutDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PayoutDetail.fromJson(Map<String, dynamic> json) => PayoutDetail(
        id: json["id"] == null ? null : json["id"],
        runnerBatchId:
            json["runner_batch_id"] == null ? null : json["runner_batch_id"],
        totalOrders: json["total_orders"] == null ? null : json["total_orders"],
        totalOrdersAmount: json["total_orders_amount"] == null
            ? null
            : json["total_orders_amount"],
        totalPayout: json["total_payout"] == null ? null : json["total_payout"],
        tax: json["tax"] == null ? null : json["tax"],
        tds: json["tds"] == null ? null : json["tds"],
        dateTime: json["date_time"] == null ? null : json["date_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "runner_batch_id": runnerBatchId == null ? null : runnerBatchId,
        "total_orders": totalOrders == null ? null : totalOrders,
        "total_orders_amount":
            totalOrdersAmount == null ? null : totalOrdersAmount,
        "total_payout": totalPayout == null ? null : totalPayout,
        "tax": tax == null ? null : tax,
        "tds": tds == null ? null : tds,
        "date_time": dateTime == null ? null : dateTime,
      };
}

class Payout {
  Payout({
    this.orderId,
    this.totalAmount,
    this.paymentMethod,
    this.cashDeposit,
    this.runnerPayout,
    this.categoryTitle,
    this.orderAmount,
  });

  String orderId;
  String totalAmount;
  String paymentMethod;
  String cashDeposit;
  String runnerPayout;
  String categoryTitle;
  String orderAmount;

  Payout copyWith(
          {String orderId,
          String totalAmount,
          String paymentMethod,
          String cashDeposit,
          String runnerPayout,
          String categoryTitle,
          String orderAmount}) =>
      Payout(
        orderId: orderId ?? this.orderId,
        totalAmount: totalAmount ?? this.totalAmount,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        cashDeposit: cashDeposit ?? this.cashDeposit,
        runnerPayout: runnerPayout ?? this.runnerPayout,
        categoryTitle: categoryTitle ?? this.categoryTitle,
        orderAmount: orderAmount ?? this.orderAmount,
      );

  factory Payout.fromRawJson(String str) => Payout.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Payout.fromJson(Map<String, dynamic> json) => Payout(
        orderId: json["order_id"] == null ? null : json["order_id"],
        totalAmount: json["total_amount"] == null ? null : json["total_amount"],
        paymentMethod:
            json["payment_method"] == null ? null : json["payment_method"],
        cashDeposit: json["cash_deposit"] == null ? null : json["cash_deposit"],
        runnerPayout:
            json["runner_payout"] == null ? null : json["runner_payout"],
        categoryTitle:
            json["category_title"] == null ? null : json["category_title"],
        orderAmount: json["order_amount"] == null ? null : json["order_amount"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId == null ? null : orderId,
        "total_amount": totalAmount == null ? null : totalAmount,
        "payment_method": paymentMethod == null ? null : paymentMethod,
        "cash_deposit": cashDeposit == null ? null : cashDeposit,
        "runner_payout": runnerPayout == null ? null : runnerPayout,
        "category_title": categoryTitle == null ? null : categoryTitle,
        "order_amount": orderAmount == null ? null : orderAmount,
      };
}
