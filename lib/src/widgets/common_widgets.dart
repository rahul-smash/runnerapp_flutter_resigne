import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/src/components/login/model/login_response.dart';
import 'package:marketplace_service_provider/src/singleton/login_user_singleton.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';

class CommonWidgets {
  static Widget gradientContainer(
      BuildContext context, double mHeight, double mWidth, Widget child,
      {List<double> stops,
      List<Color> colors,
      Alignment begin,
      Alignment end}) {
    return Container(
      height: mHeight != -1 ? mHeight : null,
      width: mWidth != -1 ? mWidth : null,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin ?? Alignment.bottomCenter,
          end: end ?? Alignment.topCenter,
          stops: stops ?? [0.1, 0.5, 0.7, 0.9],
          colors: colors ??
              [
                AppTheme.primaryColorDark,
                AppTheme.primaryColor,
                AppTheme.primaryColor,
                AppTheme.primaryColor,
              ],
        ),
      ),
      child: child,
    );
  }
}
