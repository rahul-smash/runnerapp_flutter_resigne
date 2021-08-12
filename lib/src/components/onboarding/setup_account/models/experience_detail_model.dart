// To parse this JSON data, do
//
//     final experienceDetailModel = experienceDetailModelFromJson(jsonString);

import 'dart:convert';

ExperienceDetailModel experienceDetailModelFromJson(String str) => ExperienceDetailModel.fromJson(json.decode(str));

String experienceDetailModelToJson(ExperienceDetailModel data) => json.encode(data.toJson());

class ExperienceDetailModel {
  ExperienceDetailModel({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  factory ExperienceDetailModel.fromJson(Map<String, dynamic> json) => ExperienceDetailModel(
    success: json["success"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.brandId,
    this.userId,
    this.experience,
    this.qualifications,
    this.certificate,
    this.workPhotographs,
    this.experienceId,
  });

  String brandId;
  String userId;
  String experience;
  String qualifications;
  List<String> certificate;
  List<String> workPhotographs;
  String experienceId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    brandId: json["brand_id"],
    userId: json["user_id"],
    experience: json["experience"],
    qualifications: json["qualifications"],
    certificate: List<String>.from(json["certificate"].map((x) => x)),
    workPhotographs: List<String>.from(json["work_photographs"].map((x) => x)),
    experienceId: json["experience_id"],
  );

  Map<String, dynamic> toJson() => {
    "brand_id": brandId,
    "user_id": userId,
    "experience": experience,
    "qualifications": qualifications,
    "certificate": List<String>.from(certificate.map((x) => x)),
    "work_photographs": List<String>.from(workPhotographs.map((x) => x)),
    "experience_id": experienceId,
  };
}
