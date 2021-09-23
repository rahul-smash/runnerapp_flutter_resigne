// To parse this JSON data, do
//
//     final appThemeColor = appThemeColorFromJson(jsonString);

import 'dart:convert';

AppThemeColor appThemeColorFromJson(String str) =>
    AppThemeColor.fromJson(json.decode(str));

String appThemeColorToJson(AppThemeColor data) => json.encode(data.toJson());

class AppThemeColor {
  AppThemeColor({
    this.id,
    this.primaryColor,
    this.primaryDarkColor,
    this.backgroundColor,
    this.mainTextColor,
    this.subHeadingTextColor,
    this.option1Color,
    this.option2Color,
    this.option3Color,
    this.errorColor,
  });

  String id;
  String primaryColor;
  String primaryDarkColor;
  String backgroundColor;
  String mainTextColor;
  String subHeadingTextColor;
  String option1Color;
  String option2Color;
  String option3Color;
  String errorColor;

  factory AppThemeColor.fromJson(Map<String, dynamic> json) => AppThemeColor(
        id: json["id"] == null ? null : json["id"],
        primaryColor:
            json["primary_color"] == null ? null : json["primary_color"],
        primaryDarkColor: json["primary_dark_color"] == null
            ? null
            : json["primary_dark_color"],
        backgroundColor:
            json["background_color"] == null ? null : json["background_color"],
        mainTextColor:
            json["main_text_color"] == null ? null : json["main_text_color"],
        subHeadingTextColor: json["sub_heading_text_color"] == null
            ? null
            : json["sub_heading_text_color"],
        option1Color:
            json["option1_color"] == null ? null : json["option1_color"],
        option2Color:
            json["option2_color"] == null ? null : json["option2_color"],
        option3Color:
            json["option3_color"] == null ? null : json["option3_color"],
        errorColor: json["error_color"] == null ? null : json["error_color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "primary_color": primaryColor == null ? null : primaryColor,
        "primary_dark_color":
            primaryDarkColor == null ? null : primaryDarkColor,
        "background_color": backgroundColor == null ? null : backgroundColor,
        "main_text_color": mainTextColor == null ? null : mainTextColor,
        "sub_heading_text_color":
            subHeadingTextColor == null ? null : subHeadingTextColor,
        "option1_color": option1Color == null ? null : option1Color,
        "option2_color": option2Color == null ? null : option2Color,
        "option3_color": option3Color == null ? null : option3Color,
        "error_color": errorColor == null ? null : errorColor,
      };
}
