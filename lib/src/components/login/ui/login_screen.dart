import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/dashboard_screen.dart';
import 'package:marketplace_service_provider/src/components/login/bloc/login_bloc.dart';
import 'package:marketplace_service_provider/src/components/login/model/login_response.dart';
import 'package:marketplace_service_provider/src/components/resetMPIN/reset_mpin_screen.dart';
import 'package:marketplace_service_provider/src/components/side_menu/model/duty_status_observer.dart';
import 'package:marketplace_service_provider/src/model/store_response_model.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/singleton/versio_api_singleton.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class LoginScreen extends StatefulWidget {
  bool shouldForceUpdate = false;

  LoginScreen({this.shouldForceUpdate});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseState<LoginScreen> {
  TextEditingController mobileEmailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  FocusNode mobileFocusNode = FocusNode();
  FocusNode passWordFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ValueNotifier<bool> showPassword = ValueNotifier(false);
  final LoginBloc loginBloc = LoginBloc();
  StoreResponse storeResponse;

  @override
  void dispose() {
    super.dispose();
    mobileFocusNode.dispose();
    passWordFocusNode.dispose();
    loginBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    storeResponse = VersionApiSingleton.instance.storeResponse;
    loginBloc.loginStateStream.listen((loginResult) {
      switch (loginResult.state) {
        case LoginState.progress:
          AppUtils.hideKeyboard(context);
          AppUtils.showLoader(context);
          break;
        case LoginState.failed:
          AppUtils.hideLoader(context);
          AppUtils.showToast(loginResult.data.message, true);
          break;
        case LoginState.success:
          AppUtils.hideLoader(context);
          AppUtils.showToast(loginResult.data.message, true);
          onLoginSuccess(loginResult.data);
          break;
      }
    });

    if (widget.shouldForceUpdate) {
      AppUtils.callForceUpdateDialog(
          context,
          VersionApiSingleton.instance.storeResponse.brand.name,
          VersionApiSingleton.instance.storeResponse.brand.forceDownload[0]
              .forceDownloadMessage,
          storeModel: VersionApiSingleton.instance.storeResponse.brand);
    }
  }

  Future<void> onLoginSuccess(LoginResponse loginResponse) async {
    print('onLoginSuccess ${loginResponse?.data?.id}');

    await AppSharedPref.instance.setAppUser(loginResponse);
    await AppSharedPref.instance.setLoggedIn(true);
    getIt
        .get<DutyStatusObserver>()
        .changeStatus(AppSharedPref.instance.getDutyStatus());
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => DashboardScreen()));
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
                      controller: mobileEmailCont,
                      focusNode: mobileFocusNode,
                      keyboardType: storeResponse.brand.internationalOtp == "1"
                          ? TextInputType.emailAddress
                          : TextInputType.phone,
                      // inputFormatters: [
                      //   storeResponse.brand.internationalOtp != 1
                      //       ? FilteringTextInputFormatter.digitsOnly
                      //       : FilteringTextInputFormatter.digitsOnly
                      // ],

                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(passWordFocusNode);
                      },
                      // validator: (value)
                      // => value.isEmpty
                      //     ? 'Mobile number cannot be blank'
                      //     : null,
                      style: TextStyle(color: AppTheme.mainTextColor),
                      // maxLength: storeResponse.brand.internationalOtp != "1"
                      //     ? AppConstants.mobileNumberLength
                      //     : null,
                      decoration: InputDecoration(
                        counterText: '',
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.borderNotFocusedColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.borderOnFocusedColor)),
                        hintText: storeResponse.brand.internationalOtp == "1"
                            ? labelEmail
                            : labelMobileNumber,
                        hintStyle: TextStyle(
                            color: AppTheme.subHeadingTextColor, fontSize: 14),
                        labelStyle: TextStyle(
                            color: AppTheme.mainTextColor, fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: showPassword,
                      builder: (context, value, child) {
                        return TextFormField(
                          controller: passwordCont,
                          focusNode: passWordFocusNode,
                          obscureText: !value,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: AppTheme.mainTextColor),
                          maxLength: 6,
                          validator: (value) =>
                              value.isEmpty ? 'MPIN cannot be blank' : null,
                          decoration: InputDecoration(
                            hintText: hintMPIN,
                            counterText: "",
                            hintStyle: TextStyle(
                                color: AppTheme.subHeadingTextColor,
                                fontSize: 14),
                            labelStyle: TextStyle(
                                color: AppTheme.mainTextColor, fontSize: 14),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                showPassword.value = !value;
                              },
                              child: Icon(
                                  value
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
                        );
                      },
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
                        onPressed: validateAndLogin,
                        buttonText: labelLogin,
                      ),
                    ),
                    SizedBox(
                      height: 26,
                    ),
                    // Text(
                    //   labelOR,
                    //   style: TextStyle(
                    //       color: AppTheme.subHeadingTextColor,
                    //       fontFamily: AppConstants.fontName),
                    // ),
                    // SizedBox(
                    //   height: 26,
                    // ),
                    // Align(
                    //   alignment: Alignment.bottomCenter,
                    //   child: Text.rich(
                    //     TextSpan(
                    //       text: labelDontHaveAccount,
                    //       style: TextStyle(
                    //           color: AppTheme.subHeadingTextColor,
                    //           fontFamily: AppConstants.fontName,
                    //           fontWeight: FontWeight.normal),
                    //       children: <TextSpan>[
                    //         TextSpan(
                    //             recognizer: TapGestureRecognizer()
                    //               ..onTap = () {
                    //                 Navigator.push(
                    //                     context,
                    //                     MaterialPageRoute(
                    //                         builder: (BuildContext context) =>
                    //                             SignUpScreen()));
                    //               },
                    //             text: labelSignUp,
                    //             style: TextStyle(
                    //                 color: AppTheme.primaryColor,
                    //                 fontFamily: AppConstants.fontName,
                    //                 fontWeight: FontWeight.normal)),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void validateAndLogin() {
    if (_formKey.currentState.validate()) {
      if (this.network.offline) {
        AppUtils.showToast(AppConstants.noInternetMsg, false);
        return;
      }

      if (mobileEmailCont.text.isEmpty) {
        storeResponse.brand.internationalOtp == "1"
            ? AppUtils.showToast("Please enter email", true)
            : AppUtils.showToast("Please enter mobile number", true);
        return;
      }

      if (mobileEmailCont.text.length != 10 &&
          !AppUtils.validateEmail(mobileEmailCont.text.trim())) {
        storeResponse.brand.internationalOtp == "1"
            ? AppUtils.showToast(validEmail, true)
            : AppUtils.showToast(validMobileNumber, true);
        return;
      }

      storeResponse.brand.internationalOtp == "1"
          ? loginBloc.perfromUserLogin(
              email: mobileEmailCont.text, password: passwordCont.text)
          : loginBloc.perfromLogin(
              mNumber: mobileEmailCont.text, mPin: passwordCont.text);
    }
  }
}
