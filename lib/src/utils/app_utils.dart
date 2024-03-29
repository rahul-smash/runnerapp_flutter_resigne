import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/sharedpreference/base_shared_pref.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/user_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_details_response.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/placemark_model.dart';
import 'package:marketplace_service_provider/src/model/device_info.dart';
import 'package:marketplace_service_provider/src/model/store_response_model.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:flutter_sms/flutter_sms.dart';

import '../widgets/gradient_elevated_button.dart';

appPrintLog(dynamic content) {
  if (AppConstants.isLoggerOn) print(content);
}

EventBus commonBus = EventBus();

class OnRedeemCoupon {
  String amount;
  String code;
  String points;
  String type;

  OnRedeemCoupon(this.amount, this.code, this.points, this.type);
}

class OnAddAddress {
  List<CustomerAddress> address;

  OnAddAddress(this.address);
}

class AppUtils {
  static Color colorGeneralization(Color passedColor, String colorString) {
    Color returnedColor = passedColor;
    if (colorString != null) {
      try {
        returnedColor = Color(int.parse(colorString.replaceAll("#", "0xff")));
      } catch (e) {
        print(e);
      }
    }
    return returnedColor;
  }

  static Future<PackageInfo> getAppVersionDetails() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    AppSharedPref.instance.setAppName(packageInfo.appName);
    AppSharedPref.instance.setAppVersion(packageInfo.version);

    return packageInfo;
  }

  static loadImageFromUrl(String imgURL) {
    return Image.network(
      imgURL,
      fit: BoxFit.cover,
      width: 100,
      height: 100,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return Container();
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes
                : null,
          ),
        );
      },
    );
  }

  static convertDateTime(String utcTime) {
    var dateFormat =
        DateFormat("dd MMM yyyy, hh:mm aa"); // you can change the format here
    var utcDate =
        dateFormat.format(DateTime.parse(utcTime)); // pass the UTC time here
    var localDate = dateFormat.parse(utcDate, true).toLocal().toString();
    String createdDate =
        dateFormat.format(DateTime.parse(localDate)); // you will local time
    return createdDate;
  }

  static void getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = await DeviceInfoPlugin();
    PackageInfo packageInfo = await AppUtils.getAppVersionDetails();
    String deviceId = AppSharedPref.instance.getDeviceId();
    String deviceToken = AppSharedPref.instance.getDeviceToken();
    if (deviceToken == null || deviceToken.isEmpty) {
      deviceToken = 'deviceToken';
    }
    Map<String, dynamic> param = Map();
    param['app_version'] = packageInfo.version;
    param['device_id'] = deviceId;
    param['device_token'] = deviceToken;
    if (kIsWeb) {
      param['platform'] = 'web';
    } else {
      if (Platform.operatingSystem == "android") {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        param['device_brand'] = androidInfo.brand;
        param['device_model'] = androidInfo.model;
        param['device_os'] = androidInfo.version.sdkInt;
        param['device_os_version'] = androidInfo.version.sdkInt;

        param['platform'] = 'android';
        param['model'] = androidInfo.model;
        param['manufacturer'] = androidInfo.manufacturer;
        param['isPhysicalDevice'] = androidInfo.isPhysicalDevice;
        param['androidId'] = androidInfo.id;
        param['brand'] = androidInfo.brand;
        param['device'] = androidInfo.device;
        param['display'] = androidInfo.display;
        param['version_sdkInt'] = androidInfo.version.sdkInt;
        param['version_release'] = androidInfo.version.release;
      }
      if (Platform.operatingSystem == "ios") {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        param['device_brand'] = iosInfo.model;
        param['device_model'] = iosInfo.model;
        param['device_os'] = iosInfo.systemName;
        param['device_os_version'] = iosInfo.systemVersion;

        param['platform'] = 'ios';
        param['name'] = iosInfo.name;
        param['systemName'] = iosInfo.systemName;
        param['systemVersion'] = iosInfo.systemVersion;
        param['model'] = iosInfo.model;
        param['isPhysicalDevice'] = iosInfo.isPhysicalDevice;
        param['release'] = iosInfo.utsname.release;
        param['version'] = iosInfo.utsname.version;
        param['machine'] = iosInfo.utsname.machine;
      }
    }
    DeviceInfo.getInstance(deviceInfo: param);
  }

  static void showToast(String msg, bool shortLength) {
    try {
      if (shortLength) {
        Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppTheme.toastbgColor.withOpacity(0.9),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppTheme.toastbgColor.withOpacity(0.9),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    /*if (!regex.hasMatch(value))
      return true;
    else
      return false;*/
    return regex.hasMatch(value);
  }

  static double getDeviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getDeviceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static void showLoader(BuildContext context) {
    Loader.show(context,
        isAppbarOverlay: true,
        isBottomBarOverlay: true,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: Color(0xFFFF7443),
        ),
        themeData:
            Theme.of(context).copyWith(accentColor: AppTheme.primaryColor),
        overlayColor: Colors.transparent);
  }

  static void hideLoader(BuildContext context) {
    Loader.hide();
  }

  static bool equalsIgnoreCase(String string1, String string2) {
    return string1?.toLowerCase() == string2?.toLowerCase();
  }

  static Widget showSpinner() {
    return Center(
      child: CircularProgressIndicator(
          valueColor:
              new AlwaysStoppedAnimation<Color>(AppTheme.theme.primaryColor)),
    );
  }

  static Future<DateTime> selectDate(
    BuildContext context, {
    bool isStartIndex,
    bool isEndIndex,
  }) async {
    DateTime selectedDate = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        currentDate: DateTime.now(),
        firstDate: DateTime(1970, 1),
        lastDate: DateTime.now());
    print(picked);
    if (picked != null)
      //dayName = DateFormat('DD-MM-yyyy').format(selectedDate);
      return picked;
  }

  static getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  static Future<TimeOfDay> selectTime(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay.now();
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });
    if (picked_s != null && picked_s != selectedTime) selectedTime = picked_s;
    return selectedTime;
  }

  static String removeAllHtmlTags(String htmlText) {
    try {
      var document = parse(htmlText);
      String parsedString = parse(document.body.text).documentElement.text;
      return parsedString;
    } catch (e) {
      print(e);
      return "";
    }
  }

  static String noNetWorkDialog(BuildContext context, {Function onPressed}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(labelErrorAlert),
        content: Text(labelErrorNoInternet),
        actions: <Widget>[
          TextButton(
              child: Text(labelOk),
              onPressed: onPressed ??
                  () {
                    Navigator.pop(context);
                  })
        ],
      ),
    );
  }

  static String displayCommonDialog(BuildContext context,
      {String title = '',
      String massage = '',
      bool positiveButtonEnable = true,
      bool negativeButtonEnable = false,
      Function positiveOnPressed,
      Function negativeOnPressed}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(massage),
        actions: <Widget>[
          Visibility(
            visible: negativeButtonEnable,
            child: TextButton(
                child: Text(labelCancel),
                onPressed: negativeOnPressed ??
                    () {
                      Navigator.pop(context);
                    }),
          ),
          Visibility(
            visible: positiveButtonEnable,
            child: TextButton(
                child: Text(labelOk),
                onPressed: positiveOnPressed ??
                    () {
                      Navigator.pop(context);
                    }),
          )
        ],
      ),
    );
  }

  static launchCaller(String call) async {
    String url = "tel://${call}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static double roundOffPrice(double val, int places) {
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  // ...somewhere in your Flutter app...
  static launchWhatsApp(String number) async {
    final link = WhatsAppUnilink(
      phoneNumber: '$number',
      text: "",
    );
    // Convert the WhatsAppUnilink instance to a string.
    // Use either Dart's string interpolation or the toString() method.
    // The "launch" method is part of "url_launcher".
    await launch('$link');
  }

  static launchSMS(String number) async {
    try {
      List<String> recipients = List.empty(growable: true);
      recipients.add(number);
      String _result = await sendSMS(message: '', recipients: recipients);
    } catch (error) {
      print(error);
    }
  }

  static launchMaps(String lat, String lng) async {
    String googleUrl = 'comgooglemaps://?center=${lat},${lng}';
    String appleUrl = 'https://maps.apple.com/?sll=${lat},${lng}';
    if (await canLaunch("comgooglemaps://")) {
      print('launching com googleUrl');
      await launch(googleUrl);
    } else if (await canLaunch(appleUrl)) {
      print('launching apple url');
      await launch(appleUrl);
    } else {
      throw 'Could not launch url';
    }
  }

  static Future<void> openMap(String latitude, String longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (Platform.isIOS) {
      googleUrl = 'https://maps.apple.com/?q=$latitude,$longitude';
    }

    print("urlll ===> ${Uri.encodeFull(googleUrl)}");
    if (await canLaunch(Uri.encodeFull(googleUrl))) {
      print("launchedd");
      await launch(Uri.encodeFull(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }

  static Future<bool> displayPickUpDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future(() => true);
          },
          child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              //title: Text(title,textAlign: TextAlign.center,),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  height: Dimensions.getHeight(percentage: 40),
                  width: Dimensions.getWidth(percentage: 40),
                  decoration: BoxDecoration(
                      color: AppTheme.white,
                      image: DecorationImage(
                          image: AssetImage(AppImages.icon_thankyou_popup_bg))),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 16, 20, 16),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Image.asset(
                        AppImages.icon_thankyou_content,
                        height: Dimensions.getHeight(percentage: 30),
                      ),
                    ),
                  ),
                ),
              )),
        );
      },
    );
  }

  static void share(String msg, {String subject}) {
    Share.share(msg, subject: subject);
  }

  static Widget getHtmlView(String html) {
    return Html(
      shrinkWrap: true,
      data: html,
    );
  }

  static void launchURL(String videoUrl) async => await canLaunch(videoUrl)
      ? await launch(videoUrl)
      : throw 'Could not launch $videoUrl';

  static Future<PlacemarkModel> getPlace(
      double latitude, double longitude) async {
    PlacemarkModel placemarkModel;
    try {
      List<Placemark> newPlace =
          await placemarkFromCoordinates(latitude, longitude);
      // this is all you need
      Placemark placeMark = newPlace[0];
      String name = placeMark.name;
      String subLocality = placeMark.subLocality;
      String locality = placeMark.locality;
      String administrativeArea = placeMark.administrativeArea;
      String postalCode = placeMark.postalCode;
      String country = placeMark.country;
      String street = placeMark.street;
      String mainAddress =
          "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";

      String address = "name=${name},"
          "\nsubLocality=${subLocality},"
          "\nLocality=${locality},"
          "\nadministrativeArea=${administrativeArea},"
          "\npostalCode=${postalCode},"
          "\nstreet=${street},"
          "\ncountry=${country}";
      placemarkModel = new PlacemarkModel(
          name: name,
          subLocality: subLocality,
          locality: locality,
          address: mainAddress,
          administrativeArea: administrativeArea,
          postalCode: postalCode,
          country: country,
          street: street);
      print(address);
    } catch (e) {
      print(e);
    }
    return placemarkModel;
  }

  static convertDateFormat(DateTime dateObj,
      {String parsingPattern = dateTimeAppDisplayPattern}) {
    DateFormat formatter = new DateFormat(parsingPattern);
    String formatted = formatter.format(dateObj);
    //print(formatted);
    return formatted;
  }

  static const dateTimeServerPattern = 'yyyy-MM-dd hh:mm:ss';
  static const dateOnlyServerPattern = 'yyyy-MM-dd';
  static const dateTimeAppDisplayPattern = 'dd MMM, yyyy | hh:mm a';
  static const dateTimeAppDisplayPattern_1 = 'dd MMM yyyy, hh:mm a';
  static const dateTimeAppDisplayPattern_2 = 'dd MMM yyyy';
  static const dateTimeAppDisplayPattern_3 = 'dd MMM';
  static const timeAppPattern = 'hh:mm a';

  static convertDateFromFormat(String stringDate,
      {String convertorPattern = dateTimeServerPattern,
      String parsingPattern = dateTimeAppDisplayPattern}) {
    DateFormat dateFormat = DateFormat(convertorPattern);
    DateTime dateTime = dateFormat.parse(stringDate);
    DateFormat formatter = new DateFormat(parsingPattern);
    String formatted = formatter.format(dateTime);
    return formatted;
  }

  static convertTimeSlot(DateTime dateObj,
      {String timePattern = timeAppPattern}) {
    //2021-08-06 12:30:00
//    DateFormat dateFormat = DateFormat("yyyy-MM-dd, hh:mm:ss");
//    DateTime dateTime = dateFormat.parse(dateObj);
    DateFormat formatter = new DateFormat(timePattern);
    String formatted = formatter.format(dateObj);
    //print(formatted);
    return formatted;
  }

  static Future<bool> callForceUpdateDialog(
      BuildContext context, String title, String message,
      {Brand storeModel}) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future(() => false);
          },
          child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              //title: Text(title,textAlign: TextAlign.center,),
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Center(
                        child: Text(
                          "${title}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppTheme.mainTextColor, fontSize: 18),
                        ),
                      ),
                    ),
                    Container(
                        height: 1,
                        color: Colors.black45,
                        width: MediaQuery.of(context).size.width),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                      child: Center(
                        child: Text(
                          "${message}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: FlatButton(
                              child: Text('Update'),
                              color: AppTheme.primaryColor,
                              textColor: Colors.white,
                              onPressed: () {
                                String urlString = "";
                                if (Platform.isIOS) {
                                  urlString = storeModel.iphoneShareLink;
                                } else if (Platform.isAndroid) {
                                  urlString = storeModel.androidShareLink;
                                } else if (Platform.isWindows) {
                                  urlString = storeModel.appShareLink;
                                } else if (Platform.isLinux) {
                                  urlString = storeModel.appShareLink;
                                } else if (Platform.isMacOS) {
                                  urlString = storeModel.appShareLink;
                                }
                                if (urlString.isNotEmpty)
                                  launch(urlString);
                                else {
                                  SystemNavigator.pop();
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  static Future<bool> callCommonDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future(() => false);
          },
          child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Center(
                        child: Text(
                          "$title",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppTheme.mainTextColor, fontSize: 18),
                        ),
                      ),
                    ),
                    Container(
                        height: 1,
                        color: Colors.black45,
                        width: MediaQuery.of(context).size.width),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                      child: Center(
                        child: Text(
                          "$message",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: FlatButton(
                              child: Text('Ok'),
                              color: AppTheme.primaryColor,
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  static String chooseImageDialog(BuildContext context,
      {String title = '',
      bool cameraButtonEnable = true,
      bool galleryButtonEnable = false,
      Function cameraPressed,
      Function galleryPressed}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Center(child: Text(title)),
        content: Container(
          height: Dimensions.getHeight(percentage: 20),
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Visibility(
                visible: cameraButtonEnable,
                child: Container(
                  height: Dimensions.getHeight(percentage: 7),
                  width: Dimensions.getHeight(percentage: 20),
                  child: GradientElevatedButton(
                    onPressed: cameraPressed ??
                        () {
                          Navigator.pop(context);
                        },
                    buttonText: "Camera",
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Visibility(
                visible: galleryButtonEnable,
                child: Container(
                  height: Dimensions.getHeight(percentage: 7),
                  width: Dimensions.getHeight(percentage: 20),
                  child: GradientElevatedButton(
                    onPressed: galleryPressed ??
                        () {
                          Navigator.pop(context);
                        },
                    buttonText: "Gallery",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String getCurrencyPrice(dynamic price) {
    String currency = AppSharedPref.instance.getStoreCurrency();
    NumberFormat format =
        NumberFormat.simpleCurrency(name: currency, decimalDigits: 2);
    return format.format(price);
  }

  static Future<Map<String, dynamic>> initPlatformState() async {
    Map<String, dynamic> deviceData = {};

    final deviceInfoPlugin = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error': 'Failed to get platform version.'
      };
    }

    return deviceData;
  }

  static Map<String, dynamic> readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.id,
      'systemFeatures': build.systemFeatures,
    };
  }

  static Map<String, dynamic> readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  static Cart copyWithProduct(
      dynamic product,
      dynamic selectedVariant,
      String userId,
      String orderId,
      String deviceId,
      String deviceToken,
      String platform) {
    return AppUtils.copyWith(
      id: product.id,
      storeId: product.storeId,
      userId: userId,
      orderId: orderId,
      deviceId: deviceId,
      deviceToken: deviceToken,
      platform: platform,
      productId: product.id,
      productName: product.title,
      variantId: selectedVariant.id,
      weight: selectedVariant.weight,
      mrpPrice: selectedVariant.mrpPrice,
      price: selectedVariant.price,
      discount: selectedVariant.discount,
      servicePayout: '',
      walletRefundAmount: '',
      refundStatus: '',
      unitType: selectedVariant.unitType,
      quantity: product.count.toString(),
      comment: '',
      isTaxEnable: product.isTaxEnable,
      hsnCode: product.hsnCode,
      gstDetail: product.posTaxDetail,
      cgst: '',
      sgst: '',
      igst: '',
      gstType: product.gstTaxType,
      gstTaxRate: product.gstTaxRate,
      gstState: '',
      status: product.status,
      created: product.created,
      modified: product.created,
      image10080: product.image10080,
      image300200: product.image300200,
      image: product.image,
      variants: product.variants,
    );
  }

  static Cart copyWith(
          {String id,
          String storeId,
          String userId,
          String orderId,
          String deviceId,
          String deviceToken,
          String platform,
          String productId,
          String productName,
          String variantId,
          String weight,
          String mrpPrice,
          dynamic price,
          String discount,
          String servicePayout,
          String walletRefundAmount,
          String refundStatus,
          String unitType,
          String quantity,
          String comment,
          String isTaxEnable,
          String hsnCode,
          String gstDetail,
          String cgst,
          String sgst,
          String igst,
          String gstType,
          String gstTaxRate,
          String gstState,
          String status,
          String created,
          String modified,
          String image10080,
          String image300200,
          String image,
          List<dynamic> variants}) =>
      Cart(
        id: id,
        storeId: storeId,
        userId: userId,
        orderId: orderId,
        deviceId: deviceId,
        deviceToken: deviceToken,
        platform: platform,
        productId: productId,
        productName: productName,
        variantId: variantId,
        weight: weight,
        mrpPrice: mrpPrice,
        price: price,
        discount: discount,
        servicePayout: servicePayout,
        walletRefundAmount: walletRefundAmount,
        refundStatus: refundStatus,
        unitType: unitType,
        quantity: quantity,
        comment: comment,
        isTaxEnable: isTaxEnable,
        hsnCode: hsnCode,
        gstDetail: gstDetail,
        cgst: cgst,
        sgst: sgst,
        igst: igst,
        gstType: gstType,
        gstTaxRate: gstTaxRate,
        gstState: gstState,
        status: status,
        created: created,
        modified: modified,
        image10080: image10080,
        image300200: image300200,
        image: image,
        // variants: variants,
      );
}
