import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/account_steps_detail_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/business_detail_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/experience_detail_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/profile_info_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/work_detail_document_model.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';

abstract class AccountStepsDetailRepository {

  Future<AccountStepsDetailModel> getAccountStepsDetail(String userId);

  Future<ProfileInfoModel> getProfileInfo(String userId);

  Future<BusinessDetailModel> getBusinessDetail(String userId);

  Future<ExperienceDetailModel> getExperienceDetail(String userId);

  Future<BaseResponse> saveMyProfile(File selectedProfileImg, String text,String lastName,
      String selectedGenderUpOption , String dob, String mobile, String email, String comments,
      String proofNameCont, String idProofNameCont, String selectedProofTypeTag,
      {File selectedDocument1,File selectedDocument2});

  Future<BaseResponse> saveBusinessDetail(String userId,{String business_id,String business_name,String address,
    String city,String state,String pincode,String lat,String lng,
    String radius,String service_type,
    String business_identity_proof,String business_identity_proof_number,File business_identity_proof_image,
    String working_id,
    String sun_open,String sun_close,String mon_open,String mon_close,
    String tue_open,String tue_close,String wed_open,String wed_close,
    String thu_open,String thu_close,String fri_open,String fri_close,
    String sat_open,String sat_close});


  Future<BaseResponse> saveWorkDetail({@required String userId,@required String experienceId,
    @required String workExperience,
    @required String qualification,List<WorkDetailDocumentModel> workPhotographsDocList,
    List<WorkDetailDocumentModel> certificatesAwardsDocList,ExperienceDetailModel experienceDetailModel});
}