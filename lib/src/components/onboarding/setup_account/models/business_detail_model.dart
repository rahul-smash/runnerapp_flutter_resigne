// To parse this JSON data, do
//
//     final businessDetailModel = businessDetailModelFromJson(jsonString);

import 'dart:convert';

BusinessDetailModel businessDetailModelFromJson(String str) => BusinessDetailModel.fromJson(json.decode(str));

String businessDetailModelToJson(BusinessDetailModel data) => json.encode(data.toJson());

class BusinessDetailModel {
  BusinessDetailModel({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  factory BusinessDetailModel.fromJson(Map<String, dynamic> json) => BusinessDetailModel(
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
    this.businessDetail,
    this.workingDetail,
    this.businessIdentityProofList,
    this.serviceType,
  });

  BusinessDetail businessDetail;
  WorkingDetail workingDetail;
  List<String> businessIdentityProofList;
  List<String> serviceType;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    businessDetail: BusinessDetail.fromJson(json["business_detail"]),
    workingDetail: WorkingDetail.fromJson(json["working_detail"]),
    businessIdentityProofList: List<String>.from(json["business_identity_proof_list"].map((x) => x)),
    serviceType: List<String>.from(json["service_type"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "business_detail": businessDetail.toJson(),
    "working_detail": workingDetail.toJson(),
    "business_identity_proof_list": List<dynamic>.from(businessIdentityProofList.map((x) => x)),
    "service_type": List<dynamic>.from(serviceType.map((x) => x)),
  };
}

class BusinessDetail {
  BusinessDetail({
    this.brandId,
    this.userId,
    this.businessName,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.lat,
    this.lng,
    this.serviceType,
    this.radius,
    this.businessIdentityProof,
    this.businessIdentityProofNumber,
    this.businessIdentityProofImage,
    this.businessId,
  });

  String brandId;
  String userId;
  String businessName;
  String address;
  String city;
  String state;
  String pincode;
  String lat;
  String lng;
  String serviceType;
  String radius;
  String businessIdentityProof;
  String businessIdentityProofNumber;
  String businessIdentityProofImage;
  String businessId;

  factory BusinessDetail.fromJson(Map<String, dynamic> json) => BusinessDetail(
    brandId: json["brand_id"],
    userId: json["user_id"],
    businessName: json["business_name"],
    address: json["address"],
    city: json["city"],
    state: json["state"],
    pincode: json["pincode"],
    lat: json["lat"],
    lng: json["lng"],
    serviceType: json["service_type"],
    radius: json["radius"],
    businessIdentityProof: json["business_identity_proof"],
    businessIdentityProofNumber: json["business_identity_proof_number"],
    businessIdentityProofImage: json["business_identity_proof_image"],
    businessId: json["business_id"],
  );

  Map<String, dynamic> toJson() => {
    "brand_id": brandId,
    "user_id": userId,
    "business_name": businessName,
    "address": address,
    "city": city,
    "state": state,
    "pincode": pincode,
    "lat": lat,
    "lng": lng,
    "service_type": serviceType,
    "radius": radius,
    "business_identity_proof": businessIdentityProof,
    "business_identity_proof_number": businessIdentityProofNumber,
    "business_identity_proof_image": businessIdentityProofImage,
    "business_id": businessId,
  };
}

class WorkingDetail {
  WorkingDetail({
    this.brandId,
    this.userId,
    this.sunOpen,
    this.sunClose,
    this.monOpen,
    this.monClose,
    this.tueOpen,
    this.tueClose,
    this.wedOpen,
    this.wedClose,
    this.thuOpen,
    this.thuClose,
    this.friOpen,
    this.friClose,
    this.satOpen,
    this.satClose,
    this.workingId,
  });

  String brandId;
  String userId;
  String sunOpen;
  String sunClose;
  String monOpen;
  String monClose;
  String tueOpen;
  String tueClose;
  String wedOpen;
  String wedClose;
  String thuOpen;
  String thuClose;
  String friOpen;
  String friClose;
  String satOpen;
  String satClose;
  String workingId;

  factory WorkingDetail.fromJson(Map<String, dynamic> json) => WorkingDetail(
    brandId: json["brand_id"],
    userId: json["user_id"],
    sunOpen: json["sun_open"],
    sunClose: json["sun_close"],
    monOpen: json["mon_open"],
    monClose: json["mon_close"],
    tueOpen: json["tue_open"],
    tueClose: json["tue_close"],
    wedOpen: json["wed_open"],
    wedClose: json["wed_close"],
    thuOpen: json["thu_open"],
    thuClose: json["thu_close"],
    friOpen: json["fri_open"],
    friClose: json["fri_close"],
    satOpen: json["sat_open"],
    satClose: json["sat_close"],
    workingId: json["working_id"],
  );

  Map<String, dynamic> toJson() => {
    "brand_id": brandId,
    "user_id": userId,
    "sun_open": sunOpen,
    "sun_close": sunClose,
    "mon_open": monOpen,
    "mon_close": monClose,
    "tue_open": tueOpen,
    "tue_close": tueClose,
    "wed_open": wedOpen,
    "wed_close": wedClose,
    "thu_open": thuOpen,
    "thu_close": thuClose,
    "fri_open": friOpen,
    "fri_close": friClose,
    "sat_open": satOpen,
    "sat_close": satClose,
    "working_id": workingId,
  };
}
