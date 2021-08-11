import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/img_picker/image_picker_handler.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/business_detail_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/repository/account_steps_detail_repository_impl.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';
import 'widgets/google_map.dart';

class BusinessDetailScreen extends StatefulWidget {

  final VoidCallback voidCallback;
  BusinessDetailScreen({@required this.voidCallback});

  @override
  _BusinessDetailScreenState createState() {
    return _BusinessDetailScreenState();
  }
}

class _BusinessDetailScreenState extends BaseState<BusinessDetailScreen> with TickerProviderStateMixin,
    ImagePickerListener{

  bool isLoading = false;
  BusinessDetailModel businessDetailModel;
  final _key = GlobalKey<FormState>();
  var businessNameCont = TextEditingController();
  var stateCont = TextEditingController();
  var pinCodeCont = TextEditingController();
  var cityCont = TextEditingController();
  var addressCont= TextEditingController();
  List<String> workLocationList = [];
  String _selectedWorkLocationTag;
  String _selectedProofTypeTag;
  var idProofNumberCont= TextEditingController();
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  File _selectedDocument;
  var docFileSize;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = new ImagePickerHandler(this,_controller);
    imagePicker.init();
    setState(() {
      isLoading = true;
    });
    getIt.get<AccountStepsDetailRepositoryImpl>().getBusinessDetail(loginResponse.data.id).then((value){
      businessDetailModel = value;
      workLocationList = businessDetailModel.data.serviceType;
      _selectedWorkLocationTag = workLocationList.first;
      _selectedProofTypeTag = businessDetailModel.data.businessIdentityProofList.first;
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
  selectedProfileImage(XFile _image,bool profileImage, bool docImage1, bool docImage2) async{
    if(_image == null){
      AppUtils.showToast("Invalid Image!", true);
      return;
    }
    try {
      print("XFile=${_image.path}");
      print("XFile=${_image.path}");
      if(profileImage){
        _selectedDocument = File(_image.path);
        docFileSize = await AppUtils.getFileSize(_selectedDocument.path, 1);
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
        title: Text('Business Detail',style: TextStyle(color: Colors.black),),
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
          Container(
            child: Center(child: Text("Save",style: TextStyle(color: Colors.black)),),
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
                  Container(
                    margin: EdgeInsets.only(left: Dimensions.getScaledSize(20),
                        top: Dimensions.getScaledSize(20),bottom: Dimensions.getScaledSize(10)
                    ),
                    child: Text(
                      "Business Detail",
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
                      margin: EdgeInsets.only(bottom: Dimensions.getScaledSize(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: Dimensions.getScaledSize(20),
                                right: Dimensions.getScaledSize(20),
                                bottom: Dimensions.getScaledSize(20)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: businessNameCont,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: (val) =>
                                  val.isEmpty ? "Please enter business name!" : null,
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
                                    hintText: "Enter Business Name",
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
                                      child: TextFormField(
                                        controller: stateCont,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        validator: (val) =>
                                        val.isEmpty ? "Please enter your state!" : null,
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
                                          hintText: "Enter State",
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
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: pinCodeCont,
                                        readOnly: true,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        validator: (val) =>
                                        val.isEmpty ? "Please enter your pincode!" : null,
                                        onTap: () async {

                                        },
                                        style: TextStyle(color: AppTheme.mainTextColor),
                                        decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppTheme.borderNotFocusedColor)),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppTheme.primaryColor)),
                                          hintText: "Pincode",
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
                                  controller: cityCont,
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
                                    hintText: "Enter City",
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
                                  controller: addressCont,
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
                                    hintText: "Enter Address",
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
                                Container(
                                  child: DropdownButtonFormField(
                                    dropdownColor: Colors.white,
                                    items: workLocationList.map((String category) {
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
                                    onChanged: (newValue) {
                                      // do other stuff with _category
                                      setState(() => _selectedWorkLocationTag = newValue);
                                    },
                                    value: _selectedWorkLocationTag,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(0),
                                      filled: true,
                                      fillColor: AppTheme.transparent,
                                      focusColor: AppTheme.transparent,
                                      hoverColor: AppTheme.transparent,
                                      labelText: "I would like to work at",
                                      labelStyle: TextStyle(fontSize: 16,color: AppTheme.subHeadingTextColor)
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 0,top: 10,bottom: 0 ),
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
                            child: GoogleMapScreen()
                          ),

                          Container(
                            margin: EdgeInsets.only(left: Dimensions.getScaledSize(20),
                                top: Dimensions.getScaledSize(30)
                            ),
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
                              children: businessDetailModel.data.businessIdentityProofList.map((tag) {
                                return InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedProofTypeTag = tag;
                                      });
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
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: TextFormField(
                              controller: idProofNumberCont,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                              val.isEmpty ? "Enter your ${_selectedProofTypeTag}" : null,
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
                                hintText: "Enter ${_selectedProofTypeTag}",
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

                          Container(
                            margin: EdgeInsets.only(left: Dimensions.getScaledSize(20),
                                right: Dimensions.getScaledSize(30),top: 10
                            ),
                            child: Row(
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
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: Dimensions.getScaledSize(20),
                                right: Dimensions.getScaledSize(30),top: 10
                            ),
                            child: Visibility(
                              visible: _selectedDocument == null ? true : false,
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
                                      height: Dimensions.getWidth(percentage: 25),
                                      width: Dimensions.getWidth(percentage: 35),
                                      color: Color(0xffF9F9F9),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.upload_rounded,color: AppTheme.primaryColor,),
                                            Text(
                                              "Upload\n${_selectedProofTypeTag} Document",
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
                                  imagePicker.showDialog(context, profileImage: true, docImage1: false, docImage2: false);
                                },
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(left: Dimensions.getScaledSize(20),
                                right: Dimensions.getScaledSize(30),top: 10
                            ),
                            child: Visibility(
                              visible: _selectedDocument != null ? true : false,
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
                                  title: Text(_selectedDocument == null ? "" : '${_selectedDocument.path.split('/').last}',
                                      maxLines: 2,overflow: TextOverflow.ellipsis),
                                  subtitle: Text(docFileSize == null ? "" : '${docFileSize}'),
                                  trailing: InkWell(
                                    onTap: (){
                                      setState(() {
                                        _selectedDocument = null;
                                      });
                                    },
                                    child: Icon(Icons.clear),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 10,right: 10),
                                ),
                              ),
                            ),
                          ),


                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 30, right: 30,bottom: 20),
                            width: MediaQuery.of(context).size.width,
                            child: GradientElevatedButton(
                              onPressed: () async {
                                if(this.network.offline){
                                  AppUtils.showToast(AppConstants.noInternetMsg, false);
                                  return;
                                }
                              },
                              //onPressed: validateAndSave(isSubmitPressed: true),
                              buttonText: labelSaveNext,),
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
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}