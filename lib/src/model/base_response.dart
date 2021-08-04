// To parse this JSON data, do
//
//     final baseResponse = baseResponseFromJson(jsonString);

import 'dart:convert';

class BaseResponse {
  BaseResponse({
    this.success,
    this.message,
    this.user_id,
  });

  bool success;
  String message;
  String user_id;

  BaseResponse copyWith({
    bool success,
    String message,
    String user_id,
  }) =>
      BaseResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        user_id: user_id ?? this.user_id,
      );

  factory BaseResponse.fromRawJson(String str) => BaseResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    user_id: json["user_id"] == null ? null : json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "user_id": user_id == null ? null : user_id,
  };
}
