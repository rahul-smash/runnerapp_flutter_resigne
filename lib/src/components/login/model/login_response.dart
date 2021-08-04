// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.success,
    this.data,
    this.userExists,
    this.message,
    this.brands,
    this.location,
  });

  bool success;
  UserData data;
  int userExists;
  String message;
  List<Brand> brands;
  Location location;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    success: json["success"],
    data: UserData.fromJson(json["data"]),
    userExists: json["user_exists"],
    message: json["message"],
    brands: List<Brand>.from(json["brands"].map((x) => Brand.fromJson(x))),
    location: Location.fromJson(json["location"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "user_exists": userExists,
    "message": message,
    "brands": List<dynamic>.from(brands.map((x) => x.toJson())),
    "location": location.toJson(),
  };
}

class Brand {
  Brand({
    this.id,
    this.name,
    this.address,
    this.city,
    this.state,
    this.country,
    this.zipcode,
    this.lat,
    this.lng,
    this.contactNumber,
    this.contactEmail,
    this.timeZone,
  });

  String id;
  String name;
  String address;
  String city;
  String state;
  String country;
  String zipcode;
  String lat;
  String lng;
  String contactNumber;
  String contactEmail;
  String timeZone;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    zipcode: json["zipcode"],
    lat: json["lat"],
    lng: json["lng"],
    contactNumber: json["contact_number"],
    contactEmail: json["contact_email"],
    timeZone: json["time_zone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "city": city,
    "state": state,
    "country": country,
    "zipcode": zipcode,
    "lat": lat,
    "lng": lng,
    "contact_number": contactNumber,
    "contact_email": contactEmail,
    "time_zone": timeZone,
  };
}

class UserData {
  UserData({
    this.id,
    this.fullName,
    this.lastName,
    this.email,
    this.phone,
    this.gender,
    this.dob,
    this.profileImage,
    this.otpVerify,
    this.userReferCode,
    this.userReferredBy,
    this.status,
    this.deviceId,
    this.deviceToken,
    this.platform,
    this.registeredAs,
    this.profileImage10080,
    this.profileImage300200,
    this.created,
    this.onDuty,
    this.lat,
    this.lng,
    this.rating,
  });

  String id;
  String fullName;
  String lastName;
  String email;
  String phone;
  String gender;
  String dob;
  String profileImage;
  String otpVerify;
  String userReferCode;
  String userReferredBy;
  String status;
  String deviceId;
  String deviceToken;
  String platform;
  String registeredAs;
  String profileImage10080;
  String profileImage300200;
  String created;
  String onDuty;
  String lat;
  String lng;
  String rating;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["id"],
    fullName: json["full_name"],
    lastName: json["last_name"],
    email: json["email"],
    phone: json["phone"],
    gender: json["gender"],
    dob: json["dob"],
    profileImage: json["profile_image"],
    otpVerify: json["otp_verify"],
    userReferCode: json["user_refer_code"],
    userReferredBy: json["user_referred_by"],
    status: json["status"],
    deviceId: json["device_id"],
    deviceToken: json["device_token"],
    platform: json["platform"],
    registeredAs: json["registered_as"],
    profileImage10080: json["profile_image_100_80"],
    profileImage300200: json["profile_image_300_200"],
    created: json["created"],
    onDuty: json["on_duty"],
    lat: json["lat"],
    lng: json["lng"],
    rating: json["rating"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "last_name": lastName,
    "email": email,
    "phone": phone,
    "gender": gender,
    "dob": dob,
    "profile_image": profileImage,
    "otp_verify": otpVerify,
    "user_refer_code": userReferCode,
    "user_referred_by": userReferredBy,
    "status": status,
    "device_id": deviceId,
    "device_token": deviceToken,
    "platform": platform,
    "registered_as": registeredAs,
    "profile_image_100_80": profileImage10080,
    "profile_image_300_200": profileImage300200,
    "created": created,
    "on_duty": onDuty,
    "lat": lat,
    "lng": lng,
    "rating": rating,
  };
}
class Location {
  Location({
    this.locationId,
    this.locationName,
  });

  String locationId;
  String locationName;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    locationId: json["location_id"],
    locationName: json["location_name"],
  );

  Map<String, dynamic> toJson() => {
    "location_id": locationId,
    "location_name": locationName,
  };
}

