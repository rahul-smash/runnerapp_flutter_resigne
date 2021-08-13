// To parse this JSON data, do
//
//     final underApprovalModel = underApprovalModelFromJson(jsonString);

import 'dart:convert';

UnderApprovalModel underApprovalModelFromJson(String str) => UnderApprovalModel.fromJson(json.decode(str));

String underApprovalModelToJson(UnderApprovalModel data) => json.encode(data.toJson());

class UnderApprovalModel {
  UnderApprovalModel({
    this.success,
  });

  Success success;

  factory UnderApprovalModel.fromJson(Map<String, dynamic> json) => UnderApprovalModel(
    success: Success.fromJson(json["success"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success.toJson(),
  };
}

class Success {
  Success({
    this.userData,
    this.categoryies,
    this.statusMessage,
    this.processMessage,
  });

  UserData userData;
  List<Categoryy> categoryies;
  String statusMessage;
  String processMessage;

  factory Success.fromJson(Map<String, dynamic> json) => Success(
    userData: UserData.fromJson(json["user_data"]),
    categoryies: List<Categoryy>.from(json["categoryies"].map((x) => Categoryy.fromJson(x))),
    statusMessage: json["status_message"],
    processMessage: json["process_message"],
  );

  Map<String, dynamic> toJson() => {
    "user_data": userData.toJson(),
    "categoryies": List<dynamic>.from(categoryies.map((x) => x.toJson())),
    "status_message": statusMessage,
    "process_message": processMessage,
  };
}

class Categoryy {
  Categoryy({
    this.id,
    this.title,
    this.serviceCount,
  });

  String id;
  String title;
  String serviceCount;

  factory Categoryy.fromJson(Map<String, dynamic> json) => Categoryy(
    id: json["id"],
    title: json["title"],
    serviceCount: json["service_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "service_count": serviceCount,
  };
}

class UserData {
  UserData({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.gender,
    this.dob,
    this.status,
    this.profileImage,
    this.experience,
    this.addrees,
    this.profileImage10080,
    this.profileImage300200,
  });

  String id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String gender;
  DateTime dob;
  String status;
  String profileImage;
  String experience;
  String addrees;
  String profileImage10080;
  String profileImage300200;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    phone: json["phone"],
    gender: json["gender"],
    dob: DateTime.parse(json["dob"]),
    status: json["status"],
    profileImage: json["profile_image"],
    experience: json["experience"],
    addrees: json["Addrees"],
    profileImage10080: json["profile_image_100_80"],
    profileImage300200: json["profile_image_300_200"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "phone": phone,
    "gender": gender,
    "dob": "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
    "status": status,
    "profile_image": profileImage,
    "experience": experience,
    "Addrees": addrees,
    "profile_image_100_80": profileImage10080,
    "profile_image_300_200": profileImage300200,
  };
}
