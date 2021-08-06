import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/onboarding/select_category/models/category_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/select_category/presentation/bloc/bloc.dart';
import 'package:marketplace_service_provider/src/components/onboarding/select_category/presentation/widgets/categories_services_dialog.dart';
import 'package:marketplace_service_provider/src/components/onboarding/select_category/presentation/widgets/categories_dialog.dart';
import 'package:marketplace_service_provider/src/components/onboarding/select_category/repository/categorys_list_network_datasource.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/setup_profile_screen.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/common_widgets.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class SelectCategoryScreen extends StatefulWidget {
  SelectCategoryScreen({Key key}) : super(key: key);

  @override
  _SelectCategoryScreenState createState() {
    return _SelectCategoryScreenState();
  }
}

class _SelectCategoryScreenState extends BaseState<SelectCategoryScreen> {

  final CategoryBloc categoryBloc = getIt.get<CategoryBloc>();
  List<CategoryData> selectedCategoriesList = [];
  List<int> selectedIndexList = [];
  CategoryModel categoryModel;

  @override
  void initState() {
    super.initState();
    categoryBloc.sendParams(configModel.storeId,loginResponse.location.locationId);
    categoryBloc.eventSink.add(CategoryAction.PerformApiCall);
    categoryBloc.categoryStream.listen((event) {
      if(!event.showLoader && event.categoryModel != null){
        if(this.mounted)
        showCategoryDialog(event.categoryModel);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget builder(BuildContext context) {

    return StreamBuilder<CategoryStreamOutput>(
        stream: categoryBloc.categoryStream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container();
            default:
              if (snapshot.hasError){
                return Text('Error: ${snapshot.error}');
              } else{
                CategoryStreamOutput categoryStreamOutput = snapshot.data;
                if(categoryStreamOutput.showLoader){
                  AppUtils.showLoader(context);
                  return Container();
                }else{
                  if(!categoryStreamOutput.showLoader)
                    AppUtils.hideLoader(context);
                  this.categoryModel = categoryStreamOutput.categoryModel;
                  return WillPopScope(
                    onWillPop: () {

                    },
                    child: SafeArea(
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
                                      color: Colors.white,
                                      borderRadius: new BorderRadius.only(
                                          topLeft:  const  Radius.circular(25.0),
                                          topRight: const  Radius.circular(25.0))
                                  ),
                                  margin: EdgeInsets.fromLTRB(20,  100, 20, 0),
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: Dimensions.getScaledSize(10),),
                                      InkWell(
                                        onTap: (){
                                          showCategoryDialog(categoryStreamOutput.categoryModel);
                                        },
                                        child: Container(
                                          width: SizeConfig.screenWidth,
                                          height: Dimensions.getScaledSize(50),
                                          decoration: BoxDecoration(
                                            borderRadius:BorderRadius.all(Radius.circular(25.0)),
                                            gradient: LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              stops: [0.1, 0.5, 0.7, 0.9],
                                              colors: [
                                                AppTheme.primaryColorDark,
                                                AppTheme.primaryColor,
                                                AppTheme.primaryColor,
                                                AppTheme.primaryColor,
                                              ],
                                            ),
                                          ),
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left: Dimensions.getScaledSize(20)),
                                                  child: Text("Add Categories",style: TextStyle(color: AppTheme.white,
                                                    fontWeight: FontWeight.w500,fontFamily: AppConstants.fontName,),),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(right: Dimensions.getScaledSize(20)),
                                                  child: Icon(Icons.add_circle,color: AppTheme.white),
                                                ),
                                              ]
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: Dimensions.getScaledSize(10),),
                                      Expanded(
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            itemCount: selectedCategoriesList.length,
                                            itemBuilder: (context, index) {

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
                                                                int indexx = -1;
                                                                for(int i = 0; i < selectedIndexList.length; i++ ){
                                                                  String id = selectedIndexList[i].toString();
                                                                  if(selectedCategoriesList[index].id == id){
                                                                    indexx = i;
                                                                    break;
                                                                  }
                                                                }
                                                                if(indexx != -1){
                                                                  selectedIndexList.removeAt(indexx);
                                                                  selectedCategoriesList.clear();
                                                                }
                                                                for(int i = 0; i < selectedIndexList.length; i++ ){
                                                                  var existingItem = categoryModel.data.firstWhere((itemToCheck) =>
                                                                  itemToCheck.id == selectedIndexList[i].toString(), orElse: () => null);
                                                                  selectedCategoriesList.add(existingItem);
                                                                }
                                                                setState(() {
                                                                });
                                                                },
                                                              child: Padding(
                                                                padding: EdgeInsets.only(right: 10),
                                                                child: Icon(Icons.check_box_rounded,
                                                                  color: AppTheme.primaryColor,
                                                                ),
                                                              ),
                                                            ),
                                                            Text("${selectedCategoriesList[index].title}",style: TextStyle(color: AppTheme.black,
                                                              fontWeight: FontWeight.w500,fontFamily: AppConstants.fontName,),),
                                                          ],
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: (){
                                                          print("locationId=${loginResponse.location.locationId}");
                                                          print("cat id=${selectedCategoriesList[index].id}");
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return CategoriesServicesDialog(title: selectedCategoriesList[index].title,categoryId: selectedCategoriesList[index].id,locationId:loginResponse.location.locationId);
                                                            },);
                                                          },
                                                        child: Row(
                                                          children: [
                                                            Text("${selectedCategoriesList[index].serviceCount}",style: TextStyle(color: AppTheme.black,
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
                                            separatorBuilder: (context, index) {
                                              return Divider();
                                            },
                                          )
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 50, right: 50,bottom: 25),
                                        width: MediaQuery.of(context).size.width,
                                        child: GradientElevatedButton(
                                          onPressed: () async {
                                            BaseResponse response = await getIt.get<CategoryListRemoteDataSourceImpl>()
                                                .saveCategories(loginResponse.data.id,selectedIndexList);
                                            if(response != null){
                                              AppUtils.showToast(response.message, true);
                                              Navigator.pop(context);
                                              Navigator.push(context, MaterialPageRoute(
                                                  builder: (BuildContext context) => SetupProfileScreen())
                                              );
                                            }
                                          },
                                          //onPressed: validateAndSave(isSubmitPressed: true),
                                          buttonText: labelSaveNext,),
                                      ),
                                    ],
                                  )
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 45, 0, 0),
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Select your category",
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
              }
          }
        });
  }

  void showCategoryDialog(CategoryModel categoryModel) {
    showDialog(
      context: context,
      builder: (context) {
        return CategoriesDialog(categoryResponse:categoryModel,selectedIndexIdList:selectedIndexList);
      },
    ).then((selectedCategoriesListData){
      if(selectedCategoriesListData != null){
        setState(() {
          selectedIndexList = selectedCategoriesListData;
        });
        selectedCategoriesList.clear();
        for(int i = 0; i < selectedIndexList.length; i++ ){
          var existingItem = categoryModel.data.firstWhere((itemToCheck) =>
          itemToCheck.id == selectedIndexList[i].toString(), orElse: () => null);
          selectedCategoriesList.add(existingItem);
        }
        setState(() {
        });
      }
    });
  }
}