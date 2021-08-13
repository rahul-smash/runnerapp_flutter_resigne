import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/onboarding/select_category/models/category_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/select_category/models/category_service_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/select_category/repository/categorys_list_network_datasource.dart';
import 'package:marketplace_service_provider/src/singleton/store_config_singleton.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

import 'dotted_divider.dart';

class CategoriesServicesDialog extends StatefulWidget {

  final String categoryId;
  final String locationId;
  final String title;
  CategoriesServicesDialog({this.categoryId, this.locationId,this.title});

  @override
  _CategoriesServicesDialogState createState() {
    return _CategoriesServicesDialogState();
  }
}

class _CategoriesServicesDialogState extends State<CategoriesServicesDialog> {

  List<int> selectedIndexList = [];

  @override
  Widget build(BuildContext context) {

    return Dialog(
      insetPadding: EdgeInsets.only(left: 15,right: 15,top: 30,bottom: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.clear,color: Colors.black,),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            width: MediaQuery.of(context).size.width,
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontFamily: AppConstants.fontName,
                  fontWeight: FontWeight.w700
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10,right: 10),
              child: FutureBuilder<CategoryServiceModel>(
                future: getIt.get<CategoryListRemoteDataSourceImpl>().getCategoriesServices(widget.locationId, widget.categoryId), // async work
                builder: (BuildContext context, AsyncSnapshot<CategoryServiceModel> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return AppUtils.showSpinner();
                    default:
                      if (snapshot.hasError){
                        return Text('Error: ${snapshot.error}');
                      }else{
                        CategoryServiceModel categoryServiceModel = snapshot.data;
                        if(categoryServiceModel == null){
                          return AppUtils.showSpinner();
                        }else{
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: categoryServiceModel.data.length,
                            itemBuilder: (context,index){
                              ServiceData serviceData = categoryServiceModel.data[index];
                              return Column(
                                children: [
                                  ListTile(
                                    hoverColor: Colors.transparent,
                                    onTap: (){
                                    },
                                    title: Row(
                                      children: [
                                        Text("•",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: AppTheme.primaryColor,
                                              fontWeight: FontWeight.bold
                                          ),),
                                        SizedBox(width: 10,),
                                        Text("${serviceData.title}",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.grey,
                                              fontFamily: AppConstants.fontName,
                                              fontWeight: FontWeight.normal
                                          ),),
                                      ],
                                    ),
                                    subtitle: Container(
                                      margin: EdgeInsets.only(left: Dimensions.getScaledSize(20)),
                                      child: ListView.builder(
                                          itemCount: serviceData.products.length,
                                          physics: ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context, int index) {
                                            Product product = serviceData.products[index];
                                            return ListTile(
                                              contentPadding: EdgeInsets.all(0),
                                              title: Text("${product.title}",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.black,
                                                    fontFamily: AppConstants.fontName,
                                                    fontWeight: FontWeight.w500
                                                ),),
                                              subtitle: Text("${product.variants[0].duration}",
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.grey,
                                                    fontFamily: AppConstants.fontName,
                                                    fontWeight: FontWeight.normal
                                                ),),
                                              trailing: Container(
                                                margin: EdgeInsets.only(bottom: Dimensions.getScaledSize(15)),
                                                child: Text("${StoreConfigurationSingleton.instance.configModel.currency} ${product.variants[0].price}",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.black,
                                                      fontFamily: AppConstants.fontName,
                                                      fontWeight: FontWeight.w600
                                                  ),),
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                  Container(
                                    child: DottedDivider(color: Colors.grey),
                                    margin: EdgeInsets.only(left: Dimensions.getScaledSize(40),bottom: Dimensions.getScaledSize(20)),
                                  ),
                                ],
                              );
                            },
                          );
                        }

                      }

                  }
                },
              )
            ),
          ),

        ],
      ),
    );
  }

  Widget showMarkedView(bool contains) {
    if(contains){
      return Container(
        width: Dimensions.getScaledSize(40),
        height: Dimensions.getScaledSize(40),
        child: Icon(Icons.done, size: 20,color: Colors.white,),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.primaryColor),
      );
    }else{
      return Container(
        width: Dimensions.getScaledSize(40),
        height: Dimensions.getScaledSize(40),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.grayCircle),
      );
    }
  }

}