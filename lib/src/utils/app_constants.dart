import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';

class AppConstants {
  static bool isLoggerOn = true;
  static bool isLoggedIn = false;

  static const iOS = 'IOS';
  static const android = 'Android';
  static const web = 'Web';
  static int mobileNumberLength = 10;

  static const translationsEnglish = "assets/translations/en.json";
  static const translationsArabic = "assets/translations/ar.json";
  static const configFile = 'assets/config/app_config.json';
  static const staticSplash = 'assets/splash.png';

  static const fontName = 'SFProDisplay';

  static double extraLargeSize = Dimensions.getScaledSize(26.0);
  static double largeSize = Dimensions.getScaledSize(18.0);
  static double largeSize2X = Dimensions.getScaledSize(20.0);
  static double smallSize = Dimensions.getScaledSize(16.0);
  static double extraSmallSize = Dimensions.getScaledSize(14.0);
  static double extraXSmallSize = Dimensions.getScaledSize(12.0);
  static double tinySize = Dimensions.getScaledSize(10.0);

  static String noInternetMsg = "No internet connection!";

  static String currency = '';
  static const VALUEAPPZ_ADMIN_STORE_CURRENCY = "VALUEAPPZ_ADMIN_STORE_CURRENCY";
  static const VALUEAPPZ_ADMIN_STORE_ID = "VALUEAPPZ_ADMIN_STORE_ID";

}

//Booking sorting type
enum FilterType { Delivery_Time_Slot, Booking_Date }
