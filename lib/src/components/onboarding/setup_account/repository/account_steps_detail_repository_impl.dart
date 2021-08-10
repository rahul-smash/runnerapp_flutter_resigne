import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/network/api/dio_base_service.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/account_steps_detail_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/profile_info_model.dart';
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


}