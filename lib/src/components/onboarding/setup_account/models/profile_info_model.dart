// To parse this JSON data, do
//
//     final profileInfoModel = profileInfoModelFromJson(jsonString);

import 'dart:convert';

ProfileInfoModel profileInfoModelFromJson(String str) => ProfileInfoModel.fromJson(json.decode(str));

String profileInfoModelToJson(ProfileInfoModel data) => json.encode(data.toJson());

class ProfileInfoModel {
  ProfileInfoModel({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  factory ProfileInfoModel.fromJson(Map<String, dynamic> json) => ProfileInfoModel(
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
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.gender,
    this.dob,
    this.profileImage,
    this.brandId,
    this.panCard,
    this.aadharCard,
    this.bankAccountNumber,
    this.accountType,
    this.ifsCode,
    this.bankName,
    this.branchName,
    this.drivingLicense,
    this.numberDrivingLicensePic,
    this.vehicleName,
    this.vehicleRegistrationNumber,
    this.vehicleRegistrationPlatePic,
    this.profileId,
    this.identityProofImage1,
    this.identityProofImage2,
    this.profileImage10080,
    this.profileImage300200,
    this.identityProofList,
  });

  String userId;
  String firstName;
  String lastName;
  String email;
  String phone;
  String gender;
  String dob;
  String profileImage;
  String brandId;
  String panCard;
  String aadharCard;
  String bankAccountNumber;
  String accountType;
  String ifsCode;
  String bankName;
  String branchName;
  String drivingLicense;
  String numberDrivingLicensePic;
  String vehicleName;
  String vehicleRegistrationNumber;
  String vehicleRegistrationPlatePic;
  String profileId;
  String identityProofImage1;
  String identityProofImage2;
  String profileImage10080;
  String profileImage300200;
  List<String> identityProofList;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    phone: json["phone"],
    gender: json["gender"],
    dob: json["dob"],
    profileImage: json["profile_image"],
    brandId: json["brand_id"],
    panCard: json["pan_card"],
    aadharCard: json["aadhar_card"],
    bankAccountNumber: json["bank_account_number"],
    accountType: json["account_type"],
    ifsCode: json["ifs_code"],
    bankName: json["bank_name"],
    branchName: json["branch_name"],
    drivingLicense: json["driving_license"],
    numberDrivingLicensePic: json["number_driving_license_pic"],
    vehicleName: json["vehicle_name"],
    vehicleRegistrationNumber: json["vehicle_registration_number"],
    vehicleRegistrationPlatePic: json["vehicle_registration_plate_pic"],
    profileId: json["profile_id"],
    identityProofImage1: json["identity_proof_image1"],
    identityProofImage2: json["identity_proof_image2"],
    profileImage10080: json["profile_image_100_80"],
    profileImage300200: json["profile_image_300_200"],
    identityProofList: List<String>.from(json["identity_proof_list"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "phone": phone,
    "gender": gender,
    "dob": dob,
    "profile_image": profileImage,
    "brand_id": brandId,
    "pan_card": panCard,
    "aadhar_card": aadharCard,
    "bank_account_number": bankAccountNumber,
    "account_type": accountType,
    "ifs_code": ifsCode,
    "bank_name": bankName,
    "branch_name": branchName,
    "driving_license": drivingLicense,
    "number_driving_license_pic": numberDrivingLicensePic,
    "vehicle_name": vehicleName,
    "vehicle_registration_number": vehicleRegistrationNumber,
    "vehicle_registration_plate_pic": vehicleRegistrationPlatePic,
    "profile_id": profileId,
    "identity_proof_image1": identityProofImage1,
    "identity_proof_image2": identityProofImage2,
    "profile_image_100_80": profileImage10080,
    "profile_image_300_200": profileImage300200,
    "identity_proof_list": List<dynamic>.from(identityProofList.map((x) => x)),
  };
}
