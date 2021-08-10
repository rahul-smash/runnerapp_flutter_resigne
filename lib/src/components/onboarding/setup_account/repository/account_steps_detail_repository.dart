import 'dart:io';

import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/account_steps_detail_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/business_detail_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/profile_info_model.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';

abstract class AccountStepsDetailRepository {

  Future<AccountStepsDetailModel> getAccountStepsDetail(String userd);

  Future<ProfileInfoModel> getProfileInfo(String userd);

  Future<BusinessDetailModel> getBusinessDetail(String userd);

  Future<BaseResponse> saveMyProfile(File selectedProfileImg, String text,String lastName,
      String selectedGenderUpOption , String dob, String mobile, String email, String comments,
      String proofNameCont, String idProofNameCont, String selectedProofTypeTag,
      {File selectedDocument1,File selectedDocument2});

}