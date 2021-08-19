import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/agreement_detail_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/repository/account_steps_detail_repository_impl.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class AgreementDetailScreen extends StatefulWidget {

  final VoidCallback voidCallback;
  final bool isComingFromAccount;
  AgreementDetailScreen({@required this.voidCallback,this.isComingFromAccount = false});

  @override
  _AgreementDetailScreenState createState() {
    return _AgreementDetailScreenState();
  }
}

class _AgreementDetailScreenState extends BaseState<AgreementDetailScreen> {

  bool isLoading = false;
  bool isTermAndConditionSelected = false;
  AgreementDetailModel agreementDetailModel;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getIt.get<AccountStepsDetailRepositoryImpl>().getAgreementDetail().then((value){
      agreementDetailModel = value;
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget builder(BuildContext context) {

    return Scaffold(
      appBar: BaseAppBar(
        callback: (){
          Navigator.of(context).pop();
        },
        backgroundColor: AppTheme.white,
        title: Text('Agreement',style: TextStyle(color: Colors.black),),
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark
          ),
          elevation: 0.0,
          titleSpacing: 0.0,
          bottom: PreferredSize(
              child: Container(
                color: AppTheme.grayCircle,
                height: 4.0,
              ),
              preferredSize: Size.fromHeight(4.0)),
        ),
        widgets: <Widget>[
        ],
      ),
      body: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFFECECEC),
          body: Container(
            child: isLoading ? AppUtils.showSpinner() : Stack(
              children: [
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(30),bottomLeft: Radius.circular(30)),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0.1, 0.5, 0.7, 0.9],
                      colors: [
                        AppTheme.primaryColorDark,
                        AppTheme.primaryColor,
                        AppTheme.primaryColor,
                        AppTheme.primaryColor,
                      ],
                    ),
                  ),
                ),
                Container(
                    width: SizeConfig.screenWidth,
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                            topLeft:  const  Radius.circular(25.0),
                            topRight: const  Radius.circular(25.0))
                    ),
                    margin: EdgeInsets.fromLTRB(20,  90, 20, 0),
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: Dimensions.getScaledSize(10),),
                        Expanded(
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20,  20, 20, 20),
                                    child: Image.network("${agreementDetailModel.data.image}",
                                      width: double.infinity,height: Dimensions.getScaledSize(200),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10,  0, 20, 0),
                                    child: Text("${agreementDetailModel.data.title}",style: TextStyle(color: AppTheme.mainTextColor,
                                      fontSize: 16,fontWeight: FontWeight.w600,fontFamily: AppConstants.fontName,),),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      /*child: Html(
                                        shrinkWrap: true,
                                        data: agreementDetailModel.data.message,
                                      ),*/
                                      child: AppUtils.getHtmlView(agreementDetailModel.data.message),
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Visibility(
                                    visible: widget.isComingFromAccount ? false : true,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              isTermAndConditionSelected =
                                              !isTermAndConditionSelected;
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Icon(
                                              isTermAndConditionSelected
                                                  ? Icons.check_box
                                                  : Icons.check_box_outline_blank,
                                              color: AppTheme.primaryColorDark,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              text: labelTermAndConditionString1,
                                              style: TextStyle(
                                                  color: AppTheme.subHeadingTextColor,
                                                  fontFamily: AppConstants.fontName),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: labelTermAndConditionString,
                                                    recognizer: TapGestureRecognizer()
                                                      ..onTap = () {
                                                        //TODO: Handle This
                                                        AppUtils.showToast(
                                                            labelUnderDevelopment, true);
                                                      },
                                                    style: TextStyle(
                                                        decoration: TextDecoration.underline,
                                                        color: AppTheme.primaryColorDark,
                                                        fontFamily: AppConstants.fontName)),
                                                TextSpan(
                                                  text: labelTermAndConditionString2,
                                                  style: TextStyle(
                                                      color: AppTheme.subHeadingTextColor,
                                                      fontFamily: AppConstants.fontName),
                                                ),
                                                TextSpan(
                                                    text: labelPrivacyPolicyString,
                                                    recognizer: TapGestureRecognizer()
                                                      ..onTap = () {
                                                        //TODO: Handle This
                                                        AppUtils.showToast(
                                                            labelUnderDevelopment, true);
                                                      },
                                                    style: TextStyle(
                                                        decoration: TextDecoration.underline,
                                                        color: AppTheme.primaryColorDark,
                                                        fontFamily: AppConstants.fontName)),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ),

                        Visibility(
                          visible: widget.isComingFromAccount ? false : true,
                          child: Container(
                            margin: EdgeInsets.only(left: 40, right: 40,bottom: 20,top: 20),
                            width: MediaQuery.of(context).size.width,
                            child: GradientElevatedButton(
                              onPressed: ()  {
                                callApi();
                              },
                              //onPressed: validateAndSave(isSubmitPressed: true),
                              buttonText: labelSubmit,),
                          ),
                        ),
                      ],
                    )
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 45, 0, 0),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Agreement",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontFamily: AppConstants.fontName,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 70, 0, 0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 30,height: 3,color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> callApi() async {
    if (this.network.offline) {
      AppUtils.showToast(AppConstants.noInternetMsg, false);
      return;
    }
    if(!isTermAndConditionSelected){
      AppUtils.showToast("Please accept term and condition", false);
      return;
    }
    AppUtils.showLoader(context);
    BaseResponse baseresponse = await getIt.get<AccountStepsDetailRepositoryImpl>().saveAgreementData(loginResponse.data.id);
    AppUtils.hideLoader(context);

    if(baseresponse != null){
      AppUtils.showToast(baseresponse.message, true);
      AppUtils.hideKeyboard(context);
      widget.voidCallback();
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}