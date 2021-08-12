// To parse this JSON data, do
//
//     final agreementDetailModel = agreementDetailModelFromJson(jsonString);

import 'dart:convert';

AgreementDetailModel agreementDetailModelFromJson(String str) => AgreementDetailModel.fromJson(json.decode(str));

String agreementDetailModelToJson(AgreementDetailModel data) => json.encode(data.toJson());

class AgreementDetailModel {
  AgreementDetailModel({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  factory AgreementDetailModel.fromJson(Map<String, dynamic> json) => AgreementDetailModel(
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
    this.id,
    this.brandId,
    this.title,
    this.message,
    this.lang2Message,
    this.image,
    this.created,
    this.modified,
    this.image10080,
    this.image300200,
  });

  String id;
  String brandId;
  String title;
  String message;
  String lang2Message;
  String image;
  DateTime created;
  DateTime modified;
  String image10080;
  String image300200;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    brandId: json["brand_id"],
    title: json["title"],
    message: json["message"],
    lang2Message: json["lang_2_message"],
    image: json["image"],
    created: DateTime.parse(json["created"]),
    modified: DateTime.parse(json["modified"]),
    image10080: json["image_100_80"],
    image300200: json["image_300_200"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "brand_id": brandId,
    "title": title,
    "message": message,
    "lang_2_message": lang2Message,
    "image": image,
    "created": created.toIso8601String(),
    "modified": modified.toIso8601String(),
    "image_100_80": image10080,
    "image_300_200": image300200,
  };
}
