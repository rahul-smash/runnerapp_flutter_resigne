// To parse this JSON data, do
//
//     final forgotPassword = forgotPasswordFromJson(jsonString);

import 'dart:convert';

ForgotPasswordResponse forgotPasswordFromJson(String str) => ForgotPasswordResponse.fromJson(json.decode(str));

String forgotPasswordToJson(ForgotPasswordResponse data) => json.encode(data.toJson());

class ForgotPasswordResponse {
  ForgotPasswordResponse({
    this.success,
    this.message,
    this.otp,
    this.data,
  });

  bool success;
  String message;
  String otp;
  Data data;

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) => ForgotPasswordResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    otp: json["otp"] == null ? null : json["otp"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "otp": otp == null ? null : otp,
    "data": data == null ? null : data.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.fullName,
    this.lastName,
    this.fbId,
    this.email,
    this.password,
    this.decodedPassword,
    this.phone,
    this.gender,
    this.dob,
    this.profileImage,
    this.otpVerify,
    this.userReferCode,
    this.userReferredBy,
    this.status,
    this.loginStatus,
    this.deviceId,
    this.deviceToken,
    this.platform,
    this.posCustomerId,
    this.verificationCode,
    this.verificationCodeStatus,
    this.created,
    this.modified,
  });

  String id;
  String fullName;
  String lastName;
  String fbId;
  String email;
  String password;
  String decodedPassword;
  String phone;
  String gender;
  DateTime dob;
  String profileImage;
  String otpVerify;
  String userReferCode;
  String userReferredBy;
  String status;
  String loginStatus;
  String deviceId;
  String deviceToken;
  String platform;
  String posCustomerId;
  String verificationCode;
  String verificationCodeStatus;
  DateTime created;
  DateTime modified;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"] == null ? null : json["id"],
    fullName: json["full_name"] == null ? null : json["full_name"],
    lastName: json["last_name"] == null ? null : json["last_name"],
    fbId: json["fb_id"] == null ? null : json["fb_id"],
    email: json["email"] == null ? null : json["email"],
    password: json["password"] == null ? null : json["password"],
    decodedPassword: json["decoded_password"] == null ? null : json["decoded_password"],
    phone: json["phone"] == null ? null : json["phone"],
    gender: json["gender"] == null ? null : json["gender"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    profileImage: json["profile_image"] == null ? null : json["profile_image"],
    otpVerify: json["otp_verify"] == null ? null : json["otp_verify"],
    userReferCode: json["user_refer_code"] == null ? null : json["user_refer_code"],
    userReferredBy: json["user_referred_by"] == null ? null : json["user_referred_by"],
    status: json["status"] == null ? null : json["status"],
    loginStatus: json["login_status"] == null ? null : json["login_status"],
    deviceId: json["device_id"] == null ? null : json["device_id"],
    deviceToken: json["device_token"] == null ? null : json["device_token"],
    platform: json["platform"] == null ? null : json["platform"],
    posCustomerId: json["pos_customer_id"] == null ? null : json["pos_customer_id"],
    verificationCode: json["verification_code"] == null ? null : json["verification_code"],
    verificationCodeStatus: json["verification_code_status"] == null ? null : json["verification_code_status"],
    created: json["created"] == null ? null : DateTime.parse(json["created"]),
    modified: json["modified"] == null ? null : DateTime.parse(json["modified"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "full_name": fullName == null ? null : fullName,
    "last_name": lastName == null ? null : lastName,
    "fb_id": fbId == null ? null : fbId,
    "email": email == null ? null : email,
    "password": password == null ? null : password,
    "decoded_password": decodedPassword == null ? null : decodedPassword,
    "phone": phone == null ? null : phone,
    "gender": gender == null ? null : gender,
    "dob": dob == null ? null : "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
    "profile_image": profileImage == null ? null : profileImage,
    "otp_verify": otpVerify == null ? null : otpVerify,
    "user_refer_code": userReferCode == null ? null : userReferCode,
    "user_referred_by": userReferredBy == null ? null : userReferredBy,
    "status": status == null ? null : status,
    "login_status": loginStatus == null ? null : loginStatus,
    "device_id": deviceId == null ? null : deviceId,
    "device_token": deviceToken == null ? null : deviceToken,
    "platform": platform == null ? null : platform,
    "pos_customer_id": posCustomerId == null ? null : posCustomerId,
    "verification_code": verificationCode == null ? null : verificationCode,
    "verification_code_status": verificationCodeStatus == null ? null : verificationCodeStatus,
    "created": created == null ? null : created.toIso8601String(),
    "modified": modified == null ? null : modified.toIso8601String(),
  };
}
