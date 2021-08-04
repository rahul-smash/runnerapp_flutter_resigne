import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/src/components/login/model/login_response.dart';
import 'package:marketplace_service_provider/src/singleton/login_user_singleton.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';

class CommonWidgets{

  static Widget gradientContainer(BuildContext context,double mHeight,double mWidth){
    LoginResponse loginResponse = LoginUserSingleton.instance.loginResponse;
    return Container(
      height: mHeight,
      width: mWidth,
      decoration: BoxDecoration(
        //borderRadius: BorderRadius.all(Radius.circular(30)),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            AppTheme.primaryColorDark,
            AppTheme.primaryColor,
            AppTheme.primaryColor,
            AppTheme.primaryColor,
          ],
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(left: Dimensions.getScaledSize(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi, ${loginResponse.data.fullName} ${loginResponse.data.lastName}",
              style: TextStyle(
                fontSize: Dimensions.getScaledSize(20),
                  fontWeight: FontWeight.w600,
                  color: AppTheme.white,
                  fontFamily: AppConstants.fontName),
            ),
          ],
        ),
      ),
    );
  }

}