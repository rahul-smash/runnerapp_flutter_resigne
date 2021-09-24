import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/login/model/login_response.dart';
import 'package:marketplace_service_provider/src/components/login/repository/user_authentication_repository.dart';
import 'package:marketplace_service_provider/src/components/service_location/ui/services_location_screen.dart';
import 'package:marketplace_service_provider/src/components/signUp/model/register_response.dart';
import 'package:marketplace_service_provider/src/singleton/login_user_singleton.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class SetMPINScreen extends StatefulWidget {
  final RegisterResponse registerResponse;

  SetMPINScreen(this.registerResponse);

  @override
  _SetMPINScreenState createState() => _SetMPINScreenState();
}

class _SetMPINScreenState extends BaseState<SetMPINScreen> {
  TextEditingController newPinCont = TextEditingController(text: '');
  TextEditingController confirmPinCont = TextEditingController(text: '');
  FocusNode newPinFocusNode = FocusNode();
  FocusNode confirmPinFocusNode = FocusNode();

  final _ConfirmPinKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    newPinFocusNode.dispose();
    confirmPinFocusNode.dispose();
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
            padding: EdgeInsets.fromLTRB(26.0, 70, 26, 0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 0, bottom: 60),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Image(
                        image: AssetImage(AppImages.sign_up_graphic),
                        height: 120,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      labelSetFourDigitPinTitle,
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
                    controller: newPinCont,
                    focusNode: newPinFocusNode,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(confirmPinFocusNode);
                    },
                    maxLength: 4,
                    style: TextStyle(color: AppTheme.mainTextColor),
                    decoration: InputDecoration(
                      counterText: "",
                      suffixIcon: (newPinCont.text == '' &&
                                  confirmPinCont.text == '') ||
                              newPinCont.text != confirmPinCont.text
                          ? null
                          : Image(
                              image: AssetImage(AppImages.small_tick),
                              height: 17,
                            ),
                      suffixIconConstraints: BoxConstraints(
                        maxHeight: 17,
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppTheme.borderNotFocusedColor)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: AppTheme.borderOnFocusedColor)),
                      hintText: hintEnterNewMPIN,
                      hintStyle: TextStyle(
                          color: AppTheme.subHeadingTextColor, fontSize: 14),
                      labelStyle: TextStyle(
                          color: AppTheme.mainTextColor, fontSize: 14),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _ConfirmPinKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      controller: confirmPinCont,
                      focusNode: confirmPinFocusNode,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: (value) => !(newPinCont.text == '' &&
                                  confirmPinCont.text == '') &&
                              newPinCont.text != confirmPinCont.text
                          ? labelErrorMPINNotMatched
                          : null,
                      onFieldSubmitted: (value) {
                        setState(() {});
                      },
                      style: TextStyle(color: AppTheme.mainTextColor),
                      decoration: InputDecoration(
                        hintText: hintReEnterNewMPIN,
                        counterText: "",
                        suffixIcon: (newPinCont.text == '' &&
                                    confirmPinCont.text == '') ||
                                newPinCont.text != confirmPinCont.text
                            ? null
                            : Image(
                                image: AssetImage(AppImages.small_tick),
                                height: 17,
                              ),
                        suffixIconConstraints: BoxConstraints(
                          maxHeight: 17,
                        ),
                        hintStyle: TextStyle(
                            color: AppTheme.subHeadingTextColor, fontSize: 14),
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
                  SizedBox(height: 26),
                  SizedBox(
                    height: 56,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 50, right: 50),
                    width: MediaQuery.of(context).size.width,
                    child: GradientElevatedButton(
                      onPressed: () {
                        setPin();
                      },
                      buttonText: labelSubmit,
                      isButtonEnable: !(newPinCont.text == '' &&
                              confirmPinCont.text == '') &&
                          (newPinCont.text == confirmPinCont.text),
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

  setPin() async {
    try {
      if (this.network.offline) {
        AppUtils.showToast(AppConstants.noInternetMsg, false);
        return;
      }
      if (newPinCont.text.isEmpty) {
        AppUtils.showToast(newPinValidationMsg, false);
        return;
      }

      if (newPinCont.text.length != 4 || confirmPinCont.text.length != 4) {
        AppUtils.showToast(labelErrorMPINNumber, false);
        return;
      }

      if (!AppUtils.equalsIgnoreCase(newPinCont.text, confirmPinCont.text)) {
        AppUtils.showToast(confirmPinValidationMsg, false);
        return;
      }
      AppUtils.showLoader(context);
      LoginResponse response = await getIt
          .get<UserAuthenticationRepository>()
          .setMpin(
              mPin: newPinCont.text, userId: widget.registerResponse.data.id);
      if (response != null) AppUtils.hideKeyboard(context);
      AppUtils.hideLoader(context);
      if (response.success) {
        AppUtils.showToast(response.message, false);
        LoginUserSingleton.instance.loginResponse = response;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => ServicesLocationScreen(
                      loginResponse: response,
                    )),
            (Route<dynamic> route) => false);
      }
    } catch (e) {
      print(e);
    }
  }
}
