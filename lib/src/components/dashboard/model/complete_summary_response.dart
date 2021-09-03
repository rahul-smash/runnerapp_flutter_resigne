// To parse this JSON data, do
//
//     final completeListResponse = completeListResponseFromJson(jsonString);

import 'dart:convert';

class CompleteSummaryResponse {
  CompleteSummaryResponse({
    this.success,
    this.summery,
    this.completedPayouts,
    this.totalRecord,
    this.keysList,
  });

  bool success;
  Summery summery;
  Map<String, List<CompletedPayouts>> completedPayouts;
  String totalRecord;
  List<String> keysList;

  CompleteSummaryResponse copyWith({
    bool success,
    Summery summery,
    CompletedPayouts completedPayouts,
    int totalRecord,
  }) =>
      CompleteSummaryResponse(
        success: success ?? this.success,
        summery: summery ?? this.summery,
        completedPayouts: completedPayouts ?? this.completedPayouts,
        totalRecord: totalRecord ?? this.totalRecord,
      );

  factory CompleteSummaryResponse.fromRawJson(String str) =>
      CompleteSummaryResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompleteSummaryResponse.fromJson(Map<String, dynamic> json) {
    List<String> keysList = List.empty(growable: true);
    return CompleteSummaryResponse(
        success: json["success"] == null ? null : json["success"],
        summery:
            json["summery"] == null ? null : Summery.fromJson(json["summery"]),
        completedPayouts:
            json["completedPayouts"] == null || json["completedPayouts"] is List
                ? null
                : Map.from(json["completedPayouts"]).map((k, v) {
                    keysList.add(k);
                    return MapEntry<String, List<CompletedPayouts>>(
                        k,
                        List<CompletedPayouts>.from(
                            v.map((x) => CompletedPayouts.fromJson(x))));
                  }),
        totalRecord:
            json["totalRecord"] == null ? null : json["totalRecord"].toString(),
        keysList: keysList);
  }

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "summery": summery == null ? null : summery.toJson(),

        "totalRecord": totalRecord == null ? null : totalRecord,
      };
}

class CompletedPayouts {
  CompletedPayouts({
    this.id,
    this.runnerBatchId,
    this.totalPayout,
    this.totalOrders,
    this.payoutDateTime,
    this.payoutCompletedDate,
  });

  String id;
  String runnerBatchId;
  String totalPayout;
  String totalOrders;
  String payoutDateTime;
  DateTime payoutCompletedDate;

  CompletedPayouts copyWith({
    String id,
    String runnerBatchId,
    String totalPayout,
    String totalOrders,
    String payoutDateTime,
    DateTime payoutCompletedDate,
  }) =>
      CompletedPayouts(
        id: id ?? this.id,
        runnerBatchId: runnerBatchId ?? this.runnerBatchId,
        totalPayout: totalPayout ?? this.totalPayout,
        totalOrders: totalOrders ?? this.totalOrders,
        payoutDateTime: payoutDateTime ?? this.payoutDateTime,
        payoutCompletedDate: payoutCompletedDate ?? this.payoutCompletedDate,
      );

  factory CompletedPayouts.fromRawJson(String str) =>
      CompletedPayouts.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompletedPayouts.fromJson(Map<String, dynamic> json) =>
      CompletedPayouts(
        id: json["id"] == null ? null : json["id"],
        runnerBatchId:
            json["runner_batch_id"] == null ? null : json["runner_batch_id"],
        totalPayout: json["total_payout"] == null ? null : json["total_payout"],
        totalOrders: json["total_orders"] == null ? null : json["total_orders"],
        payoutDateTime:
            json["payout_date_time"] == null ? null : json["payout_date_time"],
        payoutCompletedDate: json["payout_completed_date"] == null
            ? null
            : DateTime.parse(json["payout_completed_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "runner_batch_id": runnerBatchId == null ? null : runnerBatchId,
        "total_payout": totalPayout == null ? null : totalPayout,
        "total_orders": totalOrders == null ? null : totalOrders,
        "payout_date_time": payoutDateTime == null ? null : payoutDateTime,
        "payout_completed_date": payoutCompletedDate == null
            ? null
            : "${payoutCompletedDate.year.toString().padLeft(4, '0')}-${payoutCompletedDate.month.toString().padLeft(2, '0')}-${payoutCompletedDate.day.toString().padLeft(2, '0')}",
      };
}

class Summery {
  Summery({
    this.totalEarning,
  });

  String totalEarning;

  Summery copyWith({
    String totalEarning,
  }) =>
      Summery(
        totalEarning: totalEarning ?? this.totalEarning,
      );

  factory Summery.fromRawJson(String str) => Summery.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Summery.fromJson(Map<String, dynamic> json) => Summery(
        totalEarning:
            json["total_earning"] == null ? null : json["total_earning"],
      );

  Map<String, dynamic> toJson() => {
        "total_earning": totalEarning == null ? null : totalEarning,
      };
}
