import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseState<LoginScreen> {
  TextEditingController mobileCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  bool _showPassword = false;
  FocusNode mobileFocusNode = FocusNode();
  FocusNode passWordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    mobileFocusNode.dispose();
    passWordFocusNode.dispose();
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
            padding: EdgeInsets.all(26),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 60, bottom: 60),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Image(
                          image: AssetImage(AppImages.login_graphic),
                          height: 120,
                          width: 120),
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
                  TextFormField(
                    controller: mobileCont,
                    focusNode: mobileFocusNode,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(passWordFocusNode);
                    },
                    style: TextStyle(color: AppTheme.mainTextColor),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppTheme.borderNotFocusedColor)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: AppTheme.borderOnFocusedColor)),
                      hintText: labelMobileNumber,
                      hintStyle: TextStyle(
                          color: AppTheme.subHeadingTextColor, fontSize: 14),
                      labelStyle: TextStyle(
                          color: AppTheme.mainTextColor, fontSize: 14),
                    ),
                  ),
//                  SizedBox(height:5),
//                  Align(
//                    alignment: Alignment.topLeft,
//                    child: Text(
//                      labelOTPWillSentMsg,
//                      style: TextStyle(
//                          color: AppTheme.subHeadingTextColor,
//                          fontSize: AppConstants.extraXSmallSize,
//                          fontFamily: AppConstants.fontName,
//                          fontWeight: FontWeight.normal),
//                    ),
//                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: passwordCont,
                    focusNode: passWordFocusNode,
                    obscureText: !_showPassword,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: AppTheme.mainTextColor),
                    maxLength: 4,
                    decoration: InputDecoration(
                      hintText: hintMPIN,
                      counterText: "",
                      hintStyle: TextStyle(
                          color: AppTheme.subHeadingTextColor, fontSize: 14),
                      labelStyle: TextStyle(
                          color: AppTheme.mainTextColor, fontSize: 14),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                        child: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppTheme.primaryColor,
                            size: 20),
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: AppTheme.borderOnFocusedColor)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppTheme.borderNotFocusedColor)),
                    ),
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(labelForgotPin,
                          style: TextStyle(
                              color: AppTheme.primaryColor, fontSize: 14)),
                    ),
                  ),
                  SizedBox(
                    height: 56,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 50, right: 50),
                    width: MediaQuery.of(context).size.width,
                    child:GradientElevatedButton(onPressed: _handleLoginButton,buttonText: labelLogin,),
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
                        text: labelDontHaveAccount,
                        style: TextStyle(
                            color: AppTheme.subHeadingTextColor,
                            fontFamily: AppConstants.fontName,
                            fontWeight: FontWeight.normal),
                        children: <TextSpan>[
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => print('Tap Here onTap'),
                              text: labelSignUp,
                              style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontFamily: AppConstants.fontName,
                                  fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  _handleLoginButton() {
  }
}
