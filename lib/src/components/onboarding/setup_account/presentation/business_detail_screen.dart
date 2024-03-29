import 'dart:collection';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/img_picker/image_picker_handler.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/business_detail_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/placemark_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/presentation/widgets/AutoSearch.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/presentation/work_detail_screen.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/repository/account_steps_detail_repository_impl.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/utils/callbacks.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

import 'widgets/google_map.dart';

class BusinessDetailScreen extends StatefulWidget {
  final VoidCallback voidCallback;
  LatLng userlocation;
  final bool isComingFromAccount;

  BusinessDetailScreen(
      {@required this.voidCallback, this.isComingFromAccount = false});

  @override
  _BusinessDetailScreenState createState() {
    return _BusinessDetailScreenState();
  }
}

class _BusinessDetailScreenState extends BaseState<BusinessDetailScreen>
    with ImagePickerListener {
  bool isLoading = false;
  BusinessDetailModel businessDetailModel;
  final _key = GlobalKey<FormState>();
  var businessNameCont = TextEditingController();
  var stateCont = TextEditingController();
  var pinCodeCont = TextEditingController();
  var cityCont = TextEditingController();
  var addressCont = TextEditingController();
  var openTimeCont = TextEditingController();
  var closeTimeCont = TextEditingController();
  List<String> workLocationList = [];
  String _selectedWorkLocationTag;
  String _selectedProofTypeTag;
  var idProofNumberCont = TextEditingController();
  ImagePickerHandler imagePicker;
  File _selectedDocument;
  var docFileSize;
  List<String> daysList = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  List<String> selectedTagsList = [];
  List<String> selectedDaysList = [];
  bool showSelectedDaysListvew = false;
  HashMap<String, String> map = HashMap();
  HashMap<String, String> openTimeHashMap = HashMap();
  HashMap<String, String> closeTimeHashMap = HashMap();
  int radius;
  int defaultRadius = 20;
  LatLng center;

  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePickerHandler(this);
    imagePicker.init();
    setState(() {
      isLoading = true;
    });
    getIt
        .get<AccountStepsDetailRepositoryImpl>()
        .getBusinessDetail(userId)
        .then((value) async {
      businessDetailModel = value;
      // print("${userId.location.locationName}");
      
      GeoCode().forwardGeocoding(address: AppSharedPref.instance.getLocationId());
      
      var addresses = await GeoCode().forwardGeocoding(address: AppSharedPref.instance.getLocationId());
      var first = addresses;
      center =
          new LatLng(first.latitude, first.longitude);
      widget.userlocation = center;
      PlacemarkModel placemarkModel = await AppUtils.getPlace(
          first.latitude, first.longitude);
      setBusinessData(placemarkModel: placemarkModel);
      workLocationList = businessDetailModel.data.serviceType;
      _selectedWorkLocationTag = workLocationList.first;
      _selectedProofTypeTag =
          businessDetailModel.data.businessIdentityProofList.first;
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grayCircle,
      appBar: BaseAppBar(
        callback: () {
          widget.voidCallback();
          Navigator.of(context).pop();
        },
        backgroundColor: AppTheme.white,
        title: Text(
          'Business Detail',
          style: TextStyle(color: Colors.black),
        ),
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark),
          elevation: 0.0,
          titleSpacing: 0.0,
          bottom: PreferredSize(
              child: Container(
                color: AppTheme.grayCircle,
                height: 4.0,
              ),
              preferredSize: Size.fromHeight(4.0)),
        ),
        widgets: <Widget>[
          InkWell(
            onTap: () {
              callApi(gotoProfileStepsScreen: true);
            },
            child: Container(
              child: Center(
                child: Text("Save", style: TextStyle(color: Colors.black)),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? AppUtils.showSpinner()
            : SingleChildScrollView(
                child: Container(
                color: Colors.white,
                width: double.infinity,
                margin: EdgeInsets.only(
                    left: Dimensions.getScaledSize(20),
                    right: Dimensions.getScaledSize(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: Dimensions.getScaledSize(20),
                          top: Dimensions.getScaledSize(20),
                          bottom: Dimensions.getScaledSize(10),
                          right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Business Detail",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: AppTheme.subHeadingTextColor,
                              fontFamily: AppConstants.fontName,
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  color: AppTheme.grayCircle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35.0)),
                                  border: Border.all(
                                    color: AppTheme.grayCircle,
                                  )),
                              child: InkWell(
                                onTap: () {
                                  if (widget.isComingFromAccount) {
                                    return;
                                  }
                                  showBottomSheet(context, center, center,
                                      "${AppSharedPref.instance.getLocationId()}");
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      child: Icon(Icons.search,
                                          size: 20,
                                          color: AppTheme.primaryColor),
                                    ),
                                    Text(
                                      "Search Address",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.subHeadingTextColor,
                                        fontFamily: AppConstants.fontName,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    )
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    Form(
                      key: _key,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Container(
                        margin: EdgeInsets.only(
                            bottom: Dimensions.getScaledSize(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: Dimensions.getScaledSize(20),
                                  right: Dimensions.getScaledSize(20),
                                  bottom: Dimensions.getScaledSize(20)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    enabled: widget.isComingFromAccount
                                        ? false
                                        : true,
                                    readOnly: widget.isComingFromAccount,
                                    controller: businessNameCont,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    validator: (val) => val.isEmpty
                                        ? "Please enter business name!"
                                        : null,
                                    onFieldSubmitted: (value) {},
                                    style: TextStyle(
                                        color: AppTheme.mainTextColor),
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppTheme
                                                  .borderNotFocusedColor)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppTheme.primaryColor)),
                                      hintText: "Enter Business Name",
                                      errorStyle: TextStyle(
                                          fontSize:
                                              AppConstants.extraXSmallSize,
                                          fontFamily: AppConstants.fontName),
                                      hintStyle: TextStyle(
                                          color: AppTheme.subHeadingTextColor,
                                          fontSize: 16),
                                      labelStyle: TextStyle(
                                          color: AppTheme.mainTextColor,
                                          fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          enabled: widget.isComingFromAccount
                                              ? false
                                              : true,
                                          readOnly: widget.isComingFromAccount,
                                          controller: stateCont,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          validator: (val) => val.isEmpty
                                              ? "Please enter your state!"
                                              : null,
                                          onFieldSubmitted: (value) {},
                                          style: TextStyle(
                                              color: AppTheme.mainTextColor),
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: AppTheme
                                                        .borderNotFocusedColor)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        AppTheme.primaryColor)),
                                            hintText: "Enter State",
                                            errorStyle: TextStyle(
                                                fontSize: AppConstants
                                                    .extraXSmallSize,
                                                fontFamily:
                                                    AppConstants.fontName),
                                            hintStyle: TextStyle(
                                                color: AppTheme
                                                    .subHeadingTextColor,
                                                fontSize: 16),
                                            labelStyle: TextStyle(
                                                color: AppTheme.mainTextColor,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          enabled: widget.isComingFromAccount
                                              ? false
                                              : true,
                                          readOnly: widget.isComingFromAccount,
                                          controller: pinCodeCont,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          validator: (val) => val.isEmpty
                                              ? "Please enter your pincode!"
                                              : null,
                                          onTap: () async {},
                                          style: TextStyle(
                                              color: AppTheme.mainTextColor),
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: AppTheme
                                                        .borderNotFocusedColor)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        AppTheme.primaryColor)),
                                            hintText: "Pincode",
                                            errorStyle: TextStyle(
                                                fontSize: AppConstants
                                                    .extraXSmallSize,
                                                fontFamily:
                                                    AppConstants.fontName),
                                            hintStyle: TextStyle(
                                                color: AppTheme
                                                    .subHeadingTextColor,
                                                fontSize: 16),
                                            labelStyle: TextStyle(
                                                color: AppTheme.mainTextColor,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    enabled: widget.isComingFromAccount
                                        ? false
                                        : true,
                                    readOnly: widget.isComingFromAccount,
                                    controller: cityCont,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.send,
                                    validator: (val) =>
                                        val.isEmpty ? "Enter your city" : null,
                                    onFieldSubmitted: (value) async {},
                                    style: TextStyle(
                                        color: AppTheme.mainTextColor),
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppTheme
                                                  .borderNotFocusedColor)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppTheme.primaryColor)),
                                      hintText: "Enter City",
                                      errorStyle: TextStyle(
                                          fontSize:
                                              AppConstants.extraXSmallSize,
                                          fontFamily: AppConstants.fontName),
                                      hintStyle: TextStyle(
                                          color: AppTheme.subHeadingTextColor,
                                          fontSize: 14),
                                      labelStyle: TextStyle(
                                          color: AppTheme.mainTextColor,
                                          fontSize: 14),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    enabled: widget.isComingFromAccount
                                        ? false
                                        : true,
                                    readOnly: widget.isComingFromAccount,
                                    controller: addressCont,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.send,
                                    validator: (val) =>
                                        val.isEmpty ? "Enter address" : null,
                                    onFieldSubmitted: (value) async {},
                                    style: TextStyle(
                                        color: AppTheme.mainTextColor),
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppTheme
                                                  .borderNotFocusedColor)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppTheme.primaryColor)),
                                      hintText: "Enter Address",
                                      errorStyle: TextStyle(
                                          fontSize:
                                              AppConstants.extraXSmallSize,
                                          fontFamily: AppConstants.fontName),
                                      hintStyle: TextStyle(
                                          color: AppTheme.subHeadingTextColor,
                                          fontSize: 14),
                                      labelStyle: TextStyle(
                                          color: AppTheme.mainTextColor,
                                          fontSize: 14),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    child: DropdownButtonFormField(
                                      dropdownColor: Colors.white,
                                      items: workLocationList
                                          .map((String category) {
                                        return new DropdownMenuItem(
                                            value: category,
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  category,
                                                  style: TextStyle(
                                                      color: AppTheme
                                                          .mainTextColor,
                                                      fontFamily:
                                                          AppConstants.fontName,
                                                      fontSize: AppConstants
                                                          .smallSize),
                                                ),
                                              ],
                                            ));
                                      }).toList(),
                                      onTap: () {},
                                      onChanged: widget.isComingFromAccount
                                          ? null
                                          : (newValue) {
                                              // do other stuff with _category
                                              setState(() =>
                                                  _selectedWorkLocationTag =
                                                      newValue);
                                            },
                                      value: _selectedWorkLocationTag,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(0),
                                          filled: true,
                                          fillColor: AppTheme.transparent,
                                          focusColor: AppTheme.transparent,
                                          hoverColor: AppTheme.transparent,
                                          labelText: "I would like to work at",
                                          labelStyle: TextStyle(
                                              fontSize: 16,
                                              color: AppTheme
                                                  .subHeadingTextColor)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 0, top: 10, bottom: 0),
                                    child: Text(
                                      "I would like to receive work within",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: AppTheme.subHeadingTextColor,
                                        fontFamily: AppConstants.fontName,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                child: GoogleMapScreen(
                              isComingFromAccount: widget.isComingFromAccount,
                              userlocation: widget.userlocation,
                              businessDetailModel: businessDetailModel,
                              radius: businessDetailModel
                                      .data.businessDetail.radius.isEmpty
                                  ? defaultRadius
                                  : radius,
                              callback: (radius) {
                                this.radius = radius;
                              },
                            )),
                            Container(
                              margin: EdgeInsets.only(
                                  left: Dimensions.getScaledSize(20),
                                  top: Dimensions.getScaledSize(30)),
                              child: Text(
                                "Business ID/GST Number",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: AppTheme.subHeadingTextColor,
                                  fontFamily: AppConstants.fontName,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 20, 0, 10),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.start,
                                spacing: 15,
                                runSpacing: 5,
                                children: businessDetailModel
                                    .data.businessIdentityProofList
                                    .map((tag) {
                                  return InkWell(
                                      onTap: () {
                                        if (widget.isComingFromAccount) {
                                          return;
                                        }
                                        setState(() {
                                          _selectedProofTypeTag = tag;
                                        });
                                      },
                                      child: Container(
                                        width: SizeConfig.screenWidth / 4.1,
                                        padding:
                                            EdgeInsets.only(left: 0, right: 0),
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: _selectedProofTypeTag
                                                      .toLowerCase() ==
                                                  tag.toLowerCase()
                                              ? AppTheme.primaryColor
                                              : AppTheme.grayCircle,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            tag,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: _selectedProofTypeTag
                                                            .toLowerCase() ==
                                                        tag.toLowerCase()
                                                    ? AppTheme.white
                                                    : AppTheme
                                                        .subHeadingTextColor),
                                          ),
                                        ),
                                      ));
                                }).toList(),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: TextFormField(
                                enabled:
                                    widget.isComingFromAccount ? false : true,
                                readOnly: widget.isComingFromAccount,
                                controller: idProofNumberCont,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (val) => val.isEmpty
                                    ? "Enter your ${_selectedProofTypeTag}"
                                    : null,
                                onFieldSubmitted: (value) {},
                                style: TextStyle(color: AppTheme.mainTextColor),
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              AppTheme.borderNotFocusedColor)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppTheme.primaryColor)),
                                  hintText: "Enter ${_selectedProofTypeTag}",
                                  errorStyle: TextStyle(
                                      fontSize: AppConstants.extraXSmallSize,
                                      fontFamily: AppConstants.fontName),
                                  hintStyle: TextStyle(
                                      color: AppTheme.subHeadingTextColor,
                                      fontSize: 16),
                                  labelStyle: TextStyle(
                                      color: AppTheme.mainTextColor,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: Dimensions.getScaledSize(20),
                                  right: Dimensions.getScaledSize(30),
                                  top: 10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Text(
                                        "Upload Documents",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppTheme.subHeadingTextColor,
                                          fontFamily: AppConstants.fontName,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "Max file size: 15mb",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppTheme.mainTextColor,
                                          fontFamily: AppConstants.fontName,
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: Dimensions.getScaledSize(20),
                                  right: Dimensions.getScaledSize(30),
                                  top: 10),
                              child: Visibility(
                                visible: widget.isComingFromAccount
                                    ? false
                                    : _selectedDocument == null
                                        ? true
                                        : false,
                                child: InkWell(
                                  child: DottedBorder(
                                    dashPattern: [3, 3, 3, 3],
                                    strokeWidth: 1,
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(12),
                                    //padding: EdgeInsets.all(6),
                                    color: AppTheme.subHeadingTextColor,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      child: Container(
                                        height:
                                            Dimensions.getWidth(percentage: 25),
                                        width:
                                            Dimensions.getWidth(percentage: 35),
                                        color: Color(0xffF9F9F9),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.upload_rounded,
                                                color: AppTheme.primaryColor,
                                              ),
                                              Text(
                                                "Upload\n${_selectedProofTypeTag} Document",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: AppTheme.mainTextColor,
                                                  fontFamily:
                                                      AppConstants.fontName,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if (widget.isComingFromAccount) {
                                      return;
                                    }
                                    imagePicker.showDialog(context,
                                        profileImage: true,
                                        docImage1: false,
                                        docImage2: false);
                                  },
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: Dimensions.getScaledSize(20),
                                  right: Dimensions.getScaledSize(30),
                                  top: 10),
                              child: Visibility(
                                visible:
                                    _selectedDocument != null ? true : false,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: shadow,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 0.5,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: ListTile(
                                    leading: Container(
                                        height: double.infinity,
                                        child: Icon(
                                          Icons.description_outlined,
                                          color: AppTheme.primaryColor,
                                        )),
                                    title: Text(
                                        _selectedDocument == null
                                            ? ""
                                            : _selectedDocument.path.isEmpty
                                                ? "${businessDetailModel.data.businessDetail.businessIdentityProofImage.split('/').last}"
                                                : '${_selectedDocument.path.split('/').last}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                    subtitle: Text(docFileSize == null
                                        ? ""
                                        : '${docFileSize}'),
                                    trailing: InkWell(
                                      onTap: () {
                                        if (!widget.isComingFromAccount) {
                                          setState(() {
                                            _selectedDocument = null;
                                            docFileSize = null;
                                          });
                                        }
                                      },
                                      child: Icon(
                                        Icons.clear,
                                        color: widget.isComingFromAccount
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    contentPadding:
                                        EdgeInsets.only(left: 10, right: 10),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: Dimensions.getScaledSize(20),
                                  top: Dimensions.getScaledSize(30)),
                              child: Text(
                                "I would like to work on",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: AppTheme.subHeadingTextColor,
                                  fontFamily: AppConstants.fontName,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 20, 15, 5),
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                spacing: 10,
                                runSpacing: 5,
                                children: daysList.map((tag) {
                                  return InkWell(
                                      onTap: () {
                                        if (showSelectedDaysListvew &&
                                            selectedTagsList.contains(tag)) {
                                          map = new HashMap<String, String>();
                                          map[tag] = tag;
                                          openTimeCont.text =
                                              openTimeHashMap[tag];
                                          closeTimeCont.text =
                                              closeTimeHashMap[tag];
                                          setState(() {});
                                        } else {
                                          if (selectedTagsList.contains(tag)) {
                                            selectedTagsList.remove(tag);
                                            openTimeHashMap.remove(tag);
                                            closeTimeHashMap.remove(tag);
                                          } else {
                                            selectedTagsList.add(tag);
                                            if (showSelectedDaysListvew) {
                                              openTimeHashMap[tag] =
                                                  openTimeCont.text;
                                              closeTimeHashMap[tag] =
                                                  closeTimeCont.text;
                                            }
                                          }
                                          setState(() {});
                                        }
                                      },
                                      child: Container(
                                        width: SizeConfig.screenWidth / 7.5,
                                        padding:
                                            EdgeInsets.only(left: 0, right: 0),
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: getBoxColor(tag),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Center(
                                          child: Text(
                                            tag,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: AppTheme.white),
                                          ),
                                        ),
                                      ));
                                }).toList(),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: Dimensions.getScaledSize(20),
                                  top: Dimensions.getScaledSize(20)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            "Open at",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color:
                                                  AppTheme.subHeadingTextColor,
                                              fontFamily: AppConstants.fontName,
                                            ),
                                          ),
                                        ),
                                        TextFormField(
                                          readOnly: true,
                                          controller: openTimeCont,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          validator: (val) => val.isEmpty
                                              ? "Select time"
                                              : null,
                                          onTap: () async {
                                            TimeOfDay selectedTime =
                                                await AppUtils.selectTime(
                                                    context);
                                            print(
                                                "selectedTime=${selectedTime}");
                                            setState(() {
                                              openTimeCont.text =
                                                  "${selectedTime.format(context)}";
                                            });
                                          },
                                          style: TextStyle(
                                              color: AppTheme.mainTextColor),
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: AppTheme
                                                        .borderNotFocusedColor)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        AppTheme.primaryColor)),
                                            hintText: "Select time",
                                            errorStyle: TextStyle(
                                                fontSize: AppConstants
                                                    .extraXSmallSize,
                                                fontFamily:
                                                    AppConstants.fontName),
                                            hintStyle: TextStyle(
                                                color: AppTheme
                                                    .subHeadingTextColor,
                                                fontSize: 16),
                                            labelStyle: TextStyle(
                                                color: AppTheme.mainTextColor,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            "Close at",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color:
                                                  AppTheme.subHeadingTextColor,
                                              fontFamily: AppConstants.fontName,
                                            ),
                                          ),
                                        ),
                                        TextFormField(
                                          readOnly: true,
                                          controller: closeTimeCont,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          validator: (val) => val.isEmpty
                                              ? "Select time"
                                              : null,
                                          onTap: () async {
                                            TimeOfDay selectedTime =
                                                await AppUtils.selectTime(
                                                    context);
                                            print(
                                                "selectedTime=${selectedTime}");
                                            setState(() {
                                              closeTimeCont.text =
                                                  "${selectedTime.format(context)}";
                                            });
                                          },
                                          style: TextStyle(
                                              color: AppTheme.mainTextColor),
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: AppTheme
                                                        .borderNotFocusedColor)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        AppTheme.primaryColor)),
                                            hintText: "Select time",
                                            errorStyle: TextStyle(
                                                fontSize: AppConstants
                                                    .extraXSmallSize,
                                                fontFamily:
                                                    AppConstants.fontName),
                                            hintStyle: TextStyle(
                                                color: AppTheme
                                                    .subHeadingTextColor,
                                                fontSize: 16),
                                            labelStyle: TextStyle(
                                                color: AppTheme.mainTextColor,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                        child: Visibility(
                                      visible: true,
                                      child: GradientElevatedButton(
                                        onPressed: () async {
                                          if (selectedTagsList.isEmpty) {
                                            AppUtils.showToast(
                                                "Please select work days!",
                                                true);
                                            return;
                                          }
                                          if (openTimeCont.text.isEmpty) {
                                            AppUtils.showToast(
                                                "Please open time!", true);
                                            return;
                                          }
                                          if (closeTimeCont.text.isEmpty) {
                                            AppUtils.showToast(
                                                "Please close time!", true);
                                            return;
                                          }
                                          print("map=${map.length}");
                                          if (map.isNotEmpty) {
                                            map.forEach((k, v) {
                                              openTimeHashMap[k] =
                                                  openTimeCont.text;
                                              closeTimeHashMap[k] =
                                                  closeTimeCont.text;
                                            });
                                            map = new HashMap<String, String>();
                                          } else {
                                            for (int i = 0;
                                                i < selectedTagsList.length;
                                                i++) {
                                              openTimeHashMap[
                                                      selectedTagsList[i]] =
                                                  openTimeCont.text;
                                              closeTimeHashMap[
                                                      selectedTagsList[i]] =
                                                  closeTimeCont.text;
                                            }
                                          }
                                          selectedDaysList = selectedTagsList;
                                          setState(() {
                                            showSelectedDaysListvew = true;
                                          });
                                        },
                                        //onPressed: validateAndSave(isSubmitPressed: true),
                                        buttonText: labelSave,
                                      ),
                                    )),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: showSelectedDaysListvew,
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 20, bottom: 20),
                                width: double.infinity,
                                height: 5,
                                color: AppTheme.grayCircle,
                              ),
                            ),
                            Visibility(
                              visible: showSelectedDaysListvew,
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: Dimensions.getScaledSize(20),
                                    top: Dimensions.getScaledSize(20)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          "Days",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: AppTheme.subHeadingTextColor,
                                            fontFamily: AppConstants.fontName,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          "Open at",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: AppTheme.subHeadingTextColor,
                                            fontFamily: AppConstants.fontName,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          "Close at",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: AppTheme.subHeadingTextColor,
                                            fontFamily: AppConstants.fontName,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: showSelectedDaysListvew,
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 20),
                                width: double.infinity,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: selectedDaysList.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                "${selectedDaysList[index]}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: AppTheme.mainTextColor,
                                                  fontFamily:
                                                      AppConstants.fontName,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                "${openTimeHashMap[selectedDaysList[index]]}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: AppTheme.mainTextColor,
                                                  fontFamily:
                                                      AppConstants.fontName,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                "${closeTimeHashMap[selectedDaysList[index]]}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: AppTheme.mainTextColor,
                                                  fontFamily:
                                                      AppConstants.fontName,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: InkWell(
                                            onTap: () {
                                              print(
                                                  "selectedDaysList[index]=${selectedDaysList[index]}");
                                              selectedTagsList.remove(
                                                  selectedDaysList[index]);
                                              if (selectedTagsList.isEmpty) {
                                                openTimeCont.text = "";
                                                closeTimeCont.text = "";
                                              }
                                              setState(() {});
                                            },
                                            child: Container(
                                              child: Icon(Icons.clear),
                                            ),
                                          )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Visibility(
                              visible:
                                  widget.isComingFromAccount ? false : true,
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: Dimensions.getScaledSize(30),
                                ),
                                child: Image.asset(
                                  "lib/src/components/onboarding/images/note.png",
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                  height: 50,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Visibility(
                              visible:
                                  widget.isComingFromAccount ? false : true,
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 30, right: 30, bottom: 20),
                                width: MediaQuery.of(context).size.width,
                                child: GradientElevatedButton(
                                  onPressed: () async {
                                    callApi();
                                  },
                                  //onPressed: validateAndSave(isSubmitPressed: true),
                                  buttonText: labelSaveNext,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  selectedProfileImage(
      XFile _image,
      bool profileImage,
      bool docImage1,
      bool docImage2,
      bool doc3,
      bool docCertificateImage1,
      bool docCertificateImage2,
      bool docCertificateImage3) async {
    if (_image == null) {
      AppUtils.showToast("Invalid Image!", true);
      return;
    }
    try {
      print("XFile=${_image.path}");
      print("XFile=${_image.path}");
      if (profileImage) {
        _selectedDocument = File(_image.path);
        docFileSize = await AppUtils.getFileSize(_selectedDocument.path, 1);
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  getBoxColor(String tag) {
    Color boxColor;
    if (showSelectedDaysListvew) {
      if (selectedTagsList.contains(tag)) {
        if (map.containsKey(tag)) {
          boxColor = AppTheme.primaryColor;
        } else {
          boxColor = AppTheme.greenColor;
        }
      } else {
        boxColor = AppTheme.grayCircle;
      }
    } else {
      if (selectedTagsList.contains(tag)) {
        boxColor = AppTheme.primaryColor;
      } else {
        boxColor = AppTheme.grayCircle;
      }
    }
    return boxColor;
  }

  String sun_open = '';
  String sun_close = '';
  String mon_open = '';
  String mon_close = '';
  String tue_open = '';
  String tue_close = '';
  String wed_open = '';
  String wed_close = '';
  String thu_open = '';
  String thu_close = '';
  String fri_open = '';
  String fri_close = '';
  String sat_open = '';
  String sat_close = '';

  Future<void> callApi({bool gotoProfileStepsScreen = false}) async {
    if (this.network.offline) {
      AppUtils.showToast(AppConstants.noInternetMsg, false);
      return;
    }
    final FormState form = _key.currentState;
    if (form.validate()) {
      if (_selectedDocument == null) {
        AppUtils.showToast("Please upload document!", true);
        return;
      }

      String service_type;
      for (int i = 0; i < workLocationList.length; i++) {
        if (_selectedWorkLocationTag == workLocationList[i]) {
          service_type = i.toString();
          break;
        }
      }

      sun_open = selectedTagsList.contains("Sun") ? openTimeHashMap["Sun"] : "";
      sun_close =
          selectedTagsList.contains("Sun") ? closeTimeHashMap["Sun"] : "";
      mon_open = selectedTagsList.contains("Mon") ? openTimeHashMap["Mon"] : "";
      mon_close =
          selectedTagsList.contains("Mon") ? closeTimeHashMap["Mon"] : "";
      tue_open = selectedTagsList.contains("Tue") ? openTimeHashMap["Tue"] : "";
      tue_close =
          selectedTagsList.contains("Tue") ? closeTimeHashMap["Tue"] : "";
      wed_open = selectedTagsList.contains("Wed") ? openTimeHashMap["Wed"] : "";
      wed_close =
          selectedTagsList.contains("Wed") ? closeTimeHashMap["Wed"] : "";
      thu_open = selectedTagsList.contains("Thu") ? openTimeHashMap["Thu"] : "";
      thu_close =
          selectedTagsList.contains("Thu") ? closeTimeHashMap["Thu"] : "";
      fri_open = selectedTagsList.contains("Fri") ? openTimeHashMap["Fri"] : "";
      fri_close =
          selectedTagsList.contains("Fri") ? closeTimeHashMap["Fri"] : "";
      sat_open = selectedTagsList.contains("Sat") ? openTimeHashMap["Sat"] : "";
      sat_close =
          selectedTagsList.contains("Sat") ? closeTimeHashMap["Sat"] : "";

      AppUtils.showLoader(context);

      BaseResponse baseresponse = await getIt
          .get<AccountStepsDetailRepositoryImpl>()
          .saveBusinessDetail(
            userId,
            business_id: businessDetailModel.data.businessDetail.businessId,
            business_name: businessNameCont.text,
            state: stateCont.text,
            pincode: pinCodeCont.text,
            city: cityCont.text,
            address: addressCont.text,
            service_type: service_type,
            radius: this.radius.toString(),
            lat: "${widget.userlocation.latitude}",
            lng: "${widget.userlocation.longitude}",
            business_identity_proof: _selectedProofTypeTag,
            business_identity_proof_number: idProofNumberCont.text,
            business_identity_proof_image: _selectedDocument,
            working_id: businessDetailModel.data.workingDetail.workingId,
            sun_open: this.sun_open,
            sun_close: this.sun_open,
            mon_open: this.mon_open,
            mon_close: this.mon_close,
            tue_open: this.tue_open,
            tue_close: this.tue_close,
            wed_open: this.wed_open,
            wed_close: this.wed_close,
            thu_open: this.thu_open,
            thu_close: this.thu_close,
            fri_open: this.fri_open,
            fri_close: this.fri_close,
            sat_open: this.sat_open,
            sat_close: this.sat_close,
          );

      if (baseresponse != null) {
        AppUtils.showToast(baseresponse.message, true);
        AppUtils.hideKeyboard(context);
        AppUtils.hideLoader(context);
        if (baseresponse.success) if (widget.isComingFromAccount) {
          Navigator.pop(context);
        } else {
          if (gotoProfileStepsScreen) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            widget.voidCallback();
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => WorkDetailScreen(
                          voidCallback: () {
                            widget.voidCallback();
                          },
                        )));
          }
        }
      }
    }
  }

  void setBusinessData({PlacemarkModel placemarkModel}) {
    businessNameCont.text =
        businessDetailModel.data.businessDetail.businessName;

    if (widget.isComingFromAccount) {
      stateCont.text = businessDetailModel.data.businessDetail.state;
      pinCodeCont.text = businessDetailModel.data.businessDetail.pincode;
      cityCont.text = businessDetailModel.data.businessDetail.city;
      addressCont.text = businessDetailModel.data.businessDetail.address;
    } else {
      pinCodeCont.text =
          placemarkModel == null || placemarkModel.postalCode == null
              ? ""
              : placemarkModel.postalCode;
      addressCont.text =
          placemarkModel == null || placemarkModel.address == null
              ? ""
              : placemarkModel.address;
      cityCont.text = placemarkModel == null || placemarkModel.locality == null
          ? ""
          : placemarkModel.locality;
      stateCont.text =
          placemarkModel == null || placemarkModel.administrativeArea == null
              ? ""
              : placemarkModel.administrativeArea;
    }

    idProofNumberCont.text =
        businessDetailModel.data.businessDetail.businessIdentityProofNumber;

    if (businessDetailModel.data.businessDetail.radius.isNotEmpty) {
      radius = int.parse(businessDetailModel.data.businessDetail.radius);
    }

    if (businessDetailModel.data.businessDetail.lat.isNotEmpty &&
        widget.isComingFromAccount) {
      widget.userlocation = new LatLng(
          double.parse(businessDetailModel.data.businessDetail.lat),
          double.parse(businessDetailModel.data.businessDetail.lng));
    }

    if (businessDetailModel.data.businessDetail.serviceType.isNotEmpty) {
      for (int i = 0; i < workLocationList.length; i++) {
        if (int.parse(businessDetailModel.data.businessDetail.serviceType) ==
            i) {
          _selectedWorkLocationTag = workLocationList[i];
          break;
        }
      }
    }
    if (businessDetailModel
        .data.businessDetail.businessIdentityProof.isNotEmpty) {
      _selectedProofTypeTag =
          businessDetailModel.data.businessDetail.businessIdentityProof;
    }

    if (businessDetailModel
        .data.businessDetail.businessIdentityProofImage.isNotEmpty) {
      _selectedDocument = File("");
      docFileSize = "";
    }

    //selectedTagsList
    if (businessDetailModel.data.workingDetail.sunOpen.isNotEmpty) {
      selectedTagsList.add("Sun");
      openTimeHashMap["Sun"] = businessDetailModel.data.workingDetail.sunOpen;
      closeTimeHashMap["Sun"] = businessDetailModel.data.workingDetail.sunClose;
      showSelectedDaysListvew = true;
      openTimeCont.text = businessDetailModel.data.workingDetail.sunOpen;
      closeTimeCont.text = businessDetailModel.data.workingDetail.sunClose;
    }
    if (businessDetailModel.data.workingDetail.monOpen.isNotEmpty) {
      selectedTagsList.add("Mon");
      openTimeHashMap["Mon"] = businessDetailModel.data.workingDetail.monOpen;
      closeTimeHashMap["Mon"] = businessDetailModel.data.workingDetail.monClose;
      showSelectedDaysListvew = true;
      openTimeCont.text = businessDetailModel.data.workingDetail.sunOpen;
      closeTimeCont.text = businessDetailModel.data.workingDetail.sunClose;
    }
    if (businessDetailModel.data.workingDetail.tueOpen.isNotEmpty) {
      selectedTagsList.add("Tue");
      openTimeHashMap["Tue"] = businessDetailModel.data.workingDetail.tueOpen;
      closeTimeHashMap["Tue"] = businessDetailModel.data.workingDetail.tueClose;
      showSelectedDaysListvew = true;
      openTimeCont.text = businessDetailModel.data.workingDetail.sunOpen;
      closeTimeCont.text = businessDetailModel.data.workingDetail.sunClose;
    }
    if (businessDetailModel.data.workingDetail.wedOpen.isNotEmpty) {
      selectedTagsList.add("Wed");
      openTimeHashMap["Wed"] = businessDetailModel.data.workingDetail.wedOpen;
      closeTimeHashMap["Wed"] = businessDetailModel.data.workingDetail.wedClose;
      showSelectedDaysListvew = true;
      openTimeCont.text = businessDetailModel.data.workingDetail.sunOpen;
      closeTimeCont.text = businessDetailModel.data.workingDetail.sunClose;
    }
    if (businessDetailModel.data.workingDetail.thuOpen.isNotEmpty) {
      selectedTagsList.add("Thu");
      openTimeHashMap["Thu"] = businessDetailModel.data.workingDetail.thuOpen;
      closeTimeHashMap["Thu"] = businessDetailModel.data.workingDetail.thuClose;
      showSelectedDaysListvew = true;
      openTimeCont.text = businessDetailModel.data.workingDetail.sunOpen;
      closeTimeCont.text = businessDetailModel.data.workingDetail.sunClose;
    }
    if (businessDetailModel.data.workingDetail.friOpen.isNotEmpty) {
      selectedTagsList.add("Fri");
      openTimeHashMap["Fri"] = businessDetailModel.data.workingDetail.friOpen;
      closeTimeHashMap["Fri"] = businessDetailModel.data.workingDetail.friClose;
      showSelectedDaysListvew = true;
      openTimeCont.text = businessDetailModel.data.workingDetail.sunOpen;
      closeTimeCont.text = businessDetailModel.data.workingDetail.sunClose;
    }
    if (businessDetailModel.data.workingDetail.satOpen.isNotEmpty) {
      selectedTagsList.add("Sat");
      openTimeHashMap["Sat"] = businessDetailModel.data.workingDetail.satOpen;
      closeTimeHashMap["Sat"] = businessDetailModel.data.workingDetail.satClose;
      showSelectedDaysListvew = true;
      openTimeCont.text = businessDetailModel.data.workingDetail.sunOpen;
      closeTimeCont.text = businessDetailModel.data.workingDetail.sunClose;
    }

    selectedDaysList = selectedTagsList;

    setState(() {});
  }

  void showBottomSheet(
      context, LatLng center, LatLng selectedLocation, String address) {
    LatLng localCenter, localSelectedLocation;
    GoogleMapController _mapController;
    localCenter = center;
    localSelectedLocation = selectedLocation;
    Set<Marker> markers = Set();
    String localAddress = address;

    getAddressFromLocationFromMap(double latitude, double longitude,
        {StateSetter setState}) async {
      try {
        localCenter = LatLng(latitude, longitude);
        localSelectedLocation = LatLng(latitude, longitude);
        Coordinates coordinates = new Coordinates(latitude : latitude, longitude : longitude);

        var addresses =
            await GeoCode().reverseGeocoding(latitude: coordinates.latitude, longitude: coordinates.longitude);
        var first = addresses;
        localAddress = first.city;
        if (setState != null)
          setState(() {
            localAddress = first.city;
          });
      } catch (e) {
        print(e);
        address = "No address found!";
      }
    }

    markers.addAll([
      Marker(
          draggable: true,
          icon: BitmapDescriptor.defaultMarker,
          markerId: MarkerId('value'),
          position: localCenter,
          onDragEnd: (value) {
            getAddressFromLocationFromMap(value.latitude, value.longitude);
          })
    ]);
    getAddressFromLocationFromMap(localCenter.latitude, localCenter.longitude);
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return Wrap(children: <Widget>[
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(5, 15, 5, 5),
                          child: Icon(
                            Icons.cancel,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Text(
                        'Set Location',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.all(20),
                        //padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: AppTheme.grayCircle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            border: Border.all(
                              color: AppTheme.grayCircle,
                            )),
                        child: InkWell(
                            onTap: () async {
                              var result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return CustomSearchScaffold();
                                    },
                                    fullscreenDialog: true,
                                  ));
                              if (result != null) {
                                LatLng detail = result;
                                double lat = detail.latitude;
                                double lng = detail.longitude;
                                print("----result.location = ${lat},${lng}");

                                localCenter = LatLng(lat, lng);
                                localSelectedLocation = LatLng(lat, lng);
                                getAddressFromLocationFromMap(lat, lng,
                                    setState: setState);
                                markers.clear();
                                markers.addAll([
                                  Marker(
                                      draggable: true,
                                      icon: BitmapDescriptor.defaultMarker,
                                      markerId: MarkerId('value'),
                                      position: localCenter,
                                      onDragEnd: (value) {
                                        getAddressFromLocationFromMap(
                                            value.latitude, value.longitude,
                                            setState: setState);
                                      })
                                ]);
                                setState(() {
                                  _mapController.moveCamera(
                                      CameraUpdate.newLatLng(localCenter));
                                });
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Center(
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(3, 3, 10, 3),
                                        child: Icon(Icons.search,
                                            size: 20,
                                            color: AppTheme.primaryColor),
                                      ),
                                      Expanded(
                                        child: RichText(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          text: TextSpan(
                                            text: "${localAddress}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                        ),
                                      )
                                    ]),
                              ),
                            ))),
                    Container(
                        height: AppUtils.getDeviceHeight(context) >
                                AppUtils.getDeviceWidth(context)
                            ? AppUtils.getDeviceWidth(context) - 50
                            : AppUtils.getDeviceHeight(context) / 2 - 50,
                        margin:
                            EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        child: GoogleMap(
                          onMapCreated: (GoogleMapController controller) {
                            _mapController = controller;
                          },
                          myLocationEnabled: true,
                          initialCameraPosition: CameraPosition(
                            target: localCenter,
                            zoom: 15.0,
                          ),
                          mapType: MapType.normal,
                          markers: markers,
                          onTap: (latLng) {
                            if (markers.length >= 1) {
                              markers.clear();
                            }
                            setState(() {
                              markers.add(Marker(
                                  draggable: true,
                                  icon: BitmapDescriptor.defaultMarker,
                                  markerId: MarkerId('value'),
                                  position: latLng,
                                  onDragEnd: (value) {
                                    print(value.latitude);
                                    print(value.longitude);
                                    getAddressFromLocationFromMap(
                                        value.latitude, value.longitude,
                                        setState: setState);
                                  }));
                              getAddressFromLocationFromMap(
                                  latLng.latitude, latLng.longitude,
                                  setState: setState);
                            });
                          },
                          onCameraMove: (CameraPosition position) {
                            CameraPosition newPos =
                                CameraPosition(target: position.target);
                            Marker marker = markers.first;

                            setState(() {
                              markers.first
                                  .copyWith(positionParam: newPos.target);
                            });
                          },
                          //onCameraMove: _onCameraMove,
                        )),
                    Align(
                      alignment: Alignment.center,
                      child: ButtonTheme(
                        minWidth: 180.0,
                        height: 40.0,
                        child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              side: BorderSide(color: AppTheme.primaryColor)),
                          onPressed: () async {
                            if (widget.isComingFromAccount) {
                              return;
                            }
                            widget.userlocation = localSelectedLocation;
                            eventBus.fire(OnLocationUpdate(
                                selectedLocation: widget.userlocation));
                            PlacemarkModel placemarkModel =
                                await AppUtils.getPlace(
                                    widget.userlocation.latitude,
                                    widget.userlocation.longitude);
                            pinCodeCont.text = placemarkModel == null ||
                                    placemarkModel.postalCode == null
                                ? ""
                                : placemarkModel.postalCode;
                            addressCont.text = placemarkModel == null ||
                                    placemarkModel.address == null
                                ? ""
                                : placemarkModel.address;
                            cityCont.text = placemarkModel == null ||
                                    placemarkModel.locality == null
                                ? ""
                                : placemarkModel.locality;
                            stateCont.text = placemarkModel == null ||
                                    placemarkModel.administrativeArea == null
                                ? ""
                                : placemarkModel.administrativeArea;
                            print(
                                "---localSelectedLocation--=${localSelectedLocation}");
                            print("---localAddress---=${localAddress}");
                            Navigator.pop(context);
                            setState(() {});
                          },
                          color: AppTheme.primaryColor,
                          padding: EdgeInsets.all(5.0),
                          textColor: Colors.white,
                          child: Text("Submit"),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              )
            ]);
          });
        });
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
