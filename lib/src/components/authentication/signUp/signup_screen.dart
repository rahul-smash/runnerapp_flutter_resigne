import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:marketplace_service_provider/src/components/authentication/resetMPIN/reset_mpin_screen.dart';
import 'package:marketplace_service_provider/src/components/authentication/signUp/registration_complete_screen.dart';
import 'package:marketplace_service_provider/src/singleton/store_data_singleton.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends BaseState<SignUpScreen> {
  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController otpCont = TextEditingController();
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode signUpAsFocusNode = FocusNode();
  FocusNode mobileFocusNode = FocusNode();
  FocusNode otpFocusNode = FocusNode();

  bool isTermAndConditionSelected = false;
  List<String> _signUpOptions = List.empty(growable: true);

  String _selectedSignUpOption = labelSignUpAs;

  bool errorEnable = false;
  final _fistNameKey = GlobalKey<FormState>();
  final _lastNameKey = GlobalKey<FormState>();
  final _mobileNumberKey = GlobalKey<FormState>();
  final _otpNumberKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _signUpOptions = StoreDataSingleton.instance.storeData.brand.signupAs;
    _selectedSignUpOption =
        StoreDataSingleton.instance.storeData.brand.signupAs.first;
  }

  @override
  void dispose() {
    super.dispose();
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    signUpAsFocusNode.dispose();
    mobileFocusNode.dispose();
    otpFocusNode.dispose();
  }

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  AppImages.login_sign_up_bg,
                ),
                fit: BoxFit.fill),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 26, right: 26),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 60, bottom: 60),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Image(
                        image: AssetImage(AppImages.sign_up_graphic),
                        height: 120,
                        width: 120,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      labelWelcomeTitle,
                      style: TextStyle(
                          color: AppTheme.mainTextColor,
                          fontSize: AppConstants.extraLargeSize,
                          fontFamily: AppConstants.fontName,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      labelDummyText,
                      style: TextStyle(
                          color: AppTheme.subHeadingTextColor,
                          fontSize: AppConstants.extraSmallSize,
                          fontFamily: AppConstants.fontName,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _fistNameKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      controller: firstNameCont,
                      focusNode: firstNameFocusNode,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (val) =>
                          val.isEmpty ? labelErrorFirstName : null,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(lastNameFocusNode);
                      },
                      style: TextStyle(color: AppTheme.mainTextColor),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.borderNotFocusedColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.borderOnFocusedColor)),
                        hintText: labelFirstName,
                        errorStyle: TextStyle(
                            fontSize: AppConstants.extraXSmallSize,
                            fontFamily: AppConstants.fontName),
                        hintStyle: TextStyle(
                            color: AppTheme.subHeadingTextColor, fontSize: 14),
                        labelStyle: TextStyle(
                            color: AppTheme.mainTextColor, fontSize: 14),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _lastNameKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      controller: lastNameCont,
                      focusNode: lastNameFocusNode,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (val) => val.isEmpty ? labelLastName : null,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(signUpAsFocusNode);
                      },
                      style: TextStyle(color: AppTheme.mainTextColor),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.borderNotFocusedColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.borderOnFocusedColor)),
                        hintText: labelLastName,
                        errorStyle: TextStyle(
                            fontSize: AppConstants.extraXSmallSize,
                            fontFamily: AppConstants.fontName),
                        hintStyle: TextStyle(
                            color: AppTheme.subHeadingTextColor, fontSize: 14),
                        labelStyle: TextStyle(
                            color: AppTheme.mainTextColor, fontSize: 14),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                    dropdownColor: Colors.white,
                    focusNode: signUpAsFocusNode,
                    items: _signUpOptions.map((String category) {
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
                      setState(() => _selectedSignUpOption = newValue);
                      FocusScope.of(context).requestFocus(mobileFocusNode);
                    },
                    value: _selectedSignUpOption,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      filled: true,
                      fillColor: AppTheme.transparent,
                      focusColor: AppTheme.transparent,
                      hoverColor: AppTheme.transparent,
                      labelText: labelSignUpAs,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _mobileNumberKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      controller: mobileCont,
                      focusNode: mobileFocusNode,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.send,
                      validator: (val) =>
                          val.isEmpty ? labelErrorMobileNumber : null,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(otpFocusNode);
                      },
                      style: TextStyle(color: AppTheme.mainTextColor),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.borderNotFocusedColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.borderOnFocusedColor)),
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
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          labelOTPWillSentMsg,
                          style: TextStyle(
                              color: AppTheme.subHeadingTextColor,
                              fontSize: AppConstants.extraXSmallSize,
                              fontFamily: AppConstants.fontName,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Text(
                        labelResendOTP,
                        style: TextStyle(
                            color: AppTheme.primaryColorDark,
                            fontSize: AppConstants.extraXSmallSize,
                            fontFamily: AppConstants.fontName,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _otpNumberKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      controller: otpCont,
                      focusNode: otpFocusNode,
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          val.isEmpty ? labelErrorOTPNumber : null,
                      style: TextStyle(color: AppTheme.mainTextColor),
                      decoration: InputDecoration(
                        hintText: hintEnterOtp,
                        counterText: "",
                        hintStyle: TextStyle(
                            color: AppTheme.subHeadingTextColor, fontSize: 14),
                        errorStyle: TextStyle(
                            fontSize: AppConstants.extraXSmallSize,
                            fontFamily: AppConstants.fontName),
                        labelStyle: TextStyle(
                            color: AppTheme.mainTextColor, fontSize: 14),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.borderOnFocusedColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.borderNotFocusedColor)),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            isTermAndConditionSelected =
                                !isTermAndConditionSelected;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            isTermAndConditionSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: AppTheme.primaryColorDark,
                          ),
                        ),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: labelTermAndConditionString1,
                            style: TextStyle(
                                color: AppTheme.subHeadingTextColor,
                                fontFamily: AppConstants.fontName),
                            children: <TextSpan>[
                              TextSpan(
                                  text: labelTermAndConditionString,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      //TODO: Handle This
                                      AppUtils.showToast(
                                          labelUnderDevelopment, true);
                                    },
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: AppTheme.primaryColorDark,
                                      fontFamily: AppConstants.fontName)),
                              TextSpan(
                                text: labelTermAndConditionString2,
                                style: TextStyle(
                                    color: AppTheme.subHeadingTextColor,
                                    fontFamily: AppConstants.fontName),
                              ),
                              TextSpan(
                                  text: labelPrivacyPolicyString,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      //TODO: Handle This
                                      AppUtils.showToast(
                                          labelUnderDevelopment, true);
                                    },
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: AppTheme.primaryColorDark,
                                      fontFamily: AppConstants.fontName)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 56,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 50, right: 50),
                    width: MediaQuery.of(context).size.width,
                    child: GradientElevatedButton(
                      onPressed: _handleSignUpButton,
                      buttonText: labelSignUp,
                      isButtonEnable: true,
                    ),
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  Text(
                    labelOR,
                    style: TextStyle(
                        color: AppTheme.subHeadingTextColor,
                        fontFamily: AppConstants.fontName),
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text.rich(
                      TextSpan(
                        text: labelAlreadyHaveAccount,
                        style: TextStyle(
                            color: AppTheme.subHeadingTextColor,
                            fontFamily: AppConstants.fontName,
                            fontWeight: FontWeight.normal),
                        children: <TextSpan>[
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = _handleButton,
                              text: labelLogin,
                              style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontFamily: AppConstants.fontName,
                                  fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 26,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  _handleSignUpButton() {
    if (_fistNameKey.currentState.validate() &&
        _lastNameKey.currentState.validate() &&
        _mobileNumberKey.currentState.validate() &&
        _otpNumberKey.currentState.validate()) {
      if (!isTermAndConditionSelected) {
        AppUtils.showToast(labelErrorTermCondition, false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => RegistrationCompleteScreen()),
            (Route<dynamic> route) => false);
      }
    }
  }

  _handleButton() {
    Navigator.pop(context);
  }
}
