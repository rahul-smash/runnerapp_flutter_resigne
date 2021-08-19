// To parse this JSON data, do
//
//     final registerResponse = registerResponseFromJson(jsonString);

import 'dart:convert';

RegisterResponse registerResponseFromJson(String str) => RegisterResponse.fromJson(json.decode(str));

String registerResponseToJson(RegisterResponse data) => json.encode(data.toJson());

class RegisterResponse {
  RegisterResponse({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  UserRegisterData data;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : UserRegisterData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class UserRegisterData {
  UserRegisterData({
    this.fullName,
    this.lastName,
    this.phone,
    this.registeredAs,
    this.otpVerify,
    this.deviceId,
    this.platform,
    this.status,
    this.id,
  });

  String fullName;
  String lastName;
  String phone;
  String registeredAs;
  int otpVerify;
  String deviceId;
  String platform;
  int status;
  String id;

  factory UserRegisterData.fromJson(Map<String, dynamic> json) => UserRegisterData(
    fullName: json["full_name"],
    lastName: json["last_name"],
    phone: json["phone"],
    registeredAs: json["registered_as"],
    otpVerify: json["otp_verify"],
    deviceId: json["device_id"],
    platform: json["platform"],
    status: json["status"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "last_name": lastName,
    "phone": phone,
    "registered_as": registeredAs,
    "otp_verify": otpVerify,
    "device_id": deviceId,
    "platform": platform,
    "status": status,
    "id": id,
  };
}
