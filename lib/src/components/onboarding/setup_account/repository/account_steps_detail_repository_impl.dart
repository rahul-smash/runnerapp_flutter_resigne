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
      {File selectedDocument,String user_id,profile_id, bool docSelected1, bool docSelected2}) async{

    try {
      String docKeyName = docSelected1 ? "identity_proof_image1" :"identity_proof_image2";
      String profileFileName = selectedProfileImg.path.split('/').last;
      String docFileName = selectedDocument.path.split('/').last;

      FormData formData = FormData.fromMap({
        'user_id': user_id,
        'first_name': lastName,
        'last_name': lastName,
        'email': email,
        'phone': mobile,
        'gender': selectedGenderUpOption,
        'dob': dob,
        'profile_id': profile_id,
        'about_yourself': comments,
        'identity_proof': selectedProofTypeTag,
        'identity_proof_mentioned_name': proofNameCont,
        'identity_proof_number': idProofNumberCont,
        "image": await MultipartFile.fromFile(selectedProfileImg.path,filename: profileFileName,),
         "${docKeyName}": await MultipartFile.fromFile(selectedDocument.path,filename: docFileName,),
      });


      var response = await post(apiPath(StoreConfigurationSingleton.instance.configModel.storeId, _updateProfile),
          null, isMultipartUploadRequest: true,formData: formData);
      BaseResponse loginResponse = BaseResponse.fromJson(jsonDecode(response));
      return loginResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
  }


}