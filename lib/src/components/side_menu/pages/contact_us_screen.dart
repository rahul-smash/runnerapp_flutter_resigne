import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/dashboard_pages/home_screen.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/dashboard_screen.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/img_picker/image_picker_handler.dart';
import 'package:marketplace_service_provider/src/components/side_menu/repository/menu_option_repository_impl.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';

class ContactUsScreen extends StatefulWidget {
  ContactUsScreen();

  @override
  _ContactUsScreenState createState() {
    return _ContactUsScreenState();
  }
}

class _ContactUsScreenState extends BaseState<ContactUsScreen>
    with ImagePickerListener {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileNameController = TextEditingController();
  TextEditingController emailNameController = TextEditingController();
  TextEditingController messagetNameController = TextEditingController();
  List<String> contactUsOptionsList = ["Option 1", "Option 2"];
  String _selectedContactUsOption;
  File _selectedImg1;
  var resultFileImgSize1;
  ImagePickerHandler imagePicker;

  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePickerHandler(this);
    imagePicker.init();
    // contactUsOptionsList =
    //     VersionApiSingleton.instance.storeResponse.brand.contactusOptions;
    // _selectedContactUsOption = contactUsOptionsList?.first;
  }

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
    mobileNameController.dispose();
    emailNameController.dispose();
    messagetNameController.dispose();
  }

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grayCircle,
      appBar: BaseAppBar(
        callback: () {
          Navigator.of(context).pop();
        },
        backgroundColor: AppTheme.white,
        title: Text(
          'Contact Us',
          style: TextStyle(color: Colors.black),
        ),
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
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
        widgets: <Widget>[],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: fullNameController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: (val) =>
                      val.isEmpty ? "Please enter your first name!" : null,
                  onFieldSubmitted: (value) {},
                  style: TextStyle(color: AppTheme.mainTextColor),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppTheme.borderNotFocusedColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.primaryColor)),
                    hintText: "Enter First Name",
                    errorStyle: TextStyle(
                        fontSize: AppConstants.extraXSmallSize,
                        fontFamily: AppConstants.fontName),
                    hintStyle: TextStyle(
                        color: AppTheme.subHeadingTextColor, fontSize: 16),
                    labelStyle:
                        TextStyle(color: AppTheme.mainTextColor, fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: mobileNameController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (val) =>
                      val.isEmpty ? "Please enter your mobile number" : null,
                  onFieldSubmitted: (value) {},
                  style: TextStyle(color: AppTheme.mainTextColor),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppTheme.borderNotFocusedColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.primaryColor)),
                    hintText: "Enter Mobile Number",
                    errorStyle: TextStyle(
                        fontSize: AppConstants.extraXSmallSize,
                        fontFamily: AppConstants.fontName),
                    hintStyle: TextStyle(
                        color: AppTheme.subHeadingTextColor, fontSize: 16),
                    labelStyle:
                        TextStyle(color: AppTheme.mainTextColor, fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailNameController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.send,
                  validator: (val) => val.isEmpty ? labelErrorEmail : null,
                  onFieldSubmitted: (value) async {},
                  style: TextStyle(color: AppTheme.mainTextColor),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppTheme.borderNotFocusedColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.primaryColor)),
                    hintText: labelErrorEmail,
                    errorStyle: TextStyle(
                        fontSize: AppConstants.extraXSmallSize,
                        fontFamily: AppConstants.fontName),
                    hintStyle: TextStyle(
                        color: AppTheme.subHeadingTextColor, fontSize: 14),
                    labelStyle:
                        TextStyle(color: AppTheme.mainTextColor, fontSize: 14),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: DropdownButtonFormField(
                    dropdownColor: Colors.white,
                    items: contactUsOptionsList.map((String category) {
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
                    onChanged: (newValue) =>
                        setState(() => _selectedContactUsOption = newValue),
                    value: _selectedContactUsOption,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      filled: true,
                      fillColor: AppTheme.transparent,
                      focusColor: AppTheme.transparent,
                      hoverColor: AppTheme.transparent,
                      labelText: "Choose Option",
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Description",
                      ),
                    ]),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: Dimensions.getScaledSize(130),
                  decoration: BoxDecoration(
                    color: AppTheme.grayCircle,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  margin: EdgeInsets.only(top: 0, bottom: 0),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                    child: TextFormField(
                      //focusNode: _nodeText1,
                      controller: messagetNameController,
                      validator: (val) =>
                          val.isEmpty ? labelErrorAboutUs : null,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      textAlign: TextAlign.start,
                      decoration: new InputDecoration.collapsed(
                        hintText: "Write here",
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
                    ]),
                SizedBox(
                  height: 20,
                ),
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
                                Icon(
                                  Icons.upload_rounded,
                                  color: AppTheme.primaryColor,
                                ),
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
                    onTap: () {
                      imagePicker.showDialog(context,
                          docImage1: true,
                          profileImage: false,
                          docImage2: false);
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                showDocListview(),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 20, 10),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: AppTheme.primaryColor)),
                    child: Text('Send Your Message'),
                    color: AppTheme.primaryColor,
                    textColor: Colors.white,
                    onPressed: () async {
                      if (this.network.offline) {
                        AppUtils.showToast("No Internet connection!", true);
                        return;
                      }
                      if (fullNameController.text.trim().isEmpty) {
                        AppUtils.showToast("Please enter first name", true);
                        return;
                      }
                      if (mobileNameController.text.trim().isEmpty) {
                        AppUtils.showToast("Please enter mobile number", true);
                        return;
                      }
                      if (emailNameController.text.isEmpty) {
                        AppUtils.showToast("Please enter email", true);
                        return;
                      }
                      if (!AppUtils.validateEmail(
                          emailNameController.text.trim())) {
                        AppUtils.showToast("Please enter valid email", true);
                        return;
                      }
                      if (messagetNameController.text.isEmpty) {
                        AppUtils.showToast("Please enter description", true);
                        return;
                      }
                      AppUtils.showLoader(context);
                      BaseResponse baseresponse = await getIt
                          .get<MenuOptionRepositoryImpl>()
                          .sendContactUsData(
                              name: fullNameController.text,
                              phoneNumber: mobileNameController.text,
                              email: emailNameController.text,
                              desc: messagetNameController.text,
                              img1: _selectedImg1,
                              user_id: userId);
                      AppUtils.hideLoader(context);
                      AppUtils.showToast(baseresponse.message, true);
                      AppUtils.hideKeyboard(context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashboardScreen()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  selectedProfileImage(
      XFile _image,
      bool profileImage,
      bool docImage1,
      bool docImage2,
      bool docImage3,
      bool docCertificateImage1,
      bool docCertificateImage2,
      bool docCertificateImage3) async {
    try {
      if (_image == null) {
        AppUtils.showToast("Invalid Image!", true);
        return;
      }
      if (docImage1) {
        _selectedImg1 = File(_image.path);
        resultFileImgSize1 = await AppUtils.getFileSize(_selectedImg1.path, 1);
        print("resultFileImgSize1=${resultFileImgSize1}");
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  showDocListview() {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      children: <Widget>[
        Visibility(
          visible: _selectedImg1 != null ? true : false,
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
              leading: Container(
                  height: double.infinity,
                  child: Icon(
                    Icons.description_outlined,
                    color: AppTheme.primaryColor,
                  )),
              title: Text(
                  _selectedImg1 == null
                      ? ""
                      : "${_selectedImg1.path.split('/').last}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              subtitle: Text(
                  resultFileImgSize1 == null ? "" : '${resultFileImgSize1}'),
              trailing: InkWell(
                onTap: () {
                  setState(() {
                    _selectedImg1 = null;
                    resultFileImgSize1 = null;
                  });
                },
                child: Icon(Icons.clear),
              ),
              contentPadding: EdgeInsets.only(left: 10, right: 10),
            ),
          ),
        ),
      ],
    );
  }
}
