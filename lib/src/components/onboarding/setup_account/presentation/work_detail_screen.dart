import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/img_picker/image_picker_handler.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/experience_detail_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/repository/account_steps_detail_repository_impl.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class WorkDetailScreen extends StatefulWidget {

  final VoidCallback voidCallback;
  WorkDetailScreen({@required this.voidCallback});

  @override
  _WorkDetailScreenState createState() {
    return _WorkDetailScreenState();
  }
}

class _WorkDetailScreenState extends BaseState<WorkDetailScreen>  with TickerProviderStateMixin,
    ImagePickerListener {

  final _key = GlobalKey<FormState>();
  bool isLoading = false;
  var experienceCont = TextEditingController();
  var qualificationCont = TextEditingController();
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  File workDoc1, workDoc2, workDoc3, certificateDoc1, certificateDoc2,
      certificateDoc3;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
    getWorkDetailData();
  }

  ExperienceDetailModel experienceDetailModel;

  void getWorkDetailData() {
    setState(() {
      isLoading = true;
    });
    getIt.get<AccountStepsDetailRepositoryImpl>().getExperienceDetail(
        loginResponse.data.id).then((value) {
      experienceDetailModel = value;
      setWorkDetailData();
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
  Widget builder(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grayCircle,
      appBar: BaseAppBar(
        callback: () {
          widget.voidCallback();
          Navigator.of(context).pop();
        },
        backgroundColor: AppTheme.white,
        title: Text('Work Detail', style: TextStyle(color: Colors.black),),
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
            child: Center(
              child: Text("Save", style: TextStyle(color: Colors.black)),),
          ),
          SizedBox(width: 20,)
        ],
      ),
      body: SafeArea(
        child: isLoading ? AppUtils.showSpinner() : SingleChildScrollView(
            child: Container(
              color: Colors.white,
              width: double.infinity,
              margin: EdgeInsets.only(left: Dimensions.getScaledSize(20),
                  right: Dimensions.getScaledSize(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: Dimensions.getScaledSize(20),
                        top: Dimensions.getScaledSize(20),
                        bottom: Dimensions.getScaledSize(10)
                    ),
                    child: Text(
                      "Work experience Detail",
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
                      margin: EdgeInsets.only(
                          left: Dimensions.getScaledSize(25),
                          right: Dimensions.getScaledSize(25),
                          bottom: Dimensions.getScaledSize(20)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: experienceCont,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            validator: (val) =>
                            val.isEmpty ? "Please enter experience!" : null,
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
                              hintText: "Experience in months/years",
                              errorStyle: TextStyle(
                                  fontSize: AppConstants.extraXSmallSize,
                                  fontFamily: AppConstants.fontName),
                              hintStyle: TextStyle(
                                  color: AppTheme.subHeadingTextColor,
                                  fontSize: 16),
                              labelStyle: TextStyle(
                                  color: AppTheme.mainTextColor, fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: qualificationCont,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (val) =>
                            val.isEmpty ? "Please enter qualification" : null,
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
                              hintText: "Enter your qualification",
                              errorStyle: TextStyle(
                                  fontSize: AppConstants.extraXSmallSize,
                                  fontFamily: AppConstants.fontName),
                              hintStyle: TextStyle(
                                  color: AppTheme.subHeadingTextColor,
                                  fontSize: 16),
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
                                    "Work Photographs",
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
                          Visibility(
                            visible: workDoc1 != null && workDoc2 != null && workDoc3 != null ? false : true,
                            child: InkWell(
                              child: DottedBorder(
                                dashPattern: [3, 3, 3, 3],
                                strokeWidth: 1,
                                borderType: BorderType.RRect,
                                radius: Radius.circular(12),
                                //padding: EdgeInsets.all(6),
                                color: AppTheme.subHeadingTextColor,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5)),
                                  child: Container(
                                    height: Dimensions.getWidth(percentage: 22),
                                    width: Dimensions.getWidth(percentage: 30),
                                    color: Color(0xffF9F9F9),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: [
                                          Icon(Icons.upload_rounded,
                                            color: AppTheme.primaryColor,),
                                          Text(
                                            "Upload\nDocument",
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
                                if (workDoc1 == null) {
                                  imagePicker.showDialog(
                                      context,
                                      docImage1: true,
                                      profileImage: false,
                                      docImage2: false,
                                      docImage3: false,
                                      docCertificateImage1: false,
                                      docCertificateImage2: false,
                                      docCertificateImage3: false);
                                }
                                if (workDoc2 == null) {
                                  imagePicker.showDialog(
                                      context, docImage1: false,
                                      profileImage: false,
                                      docImage2: true,
                                      docImage3: false,
                                      docCertificateImage1: false,
                                      docCertificateImage2: false,
                                      docCertificateImage3: false);
                                }
                                if (workDoc3 == null) {
                                  imagePicker.showDialog(
                                      context, docImage1: false,
                                      profileImage: false,
                                      docImage2: false,
                                      docImage3: true,
                                      docCertificateImage1: false,
                                      docCertificateImage2: false,
                                      docCertificateImage3: false);
                                }
                              },
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          showWorkPhotoGraphsList(),

                          SizedBox(
                            height: 20,
                          ),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    "Certificates/awards",
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
                          Visibility(
                            visible: certificateDoc1 != null &&  certificateDoc2 != null && certificateDoc3 != null ? false : true,
                            child: InkWell(
                              child: DottedBorder(
                                dashPattern: [3, 3, 3, 3],
                                strokeWidth: 1,
                                borderType: BorderType.RRect,
                                radius: Radius.circular(12),
                                //padding: EdgeInsets.all(6),
                                color: AppTheme.subHeadingTextColor,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5)),
                                  child: Container(
                                    height: Dimensions.getWidth(percentage: 22),
                                    width: Dimensions.getWidth(percentage: 30),
                                    color: Color(0xffF9F9F9),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: [
                                          Icon(Icons.upload_rounded,
                                            color: AppTheme.primaryColor,),
                                          Text(
                                            "Upload\nDocument",
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
                                if (certificateDoc1 == null) {
                                  imagePicker.showDialog(
                                      context, docImage1: false,
                                      profileImage: false,
                                      docImage2: false,
                                      docImage3: false,
                                      docCertificateImage1: true,
                                      docCertificateImage2: false,
                                      docCertificateImage3: false);
                                }
                                if (certificateDoc2 == null) {
                                  imagePicker.showDialog(
                                      context, docImage1: false,
                                      profileImage: false,
                                      docImage2: false,
                                      docImage3: false,
                                      docCertificateImage1: false,
                                      docCertificateImage2: true,
                                      docCertificateImage3: false);
                                }
                                if (certificateDoc3 == null) {
                                  imagePicker.showDialog(
                                      context, docImage1: false,
                                      profileImage: false,
                                      docImage2: false,
                                      docImage3: false,
                                      docCertificateImage1: false,
                                      docCertificateImage2: false,
                                      docCertificateImage3: true);
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          showCertificatesAwardsList(),

                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 30, right: 30, bottom: 20),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: GradientElevatedButton(
                              onPressed: () async {
                                callApi();
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


  @override
  selectedProfileImage(XFile _image, bool profileImage,
      bool docImage1, bool docImage2, bool doc3,
      bool docCertificateImage1,bool docCertificateImage2,bool docCertificateImage3) async {
    try {
      if (_image == null) {
        AppUtils.showToast("Invalid Image!", true);
        return;
      }
      print("XFile=${_image.path}"
          "docImage1=${docImage1}"
          "docImage2=${docImage2}"
          "docImage3=${doc3} "
          "docCertificateImage1=${docCertificateImage1} "
          "docCertificateImage2=${docCertificateImage2} "
          "docCertificateImage3=${docCertificateImage3}");
      if (docImage1) {
        File file = File(_image.path);
        var fileSize = await AppUtils.getFileSize(file.path, 1);
        workDoc1 = file;
        setState(() {});
      }
      if (docImage2) {
        File file = File(_image.path);
        var fileSize = await AppUtils.getFileSize(file.path, 1);
        workDoc2 = file;
        setState(() {});
      }
      if (doc3) {
        File file = File(_image.path);
        var fileSize = await AppUtils.getFileSize(file.path, 1);
        workDoc3 = file;
        setState(() {});
      }

      if (docCertificateImage1) {
        File file = File(_image.path);
        var fileSize = await AppUtils.getFileSize(file.path, 1);
        certificateDoc1 = file;
        setState(() {});
      }
      if (docCertificateImage2) {
        File file = File(_image.path);
        var fileSize = await AppUtils.getFileSize(file.path, 1);
        certificateDoc2 = file;
        setState(() {});
      }
      if (docCertificateImage3) {
        File file = File(_image.path);
        var fileSize = await AppUtils.getFileSize(file.path, 1);
        certificateDoc3 = file;
        setState(() {});
      }

    } catch (e) {
      print(e);
    }
  }


  showWorkPhotoGraphsList() {
    return Column(
      children: [
        Visibility(
          visible: workDoc1 != null ? true : false,
          child: Container(
            margin: EdgeInsets.only(top: Dimensions.getScaledSize(10)),
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
                  child: Icon(
                    Icons.description_outlined, color: AppTheme.primaryColor,)
              ),
              title: Text(workDoc1 == null || workDoc1.path.isEmpty ? "" : workDoc1.path.split('/').last ,
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Text("N/A"),
              trailing: InkWell(
                onTap: () {
                  setState(() {
                    workDoc1 = null;
                    //workPhotographsDocList.removeAt(index);
                  });
                },
                child: Icon(Icons.clear),
              ),
              contentPadding: EdgeInsets.only(left: 10, right: 10),
            ),
          ),
        ),
        Visibility(
          visible: workDoc2 != null ? true : false,
          child: Container(
            margin: EdgeInsets.only(top: Dimensions.getScaledSize(10)),
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
                  child: Icon(
                    Icons.description_outlined, color: AppTheme.primaryColor,)
              ),
              title: Text(workDoc2 == null || workDoc2.path.isEmpty ? "" : workDoc2.path.split("/").last, maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Text("N/A"),
              trailing: InkWell(
                onTap: () {
                  setState(() {
                    workDoc2= null;
                    //workPhotographsDocList.removeAt(index);
                  });
                },
                child: Icon(Icons.clear),
              ),
              contentPadding: EdgeInsets.only(left: 10, right: 10),
            ),
          ),
        ),
        Visibility(
          visible: workDoc3 != null ? true : false,
          child: Container(
            margin: EdgeInsets.only(top: Dimensions.getScaledSize(10)),
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
                  child: Icon(
                    Icons.description_outlined, color: AppTheme.primaryColor,)
              ),
              title: Text(workDoc3 == null || workDoc3.path.isEmpty ? "" : workDoc3.path.split("/").last, maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Text("N/A"),
              trailing: InkWell(
                onTap: () {
                  setState(() {
                    workDoc3 = null;
                    //workPhotographsDocList.removeAt(index);
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

  showCertificatesAwardsList() {
    return Column(
      children: [
        Visibility(
          visible: certificateDoc1 != null ? true : false,
          child: Container(
            margin: EdgeInsets.only(top: Dimensions.getScaledSize(10)),
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
                  child: Icon(
                    Icons.description_outlined, color: AppTheme.primaryColor,)
              ),
              title: Text(certificateDoc1 == null || certificateDoc1.path.isEmpty ? "" : certificateDoc1.path.split('/').last, maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Text("N/A"),
              trailing: InkWell(
                onTap: () {
                  setState(() {
                    certificateDoc1 = null;
                    //workPhotographsDocList.removeAt(index);
                  });
                },
                child: Icon(Icons.clear),
              ),
              contentPadding: EdgeInsets.only(left: 10, right: 10),
            ),
          ),
        ),
        Visibility(
          visible: certificateDoc2 != null ? true : false,
          child: Container(
            margin: EdgeInsets.only(top: Dimensions.getScaledSize(10)),
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
                  child: Icon(
                    Icons.description_outlined, color: AppTheme.primaryColor,)
              ),
              title: Text(certificateDoc2 == null || certificateDoc2.path.isEmpty ? "" : certificateDoc2.path.split('/').last, maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Text("N/A"),
              trailing: InkWell(
                onTap: () {
                  setState(() {
                    certificateDoc2 = null;
                    //workPhotographsDocList.removeAt(index);
                  });
                },
                child: Icon(Icons.clear),
              ),
              contentPadding: EdgeInsets.only(left: 10, right: 10),
            ),
          ),
        ),
        Visibility(
          visible: certificateDoc3 != null ? true : false,
          child: Container(
            margin: EdgeInsets.only(top: Dimensions.getScaledSize(10)),
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
                  child: Icon(
                    Icons.description_outlined, color: AppTheme.primaryColor,)
              ),
              title: Text(certificateDoc3 == null || certificateDoc3.path.isEmpty ? "" : certificateDoc3.path.split('/').last, maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Text("N/A"),
              trailing: InkWell(
                onTap: () {
                  setState(() {
                    certificateDoc3 = null;
                    //workPhotographsDocList.removeAt(index);
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

  Future<void> callApi() async {
    if (this.network.offline) {
      AppUtils.showToast(AppConstants.noInternetMsg, false);
      return;
    }

    final FormState form = _key.currentState;
    if (form.validate()) {
      if(workDoc1 == null && workDoc2 == null && workDoc3 == null){
        AppUtils.showToast("Please upload atleast one work photo document", true);
        return;
      }
      if(certificateDoc1 == null && certificateDoc2 == null && certificateDoc3 == null){
        AppUtils.showToast("Please upload atleast one certificates or award document", true);
        return;
      }
      //AppUtils.showLoader(context);

       BaseResponse baseresponse = await getIt.get<AccountStepsDetailRepositoryImpl>()
          .saveWorkDetail(userId:loginResponse.data.id,experienceId: experienceDetailModel.data.experienceId,
          workExperience: experienceCont.text,qualification: qualificationCont.text,
          experienceDetailModel: experienceDetailModel,
           workDoc1: workDoc1,
           workDoc2: workDoc2,
           workDoc3: workDoc3,
           certificateDoc1:certificateDoc1,
           certificateDoc2: certificateDoc2,
           certificateDoc3: certificateDoc3);

      if(baseresponse != null){
        AppUtils.showToast(baseresponse.message, true);
        AppUtils.hideKeyboard(context);
      AppUtils.hideLoader(context);


      }
    }
  }

  void setWorkDetailData() {
    experienceCont.text = experienceDetailModel.data.experience;
    qualificationCont.text = experienceDetailModel.data.qualifications;

    if (experienceDetailModel.data.workPhotographImage1.isNotEmpty) {
      workDoc1 = File("");
    }
    if (experienceDetailModel.data.workPhotographImage2.isNotEmpty) {
      workDoc2 = File("");
    }
    if (experienceDetailModel.data.workPhotographImage3.isNotEmpty) {
      workDoc3 = File("");
    }

    if (experienceDetailModel.data.certificateImage1.isNotEmpty) {
      certificateDoc1 = File("");
    }
    if (experienceDetailModel.data.certificateImage2.isNotEmpty) {
      certificateDoc2 = File("");
    }
    if (experienceDetailModel.data.certificateImage3.isNotEmpty) {
      certificateDoc3 = File("");
    }
    setState(() {
    });
  }
}
