// To parse this JSON data, do
//
//     final storeResponse = storeResponseFromJson(jsonString);

import 'dart:convert';

import 'package:marketplace_service_provider/src/model/app_theme_color.dart';

class StoreResponse {
  StoreResponse({
    this.success,
    this.brand,
  });

  bool success;
  Brand brand;

  StoreResponse copyWith({
    bool success,
    Brand brand,
  }) =>
      StoreResponse(
        success: success ?? this.success,
        brand: brand ?? this.brand,
      );

  factory StoreResponse.fromRawJson(String str) =>
      StoreResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StoreResponse.fromJson(Map<String, dynamic> json) => StoreResponse(
        success: json["success"] == null ? null : json["success"],
        brand: json["brand"] == null ? null : Brand.fromJson(json["brand"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "brand": brand == null ? null : brand.toJson(),
      };
}

class Brand {
  Brand(
      {this.id,
      this.name,
      this.userId,
      this.contactNumber,
      this.contactEmail,
      this.address,
      this.city,
      this.state,
      this.country,
      this.timeZone,
      this.lat,
      this.lng,
      this.zipcode,
      this.logo,
      this.aboutUs,
      this.lang2AboutUs,
      this.currency,
      this.showCurrency,
      this.favIcon,
      this.appIcon,
      this.appShareLink,
      this.androidShareLink,
      this.iphoneShareLink,
      this.androidMerchantApp,
      this.iphoneMerchantApp,
      this.runnerApp,
      this.radius,
      this.radiusType,
      this.radiusTypeValue,
      this.runnersTrackingAutorefresh,
      this.type,
      this.isMembershipOn,
      this.version,
      this.currencyUnicode,
      this.currencyAbbr,
      this.internationalOtp,
      this.forceDownload,
      this.logo10080,
      this.logo300200,
      this.banner10080,
      this.banner300200,
      this.domain,
      this.signupAs,
      this.contactusOptions,
      this.bookingCancelReason,
      this.socialLinking,
      this.appThemeColor});

  String id;
  String name;
  String userId;
  String contactNumber;
  String contactEmail;
  String address;
  String city;
  String state;
  String country;
  String timeZone;
  String lat;
  String lng;
  String zipcode;
  String logo;
  String aboutUs;
  String lang2AboutUs;
  String currency;
  String showCurrency;
  String favIcon;
  String appIcon;
  String appShareLink;
  String androidShareLink;
  String iphoneShareLink;
  String androidMerchantApp;
  String iphoneMerchantApp;
  String runnerApp;
  String radius;
  String radiusType;
  String radiusTypeValue;
  String runnersTrackingAutorefresh;
  String type;
  String isMembershipOn;
  String version;
  String currencyUnicode;
  String currencyAbbr;
  String internationalOtp;
  List<ForceDownload> forceDownload;
  String logo10080;
  String logo300200;
  String banner10080;
  String banner300200;
  String domain;
  List<String> signupAs;
  List<String> contactusOptions;
  List<String> bookingCancelReason;
  SocialLinking socialLinking;
  AppThemeColor appThemeColor;

  Brand copyWith(
          {String id,
          String name,
          String userId,
          String contactNumber,
          String contactEmail,
          String address,
          String city,
          String state,
          String country,
          String timeZone,
          String lat,
          String lng,
          String zipcode,
          String logo,
          String aboutUs,
          String lang2AboutUs,
          String currency,
          String showCurrency,
          String favIcon,
          String appIcon,
          String appShareLink,
          String androidShareLink,
          String iphoneShareLink,
          String androidMerchantApp,
          String iphoneMerchantApp,
          String runnerApp,
          String radius,
          String radiusType,
          String radiusTypeValue,
          String runnersTrackingAutorefresh,
          String type,
          String isMembershipOn,
          String version,
          String currencyUnicode,
          String currencyAbbr,
          String internationalOtp,
          List<ForceDownload> forceDownload,
          String logo10080,
          String logo300200,
          String banner10080,
          String banner300200,
          String domain,
          List<String> signupAs,
          List<String> contactusOptions,
          List<String> bookingCancelReason,
          SocialLinking socialLinking,
          AppThemeColor appThemeColor}) =>
      Brand(
          id: id ?? this.id,
          name: name ?? this.name,
          userId: userId ?? this.userId,
          contactNumber: contactNumber ?? this.contactNumber,
          contactEmail: contactEmail ?? this.contactEmail,
          address: address ?? this.address,
          city: city ?? this.city,
          state: state ?? this.state,
          country: country ?? this.country,
          timeZone: timeZone ?? this.timeZone,
          lat: lat ?? this.lat,
          lng: lng ?? this.lng,
          zipcode: zipcode ?? this.zipcode,
          logo: logo ?? this.logo,
          aboutUs: aboutUs ?? this.aboutUs,
          lang2AboutUs: lang2AboutUs ?? this.lang2AboutUs,
          currency: currency ?? this.currency,
          showCurrency: showCurrency ?? this.showCurrency,
          favIcon: favIcon ?? this.favIcon,
          appIcon: appIcon ?? this.appIcon,
          appShareLink: appShareLink ?? this.appShareLink,
          androidShareLink: androidShareLink ?? this.androidShareLink,
          iphoneShareLink: iphoneShareLink ?? this.iphoneShareLink,
          androidMerchantApp: androidMerchantApp ?? this.androidMerchantApp,
          iphoneMerchantApp: iphoneMerchantApp ?? this.iphoneMerchantApp,
          runnerApp: runnerApp ?? this.runnerApp,
          radius: radius ?? this.radius,
          radiusType: radiusType ?? this.radiusType,
          radiusTypeValue: radiusTypeValue ?? this.radiusTypeValue,
          runnersTrackingAutorefresh:
              runnersTrackingAutorefresh ?? this.runnersTrackingAutorefresh,
          type: type ?? this.type,
          isMembershipOn: isMembershipOn ?? this.isMembershipOn,
          version: version ?? this.version,
          currencyUnicode: currencyUnicode ?? this.currencyUnicode,
          currencyAbbr: currencyAbbr ?? this.currencyAbbr,
          internationalOtp: internationalOtp ?? this.internationalOtp,
          forceDownload: forceDownload ?? this.forceDownload,
          logo10080: logo10080 ?? this.logo10080,
          logo300200: logo300200 ?? this.logo300200,
          banner10080: banner10080 ?? this.banner10080,
          banner300200: banner300200 ?? this.banner300200,
          domain: domain ?? this.domain,
          signupAs: signupAs ?? this.signupAs,
          contactusOptions: contactusOptions ?? this.contactusOptions,
          bookingCancelReason: bookingCancelReason ?? this.bookingCancelReason,
          socialLinking: socialLinking ?? this.socialLinking,
          appThemeColor: appThemeColor ?? this.appThemeColor);

  factory Brand.fromRawJson(String str) => Brand.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
      id: json["id"] == null ? null : json["id"],
      name: json["name"] == null ? null : json["name"],
      userId: json["user_id"] == null ? null : json["user_id"],
      contactNumber:
          json["contact_number"] == null ? null : json["contact_number"],
      contactEmail:
          json["contact_email"] == null ? null : json["contact_email"],
      address: json["address"] == null ? null : json["address"],
      city: json["city"] == null ? null : json["city"],
      state: json["state"] == null ? null : json["state"],
      country: json["country"] == null ? null : json["country"],
      timeZone: json["time_zone"] == null ? null : json["time_zone"],
      lat: json["lat"] == null ? null : json["lat"],
      lng: json["lng"] == null ? null : json["lng"],
      zipcode: json["zipcode"] == null ? null : json["zipcode"],
      logo: json["logo"] == null ? null : json["logo"],
      aboutUs: json["about_us"] == null ? null : json["about_us"],
      lang2AboutUs:
          json["lang_2_about_us"] == null ? null : json["lang_2_about_us"],
      currency: json["currency"] == null ? null : json["currency"],
      showCurrency:
          json["show_currency"] == null ? null : json["show_currency"],
      favIcon: json["fav_icon"] == null ? null : json["fav_icon"],
      appIcon: json["app_icon"] == null ? null : json["app_icon"],
      appShareLink:
          json["app_share_link"] == null ? null : json["app_share_link"],
      androidShareLink: json["android_share_link"] == null
          ? null
          : json["android_share_link"],
      iphoneShareLink:
          json["iphone_share_link"] == null ? null : json["iphone_share_link"],
      androidMerchantApp: json["android_merchant_app"] == null
          ? null
          : json["android_merchant_app"],
      iphoneMerchantApp: json["iphone_merchant_app"] == null
          ? null
          : json["iphone_merchant_app"],
      runnerApp: json["runner_app"] == null ? null : json["runner_app"],
      radius: json["radius"] == null ? null : json["radius"],
      radiusType: json["radius_type"] == null ? null : json["radius_type"],
      radiusTypeValue:
          json["radius_type_value"] == null ? null : json["radius_type_value"],
      runnersTrackingAutorefresh: json["runners_tracking_autorefresh"] == null
          ? null
          : json["runners_tracking_autorefresh"],
      type: json["type"] == null ? null : json["type"],
      isMembershipOn:
          json["is_membership_on"] == null ? null : json["is_membership_on"],
      version: json["version"] == null ? null : json["version"],
      currencyUnicode:
          json["currency_unicode"] == null ? null : json["currency_unicode"],
      currencyAbbr:
          json["currency_abbr"] == null ? null : json["currency_abbr"],
      internationalOtp:
          json["international_otp"] == null ? null : json["international_otp"],
      forceDownload: json["force_download"] == null
          ? null
          : List<ForceDownload>.from(
              json["force_download"].map((x) => ForceDownload.fromJson(x))),
      logo10080: json["logo_100_80"] == null ? null : json["logo_100_80"],
      logo300200: json["logo_300_200"] == null ? null : json["logo_300_200"],
      banner10080: json["banner_100_80"] == null ? null : json["banner_100_80"],
      banner300200:
          json["banner_300_200"] == null ? null : json["banner_300_200"],
      domain: json["domain"] == null ? null : json["domain"],
      signupAs: json["signupAs"] == null
          ? null
          : List<String>.from(json["signupAs"].map((x) => x)),
      contactusOptions: json["contactus_options"] == null
          ? null
          : List<String>.from(json["contactus_options"].map((x) => x)),
      bookingCancelReason: json["booking_cancel_reason"] == null
          ? null
          : List<String>.from(json["booking_cancel_reason"].map((x) => x)),
      socialLinking: json["social_linking"] == null
          ? null
          : SocialLinking.fromJson(json["social_linking"]),
      appThemeColor: json["app_theme_color"] == null
          ? null
          : AppThemeColor.fromJson(json["app_theme_color"]));

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "user_id": userId == null ? null : userId,
        "contact_number": contactNumber == null ? null : contactNumber,
        "contact_email": contactEmail == null ? null : contactEmail,
        "address": address == null ? null : address,
        "city": city == null ? null : city,
        "state": state == null ? null : state,
        "country": country == null ? null : country,
        "time_zone": timeZone == null ? null : timeZone,
        "lat": lat == null ? null : lat,
        "lng": lng == null ? null : lng,
        "zipcode": zipcode == null ? null : zipcode,
        "logo": logo == null ? null : logo,
        "about_us": aboutUs == null ? null : aboutUs,
        "lang_2_about_us": lang2AboutUs == null ? null : lang2AboutUs,
        "currency": currency == null ? null : currency,
        "show_currency": showCurrency == null ? null : showCurrency,
        "fav_icon": favIcon == null ? null : favIcon,
        "app_icon": appIcon == null ? null : appIcon,
        "app_share_link": appShareLink == null ? null : appShareLink,
        "android_share_link":
            androidShareLink == null ? null : androidShareLink,
        "iphone_share_link": iphoneShareLink == null ? null : iphoneShareLink,
        "android_merchant_app":
            androidMerchantApp == null ? null : androidMerchantApp,
        "iphone_merchant_app":
            iphoneMerchantApp == null ? null : iphoneMerchantApp,
        "runner_app": runnerApp == null ? null : runnerApp,
        "radius": radius == null ? null : radius,
        "radius_type": radiusType == null ? null : radiusType,
        "radius_type_value": radiusTypeValue == null ? null : radiusTypeValue,
        "runners_tracking_autorefresh": runnersTrackingAutorefresh == null
            ? null
            : runnersTrackingAutorefresh,
        "type": type == null ? null : type,
        "is_membership_on": isMembershipOn == null ? null : isMembershipOn,
        "version": version == null ? null : version,
        "currency_unicode": currencyUnicode == null ? null : currencyUnicode,
        "currency_abbr": currencyAbbr == null ? null : currencyAbbr,
        "international_otp": internationalOtp == null ? null : internationalOtp,
        "force_download": forceDownload == null
            ? null
            : List<dynamic>.from(forceDownload.map((x) => x.toJson())),
        "logo_100_80": logo10080 == null ? null : logo10080,
        "logo_300_200": logo300200 == null ? null : logo300200,
        "banner_100_80": banner10080 == null ? null : banner10080,
        "banner_300_200": banner300200 == null ? null : banner300200,
        "domain": domain == null ? null : domain,
        "signupAs": signupAs == null
            ? null
            : List<dynamic>.from(signupAs.map((x) => x)),
        "contactus_options": contactusOptions == null
            ? null
            : List<dynamic>.from(contactusOptions.map((x) => x)),
        "booking_cancel_reason": bookingCancelReason == null
            ? null
            : List<dynamic>.from(bookingCancelReason.map((x) => x)),
        "social_linking": socialLinking == null ? null : socialLinking.toJson(),
        "app_theme_color": appThemeColor == null ? null : appThemeColor.toJson()
      };
}

class ForceDownload {
  ForceDownload({
    this.iosAppVersion,
    this.androidAppVerison,
    this.forceDownload,
    this.forceDownloadMessage,
  });

  String iosAppVersion;
  String androidAppVerison;
  String forceDownload;
  String forceDownloadMessage;

  ForceDownload copyWith({
    String iosAppVersion,
    String androidAppVerison,
    String forceDownload,
    String forceDownloadMessage,
  }) =>
      ForceDownload(
        iosAppVersion: iosAppVersion ?? this.iosAppVersion,
        androidAppVerison: androidAppVerison ?? this.androidAppVerison,
        forceDownload: forceDownload ?? this.forceDownload,
        forceDownloadMessage: forceDownloadMessage ?? this.forceDownloadMessage,
      );

  factory ForceDownload.fromRawJson(String str) =>
      ForceDownload.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ForceDownload.fromJson(Map<String, dynamic> json) => ForceDownload(
        iosAppVersion:
            json["ios_app_version"] == null ? null : json["ios_app_version"],
        androidAppVerison: json["android_app_verison"] == null
            ? null
            : json["android_app_verison"],
        forceDownload:
            json["force_download"] == null ? null : json["force_download"],
        forceDownloadMessage: json["force_download_message"] == null
            ? null
            : json["force_download_message"],
      );

  Map<String, dynamic> toJson() => {
        "ios_app_version": iosAppVersion == null ? null : iosAppVersion,
        "android_app_verison":
            androidAppVerison == null ? null : androidAppVerison,
        "force_download": forceDownload == null ? null : forceDownload,
        "force_download_message":
            forceDownloadMessage == null ? null : forceDownloadMessage,
      };
}

class SocialLinking {
  SocialLinking({
    this.id,
    this.facebook,
    this.twitter,
    this.instagram,
    this.linkedin,
    this.youtube,
    this.heading1,
    this.heading2,
  });

  String id;
  String facebook;
  String twitter;
  String instagram;
  String linkedin;
  String youtube;
  String heading1;
  String heading2;

  SocialLinking copyWith({
    String id,
    String facebook,
    String twitter,
    String instagram,
    String linkedin,
    String youtube,
    String heading1,
    String heading2,
  }) =>
      SocialLinking(
        id: id ?? this.id,
        facebook: facebook ?? this.facebook,
        twitter: twitter ?? this.twitter,
        instagram: instagram ?? this.instagram,
        linkedin: linkedin ?? this.linkedin,
        youtube: youtube ?? this.youtube,
        heading1: heading1 ?? this.heading1,
        heading2: heading2 ?? this.heading2,
      );

  factory SocialLinking.fromRawJson(String str) =>
      SocialLinking.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SocialLinking.fromJson(Map<String, dynamic> json) => SocialLinking(
        id: json["id"] == null ? null : json["id"],
        facebook: json["facebook"] == null ? null : json["facebook"],
        twitter: json["twitter"] == null ? null : json["twitter"],
        instagram: json["instagram"] == null ? null : json["instagram"],
        linkedin: json["linkedin"] == null ? null : json["linkedin"],
        youtube: json["youtube"] == null ? null : json["youtube"],
        heading1: json["heading1"] == null ? null : json["heading1"],
        heading2: json["heading2"] == null ? null : json["heading2"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "facebook": facebook == null ? null : facebook,
        "twitter": twitter == null ? null : twitter,
        "instagram": instagram == null ? null : instagram,
        "linkedin": linkedin == null ? null : linkedin,
        "youtube": youtube == null ? null : youtube,
        "heading1": heading1 == null ? null : heading1,
        "heading2": heading2 == null ? null : heading2,
      };
}
