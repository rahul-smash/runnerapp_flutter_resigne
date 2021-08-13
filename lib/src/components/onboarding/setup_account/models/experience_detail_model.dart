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
    this.certificateImage1,
    this.certificateImage2,
    this.certificateImage3,
    this.workPhotographImage1,
    this.workPhotographImage2,
    this.workPhotographImage3,
    this.experienceId,
  });

  String brandId;
  String userId;
  String experience;
  String qualifications;
  String certificateImage1;
  String certificateImage2;
  String certificateImage3;
  String workPhotographImage1;
  String workPhotographImage2;
  String workPhotographImage3;
  String experienceId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    brandId: json["brand_id"],
    userId: json["user_id"],
    experience: json["experience"],
    qualifications: json["qualifications"],
    certificateImage1: json["certificate_image1"],
    certificateImage2: json["certificate_image2"],
    certificateImage3: json["certificate_image3"],
    workPhotographImage1: json["work_photograph_image1"],
    workPhotographImage2: json["work_photograph_image2"],
    workPhotographImage3: json["work_photograph_image3"],
    experienceId: json["experience_id"],
  );

  Map<String, dynamic> toJson() => {
    "brand_id": brandId,
    "user_id": userId,
    "experience": experience,
    "qualifications": qualifications,
    "certificate_image1": certificateImage1,
    "certificate_image2": certificateImage2,
    "certificate_image3": certificateImage3,
    "work_photograph_image1": workPhotographImage1,
    "work_photograph_image2": workPhotographImage2,
    "work_photograph_image3": workPhotographImage3,
    "experience_id": experienceId,
  };
}
