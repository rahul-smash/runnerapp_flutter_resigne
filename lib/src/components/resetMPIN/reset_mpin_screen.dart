import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/login/repository/user_authentication_repository.dart';
import 'package:marketplace_service_provider/src/components/resetMPIN/set_new_mpin_screen.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class ResetMPINScreen extends StatefulWidget {
  @override
  _ResetMPINScreenState createState() => _ResetMPINScreenState();
}

class _ResetMPINScreenState extends BaseState<ResetMPINScreen> {
  TextEditingController mobileCont = TextEditingController();
  TextEditingController otpCont = TextEditingController();
  FocusNode mobileFocusNode = FocusNode();
  FocusNode otpFocusNode = FocusNode();
  BaseResponse baseResponse;

  @override
  void dispose() {
    super.dispose();
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
                              labelResetMPINTitle,
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
                              labelResetMPINSubTitle,
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
                              FocusScope.of(context).requestFocus(otpFocusNode);
                              sendOtp();
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
                              hintStyle: TextStyle(
                                  color: AppTheme.subHeadingTextColor,
                                  fontSize: 14),
                              labelStyle: TextStyle(
                                  color: AppTheme.mainTextColor, fontSize: 14),
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
                              onPressed: _handleResetPINButton,
                              buttonText: labelResetPIN,
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

  sendOtp() async {
    try {
      if(this.network.offline){
        AppUtils.showToast(AppConstants.noInternetMsg, false);
        return;
      }
      if (mobileCont.text.isNotEmpty){
        AppUtils.showLoader(context);
        baseResponse =
        await getIt.get<UserAuthenticationRepository>().resetPinOtp(phoneNumber: mobileCont.text);
        if(baseResponse != null)
          AppUtils.showToast(baseResponse.message, false);
        AppUtils.hideKeyboard(context);
        AppUtils.hideLoader(context);
      }
    } catch (e) {
      print(e);
    }
  }

  _handleResetPINButton() async {
    if(this.network.offline){
      AppUtils.showToast(AppConstants.noInternetMsg, false);
      return;
    }
    if (mobileCont.text.isEmpty){
      AppUtils.showToast("Please enter valid phone number!", false);
      return;
    }
    if (otpCont.text.isEmpty){
      AppUtils.showToast("Please enter valid Otp!", false);
      return;
    }
    AppUtils.showLoader(context);
    baseResponse =
        await getIt.get<UserAuthenticationRepository>().verifyResetPinOtp(
            otp: otpCont.text,phoneNumber: mobileCont.text);
    if(baseResponse != null)
      AppUtils.showToast(baseResponse.message, false);
    AppUtils.hideKeyboard(context);
    AppUtils.hideLoader(context);
    Navigator.pop(context);
    Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) => SetNewMPINScreen(user_id:baseResponse.user_id),
        ));
  }
}
