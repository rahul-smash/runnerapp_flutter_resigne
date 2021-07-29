import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';

class LanguageUtil {
  static String ENGLISH = 'eng';
  static String ARABIC = 'عربى';
  static Map<String, String> localizedValues;
  static bool isLTR = true;

  /// Static function to determine the device text direction RTL/LTR
  static bool isRTL() {
//    return ui.window.locale.languageCode.toLowerCase() == "ar";
    return isLTR == false;
  }

  static String getLanguageParam({String passedSelected}) {
    return LanguageUtil.isLTR ? 'eng' : passedSelected ?? "ar";
  }

  static TextDirection getTextDirection() {
    return isLTR == false ? TextDirection.rtl : TextDirection.ltr;
  }

  LanguageUtil();

  Future<void> changeLanguage() async {
    String lanuguage = await AppSharedPref.instance.getAppLanguage();

    String jsonResult = await loadAsset(lanuguage);
    Map<String, dynamic> mappedJson = json.decode(jsonResult);

    localizedValues = mappedJson.map((key, value) {
      return MapEntry(key, value.toString());
    });
  }

  static String getTranslated(String key) {
    return localizedValues[key];
  }

  static Future<String> getSelectedLanguage(String key) async {
    String selectedLangauge = await AppSharedPref.instance.getAppLanguage();
    return selectedLangauge;
  }

  Future<String> loadAsset(String selectedLangauge) async {
    appPrintLog("\nselectedLangauge = ${selectedLangauge}");
    if (selectedLangauge != null &&
        (selectedLangauge == LanguageUtil.ARABIC || selectedLangauge == 'ar')) {
      isLTR = false;
      return await rootBundle.loadString(AppConstants.translationsArabic);
    } else {
      isLTR = true;
      return await rootBundle.loadString(AppConstants.translationsEnglish);
    }
  }
}
