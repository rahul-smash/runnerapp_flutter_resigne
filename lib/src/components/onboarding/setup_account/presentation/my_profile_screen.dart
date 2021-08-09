import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/src/singleton/versio_api_singleton.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class MyProfileScreen extends StatefulWidget {

  MyProfileScreen();

  @override
  _MyProfileScreenState createState() {
    return _MyProfileScreenState();
  }
}

class _MyProfileScreenState extends BaseState<MyProfileScreen> {

  final _key = GlobalKey<FormState>();
  TextEditingController nameCont = TextEditingController();
  TextEditingController ageCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  List<String> _genderOptions = ["Male","Female"];
  String _selectedGenderUpOption = labelSignUpAs;
  DateTime selectedStartDate;
  List<String> addressProofsList = [];
  String _selectedTag;

  var _isDefaultAddress = false;

  var userCommentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedGenderUpOption = _genderOptions.first;
    addressProofsList.add('Aadhaar');
    addressProofsList.add('Driving Licence');
    addressProofsList.add('Voter Id');
    _selectedTag = addressProofsList.first;
  }

  @override
  Widget builder(BuildContext context) {

    return Scaffold(
      backgroundColor: AppTheme.grayCircle,
      appBar: BaseAppBar(
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
        Container(
          child: Center(child: Text("Save",style: TextStyle(color: Colors.black)),),
        ),
        SizedBox(width: 20,)
      ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            width: double.infinity,
            margin: EdgeInsets.only(left: Dimensions.getScaledSize(20),right: Dimensions.getScaledSize(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: Dimensions.getScaledSize(20),
                      top: Dimensions.getScaledSize(20),bottom: Dimensions.getScaledSize(20)
                  ),
                  width: Dimensions.getScaledSize(80),
                  height: Dimensions.getScaledSize(80),
                  child: Icon(Icons.person_outline,color: AppTheme.subHeadingTextColor, size: 40,),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.grayCircle),
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
                          controller: nameCont,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (val) =>
                          val.isEmpty ? "Please enter your name!" : null,
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
                            hintText: "Enter Name",
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
                                onChanged: (newValue) {
                                  // do other stuff with _category
                                  setState(() => _selectedGenderUpOption = newValue);
                                },
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
                        Container(
                          height: Dimensions.getScaledSize(100),
                          decoration: BoxDecoration(
                            color: AppTheme.grayCircle,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          margin: EdgeInsets.only(top: 0,  bottom: 0),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                            child: TextField(
                              //focusNode: _nodeText1,
                              controller: userCommentController,
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
                            children: addressProofsList.map((tag) {
                              return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedTag = tag;
                                    });
                                  },
                                  child: Container(
                                    width: SizeConfig.screenWidth/4.1,
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: _selectedTag.toLowerCase() ==
                                          tag.toLowerCase()
                                          ? AppTheme.primaryColor
                                          : AppTheme.grayCircle,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        tag,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: _selectedTag.toLowerCase() ==
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
                          controller: nameCont,
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
                          controller: nameCont,
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
                            DottedBorder(
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
                            SizedBox(
                              width: 20,
                            ),
                            DottedBorder(
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
                          ],
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 30, right: 30,bottom: 20),
                          width: MediaQuery.of(context).size.width,
                          child: GradientElevatedButton(
                            onPressed: () async {

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