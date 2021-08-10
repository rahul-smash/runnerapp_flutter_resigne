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
      {File selectedDocument1,File selectedDocument2,String user_id,profile_id}) async{
    FormData formData;
    Map<String, dynamic> param = getIt.get<CommonNetworkUtils>().getDeviceParams();
    try {
      String profileFileName = selectedProfileImg.path.split('/').last;
      if(selectedDocument1 != null && selectedDocument2 != null){
        String doc1FileName = selectedDocument1.path.split('/').last;
        String doc2FileName = selectedDocument2.path.split('/').last;
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
          'profile_id': profile_id,
          'about_yourself': comments,
          'identity_proof': selectedProofTypeTag,
          'identity_proof_mentioned_name': proofNameCont,
          'identity_proof_number': idProofNumberCont,
          "image": await MultipartFile.fromFile(selectedProfileImg.path,filename: profileFileName,),
          "identity_proof_image1": await MultipartFile.fromFile(selectedDocument1.path,filename: doc1FileName,),
          "identity_proof_image2": await MultipartFile.fromFile(selectedDocument2.path,filename: doc2FileName,),
        });
      }else{

        File proofDocument;
        String selectedDocKeyName,selectedDocFileName;
        if(selectedDocument1 != null){
          proofDocument = selectedDocument1;
          selectedDocKeyName = "identity_proof_image1";
        }else if(selectedDocument2 != null){
          proofDocument = selectedDocument2;
          selectedDocKeyName = "identity_proof_image2";
        }
        selectedDocFileName = proofDocument.path.split('/').last;
        formData = FormData.fromMap({
          'platform': param["platform"],
          'device_id': param["device_id"],
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
          "$selectedDocKeyName": await MultipartFile.fromFile(proofDocument.path,filename: selectedDocFileName,),
        });
      }

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