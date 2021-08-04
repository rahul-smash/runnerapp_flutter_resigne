import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/login/bloc/user_login_bloc.dart';
import 'package:marketplace_service_provider/src/components/login/model/login_event_data.dart';
import 'package:marketplace_service_provider/src/components/service_location/ui/services_location_screen.dart';
import 'package:marketplace_service_provider/src/components/signUp/signup_screen.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseState<LoginScreen> {

  final UserLoginBloc userLoginBloc = getIt.get<UserLoginBloc>();
  TextEditingController mobileCont = TextEditingController(text: "8847485654");
  TextEditingController passwordCont = TextEditingController(text: "1234");
  bool _showPassword = false;
  FocusNode mobileFocusNode = FocusNode();
  FocusNode passWordFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: Dimensions.pixels_60, bottom: Dimensions.pixels_60),
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
                      validator: (value) =>
                      value.isEmpty ? 'Mobile number cannot be blank' : null,
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
                      validator: (value) =>
                      value.isEmpty ? 'MPIN cannot be blank' : null,
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
                      child:GradientElevatedButton(
                        onPressed: validateAndSave,
                        buttonText: labelLogin,),
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
                                  ..onTap = () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) => SignUpScreen())
                                    );
                                  },
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
          ),
        )
    );
  }

  void validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      print('Form is valid');
      if(this.network.offline){
        AppUtils.showToast(AppConstants.noInternetMsg, false);
        return;
      }
      userLoginBloc.eventSink.add(LoginEventData(UserLoginAction.PerformLoggin,mobileCont.text,passwordCont.text));

      userLoginBloc.userModelStream.listen((event) {
        if(event.showLoader){
          AppUtils.showLoader(context);
        }
        if(!event.showLoader){
          AppUtils.hideKeyboard(context);
          AppUtils.hideLoader(context);
        }


        if(event.loginResponse != null){
          if(!event.loginResponse.success){
            AppUtils.showToast(event.loginResponse.message, false);
          }else if(event.loginResponse.success){
            AppUtils.showToast(event.loginResponse.message, false);
            if(event.loginResponse.locationId == "0"){
              Navigator.pushReplacement(context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ServicesLocationScreen(userId: event.loginResponse.data.id,))
              );
            }else{

            }
          }
        }
        //call next screen here
      });
    }
  }

}
