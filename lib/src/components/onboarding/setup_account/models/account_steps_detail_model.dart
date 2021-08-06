// To parse this JSON data, do
//
//     final accountStepsDetailModel = accountStepsDetailModelFromJson(jsonString);

import 'dart:convert';

AccountStepsDetailModel accountStepsDetailModelFromJson(String str) => AccountStepsDetailModel.fromJson(json.decode(str));

String accountStepsDetailModelToJson(AccountStepsDetailModel data) => json.encode(data.toJson());

class AccountStepsDetailModel {
  AccountStepsDetailModel({
    this.success,
    this.data,
  });

  bool success;
  AccountStepsData data;

  factory AccountStepsDetailModel.fromJson(Map<String, dynamic> json) => AccountStepsDetailModel(
    success: json["success"],
    data: AccountStepsData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
  };
}

class AccountStepsData {
  AccountStepsData({
    this.id,
    this.brandId,
    this.userId,
    this.profileDetail,
    this.businessDetail,
    this.workDetail,
    this.agreementDetail,
  });

  String id;
  String brandId;
  String userId;
  String profileDetail;
  String businessDetail;
  String workDetail;
  String agreementDetail;

  factory AccountStepsData.fromJson(Map<String, dynamic> json) => AccountStepsData(
    id: json["id"],
    brandId: json["brand_id"],
    userId: json["user_id"],
    profileDetail: json["profile_detail"],
    businessDetail: json["business_detail"],
    workDetail: json["work_detail"],
    agreementDetail: json["agreement_detail"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "brand_id": brandId,
    "user_id": userId,
    "profile_detail": profileDetail,
    "business_detail": businessDetail,
    "work_detail": workDetail,
    "agreement_detail": agreementDetail,
  };
}
