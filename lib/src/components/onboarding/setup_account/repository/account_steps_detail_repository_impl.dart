import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/network/api/dio_base_service.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/account_steps_detail_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/agreement_detail_model.dart';
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
  static const _getAgreementDetail= '/runner_authentication/getAgreementDetail/';


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
    List<WorkDetailDocumentModel> certificatesAwardsDocList,
    ExperienceDetailModel experienceDetailModel}) async{

    Map<String, dynamic> param = getIt.get<CommonNetworkUtils>().getDeviceParams();
    FormData formData;
    print("workPhotographsDocList.length=${workPhotographsDocList.length} and ${certificatesAwardsDocList.length}");

    File certificate_image1,certificate_image2,certificate_image3;
    File workPhotographs_image1,workPhotographs_image2,workPhotographs_image3;

    if(workPhotographsDocList.length == 1){
      workPhotographs_image1 = workPhotographsDocList[0].file;
    }
    if(workPhotographsDocList.length == 2){
      workPhotographs_image1 = workPhotographsDocList[0].file;
      workPhotographs_image2 = workPhotographsDocList[1].file;
    }
    if(workPhotographsDocList.length  == 3){
      workPhotographs_image1 = workPhotographsDocList[0].file;
      workPhotographs_image2 = workPhotographsDocList[1].file;
      workPhotographs_image3 = workPhotographsDocList[2].file;
    }

    //===========================================
    if(certificatesAwardsDocList.length == 1){
      certificate_image1 = certificatesAwardsDocList[0].file;
    }
    if(certificatesAwardsDocList.length == 2){
      certificate_image1 = certificatesAwardsDocList[0].file;
      certificate_image2 = certificatesAwardsDocList[1].file;
    }
    if(certificatesAwardsDocList.length == 3){
      certificate_image1 = certificatesAwardsDocList[0].file;
      certificate_image2 = certificatesAwardsDocList[1].file;
      certificate_image3 = certificatesAwardsDocList[2].file;
    }


    formData = FormData.fromMap({
      'platform': param["platform"],
      'device_id': param["device_id"],
      'user_id': userId,
      'experience_id': experienceId,
      'experience': workExperience,
      'qualifications': qualification,
      'work_photograph_image1_delete': "",
      'work_photograph_image2_delete': "",
      'work_photograph_image3_delete': "",
      'work_photograph_image1': workPhotographs_image1.path == null || workPhotographs_image1.path.isEmpty
          ? ""
          : await MultipartFile.fromFile(workPhotographs_image1.path,filename: workPhotographs_image1.path.isEmpty ? "" : workPhotographs_image1.path.split('/').last,),
      'work_photograph_image2': workPhotographs_image2.path == null || workPhotographs_image2.path.isEmpty
          ? ""
          : await MultipartFile.fromFile(workPhotographs_image2.path,filename: workPhotographs_image2.path.isEmpty ? "" : workPhotographs_image2.path.split('/').last,),
      'work_photograph_image3': workPhotographs_image3.path == null || workPhotographs_image3.path.isEmpty
          ? ""
          : await MultipartFile.fromFile(workPhotographs_image3.path,filename: workPhotographs_image3.path.isEmpty ? "" : workPhotographs_image3.path.split('/').last,),
//------------------------------------------------------------------------------------------------------------------
      'certificate_image1': certificate_image1.path == null || certificate_image1.path.isEmpty
          ? ""
          : await MultipartFile.fromFile(certificate_image1.path,filename: certificate_image1.path.isEmpty ? "" : certificate_image1.path.split('/').last,),

      'certificate_image2': certificate_image2.path == null || certificate_image2.path.isEmpty
          ? ""
          : await MultipartFile.fromFile(certificate_image2.path,filename: certificate_image2.path.isEmpty ? "" : certificate_image2.path.split('/').last,),

      'certificate_image3': certificate_image3.path == null || certificate_image3.path.isEmpty
          ? ""
          : await MultipartFile.fromFile(certificate_image3.path,filename: certificate_image3.path.isEmpty ? "" : certificate_image3.path.split('/').last,),
      'certificate_image1_delete': "",
      'certificate_image2_delete': "",
      'certificate_image3_delete': "",
    });

    var response = await post(apiPath(StoreConfigurationSingleton.instance.configModel.storeId, _saveExperienceDetail),
        null, isMultipartUploadRequest: true,formData: formData);
    BaseResponse loginResponse = BaseResponse.fromJson(jsonDecode(response));
    return loginResponse;
  }

  @override
  Future<AgreementDetailModel> getAgreementDetail() async {
    try {
      var response = await get(apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
          _getAgreementDetail), null);
      AgreementDetailModel categoryModel = AgreementDetailModel.fromJson(jsonDecode(response));
      return categoryModel;
    } catch (e) {
    }
  }


}