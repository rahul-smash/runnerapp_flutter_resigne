import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/onboarding/select_category/presentation/widgets/categories_services_dialog.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/under_approval_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/repository/account_steps_detail_repository_impl.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';

class SelectedUserCategoryScreen extends StatefulWidget {
  SelectedUserCategoryScreen();

  @override
  _SelectedUserCategoryScreenState createState() {
    return _SelectedUserCategoryScreenState();
  }
}

class _SelectedUserCategoryScreenState
    extends BaseState<SelectedUserCategoryScreen> {
  bool isLoading;
  UnderApprovalModel underApprovalModel;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getIt
        .get<AccountStepsDetailRepositoryImpl>()
        .getUnderApprovalDetail(userId)
        .then((value) {
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
    return SafeArea(
      child: Scaffold(
        appBar: BaseAppBar(
          callback: () {
            Navigator.of(context).pop();
          },
          backgroundColor: AppTheme.white,
          title: Text(
            'Selected Categories',
            style: TextStyle(color: Colors.black),
          ),
          appBar: AppBar(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            backwardsCompatibility: false,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark),
            elevation: 0.0,
            titleSpacing: 0.0,
            bottom: PreferredSize(
                child: Container(
                  color: AppTheme.grayCircle,
                  height: 4.0,
                ),
                preferredSize: Size.fromHeight(4.0)),
          ),
          widgets: <Widget>[],
        ),
        backgroundColor: Color(0xFFECECEC),
        body: Container(
          child: Stack(
            children: [
              Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30)),
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
                          topLeft: const Radius.circular(25.0),
                          topRight: const Radius.circular(25.0))),
                  margin: EdgeInsets.fromLTRB(20, 100, 20, 0),
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: Dimensions.getScaledSize(10),
                      ),
                      SizedBox(
                        height: Dimensions.getScaledSize(10),
                      ),
                      isLoading
                          ? AppUtils.showSpinner()
                          : Expanded(
                              child: ListView.separated(
                              shrinkWrap: true,
                              itemCount:
                                  underApprovalModel.success.categoryies.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.fromLTRB(0, 15, 10, 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Text(
                                                "${underApprovalModel.success.categoryies[index].title}",
                                                style: TextStyle(
                                                  color: AppTheme.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      AppConstants.fontName,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            // print("locationId=${userId.location.locationId}");
                                            print(
                                                "cat id=${underApprovalModel.success.categoryies[index].id}");
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return CategoriesServicesDialog(
                                                    title: underApprovalModel
                                                        .success
                                                        .categoryies[index]
                                                        .title,
                                                    categoryId:
                                                        underApprovalModel
                                                            .success
                                                            .categoryies[index]
                                                            .id,
                                                    locationId: AppSharedPref
                                                        .instance
                                                        .getLocationId());
                                              },
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                "${underApprovalModel.success.categoryies[index].serviceCount}",
                                                style: TextStyle(
                                                  color: AppTheme.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily:
                                                      AppConstants.fontName,
                                                ),
                                              ),
                                              SizedBox(
                                                width: Dimensions.getScaledSize(
                                                    10),
                                              ),
                                              Text(
                                                "Services",
                                                style: TextStyle(
                                                  color: AppTheme
                                                      .subHeadingTextColor,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily:
                                                      AppConstants.fontName,
                                                ),
                                              ),
                                              SizedBox(
                                                width:
                                                    Dimensions.getScaledSize(5),
                                              ),
                                              Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  size:
                                                      Dimensions.getScaledSize(
                                                          20),
                                                  color: AppTheme
                                                      .subHeadingTextColor)
                                            ],
                                          ),
                                        )
                                      ],
                                    ));
                              },
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                            )),
                    ],
                  )),
              Container(
                margin: EdgeInsets.fromLTRB(0, 45, 0, 0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Selected Category",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontFamily: AppConstants.fontName,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 70, 0, 0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 30,
                    height: 3,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
