import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/repository/account_steps_detail_repository_impl.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';
import 'models/account_steps_detail_model.dart';
import 'models/setup_account_model.dart';

class SetupProfileScreen extends StatefulWidget {
  SetupProfileScreen();

  @override
  _SetupProfileScreenState createState() {
    return _SetupProfileScreenState();
  }
}

class _SetupProfileScreenState extends BaseState<SetupProfileScreen> {

  List<SetupAccountModel> list = [];

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget builder(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFFECECEC),
          body: Container(
            child: Stack(
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
                        color: Colors.transparent,
                        borderRadius: new BorderRadius.only(
                            topLeft:  const  Radius.circular(25.0),
                            topRight: const  Radius.circular(25.0))
                    ),
                    margin: EdgeInsets.fromLTRB(0,  80, 0, 0),
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: Dimensions.getScaledSize(10),),
                        Expanded(
                            child: FutureBuilder<AccountStepsDetailModel>(
                              future: getIt.get<AccountStepsDetailRepositoryImpl>().getAccountStepsDetail(loginResponse.data.id), // async work
                              builder: (BuildContext context, AsyncSnapshot<AccountStepsDetailModel> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return AppUtils.showSpinner();
                                  default:
                                    if (snapshot.hasError){
                                      return Text('Error: ${snapshot.error}');
                                    } else{
                                      AccountStepsDetailModel accountStepsDetailModel = snapshot.data;
                                      addDataToList(accountStepsDetailModel);
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        itemCount: list.length,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30)
                                            ),
                                            child: Stack(
                                              clipBehavior: Clip.antiAlias,
                                              children: [
                                                Container(
                                                    padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                                    width: double.infinity,height: 100,
                                                    margin: EdgeInsets.fromLTRB(0,0,0,0),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center ,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center ,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            SizedBox(width: 10,),
                                                            Container(
                                                                width: 30,
                                                                height: 30,
                                                                child: Center(child: Text("${index+1}",style: TextStyle(fontSize: Dimensions.getScaledSize(20)),)),
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                      width: 1.5,
                                                                      color: AppTheme.primaryColor,
                                                                    ),
                                                                    shape: BoxShape.circle,
                                                                    color: Colors.white)
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(width: 20,),
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Text("${list[index].title}",style: TextStyle(color: AppTheme.black,
                                                                        fontSize: 18,fontWeight: FontWeight.w600,fontFamily: AppConstants.fontName,),),
                                                                      Text("${list[index].subTitle}",
                                                                        style: TextStyle(color: AppTheme.subHeadingTextColor,fontSize: 14,
                                                                          fontWeight: FontWeight.w500,fontFamily: AppConstants.fontName,),),
                                                                    ],
                                                                  )
                                                              ),
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center ,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  SizedBox(width: 10,),
                                                                  Container(
                                                                    child: Center(child: Text("${getStatusValue(accountStepsDetailModel,list[index].title)}",
                                                                      style: TextStyle(color: AppTheme.primaryColor),)),
                                                                  ),
                                                                  SizedBox(width: 10,),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                ),

                                                Positioned.fill(
                                                  child: Align(
                                                    child: Container(
                                                      child: Image.asset("lib/src/components/onboarding/images/colored_next_arrow.png",
                                                      width: 35,height: 35,),
                                                    ),
                                                    alignment: Alignment.bottomRight,
                                                  ),
                                                )

                                              ],
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return Divider();
                                        },
                                      );
                                    }

                                }
                              },
                            )
                        ),

                        Container(
                          margin: EdgeInsets.only(left: 40, right: 40,bottom: 20),
                          width: MediaQuery.of(context).size.width,
                          child: GradientElevatedButton(
                            onPressed: () async {

                            },
                            //onPressed: validateAndSave(isSubmitPressed: true),
                            buttonText: labelSubmitForApproval,),
                        ),
                      ],
                    )
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 45, 0, 0),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Setup Your Account",
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

  void addDataToList(AccountStepsDetailModel accountStepsDetailModel) {
    SetupAccountModel setupAccountModel1 = SetupAccountModel("My Profile","View your profile and updare personal detail");
    SetupAccountModel setupAccountModel2 = SetupAccountModel("Business Detail","View and update business detail");
    SetupAccountModel setupAccountModel3 = SetupAccountModel("Work Detail","View and update work detail");
    SetupAccountModel setupAccountModel4 = SetupAccountModel("Agreement","Read and accept agreement");
    list.add(setupAccountModel1);
    list.add(setupAccountModel2);
    list.add(setupAccountModel3);
    list.add(setupAccountModel4);
    /*2= in progress
    1= completed
    0 = not completed*/
  }

  getStatusValue(AccountStepsDetailModel accountStepsDetailModel,String type){
    String statusValue = '';
    String status = '';
    if(type == "My Profile"){
      statusValue = accountStepsDetailModel.data.profileDetail;
    }
    if(type == "Business Detail"){
      statusValue = accountStepsDetailModel.data.businessDetail;
    }
    if(type == "Work Detail"){
      statusValue = accountStepsDetailModel.data.workDetail;
    }
    if(type == "Agreement"){
      statusValue = accountStepsDetailModel.data.agreementDetail;
    }

    if(statusValue == "2"){
      status = "In Progress";
    }
    if(statusValue == "1"){
      status = "Completed";
    }
    if(statusValue == "0"){
      status = "Not Completed";
    }
    return status;
  }


}