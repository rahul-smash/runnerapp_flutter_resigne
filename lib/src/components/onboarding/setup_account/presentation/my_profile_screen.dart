import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/img_picker/image_picker_handler.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/profile_info_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/repository/account_steps_detail_repository_impl.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/common_widgets.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';
import 'dart:io';

import 'business_detail_screen.dart';

class MyProfileScreen extends StatefulWidget {

  final VoidCallback voidCallback;
  final bool isComingFromAccount;
  MyProfileScreen({@required this.voidCallback,this.isComingFromAccount = false});

  @override
  _MyProfileScreenState createState() {
    return _MyProfileScreenState();
  }
}

class _MyProfileScreenState extends BaseState<MyProfileScreen> with ImagePickerListener{

  final _key = GlobalKey<FormState>();
  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController ageCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  List<String> _genderOptions = ["Male","Female"];
  String _selectedGenderUpOption = labelSignUpAs;
  DateTime selectedStartDate;
  List<String> addressProofsList = [];
  String _selectedProofTypeTag;
  TextEditingController userCommentController = TextEditingController();
  TextEditingController proofNameCont = TextEditingController();
  TextEditingController idProofNameCont = TextEditingController();
  ProfileInfoModel profileInfoModel;
  ImagePickerHandler imagePicker;
  File _selectedProfileImg;
  File _selectedImg1,_selectedImg2;
  var resultFileImgSize1,resultFileImgSize2;
  bool isLoading = false;
  Location location = new Location();

  bool _serviceEnabled=false;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  @override
  void initState() {
    super.initState();
    _selectedGenderUpOption = _genderOptions.first;
    imagePicker = new ImagePickerHandler(this);
    imagePicker.init();
    getProfileData();
  }

  void getProfileData(){
    setState(() {
      isLoading = true;
    });
    getIt.get<AccountStepsDetailRepositoryImpl>().getProfileInfo(loginResponse.data.id).then((value){
      profileInfoModel = value;
      if(addressProofsList.isNotEmpty)
      addressProofsList.clear();
      for(int i = 0; i < profileInfoModel.data.identityProofList.length; i ++){
        addressProofsList.add(profileInfoModel.data.identityProofList[i]);
      }
      _selectedProofTypeTag = addressProofsList.first;
      setSavedProfileData();
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  selectedProfileImage(XFile _image,bool profileImage, bool docImage1, bool docImage2,bool doc3,
      bool docCertificateImage1,bool docCertificateImage2,bool docCertificateImage3) async{
    if(_image == null){
      AppUtils.showToast("Invalid Image!", true);
      return;
    }
    try {
      print("XFile=${_image.path}");
      if(profileImage){
        profileInfoModel.data.profileImage = "";
        _selectedProfileImg = File(_image.path);
        setState(() {
        });
      }
      if(docImage1){
        _selectedImg1 = File(_image.path);
        resultFileImgSize1 = await AppUtils.getFileSize(_selectedImg1.path, 1);
        print("resultFileImgSize1=${resultFileImgSize1}");
        setState(() {
        });
      }
      if(docImage2){
        _selectedImg2 = File(_image.path);
        resultFileImgSize2 = await AppUtils.getFileSize(_selectedImg2.path, 1);
        print("resultFileImgSize2=${resultFileImgSize2}");
        setState(() {
        });
      }
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget builder(BuildContext context) {

    return Scaffold(
      backgroundColor: AppTheme.grayCircle,
      appBar: BaseAppBar(
        callback: (){
          widget.voidCallback();
          Navigator.of(context).pop();
        },
        backgroundColor: AppTheme.white,
        title: Text('My Profile',style: TextStyle(color: Colors.black),),
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark
          ),
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
            onTap: (){
              callProfileApi(gotoProfileStepsScreen: true);
            },
            child: Container(
              child: Center(child: Text("Save",style: TextStyle(color: Colors.black)),),
            ),
          ),
          SizedBox(width: 20,)
        ],
      ),
      body: SafeArea(
        child: isLoading ? AppUtils.showSpinner() : SingleChildScrollView(
            child: Container(
              color: Colors.white,
              width: double.infinity,
              margin: EdgeInsets.only(left: Dimensions.getScaledSize(20),right: Dimensions.getScaledSize(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: (){
                      imagePicker.showDialog(context,profileImage: true,docImage1: false,docImage2: false);
                    },
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: (){

                          },
                          child: profileInfoModel.data.profileImage.isNotEmpty
                              ? showImageFromUrl()
                              : _selectedProfileImg == null
                              ? showImgPlaceholderView()
                              : showUserImgView() ,
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppTheme.white,
                                      width: 3,
                                    ),
                                    shape: BoxShape.circle,
                                    color: AppTheme.primaryColorDark
                                ),
                                width: 30,
                                height: 30,
                                child: Icon(Icons.camera_alt,color: Colors.white,size: 20,)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: Dimensions.getScaledSize(20),
                        top: Dimensions.getScaledSize(20),bottom: Dimensions.getScaledSize(10)
                    ),
                    child: Text(
                      "Personal Detail",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: AppTheme.subHeadingTextColor,
                        fontFamily: AppConstants.fontName,
                      ),
                    ),
                  ),

                  Form(
                    key: _key,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Container(
                      margin: EdgeInsets.only(left: Dimensions.getScaledSize(20),
                          right: Dimensions.getScaledSize(20),
                          bottom: Dimensions.getScaledSize(20)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            enabled:  widget.isComingFromAccount ? false : true,
                            readOnly: widget.isComingFromAccount,
                            controller: firstNameCont,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (val) =>
                            val.isEmpty ? "Please enter your first name!" : null,
                            onFieldSubmitted: (value) {

                            },
                            style: TextStyle(color: AppTheme.mainTextColor),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.borderNotFocusedColor)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.primaryColor)),
                              hintText: "Enter First Name",
                              errorStyle: TextStyle(
                                  fontSize: AppConstants.extraXSmallSize,
                                  fontFamily: AppConstants.fontName),
                              hintStyle: TextStyle(
                                  color: AppTheme.subHeadingTextColor, fontSize: 16),
                              labelStyle: TextStyle(
                                  color: AppTheme.mainTextColor, fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            enabled:  widget.isComingFromAccount ? false : true,
                            readOnly: widget.isComingFromAccount,
                            controller: lastNameCont,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (val) =>
                            val.isEmpty ? "Please enter your last name!" : null,
                            onFieldSubmitted: (value) {

                            },
                            style: TextStyle(color: AppTheme.mainTextColor),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.borderNotFocusedColor)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.primaryColor)),
                              hintText: "Enter Last Name",
                              errorStyle: TextStyle(
                                  fontSize: AppConstants.extraXSmallSize,
                                  fontFamily: AppConstants.fontName),
                              hintStyle: TextStyle(
                                  color: AppTheme.subHeadingTextColor, fontSize: 16),
                              labelStyle: TextStyle(
                                  color: AppTheme.mainTextColor, fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField(
                                  dropdownColor: Colors.white,
                                  items: _genderOptions.map((String category) {
                                    return new DropdownMenuItem(
                                        value: category,
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              category,
                                              style: TextStyle(
                                                  color: AppTheme.mainTextColor,
                                                  fontFamily: AppConstants.fontName,
                                                  fontSize: AppConstants.smallSize),
                                            ),
                                          ],
                                        ));
                                  }).toList(),
                                  onTap: () {},
                                  onChanged: widget.isComingFromAccount
                                      ? null
                                      : (newValue) => setState(() => _selectedGenderUpOption = newValue),
                                  value: _selectedGenderUpOption,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(0),
                                    filled: true,
                                    fillColor: AppTheme.transparent,
                                    focusColor: AppTheme.transparent,
                                    hoverColor: AppTheme.transparent,
                                    labelText: "Gender",
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextFormField(
                                  enabled:  widget.isComingFromAccount ? false : true,
                                  controller: ageCont,
                                  readOnly: true,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: (val) =>
                                  val.isEmpty ? "Please enter your age!" : null,
                                  onTap: () async {
                                    selectedStartDate =
                                    await AppUtils.selectDate(context, isStartIndex: true);
                                    if (selectedStartDate != null) {
                                      String date = DateFormat('yyyy-MM-dd').format(selectedStartDate);
                                      setState(() {
                                        ageCont.text = date;
                                      });
                                    }
                                  },
                                  style: TextStyle(color: AppTheme.mainTextColor),
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppTheme.borderNotFocusedColor)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppTheme.primaryColor)),
                                    hintText: "Age",
                                    errorStyle: TextStyle(
                                        fontSize: AppConstants.extraXSmallSize,
                                        fontFamily: AppConstants.fontName),
                                    hintStyle: TextStyle(
                                        color: AppTheme.subHeadingTextColor, fontSize: 16),
                                    labelStyle: TextStyle(
                                        color: AppTheme.mainTextColor, fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            enabled:  widget.isComingFromAccount ? false : true,
                            readOnly: widget.isComingFromAccount,
                            controller: mobileCont,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.send,
                            validator: (val) =>
                            val.isEmpty ? labelErrorMobileNumber : null,
                            onFieldSubmitted: (value) async {

                            },
                            style: TextStyle(color: AppTheme.mainTextColor),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.borderNotFocusedColor)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.primaryColor)),
                              hintText: labelMobileNumber,
                              errorStyle: TextStyle(
                                  fontSize: AppConstants.extraXSmallSize,
                                  fontFamily: AppConstants.fontName),
                              hintStyle: TextStyle(
                                  color: AppTheme.subHeadingTextColor, fontSize: 14),
                              labelStyle: TextStyle(
                                  color: AppTheme.mainTextColor, fontSize: 14),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          TextFormField(
                            enabled:  widget.isComingFromAccount ? false : true,
                            readOnly: widget.isComingFromAccount,
                            controller: emailCont,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.send,
                            validator: (val) =>
                            val.isEmpty ? labelErrorEmail : null,
                            onFieldSubmitted: (value) async {

                            },
                            style: TextStyle(color: AppTheme.mainTextColor),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.borderNotFocusedColor)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.primaryColor)),
                              hintText: labelErrorEmail,
                              errorStyle: TextStyle(
                                  fontSize: AppConstants.extraXSmallSize,
                                  fontFamily: AppConstants.fontName),
                              hintStyle: TextStyle(
                                  color: AppTheme.subHeadingTextColor, fontSize: 14),
                              labelStyle: TextStyle(
                                  color: AppTheme.mainTextColor, fontSize: 14),
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),

                          Visibility(
                            visible: widget.isComingFromAccount ? true : false,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("About Yourself",),
                                  InkWell(
                                    onTap: (){
                                      openAboutYourSelfDialog();
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit,color: AppTheme.primaryColor,size: 20,),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text("Edit",style: TextStyle(
                                            color: AppTheme.primaryColor,
                                            fontFamily: AppConstants.fontName,
                                            fontWeight: FontWeight.w500
                                        ),)
                                      ],
                                    ),
                                  )
                                ]
                            ),
                          ),

                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: Dimensions.getScaledSize(100),
                            decoration: BoxDecoration(
                              color: AppTheme.grayCircle,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            margin: EdgeInsets.only(top: 0,  bottom: 0),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                              child: TextFormField(
                                //focusNode: _nodeText1,
                                controller: userCommentController,
                                enabled:  widget.isComingFromAccount ? false : true,
                                readOnly: widget.isComingFromAccount,
                                validator: (val) =>
                                val.isEmpty ? labelErrorAboutUs : null,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                textAlign: TextAlign.start,
                                decoration: new InputDecoration.collapsed(
                                  hintText: "About yourself",
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Text(
                              "Identity/Address Proof",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: AppTheme.subHeadingTextColor,
                                fontFamily: AppConstants.fontName,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              spacing: 15,
                              runSpacing: 5,
                              children: addressProofsList.map((tag) {
                                return InkWell(
                                    onTap: () {
                                      if(!widget.isComingFromAccount){
                                        setState(() {
                                          _selectedProofTypeTag = tag;
                                        });
                                      }

                                    },
                                    child: Container(
                                      width: SizeConfig.screenWidth/4.1,
                                      padding: EdgeInsets.only(left: 0, right: 0),
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: _selectedProofTypeTag.toLowerCase() ==
                                            tag.toLowerCase()
                                            ? AppTheme.primaryColor
                                            : AppTheme.grayCircle,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          tag,textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: _selectedProofTypeTag.toLowerCase() ==
                                                  tag.toLowerCase()
                                                  ? AppTheme.white
                                                  : AppTheme.subHeadingTextColor),
                                        ),
                                      ),
                                    ));
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            enabled:  widget.isComingFromAccount ? false : true,
                            readOnly: widget.isComingFromAccount,
                            controller: proofNameCont,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (val) =>
                            val.isEmpty ? "Name (As on selected Id)" : null,
                            onFieldSubmitted: (value) {

                            },
                            style: TextStyle(color: AppTheme.mainTextColor),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.borderNotFocusedColor)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.primaryColor)),
                              hintText: "Name (As on selected Id)",
                              errorStyle: TextStyle(
                                  fontSize: AppConstants.extraXSmallSize,
                                  fontFamily: AppConstants.fontName),
                              hintStyle: TextStyle(
                                  color: AppTheme.subHeadingTextColor, fontSize: 16),
                              labelStyle: TextStyle(
                                  color: AppTheme.mainTextColor, fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            enabled:  widget.isComingFromAccount ? false : true,
                            readOnly: widget.isComingFromAccount,
                            controller: idProofNameCont,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (val) =>
                            val.isEmpty ? "Enter your Id Number(As on selected Id)" : null,
                            onFieldSubmitted: (value) {

                            },
                            style: TextStyle(color: AppTheme.mainTextColor),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.borderNotFocusedColor)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.primaryColor)),
                              hintText: "Enter your Id Number(As on selected Id)",
                              errorStyle: TextStyle(
                                  fontSize: AppConstants.extraXSmallSize,
                                  fontFamily: AppConstants.fontName),
                              hintStyle: TextStyle(
                                  color: AppTheme.subHeadingTextColor, fontSize: 16),
                              labelStyle: TextStyle(
                                  color: AppTheme.mainTextColor, fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              ]
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Visibility(
                                visible: _selectedImg1 == null ? true : false,
                                child: InkWell(
                                  child: DottedBorder(
                                    dashPattern: [3, 3, 3, 3],
                                    strokeWidth: 1,
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(12),
                                    //padding: EdgeInsets.all(6),
                                    color: AppTheme.subHeadingTextColor,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      child: Container(
                                        height: Dimensions.getWidth(percentage: 22),
                                        width: Dimensions.getWidth(percentage: 30),
                                        color: Color(0xffF9F9F9),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.upload_rounded,color: AppTheme.primaryColor,),
                                              Text(
                                                "Upload\nImage 1",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: AppTheme.mainTextColor,
                                                  fontFamily: AppConstants.fontName,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: (){
                                    if(!widget.isComingFromAccount){
                                      imagePicker.showDialog(context,docImage1: true,profileImage: false,docImage2: false);
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Visibility(
                                visible: _selectedImg2 == null ? true : false,
                                child: InkWell(
                                  child: DottedBorder(
                                    dashPattern: [3, 3, 3, 3],
                                    strokeWidth: 1,
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(12),
                                    color: AppTheme.subHeadingTextColor,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      child: Container(
                                        height: Dimensions.getWidth(percentage: 22),
                                        width: Dimensions.getWidth(percentage: 30),
                                        color: Color(0xffF9F9F9),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.upload_rounded,color: AppTheme.primaryColor,),
                                              Text(
                                                "Upload\nImage 2",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: AppTheme.mainTextColor,
                                                  fontFamily: AppConstants.fontName,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: (){
                                    if(!widget.isComingFromAccount){
                                      imagePicker.showDialog(context,docImage2: true,profileImage: false,docImage1: false);
                                    }
                                  },
                                ),
                              ),

                            ],
                          ),
                          showDocListview(),
                          SizedBox(
                            height: 35,
                          ),
                          Visibility(
                            visible: widget.isComingFromAccount ? false : true,
                            child: Container(
                              margin: EdgeInsets.only(left: 30, right: 30,bottom: 20),
                              width: MediaQuery.of(context).size.width,
                              child: GradientElevatedButton(
                                onPressed: () async {
                                  if(this.network.offline){
                                    AppUtils.showToast(AppConstants.noInternetMsg, false);
                                    return;
                                  }
                                  callProfileApi();
                                },
                                //onPressed: validateAndSave(isSubmitPressed: true),
                                buttonText: labelSaveNext,),
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
            )
        ),
      ),
    );
  }

  showImgPlaceholderView() {
    return Container(
      margin: EdgeInsets.only(left: Dimensions.getScaledSize(20),
          top: Dimensions.getScaledSize(20),bottom: Dimensions.getScaledSize(20)),
      width: Dimensions.getScaledSize(80),
      height: Dimensions.getScaledSize(80),
      child: Icon(Icons.person_outline,color: AppTheme.subHeadingTextColor, size: 40,),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.grayCircle),
    );
  }

  showUserImgView() {
    return Container(
      margin: EdgeInsets.only(left: Dimensions.getScaledSize(20),top: Dimensions.getScaledSize(20) ),
      decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.primaryColorDark,
            width: 4,
          ),
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(50)
      ),
      width: 100,height: 100,
      child: ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.all(Radius.circular(80)),
          child: Image.file(_selectedProfileImg,width: 100,height: 100,fit: BoxFit.cover,)
      )
    );
  }

  showImageFromUrl() {

    return Container(
        margin: EdgeInsets.only(left: Dimensions.getScaledSize(20),top: Dimensions.getScaledSize(20) ),
        decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.primaryColorDark,
              width: 4,
            ),
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(50)
        ),
        width: 100,height: 100,
        child: ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.all(Radius.circular(80)),
            child: Image.network(profileInfoModel.data.profileImage,width: 100,height: 100,fit: BoxFit.cover,)
        )
    );
  }

  showDocListview() {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      children: <Widget>[

        Visibility(
          visible: _selectedImg1 != null || _selectedImg2 != null ? true : false,
          child: SizedBox(
            height: 20,
          ),
        ),
        Visibility(
          visible: _selectedImg1 != null ? true : false,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: shadow,
              border: Border.all(
                color: Colors.grey,
                width: 0.5,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: ListTile(
              leading: Container(height: double.infinity,
                  child: Icon(Icons.description_outlined,color: AppTheme.primaryColor,)
              ),
              title: Text(resultFileImgSize1 == null ? "" : profileInfoModel.data.identityProofImage1.isNotEmpty ? "${profileInfoModel.data.identityProofImage1.split('/').last}" : '${_selectedImg1.path.split('/').last}',maxLines: 2,overflow: TextOverflow.ellipsis),
              subtitle: Text(resultFileImgSize1 == null ? "" : '${resultFileImgSize1}'),
              trailing: InkWell(
                onTap: (){
                  if(!widget.isComingFromAccount){
                    setState(() {
                      _selectedImg1 = null;
                      resultFileImgSize1 = null;
                    });
                  }
                },
                child: Icon(Icons.clear),
              ),
              contentPadding: EdgeInsets.only(left: 10,right: 10),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Visibility(
          visible: _selectedImg2 != null ? true : false,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: shadow,
              border: Border.all(
                color: Colors.grey,
                width: 0.5,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 10,right: 10),
              leading: Container(height: double.infinity,
                  child: Icon(Icons.description_outlined,color: AppTheme.primaryColor,)
              ),
              title: Text(resultFileImgSize2 == null ? "" : profileInfoModel.data.identityProofImage2.isNotEmpty ? "${profileInfoModel.data.identityProofImage2.split('/').last}" : '${_selectedImg2.path.split('/').last}',maxLines: 2,overflow: TextOverflow.ellipsis,),
              subtitle: Text(resultFileImgSize2 == null ? "" : '${resultFileImgSize2}'),
              trailing: InkWell(
                onTap: (){
                  if(!widget.isComingFromAccount){
                    setState(() {
                      _selectedImg2 = null;
                      resultFileImgSize2 = null;
                    });
                  }
                },
                child: Icon(Icons.clear),
              ),
            ),
          ),
        ),

      ],
    );
  }

  Future<void> callProfileApi({bool gotoProfileStepsScreen = false}) async {
    final FormState form = _key.currentState;
    if (form.validate()) {
      if(profileInfoModel.data.profileImage.isEmpty){
        if(_selectedProfileImg == null){
          AppUtils.showToast("Please upload your profile picture", false);
          return;
        }
      }

      if(profileInfoModel.data.identityProofImage1.isEmpty && profileInfoModel.data.identityProofImage2.isEmpty){
        if(_selectedImg1 == null && _selectedImg2==null){
          AppUtils.showToast("Please upload atleast one identity proof document", false);
          return;
        }
      }

      AppUtils.showLoader(context);
      BaseResponse baseresponse = await getIt.get<AccountStepsDetailRepositoryImpl>()
          .saveMyProfile(_selectedProfileImg,firstNameCont.text,lastNameCont.text,
          _selectedGenderUpOption,ageCont.text,mobileCont.text,emailCont.text,userCommentController.text,
          proofNameCont.text,idProofNameCont.text,_selectedProofTypeTag,
          selectedDocument1:_selectedImg1,selectedDocument2: _selectedImg2,
          user_id: loginResponse.data.id,
          profile_id: profileInfoModel.data.profileId,profileInfoModel:profileInfoModel);
      AppUtils.hideLoader(context);
      if(baseresponse != null){
        AppUtils.showToast(baseresponse.message, true);
        AppUtils.hideKeyboard(context);
        if(baseresponse.success)
          if(gotoProfileStepsScreen){
            Navigator.of(context).popUntil((route) => route.isFirst);
            widget.voidCallback();
          }else{

            if (!_serviceEnabled) {
              _serviceEnabled = await location.requestService();
              if (!_serviceEnabled) {
                return;
              }
            }

            _permissionGranted = await location.hasPermission();
            if (_permissionGranted == PermissionStatus.denied) {
              _permissionGranted = await location.requestPermission();
              if (_permissionGranted != PermissionStatus.granted) {
                return;
              }
            }
            LocationAccuracy _locationAccuracy = LocationAccuracy.high;
            await location.changeSettings(accuracy: _locationAccuracy);

            _locationData = await location.getLocation();
            LatLng userlocation = LatLng(_locationData.latitude,_locationData.longitude);

            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) => BusinessDetailScreen(userlocation: userlocation,
                voidCallback: (){
                  widget.voidCallback();

                },))
            );
          }

      }
    }
  }

  void setSavedProfileData() {
    firstNameCont.text = profileInfoModel.data.firstName;
    lastNameCont.text = profileInfoModel.data.lastName;
    if(profileInfoModel.data.gender.isNotEmpty){
      _selectedGenderUpOption = profileInfoModel.data.gender;
    }
    ageCont.text =  profileInfoModel.data.dob;
    mobileCont.text =  profileInfoModel.data.phone;
    emailCont.text =  profileInfoModel.data.email;
    userCommentController.text = profileInfoModel.data.aboutYourself;
    if(profileInfoModel.data.identityProof.isNotEmpty){
      _selectedProofTypeTag = profileInfoModel.data.identityProof;
    }
    proofNameCont.text =  profileInfoModel.data.identityProofMentionedName;
    idProofNameCont.text = profileInfoModel.data.identityProofNumber;

    if(profileInfoModel.data.identityProofImage1.isNotEmpty){
      _selectedImg1 = File("");
      resultFileImgSize1 = "";
    }
    if(profileInfoModel.data.identityProofImage2.isNotEmpty){
      _selectedImg2 = File("");
      resultFileImgSize2 = "";
    }

    /*
    _selectedProfileImg = ?
    _selectedImg1 = ?
    _selectedImg2 = ?*/
  }


  void openAboutYourSelfDialog() {

    showDialog(
      context: context,
      builder: (BuildContext context) {

        return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.symmetric(horizontal: 0),
            elevation: 0.0,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 0,right: 0,bottom: 0),
                  decoration: BoxDecoration(
                      boxShadow: shadow,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      color: Colors.white
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              child: Center(
                                child: Text(
                                  "About Yourself",
                                  style: TextStyle(
                                      fontSize: Dimensions.getScaledSize(20),
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.mainTextColor,
                                      fontFamily: AppConstants.fontName),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.clear,color: AppTheme.primaryColor,size: 30,),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Container(
                        height: Dimensions.getScaledSize(130),
                        decoration: BoxDecoration(
                          color: AppTheme.grayCircle,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        margin: EdgeInsets.only(left: 20,right: 20,bottom: 0),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                          child: TextFormField(
                            //focusNode: _nodeText1,
                            controller: userCommentController,
                            validator: (val) =>
                            val.isEmpty ? labelErrorAboutUs : null,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            textAlign: TextAlign.start,
                            decoration: new InputDecoration.collapsed(
                              hintText: "About yourself",
                            ),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 45, right: 45,),
                        width: MediaQuery.of(context).size.width,
                        child: GradientElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          //onPressed: validateAndSave(isSubmitPressed: true),
                          buttonText: labelSave,),
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),

              ],
            ));
      },
    );

  }

}
