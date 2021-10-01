import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/network/api/dio_base_service.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/side_menu/model/faq_model.dart';
import 'package:marketplace_service_provider/src/components/side_menu/model/help_videos_model.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/network/app_network_constants.dart';
import 'package:marketplace_service_provider/src/network/components/common_network_utils.dart';
import 'package:marketplace_service_provider/src/singleton/store_config_singleton.dart';

import 'menu_options_repository.dart';

class MenuOptionRepositoryImpl extends DioBaseService
    implements MenuOptionRepository {
  static const _contactUs = '/runner_static_contents/contactUs';
  static const _faq = '/runner_static_contents/faqs';
  static const _helpVideos = '/runner_static_contents/helpVideos';
  static const _toggleDuty = '/runner_authentication/toggleDuty';

  MenuOptionRepositoryImpl() : super(AppNetworkConstants.baseUrl);

  String apiPath(String storeId, String path) =>
      '$storeId${AppNetworkConstants.baseRouteV2}$path';

  @override
  Future<BaseResponse> sendContactUsData(
      {String name,
      String phoneNumber,
      String email,
      String options,
      String desc,
      File img1,
      File img2,
      String user_id}) async {
    String fileName = img1 == null ? "" : img1.path.split('/').last;
    FormData formData;
    formData = FormData.fromMap({
      'name': name,
      'phone': phoneNumber,
      'email': email,
      'options': options,
      'desc': desc,
      'user_id': user_id,
      "image1": img1 == null
          ? ""
          : await MultipartFile.fromFile(img1.path, filename: fileName)
    });
    print(formData.fields.toString());
    try {
      var response = await post(
          apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
              _contactUs),
          null,
          isMultipartUploadRequest: true,
          formData: formData);
      BaseResponse baseResponse = BaseResponse.fromJson(jsonDecode(response));
      return baseResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  @override
  Future<FaqModel> getFaqData() async {
    try {
      var response = await get(
          apiPath(
              StoreConfigurationSingleton.instance.configModel.storeId, _faq),
          null);
      FaqModel categoryModel = FaqModel.fromJson(jsonDecode(response));
      return categoryModel;
    } catch (e) {}
    return null;
  }

  @override
  Future<HelpVideosModel> getHowToVideos() async {
    try {
      var response = await get(
          apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
              _helpVideos),
          null);
      HelpVideosModel categoryModel =
          HelpVideosModel.fromJson(jsonDecode(response));
      return categoryModel;
    } catch (e) {}
    return null;
  }

  @override
  Future<BaseResponse> updateDutyStatus(
      {String status,
      String userId,
      String lat,
      String lng,
      String address}) async {
    String storeId = StoreConfigurationSingleton.instance.configModel.storeId;
    Map<String, dynamic> param =
        getIt.get<CommonNetworkUtils>().getDeviceParams();
    param['user_id'] = userId;
    param['duty'] = status;
    param['lat'] = lat;
    param['lng'] = lng;
    param['address'] = address;
    try {
      var response = await post(apiPath(storeId, _toggleDuty), param);
      BaseResponse baseResponse = BaseResponse.fromJson(jsonDecode(response));
      return baseResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
