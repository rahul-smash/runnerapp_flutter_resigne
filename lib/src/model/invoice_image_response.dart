// To parse this JSON data, do
//
//     final invoiceImageResponse = invoiceImageResponseFromJson(jsonString);

import 'dart:convert';

InvoiceImageResponse invoiceImageResponseFromJson(String str) =>
    InvoiceImageResponse.fromJson(json.decode(str));

String invoiceImageResponseToJson(InvoiceImageResponse data) =>
    json.encode(data.toJson());

class InvoiceImageResponse {
  InvoiceImageResponse({
    this.success,
    this.message,
  });

  bool success;
  String message;

  factory InvoiceImageResponse.fromJson(Map<String, dynamic> json) =>
      InvoiceImageResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
