import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/widgets/common_widgets.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double mHeight = Dimensions.getHeight(percentage: 24);
    return new Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                CommonWidgets.gradientContainer(context, mHeight, SizeConfig.screenWidth),

                Container(
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                            topLeft:  const  Radius.circular(30.0),
                            topRight: const  Radius.circular(30.0))
                    ),
                    margin: EdgeInsets.fromLTRB(0,  Dimensions.getHeight(percentage: 18), 0, 0),
                    padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      children: <Widget>[
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                            child: new Text(
                              //AppConstant.txt_OTP,
                              "Enter Verification Code",
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  fontSize: 20.0,
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w700
                              ),
                            )
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 5.0),
                            child: new Text(
                              //AppConstant.txt_OTP,
                              "Verification code has been sent to (+91).Please enter it here",
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                fontSize: 14.0,
                                color: AppTheme.primaryColor,
                              ),
                            )),
                        SizedBox(height: 30,),

                      ],
                    )
                ),
              ],
            ),
          )
      ),
    );
  }
}