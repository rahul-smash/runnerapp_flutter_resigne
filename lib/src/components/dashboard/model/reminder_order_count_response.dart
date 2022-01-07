// To parse this JSON data, do
//
//     final reminderOrderCountResponse = reminderOrderCountResponseFromJson(jsonString);

import 'dart:convert';

class ReminderOrderCountResponse {
  ReminderOrderCountResponse({
    this.success,
    this.orderCountManual,
    this.orderCountAuto,
    this.message,
  });

  bool success;
  String orderCountManual;
  String orderCountAuto;
  String message;

  ReminderOrderCountResponse copyWith({
    bool success,
    String orderCountManual,
    String orderCountAuto,
    String message,
  }) =>
      ReminderOrderCountResponse(
        success: success ?? this.success,
        orderCountManual: orderCountManual ?? this.orderCountManual,
        orderCountAuto: orderCountAuto ?? this.orderCountAuto,
        message: message ?? this.message,
      );

  factory ReminderOrderCountResponse.fromRawJson(String str) => ReminderOrderCountResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReminderOrderCountResponse.fromJson(Map<String, dynamic> json) => ReminderOrderCountResponse(
    success: json["success"] == null ? null : json["success"],
    orderCountManual: json["order_count_manual"] == null ? null : json["order_count_manual"].toString(),
    orderCountAuto: json["order_count_auto"] == null ? null : json["order_count_auto"].toString(),
    message: json["message"] == null ? null : json["message"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "order_count_manual": orderCountManual == null ? null : orderCountManual,
    "order_count_auto": orderCountAuto == null ? null : orderCountAuto,
    "message": message == null ? null : message,
  };
}
