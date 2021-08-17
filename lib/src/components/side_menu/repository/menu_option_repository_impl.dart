import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/network/api/dio_base_service.dart';
import 'package:marketplace_service_provider/src/components/side_menu/model/faq_model.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/network/app_network_constants.dart';
import 'package:marketplace_service_provider/src/singleton/store_config_singleton.dart';
import 'menu_options_repository.dart';

class MenuOptionRepositoryImpl extends DioBaseService implements MenuOptionRepository{

  static const _contactUs = '/runner_static_contents/contactUs';
  static const _faq = '/runner_static_contents/faqs';

  MenuOptionRepositoryImpl() : super(AppNetworkConstants.baseUrl);

  String apiPath(String storeId, String path) =>
      '$storeId${AppNetworkConstants.baseRoute}$path';

  @override
  Future<BaseResponse> sendContactUsData({String name, String phoneNumber, String email, String options,
    String desc, File img1, File img2, String user_id}) async {

    String fileName = img1 == null ? "" : img1.path.split('/').last;
    FormData formData;
    formData = FormData.fromMap({
      'name': name,
      'phone': phoneNumber,
      'email': email,
      'options': options,
      'desc': desc,
      'user_id' : user_id,
      "image1": img1 == null ? "" : await MultipartFile.fromFile(img1.path,filename: fileName)
    });
    try {
      var response = await post(apiPath(StoreConfigurationSingleton.instance.configModel.storeId, _contactUs),null,
                                isMultipartUploadRequest: true,formData:formData);
      BaseResponse baseResponse = BaseResponse.fromJson(jsonDecode(response));
      return baseResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  @override
  Future<FaqModel> getFaqData() async{
    try {
      var response = await get(apiPath(StoreConfigurationSingleton.instance.configModel.storeId, _faq), null);
      FaqModel categoryModel = FaqModel.fromJson(jsonDecode(response));
      return categoryModel;
    } catch (e) {
    }
    return null;
  }

}