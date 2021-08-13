import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/src/components/onboarding/select_category/models/category_model.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class CategoriesDialog extends StatefulWidget {

  final CategoryModel categoryResponse;
  List<int> selectedIndexIdList;
  CategoriesDialog({this.categoryResponse, this.selectedIndexIdList});

  @override
  _CategoriesDialogState createState() {
    return _CategoriesDialogState();
  }
}

class _CategoriesDialogState extends State<CategoriesDialog> {

  List<int> selectedIndexList = [];

  @override
  void initState() {
    super.initState();
    if(widget.selectedIndexIdList == null){
      widget.selectedIndexIdList = [];
    }else{
      selectedIndexList = widget.selectedIndexIdList;
    }
  }

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
              "Select categories",
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
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.categoryResponse.data.length,
                itemBuilder: (context,index){
                  CategoryData categoryData = widget.categoryResponse.data[index];
                  return ListTile(
                    hoverColor: Colors.transparent,
                    onTap: (){
                      //print("--selectedIndexList=${selectedIndexList} = ${categoryData.id}");
                      if(selectedIndexList.contains(int.parse(categoryData.id))){
                        selectedIndexList.remove(int.parse(categoryData.id));
                      }else{
                        selectedIndexList.add(int.parse(categoryData.id));
                      }
                      setState(() {
                      });
                    },
                    title: Text(widget.categoryResponse.data[index].title,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontFamily: AppConstants.fontName,
                          fontWeight: FontWeight.w500
                      ),),
                    trailing: showMarkedView(selectedIndexList.contains(int.parse(categoryData.id)))
                  );
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 30, right: 30,bottom: 20),
            width: MediaQuery.of(context).size.width,
            child: GradientElevatedButton(
              onPressed: (){
                //print("1onTap.selectedIndex=${selectedIndex}");
                Navigator.pop(context,selectedIndexList);
              },
              buttonText: labelSave,),
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