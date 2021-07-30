// To parse this JSON data, do
//
//     final baseResponse = baseResponseFromJson(jsonString);

import 'dart:convert';

class BaseResponse {
  BaseResponse({
    this.success,
    this.message,
  });

  bool success;
  String message;

  BaseResponse copyWith({
    bool success,
    String message,
  }) =>
      BaseResponse(
        success: success ?? this.success,
        message: message ?? this.message,
      );

  factory BaseResponse.fromRawJson(String str) => BaseResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
  };
}
