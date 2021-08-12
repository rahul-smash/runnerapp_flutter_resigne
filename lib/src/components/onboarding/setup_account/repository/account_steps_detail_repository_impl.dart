import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/network/api/dio_base_service.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/account_steps_detail_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/business_detail_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/experience_detail_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/profile_info_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/work_detail_document_model.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/network/app_network_constants.dart';
import 'package:marketplace_service_provider/src/network/components/common_network_utils.dart';
import 'package:marketplace_service_provider/src/singleton/store_config_singleton.dart';
import 'account_steps_detail_repository.dart';

class AccountStepsDetailRepositoryImpl extends DioBaseService implements AccountStepsDetailRepository{

  AccountStepsDetailRepositoryImpl() : super(AppNetworkConstants.baseUrl);

  static const _getAccountStepsDetail = '/runner_authentication/getAccountStepsDetail/';
  static const _getProfileInfo = '/runner_authentication/getProfileInfo/';
  static const _updateProfile = '/runner_authentication/updateProfile';
  static const _getBusinessDetail = '/runner_authentication/getBusinessDetail/';
  static const _saveBusinessDetail = '/runner_authentication/updateBusinessDetail';
  static const _getExperienceDetail = '/runner_authentication/getExperienceDetail/';
  static const _saveExperienceDetail = '/runner_authentication/updateExperienceDetail';

  String apiPath(String storeId, String path) =>
      '$storeId${AppNetworkConstants.baseRoute}$path';

  @override
  Future<AccountStepsDetailModel> getAccountStepsDetail(String userId) async {
    try {
      String queryParms = "/${userId}";
      var response = await get(apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
          _getAccountStepsDetail)+queryParms, null);
      AccountStepsDetailModel categoryModel = AccountStepsDetailModel.fromJson(jsonDecode(response));
      return categoryModel;
    } catch (e) {
    }
    return null;
  }

  @override
  Future<ProfileInfoModel> getProfileInfo(String userId) async {
    try {
      String queryParms = "/${userId}";
      var response = await get(apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
          _getProfileInfo)+queryParms, null);
      ProfileInfoModel categoryModel = ProfileInfoModel.fromJson(jsonDecode(response));
      return categoryModel;
    } catch (e) {
    }
    return null;
  }

  @override
  Future<BaseResponse> saveMyProfile(File selectedProfileImg, String firstNameCont,String lastName,
      String selectedGenderUpOption , String dob, String mobile, String email, String comments,
      String proofNameCont, String idProofNumberCont, String selectedProofTypeTag,
      {File selectedDocument1,File selectedDocument2,String user_id,profile_id, ProfileInfoModel profileInfoModel}) async{
    FormData formData;
    Map<String, dynamic> param = getIt.get<CommonNetworkUtils>().getDeviceParams();
    try {
      String profileFileName = selectedProfileImg == null ? "" : selectedProfileImg.path.split('/').last;
      String doc1FileName = selectedDocument1 == null ? "" : selectedDocument1.path.isEmpty ? "" : selectedDocument1.path.split('/').last;
      String doc2FileName = selectedDocument2 == null ? "" : selectedDocument2.path.isEmpty ? "" : selectedDocument2.path.split('/').last;
      formData = FormData.fromMap({
        'platform': param["platform"],
        'device_id': param["device_id"],
        'user_id': user_id,
        'first_name': firstNameCont,
        'last_name': lastName,
        'email': email,
        'phone': mobile,
        'gender': selectedGenderUpOption,
        'dob': dob,
        'identity_proof_image1_delete': selectedDocument1 == null ? "1" : "0",
        'identity_proof_image2_delete': selectedDocument2 == null ? "1" : "0",
        'profile_id': profile_id,
        'about_yourself': comments,
        'identity_proof': selectedProofTypeTag,
        'identity_proof_mentioned_name': proofNameCont,
        'identity_proof_number': idProofNumberCont,
        "image": selectedProfileImg == null ? "" : await MultipartFile.fromFile(selectedProfileImg.path,filename: profileFileName,),
        "identity_proof_image1": selectedDocument1 == null
            ? ""
            : selectedDocument1.path.isEmpty ? "" : await MultipartFile.fromFile(selectedDocument1.path,filename: doc1FileName,),
        "identity_proof_image2": selectedDocument2 == null
            ? ""
            : await selectedDocument2.path.isEmpty ? "" : MultipartFile.fromFile(selectedDocument2.path,filename: doc2FileName,),
      });

      var response = await post(apiPath(StoreConfigurationSingleton.instance.configModel.storeId, _updateProfile),
          null, isMultipartUploadRequest: true,formData: formData);
      BaseResponse loginResponse = BaseResponse.fromJson(jsonDecode(response));
      return loginResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  @override
  Future<BusinessDetailModel> getBusinessDetail(String userId) async{
    try {
      String queryParms = "/${userId}";
      var response = await get(apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
          _getBusinessDetail)+queryParms, null);
      BusinessDetailModel categoryModel = BusinessDetailModel.fromJson(jsonDecode(response));
      return categoryModel;
    } catch (e) {
    }
    return null;
  }

  @override
  Future<BaseResponse> saveBusinessDetail(String userId,{String business_id,String business_name,String address,
    String city,String state,String pincode,String lat,String lng,
    String radius,String service_type,
    String business_identity_proof,String business_identity_proof_number,File business_identity_proof_image,
    String working_id,
    String sun_open,String sun_close,String mon_open,String mon_close,
    String tue_open,String tue_close,String wed_open,String wed_close,
    String thu_open,String thu_close,String fri_open,String fri_close,
    String sat_open,String sat_close}) async {

    Map<String, dynamic> param = getIt.get<CommonNetworkUtils>().getDeviceParams();
    FormData formData;
    String docFileName = business_identity_proof_image == null ? "" : business_identity_proof_image.path.isEmpty ? "" : business_identity_proof_image.path.split('/').last;

    formData = FormData.fromMap({
      'platform': param["platform"],
      'device_id': param["device_id"],
      'user_id': userId,
      'business_id': business_id,
      'business_name': business_name,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'lat': lat,
      'lng': lng,
      'radius': radius,
      'service_type': service_type,
      'business_identity_proof': business_identity_proof,
      'business_identity_proof_number': business_identity_proof_number,
      "business_identity_proof_image": business_identity_proof_image == null
          ? ""
          : business_identity_proof_image.path.isEmpty ? "" : await MultipartFile.fromFile(business_identity_proof_image.path,filename: docFileName,),
      'working_id': working_id,
      'sun_open': sun_open,
      'sun_close': sun_close,
      'mon_open': mon_open,
      'mon_close': mon_close,
      'tue_open': tue_open,
      'tue_close': tue_close,
      'wed_open': wed_open,
      'wed_close': wed_close,
      'thu_open': thu_open,
      'thu_close': thu_close,
      'fri_open': fri_open,
      'fri_close': fri_close,
      'sat_open': sat_open,
      'sat_close': sat_close,
        });

    var response = await post(apiPath(StoreConfigurationSingleton.instance.configModel.storeId, _saveBusinessDetail),
        null, isMultipartUploadRequest: true,formData: formData);
    BaseResponse loginResponse = BaseResponse.fromJson(jsonDecode(response));
    return loginResponse;
  }

  @override
  Future<ExperienceDetailModel> getExperienceDetail(String userId) async {
    try {
      String queryParms = "/${userId}";
      var response = await get(apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
          _getExperienceDetail)+queryParms, null);
      ExperienceDetailModel categoryModel = ExperienceDetailModel.fromJson(jsonDecode(response));
      return categoryModel;
    } catch (e) {
    }
    return null;
  }

  @override
  Future<BaseResponse> saveWorkDetail({String userId, String experienceId,String workExperience, String qualification,
    List<WorkDetailDocumentModel> workPhotographsDocList,
    List<WorkDetailDocumentModel> certificatesAwardsDocList,ExperienceDetailModel experienceDetailModel}) async{

    Map<String, dynamic> param = getIt.get<CommonNetworkUtils>().getDeviceParams();
    FormData formData;
    formData = FormData.fromMap({
      'platform': param["platform"],
      'device_id': param["device_id"],
      'user_id': userId,
      'experience_id': experienceId,
      'experience': workExperience,
      'qualifications': qualification,
      'certificates': experienceDetailModel.data.certificate,
      'work_photographs': experienceDetailModel.data.certificate,
    });


    for (var workPhotographObj in workPhotographsDocList) {
      formData.files.addAll([
        MapEntry("work_photograph_images", await MultipartFile.fromFile(workPhotographObj.file.path,filename: workPhotographObj.file.path.split('/').last)),
      ]);
    }
    for (var certificatesObj in certificatesAwardsDocList) {
      formData.files.addAll([
        MapEntry("certificate_images", await MultipartFile.fromFile(certificatesObj.file.path,filename: certificatesObj.file.path.split('/').last)),
      ]);
    }

    var response = await post(apiPath(StoreConfigurationSingleton.instance.configModel.storeId, _saveExperienceDetail),
        null, isMultipartUploadRequest: true,formData: formData);
    BaseResponse loginResponse = BaseResponse.fromJson(jsonDecode(response));
    return loginResponse;
  }


}