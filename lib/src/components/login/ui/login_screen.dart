import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/dashboard_screen.dart';
import 'package:marketplace_service_provider/src/components/login/bloc/user_login_bloc.dart';
import 'package:marketplace_service_provider/src/components/login/model/login_event_data.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/presentation/user_profile_status_screen.dart';
import 'package:marketplace_service_provider/src/components/resetMPIN/reset_mpin_screen.dart';
import 'package:marketplace_service_provider/src/components/service_location/ui/services_location_screen.dart';
import 'package:marketplace_service_provider/src/components/side_menu/model/duty_status_observer.dart';
import 'package:marketplace_service_provider/src/components/signUp/signup_screen.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/singleton/login_user_singleton.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

import '../../../../main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseState<LoginScreen> {
  final UserLoginBloc userLoginBloc = getIt.get<UserLoginBloc>();
  TextEditingController mobileCont = TextEditingController(text: "");
  TextEditingController passwordCont = TextEditingController(text: "");
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
                      margin: EdgeInsets.only(
                          top: Dimensions.pixels_60,
                          bottom: Dimensions.pixels_60),
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
                      validator: (value) => value.isEmpty
                          ? 'Mobile number cannot be blank'
                          : null,
                      style: TextStyle(color: AppTheme.mainTextColor),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.borderNotFocusedColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.borderOnFocusedColor)),
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
                            borderSide: BorderSide(
                                color: AppTheme.borderOnFocusedColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.borderNotFocusedColor)),
                      ),
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ResetMPINScreen(),
                              ));
                        },
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
                      child: GradientElevatedButton(
                        onPressed: validateAndSave,
                        buttonText: labelLogin,
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
                          text: labelDontHaveAccount,
                          style: TextStyle(
                              color: AppTheme.subHeadingTextColor,
                              fontFamily: AppConstants.fontName,
                              fontWeight: FontWeight.normal),
                          children: <TextSpan>[
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                SignUpScreen()));
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
        ));
  }

  void validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      print('Form is valid');
      if (this.network.offline) {
        AppUtils.showToast(AppConstants.noInternetMsg, false);
        return;
      }
      userLoginBloc.eventSink.add(LoginEventData(
          UserLoginAction.PerformLoggin, mobileCont.text, passwordCont.text));

      userLoginBloc.userModelStream.listen((event) async {
        if (event.showLoader) {
          AppUtils.showLoader(context);
        }
        if (!event.showLoader) {
          AppUtils.hideKeyboard(context);
          AppUtils.hideLoader(context);
        }

        if (event.loginResponse != null) {
          if (!event.loginResponse.success) {
            AppUtils.showToast(event.loginResponse.message, true);
          } else if (event.loginResponse.success) {
            AppUtils.showToast(event.loginResponse.message, false);
            if (event.loginResponse.location.locationId == "0") {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ServicesLocationScreen(
                            loginResponse: event.loginResponse,
                            redirectToLogin: true,
                          )));
            } else {
              if (!event.loginResponse.success) {
                AppUtils.showToast(event.loginResponse.message, false);
                return;
              }

              LoginUserSingleton.instance.loginResponse = event.loginResponse;
              //"status": value are below,
              // 3 = under approval
              // 1 = approval
              // 2 = block

              await AppSharedPref.instance.saveUser(event.loginResponse);
              await AppSharedPref.instance.saveDutyStatus(event.loginResponse.data.onDuty);
              getIt.get<DutyStatusObserver>().changeStatus(event.loginResponse.data.onDuty);

              if (event.loginResponse.data.status == "3") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            UserProfileStatusScreen(
                              isProfileApproved: false,
                              userId: event.loginResponse.data.id,
                            )));
              }

              if (event.loginResponse.data.status == "1" &&
                  event.loginResponse.afterApprovalFirstTime == "2") {
                AppConstants.isLoggedIn =
                    await AppSharedPref.instance.setLoggedIn(true);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => DashboardScreen()));
              }

              if (event.loginResponse.data.status == "1" &&
                  event.loginResponse.afterApprovalFirstTime == "1") {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            UserProfileStatusScreen(
                                isProfileApproved: true,
                                userId: event.loginResponse.data.id)));
              }
            }
          }
        }
        //call next screen here
      });
    }
  }
}
