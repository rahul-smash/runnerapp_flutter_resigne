import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/login/repository/user_authentication_repository.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/singleton/versio_api_singleton.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

import 'model/register_response.dart';
import 'registration_complete_screen.dart';

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
  BaseResponse response;

  Timer _timer;
  int _start = 30;
  bool resendOtp = false;

  @override
  void initState() {
    super.initState();
    _signUpOptions = VersionApiSingleton.instance.storeResponse.brand.signupAs;
    _selectedSignUpOption =
        VersionApiSingleton.instance.storeResponse.brand.signupAs.first;
  }

  @override
  void dispose() {
    super.dispose();
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    signUpAsFocusNode.dispose();
    mobileFocusNode.dispose();
    otpFocusNode.dispose();

    if (_timer != null) {
      _timer.cancel();
    }
  }

  void startTimer() {
    //print('--startTimer===  $_start');
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        //print('--periodic===  $_start');
        setState(
          () {
            if (_start < 1) {
              timer.cancel();
            } else {
              _start = _start - 1;
            }
          },
        );
      },
    );
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
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.send,
                      validator: (val) =>
                          val.isEmpty ? labelErrorMobileNumber : null,
                      onFieldSubmitted: (value) async {
                        FocusScope.of(context).requestFocus(otpFocusNode);
                        sendOtp();
                      },
                      maxLength: AppConstants.mobileNumberLength,
                      style: TextStyle(color: AppTheme.mainTextColor),
                      decoration: InputDecoration(
                        counterText: '',
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
                      Visibility(
                        visible: resendOtp,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            child: Text(
                              _start < 1
                                  ? labelResendOTP
                                  : '$labelResendOTPIn $_start sec',
                              style: TextStyle(
                                  color: AppTheme.primaryColorDark,
                                  fontSize: AppConstants.extraXSmallSize,
                                  fontFamily: AppConstants.fontName,
                                  fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              if (_start < 1) {
                                sendOtp();
                              }
                            },
                          ),
                        ),
                      ),
                      Text(
                        //labelResendOTP,
                        "",
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

  sendOtp() async {
    try {
      if (this.network.offline) {
        AppUtils.showToast(AppConstants.noInternetMsg, false);
        return;
      }
      if (mobileCont.text.isNotEmpty) {
        if (mobileCont.text.length < 10) {
          AppUtils.showToast(validMobileNumber, false);
          return;
        }

        AppUtils.showLoader(context);
        response = await getIt
            .get<UserAuthenticationRepository>()
            .sendOtp(phoneNumber: mobileCont.text);
        AppUtils.showToast(response.message, false);
        setState(() {
          resendOtp = true;
        });
        _start = 30;
        startTimer();
        AppUtils.hideKeyboard(context);
        AppUtils.hideLoader(context);
      }
    } catch (e) {
      print(e);
    }
  }

  _handleSignUpButton() async {
    if (_fistNameKey.currentState.validate() &&
        _lastNameKey.currentState.validate() &&
        _mobileNumberKey.currentState.validate() &&
        _otpNumberKey.currentState.validate()) {
      if (!isTermAndConditionSelected) {
        AppUtils.showToast(labelErrorTermCondition, false);
      } else {
        if (this.network.offline) {
          AppUtils.showToast(AppConstants.noInternetMsg, false);
          return;
        }
        AppUtils.showLoader(context);
        RegisterResponse response = await getIt
            .get<UserAuthenticationRepository>()
            .registerUser(
                first_name: firstNameCont.text.trim(),
                last_name: lastNameCont.text.trim(),
                otp: otpCont.text.trim(),
                phone: mobileCont.text.trim(),
                registeredAs: _selectedSignUpOption);
        AppUtils.hideLoader(context);
        AppUtils.showToast(response.message, false);
        AppUtils.hideKeyboard(context);
        if (response != null) {
          if (response.success) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => RegistrationCompleteScreen(
                          registerResponse: response,
                        )),
                (Route<dynamic> route) => false);
          }
        }
      }
    }
  }

  _handleButton() {
    Navigator.pop(context);
  }
}
