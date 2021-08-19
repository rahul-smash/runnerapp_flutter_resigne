import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/src/components/dashboard/dashboard_pages/selected_user_category_screen.dart';
import 'package:marketplace_service_provider/src/components/onboarding/select_category/presentation/ui/select_category_screen.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/setup_account_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/presentation/agreement_detail_screen.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/presentation/business_detail_screen.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/presentation/my_profile_screen.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/presentation/work_detail_screen.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen();

  @override
  _AccountScreenState createState() {
    return _AccountScreenState();
  }
}

class _AccountScreenState extends BaseState<AccountScreen> {

  List<SetupAccountModel> list = [];

  @override
  void initState() {
    super.initState();
    addDataToList();
  }

  @override
  void dispose() {
    super.dispose();
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
                  height: 110,
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
                    margin: EdgeInsets.fromLTRB(0,  40, 0, 0),
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: Dimensions.getScaledSize(10),),
                        Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: (){
                                    onListViewTap(index);
                                  },
                                  child: Card(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        //side: BorderSide(color: getColorFromStatus(getStatusValue(accountStepsDetailModel,list[index].title)), width: 2),
                                        borderRadius: BorderRadius.circular(22)
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
                                                        child: Center(
                                                            child:Image.asset(list[index].imgePath,width: Dimensions.getScaledSize(30),height: Dimensions.getScaledSize(30),),
                                                        ),
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
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                        ),
                                        Positioned.fill(
                                          child: Align(
                                            child: Container(
                                                child: getImgFromStatus("In Progress")
                                            ),
                                            alignment: Alignment.bottomRight,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                        ),
                      ],
                    )
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontFamily: AppConstants.fontName,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
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

  void addDataToList() {
    SetupAccountModel setupAccountModel1 = SetupAccountModel(
        "My Profile",
        "Please provide us precise and authentic information about your own self.",
        imgePath: "lib/src/components/dashboard/images/profileicon.png"
    );
    SetupAccountModel setupAccountModel2 = SetupAccountModel(
        "Business Detail",
        "Please tell us more about your business-location timings etc.",
        imgePath: "lib/src/components/dashboard/images/businessdetailicon.png"
    );
    SetupAccountModel setupAccountModel3 = SetupAccountModel(
        "Work Detail",
        "Please share your work experience and work proofs",
      imgePath: "lib/src/components/dashboard/images/workdetailicon.png"
    );
    SetupAccountModel setupAccountModel4 = SetupAccountModel(
        "Agreement",
        "Please thoroughly check and accept work agreement",
        imgePath: "lib/src/components/dashboard/images/agreementicon.png"
    );
    SetupAccountModel setupAccountModel5 = SetupAccountModel(
        "My Services",
        "View and update my services details",
      imgePath:  "lib/src/components/dashboard/images/myserviceicon.png"
    );
    list.add(setupAccountModel1);
    list.add(setupAccountModel2);
    list.add(setupAccountModel3);
    list.add(setupAccountModel5);
    list.add(setupAccountModel4);
    /*2= in progress
    1= completed
    0 = not completed*/
  }

  Widget getImgFromStatus(String status){
    if(status == "In Progress"){
      return Image.asset("lib/src/components/onboarding/images/colored_next_arrow.png",width: 35,height: 35,);
    }
    if(status == "Not Completed"){
      return Image.asset("lib/src/components/onboarding/images/grey_next_arrow.png",width: 35,height: 35,);
    }
    if(status == "Completed"){
      return Image.asset("lib/src/components/onboarding/images/green_next_arrow.png",width: 35,height: 35,);
    }
  }

  void onListViewTap(int index) {
    //print(index);
    if(index == 0){
      //Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) => MyProfileScreen(
            isComingFromAccount: true,
            voidCallback: (){
          },))
      );
    }else if(index == 1){
      Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) => BusinessDetailScreen(
            isComingFromAccount: true,
            userlocation: null,
            voidCallback: (){
            },))
      );
    } else if(index == 2){
      Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) => WorkDetailScreen(
            isComingFromAccount: true,
            voidCallback: (){
          },)));
    } else if(index == 3){
      Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) => SelectedUserCategoryScreen())
      );
    }else if(index == 4){
      Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) => AgreementDetailScreen(
            isComingFromAccount: true,
            voidCallback: (){

            },)));
    }
  }

}