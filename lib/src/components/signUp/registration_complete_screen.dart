import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/src/components/setMPIN/set_mpin_screen.dart';
import 'package:marketplace_service_provider/src/components/signUp/model/register_response.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class RegistrationCompleteScreen extends StatelessWidget {
  final RegisterResponse registerResponse;
  RegistrationCompleteScreen({this.registerResponse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  AppImages.regsitration_bg,
                ),
                fit: BoxFit.fill),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(26),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image(
                    image: AssetImage(AppImages.tick_graphic),
                    height: 130,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    labelRegistrationCompleteTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppTheme.mainTextColor,
                        fontSize: AppConstants.extraLargeSize,
                        fontFamily: AppConstants.fontName,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text.rich(
                      TextSpan(
                        text: labelRegistrationThanksMsg,
                        style: TextStyle(
                            fontSize: AppConstants.smallSize,
                            color: AppTheme.mainTextColor,
                            fontFamily: AppConstants.fontName,
                            fontWeight: FontWeight.normal),
                        children: <TextSpan>[
                          TextSpan(
                              text: appValueappzName,
                              style: TextStyle(
                                fontSize: AppConstants.smallSize,
                                  color: AppTheme.mainTextColor,
                                  fontFamily: AppConstants.fontName,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 40,
                  ),
                  Text.rich(
                      TextSpan(
                        text: labelsetupMPINMsg1,
                        style: TextStyle(
                            fontSize: AppConstants.smallSize,
                            color: AppTheme.mainTextColor,
                            fontFamily: AppConstants.fontName,
                            fontWeight: FontWeight.normal),
                        children: <TextSpan>[
                          TextSpan(
                              text: labelMPIN,
                              style: TextStyle(
                                  fontSize: AppConstants.smallSize,
                                  color: AppTheme.mainTextColor,
                                  fontFamily: AppConstants.fontName,
                                  fontWeight: FontWeight.bold))
                          ,TextSpan(
                              text: labelsetupMPINMsg2,
                              style: TextStyle(
                                  fontSize: AppConstants.smallSize,
                                  color: AppTheme.mainTextColor,
                                  fontFamily: AppConstants.fontName,
                                  fontWeight: FontWeight.normal)),
                        ],
                      ),
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 50, right: 50),
                    width: MediaQuery.of(context).size.width,
                    child: GradientElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (BuildContext context) => SetMPINScreen(this.registerResponse),
                            ));
                      },
                      buttonText: labelSetUpMPIN,
                      isButtonEnable: true,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
