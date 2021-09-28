// To parse this JSON data, do
//
//     final depositHistory = depositHistoryFromJson(jsonString);

import 'dart:convert';

DepositHistory depositHistoryFromJson(String str) =>
    DepositHistory.fromJson(json.decode(str));

String depositHistoryToJson(DepositHistory data) => json.encode(data.toJson());

class DepositHistory {
  DepositHistory({
    this.success,
    this.summery,
    this.depositData,
    this.totalRecord,
  });

  bool success;
  Summery summery;
  List<DepositDatum> depositData;
  int totalRecord;

  factory DepositHistory.fromJson(Map<String, dynamic> json) => DepositHistory(
        success: json["success"] == null ? null : json["success"],
        summery:
            json["summery"] == null ? null : Summery.fromJson(json["summery"]),
        depositData: json["depositData"] == null
            ? null
            : List<DepositDatum>.from(
                json["depositData"].map((x) => DepositDatum.fromJson(x))),
        totalRecord: json["totalRecord"] == null ? null : json["totalRecord"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "summery": summery == null ? null : summery.toJson(),
        "depositData": depositData == null
            ? null
            : List<dynamic>.from(depositData.map((x) => x.toJson())),
        "totalRecord": totalRecord == null ? null : totalRecord,
      };
}

class DepositDatum {
  DepositDatum({
    this.id,
    this.runnerDepositBatchId,
    this.totalOrders,
    this.totalOrdersAmount,
    this.depositVerified,
    this.depositDateTime,
    this.depositType,
  });

  String id;
  String runnerDepositBatchId;
  String totalOrders;
  String totalOrdersAmount;
  String depositVerified;
  DateTime depositDateTime;
  String depositType;

  factory DepositDatum.fromJson(Map<String, dynamic> json) => DepositDatum(
        id: json["id"] == null ? null : json["id"],
        runnerDepositBatchId: json["runner_deposit_batch_id"] == null
            ? null
            : json["runner_deposit_batch_id"],
        totalOrders: json["total_orders"] == null ? null : json["total_orders"],
        totalOrdersAmount: json["total_orders_amount"] == null
            ? null
            : json["total_orders_amount"],
        depositVerified:
            json["deposit_verified"] == null ? null : json["deposit_verified"],
        depositDateTime: json["deposit_date_time"] == null
            ? null
            : DateTime.parse(json["deposit_date_time"]),
        depositType: json["deposit_type"] == null ? null : json["deposit_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "runner_deposit_batch_id":
            runnerDepositBatchId == null ? null : runnerDepositBatchId,
        "total_orders": totalOrders == null ? null : totalOrders,
        "total_orders_amount":
            totalOrdersAmount == null ? null : totalOrdersAmount,
        "deposit_verified": depositVerified == null ? null : depositVerified,
        "deposit_date_time":
            depositDateTime == null ? null : depositDateTime.toIso8601String(),
        "deposit_type": depositType == null ? null : depositType,
      };
}

class Summery {
  Summery({
    this.totalEarning,
  });

  String totalEarning;

  factory Summery.fromJson(Map<String, dynamic> json) => Summery(
        totalEarning:
            json["total_earning"] == null ? null : json["total_earning"],
      );

  Map<String, dynamic> toJson() => {
        "total_earning": totalEarning == null ? null : totalEarning,
      };
}
