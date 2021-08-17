import 'dart:io';

import 'package:marketplace_service_provider/src/components/side_menu/model/faq_model.dart';
import 'package:marketplace_service_provider/src/components/side_menu/model/help_videos_model.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';

abstract class MenuOptionRepository {

  Future<BaseResponse> sendContactUsData({String name,String phoneNumber, String email,String options,String user_id,String desc,File img1, File img2});

  Future<FaqModel> getFaqData();

  Future<HelpVideosModel> getHowToVideos();

}
