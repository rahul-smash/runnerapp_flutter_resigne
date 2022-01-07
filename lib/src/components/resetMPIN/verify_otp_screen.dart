import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/login/model/forgot_password_response.dart';
import 'package:marketplace_service_provider/src/components/login/repository/user_authentication_repository.dart';
import 'package:marketplace_service_provider/src/components/resetMPIN/set_new_mpin_screen.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/model/store_response_model.dart';
import 'package:marketplace_service_provider/src/singleton/versio_api_singleton.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class VerifyOTPScreen extends StatefulWidget {
 final String userId;
  final String otp;

  const VerifyOTPScreen({Key key, this.userId, this.otp}) : super(key: key);
  @override
  _VerifyOTPScreenState createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends BaseState<VerifyOTPScreen> {
  TextEditingController otpCont = TextEditingController();
  FocusNode otpFocusNode = FocusNode();
  BaseResponse baseResponse;
  StoreResponse storeResponse;
  ForgotPasswordResponse forgotPasswordResponse;

  @override
  void initState() {
    super.initState();
    storeResponse = VersionApiSingleton.instance.storeResponse;

  }

  @override
  void dispose() {
    super.dispose();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(26.0, 0, 26, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 60),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Image(
                                image: AssetImage(AppImages.login_graphic),
                                height: 120,
                                width: 120,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              labelVerifyOTPTitle,
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
                              labelOTPSubTitle,
                              style: TextStyle(
                                  color: AppTheme.subHeadingTextColor,
                                  fontSize: AppConstants.extraSmallSize,
                                  fontFamily: AppConstants.fontName,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),



                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: otpCont,
                            focusNode: otpFocusNode,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: AppTheme.mainTextColor),
                            decoration: InputDecoration(
                              hintText: hintEnterOtp,
                              counterText: "",
                              hintStyle: TextStyle(
                                  color: AppTheme.subHeadingTextColor,
                                  fontSize: 14),
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
                          SizedBox(height: 26),
                          SizedBox(
                            height: 56,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 50, right: 50),
                            width: MediaQuery.of(context).size.width,
                            child: GradientElevatedButton(
                              onPressed:
                              _handleResetPINButton,
                              buttonText:
                              labelResetPIN,
                              isButtonEnable: true,
                            ),
                          ),
                          SizedBox(
                            height: 26,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }



  _handleResetPINButton() async {
    String pass=otpCont.text.trim();
    if (this.network.offline) {
      AppUtils.showToast(AppConstants.noInternetMsg, false);
      return;
    }
    // if (mobileCont.text.isEmpty) {
    //   storeResponse.brand.internationalOtp == "1"
    //       ? AppUtils.showToast("Please enter email", true)
    //       : AppUtils.showToast("Please enter mobile number", true);
    //   return;
    // }
    // if (mobileCont.text.length < 10 ||
    //     !AppUtils.validateEmail(mobileCont.text.trim())) {
    //   storeResponse.brand.internationalOtp == "1"
    //       ? AppUtils.showToast(validEmail, true)
    //       : AppUtils.showToast(validMobileNumber, false);
    //   return;
    // }

    if (otpCont.text.isEmpty) {
      AppUtils.showToast("Please enter OTP", true);
        return;
      }
    if (pass!=widget.otp) {
      AppUtils.showToast("Please enter valid Otp!", false);
      return;
    }
    // AppUtils.showLoader(context);
    // baseResponse = await getIt
    //     .get<UserAuthenticationRepository>()
    //     .verifyResetPinOtp(otp: otpCont.text, phoneNumber: mobileCont.text);
    // if (baseResponse != null) {
    //   AppUtils.showToast(baseResponse.message, false);
    //   AppUtils.hideKeyboard(context);
    //   AppUtils.hideLoader(context);
    //   if (baseResponse.success) {
    //     Navigator.pop(context);
        Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (BuildContext context) =>
                  SetNewMPINScreen(id: widget.userId,),
            ));
      }
    }
//   }
// }
