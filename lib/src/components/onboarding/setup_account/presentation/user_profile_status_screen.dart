import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/under_approval_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/repository/account_steps_detail_repository_impl.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class UserProfileStatusScreen extends StatefulWidget {

  bool isProfileApproved = false;
  String userId;
  UserProfileStatusScreen({this.isProfileApproved,this.userId});

  @override
  _UserProfileStatusScreenState createState() {
    return _UserProfileStatusScreenState();
  }
}

class _UserProfileStatusScreenState extends BaseState<UserProfileStatusScreen> {

  bool isProfileApproved = false;
  bool isLoading;
  UnderApprovalModel underApprovalModel;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getIt.get<AccountStepsDetailRepositoryImpl>().getUnderApprovalDetail(widget.userId).then((value){
      underApprovalModel = value;
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
        centerTitle: true,
        backBtnColor: Colors.white,
        callback: (){
          Navigator.of(context).pop();
        },
        backgroundColor: AppTheme.white,
        title: Text('Value Appz',style: TextStyle(color: Colors.black),),
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
          Visibility(
            visible: false,
            child: InkWell(
              onTap: (){

              },
              child: Container(
                child: Center(child: Text("Continue",style: TextStyle(color: Colors.black)),),
              ),
            ),
          ),
          SizedBox(width: 20,)
        ],
      ),
      body: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: isLoading
              ? AppUtils.showSpinner()
              : Container(child: Stack(
              children: [
                Container(
                  height: Dimensions.getHeight(percentage: 42),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(40),bottomLeft: Radius.circular(40)),
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
                  //height: Dimensions.getHeight(percentage: 20),
                  margin: EdgeInsets.only(left: 30,right: 30,top: 0),
                  child: Column(
                    children: [
                      Container(
                        height: Dimensions.getHeight(percentage: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Contact",
                                    style: TextStyle(
                                        fontSize: Dimensions.getScaledSize(16),
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.white.withOpacity(0.5),
                                        fontFamily: AppConstants.fontName),
                                  ),
                                  Text(
                                    "${underApprovalModel.success.userData.phone}",
                                    style: TextStyle(
                                        fontSize: Dimensions.getScaledSize(20),
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.white,
                                        fontFamily: AppConstants.fontName),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  showImageFromUrl()
                                ],
                              )
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Experience",
                                    style: TextStyle(
                                        fontSize: Dimensions.getScaledSize(16),
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.white.withOpacity(0.5),
                                        fontFamily: AppConstants.fontName),
                                  ),
                                  Text(
                                    underApprovalModel.success.userData.experience,
                                    style: TextStyle(
                                        fontSize: Dimensions.getScaledSize(20),
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.white,
                                        fontFamily: AppConstants.fontName),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Center(
                          child: Text(
                            "Hi, ${underApprovalModel.success.userData.firstName} ${underApprovalModel.success.userData.lastName}",
                            style: TextStyle(
                                fontSize: Dimensions.getScaledSize(20),
                                fontWeight: FontWeight.w600,
                                color: AppTheme.white,
                                fontFamily: AppConstants.fontName),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: 30,height: 3,color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        child: Center(
                          child: Text(
                            "${underApprovalModel.success.userData.addrees}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppTheme.white.withOpacity(0.7),
                                fontFamily: AppConstants.fontName),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: Dimensions.getHeight(percentage: !isProfileApproved ? 23 : 35),
                  margin: EdgeInsets.only(left: 30,right: 30,top: Dimensions.getHeight(percentage: 32)),
                  decoration: BoxDecoration(
                      boxShadow: shadow,
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      color: Colors.white
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 30,),
                      Text(
                        "Account Approval Status",
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(18),
                            color: AppTheme.subHeadingTextColor,
                            fontFamily: AppConstants.fontName),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        child: Center(
                          child: Text(
                            !isProfileApproved ? "${underApprovalModel.success.statusMessage}" : "Your Profile has been Approved",
                            style: TextStyle(
                                fontSize: Dimensions.getScaledSize(24),
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor,
                                fontFamily: AppConstants.fontName),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: 30,height: 3,color: Colors.black,
                          ),
                        ),
                      ),

                      Visibility(
                        visible: isProfileApproved ? false : true,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Text(
                                  "${underApprovalModel.success.processMessage}",
                                  maxLines: 2,textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: Dimensions.getScaledSize(18),
                                      color: AppTheme.mainTextColor,
                                      fontFamily: AppConstants.fontName),
                                )
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, isProfileApproved ? 10 : 0, 20, 0),
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isProfileApproved ? "Access the app feature by\nclicking the button below" : "",
                                style: TextStyle(
                                    fontSize: Dimensions.getScaledSize(18),
                                    color: AppTheme.mainTextColor,
                                    fontFamily: AppConstants.fontName),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //

                      Visibility(
                        visible: !isProfileApproved ? false : true,
                        child: Container(
                          margin: EdgeInsets.only(left: 40, right: 40,top: 30),
                          width: MediaQuery.of(context).size.width,
                          child: GradientElevatedButton(
                            onPressed: () async {

                            },
                            //onPressed: validateAndSave(isSubmitPressed: true),
                            buttonText: "Click here to continue",),
                        ),
                      )
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 30,right: 30,top: Dimensions.getHeight(percentage:!isProfileApproved ? 58: 68)),
                  child: Text(
                    "Your Categories",
                    style: TextStyle(
                        fontSize: Dimensions.getScaledSize(18),
                        color: AppTheme.subHeadingTextColor,
                        fontFamily: AppConstants.fontName),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 30,right: 30,top: Dimensions.getHeight(percentage:!isProfileApproved ? 60: 70)),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: underApprovalModel.success.categoryies.length,
                    itemBuilder: (context, index) {
                      Categoryy cat = underApprovalModel.success.categoryies[index];
                      return Container(
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(0,15,10,10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {

                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Icon(Icons.check,
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                                    ),
                                    Text("${cat.title}",style: TextStyle(color: AppTheme.black,
                                      fontWeight: FontWeight.w500,fontFamily: AppConstants.fontName,),),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: (){

                                },
                                child: Row(
                                  children: [
                                    Text("${cat.serviceCount}",style: TextStyle(color: AppTheme.black,
                                      fontWeight: FontWeight.w700,fontFamily: AppConstants.fontName,),),
                                    SizedBox(width: Dimensions.getScaledSize(10),),
                                    Text("Services",style: TextStyle(color: AppTheme.subHeadingTextColor,
                                      fontWeight: FontWeight.normal,fontFamily: AppConstants.fontName,),),
                                    SizedBox(width: Dimensions.getScaledSize(5),),
                                    Icon(Icons.arrow_forward_ios_rounded,size:Dimensions.getScaledSize(20),color: AppTheme.subHeadingTextColor)
                                  ],
                                ),
                              )
                            ],
                          )
                      );
                    },

                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  showImageFromUrl() {

    return Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.white,
              width: 4,
            ),
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(50)
        ),
        width: 100,height: 100,
        child: ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.all(Radius.circular(80)),
            child: Image.network(
              "${underApprovalModel.success.userData.profileImage}",
              width: 100,height: 100,fit: BoxFit.cover,)
        )
    );
  }
}