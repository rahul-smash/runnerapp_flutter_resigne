import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/img_picker/image_picker_handler.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/work_detail_document_model.dart';
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
    ImagePickerListener{

  final _key = GlobalKey<FormState>();
  bool isLoading = false;
  var experienceCont = TextEditingController();
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  List<WorkDetailDocumentModel> workPhotographsDocList = [];
  List<WorkDetailDocumentModel> certificatesAwardsDocList = [];

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = new ImagePickerHandler(this,_controller);
    imagePicker.init();
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
        callback: (){
          widget.voidCallback();
          Navigator.of(context).pop();
        },
        backgroundColor: AppTheme.white,
        title: Text('Work Detail',style: TextStyle(color: Colors.black),),
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
                      margin: EdgeInsets.only(left: Dimensions.getScaledSize(25),
                          right: Dimensions.getScaledSize(25),
                          bottom: Dimensions.getScaledSize(20)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: experienceCont,
                            keyboardType: TextInputType.text,
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
                                  color: AppTheme.subHeadingTextColor, fontSize: 16),
                              labelStyle: TextStyle(
                                  color: AppTheme.mainTextColor, fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: experienceCont,
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
                                  color: AppTheme.subHeadingTextColor, fontSize: 16),
                              labelStyle: TextStyle(
                                  color: AppTheme.mainTextColor, fontSize: 16),
                            ),
                          ),

                          SizedBox(
                            height:30,
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
                            visible: workPhotographsDocList.length > 3 ? false : true,
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
                              onTap: (){
                                imagePicker.showDialog(context,docImage1: true, profileImage: false,docImage2: false);
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
                            visible: certificatesAwardsDocList.length > 3 ? false : true,
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
                              onTap: (){
                                imagePicker.showDialog(context,docImage1: false,profileImage: false,docImage2:true);
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
                            margin: EdgeInsets.only(left: 30, right: 30,bottom: 20),
                            width: MediaQuery.of(context).size.width,
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
    );;
  }

  void callApi() {}

  @override
  selectedProfileImage(XFile _image, bool profileImage, bool docImage1, bool docImage2) async {
    try {
      if(_image == null){
            AppUtils.showToast("Invalid Image!", true);
            return;
          }
      print("XFile=${_image.path} and ${docImage1}");
      if(docImage1){
        File file  = File(_image.path);
        var fileSize = await AppUtils.getFileSize(file.path, 1);
        workPhotographsDocList.add(WorkDetailDocumentModel(file,fileSize));
        setState(() {
        });
      }
      if(docImage2){
        File file  = File(_image.path);
        var fileSize = await AppUtils.getFileSize(file.path, 1);
        certificatesAwardsDocList.add(WorkDetailDocumentModel(file,fileSize));
        setState(() {
        });
      }
    } catch (e) {
      print(e);
    }
  }

  showWorkPhotoGraphsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: workPhotographsDocList.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context,index){
        WorkDetailDocumentModel workDetailDocumentModel = workPhotographsDocList[index];
        File file = workDetailDocumentModel.file;
        return Container(
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
                child: Icon(Icons.description_outlined,color: AppTheme.primaryColor,)
            ),
            title: Text(file == null ? "" : '${file.path.split('/').last}',maxLines: 2,overflow: TextOverflow.ellipsis),
            subtitle: Text("${workDetailDocumentModel.fileSize}"),
            trailing: InkWell(
              onTap: (){
                setState(() {

                });
              },
              child: Icon(Icons.clear),
            ),
            contentPadding: EdgeInsets.only(left: 10,right: 10),
          ),
        );
      },
    );
  }

  showCertificatesAwardsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: certificatesAwardsDocList.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context,index){
        WorkDetailDocumentModel workDetailDocumentModel = certificatesAwardsDocList[index];
        File file = workDetailDocumentModel.file;
        return Container(
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
                child: Icon(Icons.description_outlined,color: AppTheme.primaryColor,)
            ),
            title: Text(file == null ? "" : '${file.path.split('/').last}',maxLines: 2,overflow: TextOverflow.ellipsis),
            subtitle: Text("${workDetailDocumentModel.fileSize}"),
            trailing: InkWell(
              onTap: (){
                setState(() {

                });
              },
              child: Icon(Icons.clear),
            ),
            contentPadding: EdgeInsets.only(left: 10,right: 10),
          ),
        );
      },
    );
  }

}