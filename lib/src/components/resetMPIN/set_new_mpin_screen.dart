import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class SetNewMPINScreen extends StatefulWidget {
  @override
  _SetNewMPINScreenState createState() => _SetNewMPINScreenState();
}

class _SetNewMPINScreenState extends BaseState<SetNewMPINScreen> {
  TextEditingController newPinCont = TextEditingController();
  TextEditingController confirmPinCont = TextEditingController();
  FocusNode newPinFocusNode = FocusNode();
  FocusNode confirmPinFocusNode = FocusNode();

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
            child: Stack(
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
                Padding(
                  padding: EdgeInsets.fromLTRB(26.0, 70, 26, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 0, bottom: 60),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Image(
                                image: AssetImage(AppImages.set_pin_graphic),
                                height: 150,
                               ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            labelSetNewMPINTitle,
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
                            labelSetNewMPINSubTitle,
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
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(confirmPinFocusNode);
                          },
                          maxLength: 4,
                          style: TextStyle(color: AppTheme.mainTextColor),
                          decoration: InputDecoration(
                            counterText: "",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppTheme.borderNotFocusedColor)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppTheme.borderOnFocusedColor)),
                            hintText: hintEnterNewMPIN,
                            hintStyle: TextStyle(
                                color: AppTheme.subHeadingTextColor,
                                fontSize: 14),
                            labelStyle: TextStyle(
                                color: AppTheme.mainTextColor, fontSize: 14),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: confirmPinCont,
                          focusNode: confirmPinFocusNode,
                          keyboardType: TextInputType.text,
                          maxLength: 4,
                          style: TextStyle(color: AppTheme.mainTextColor),
                          decoration: InputDecoration(
                            hintText: hintReEnterNewMPIN,
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
                            onPressed: _handleLoginButton,
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
              ],
            ),
          ),
        ));
  }

  _handleLoginButton() {}
}