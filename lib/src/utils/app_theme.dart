import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
      primaryColor: primaryColor,
      primaryColorLight: primaryColorLight,
      primaryColorDark: primaryColorDark,
      fontFamily: 'SFProDisplay',
      buttonTheme: ButtonThemeData(
        buttonColor: primaryColorLight,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              textStyle: TextStyle(fontSize: 14.0),
              primary: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              textStyle: TextStyle(fontSize: 14.0),
              primary: primaryColor,
              side: BorderSide(
                  color: primaryColor, width: 1.0, style: BorderStyle.solid),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              primary: AppTheme.transparent,
              onSurface: AppTheme.transparent,
              onPrimary: AppTheme.transparent,
              shadowColor: AppTheme.transparent,
              padding: EdgeInsets.fromLTRB(10, 12, 10, 12),
              textStyle: TextStyle(fontSize: 14.0,fontFamily: AppConstants.fontName),
              shape:new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ))));

  static Color primaryColor = Color(0xff334FE0);
  static Color primaryColorLight = Color(0xff635EEC);
  static Color primaryColorDark = Color(0xff8A6BF9);
  static Color primaryColorDark2 = Color(0xff8F75F9);
  static Color backgroundColor = Colors.white;
  static Color white = Colors.white;
  static Color toastbgColor = Color(0xff656565);
  static Color mainTextColor = Color(0xff23212B);
  static Color subHeadingTextColor = Color(0xffA6A7B2);
  static Color transparent = Colors.transparent;
  static Color black = Colors.black;
  static Color borderNotFocusedColor = Color(0xffE8E9EB);
  static Color borderOnFocusedColor = Color(0xffD2D3D8);
  static Color containerBackgroundColor = Color(0xffECECEC);
  static Color buttonShadowColor = Color(0xffC8CFF2);
  static Color optionTotalEarningColor = Color(0xff29C6C6);
  static Color optionTotalBookingBgColor = Color(0xffFD7443);
  static Color optionTotalCustomerBgColor = Color(0xffFE5767);
  static Color whiteDisable=Colors.white38;
}
