import 'dart:async';
import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';

import 'image_picker_handler.dart';

class ImagePickerDialog extends StatelessWidget {

  ImagePickerHandler _listener;
  BuildContext context;

  ImagePickerDialog(this._listener);

  void initState() {

  }

  getImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return this;
      },
    );
  }

  dismissDialog() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return dialogView();
  }

  Widget dialogView(){

    return Material(
        type: MaterialType.transparency,
        child: Opacity(
          opacity: 1.0,
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: Dimensions.getHeight(percentage: 30),
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 20,right: 20,bottom: 10),
                  decoration: BoxDecoration(
                      boxShadow: shadow,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Text(
                        "Select Image",
                        style: TextStyle(
                            fontSize: Dimensions.getScaledSize(18),
                            color: AppTheme.mainTextColor,
                            fontFamily: AppConstants.fontName),
                      ),
                      Text(
                        "From one of the options",
                        style: TextStyle(
                            fontSize: Dimensions.getScaledSize(18),
                            color: AppTheme.subHeadingTextColor,
                            fontFamily: AppConstants.fontName),
                      ),
                      SizedBox(height: 20,),
                      InkWell(
                        onTap: () => _listener.openCamera(),
                        child: Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: (){
                                  }, icon: Icon(Icons.camera_alt,color: Color(0xff007AFF),)
                              ),

                              Expanded(
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      "Camera",
                                      style: TextStyle(
                                          fontSize: Dimensions.getScaledSize(22),
                                          color: Color(0xff007AFF),
                                          fontFamily: AppConstants.fontName),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 25,),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      InkWell(
                        onTap: () => _listener.openGallery(),
                        child: Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: (){
                                  }, icon: Icon(Icons.image,color:Color(0xff007AFF),)
                              ),

                              Expanded(
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      "Gallery",
                                      style: TextStyle(
                                          fontSize: Dimensions.getScaledSize(22),
                                          color: Color(0xff007AFF),
                                          fontFamily: AppConstants.fontName),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 25,),
                            ],
                          ),
                        ),
                      )

                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    dismissDialog();
                  },
                  child: Container(
                    height: Dimensions.getHeight(percentage: 8),
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 0),
                    decoration: BoxDecoration(
                        boxShadow: shadow,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white
                    ),
                    child: Container(
                      margin: EdgeInsets.only(left: 20,right: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Center(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dimensions.getScaledSize(20),
                                      color: AppTheme.primaryColor,
                                      fontFamily: AppConstants.fontName),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )

              ],
            ),
        )
    );
  }

  Widget roundedButton(
      String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(15.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.all(const Radius.circular(100.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF696969),
            offset: Offset(1.0, 6.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: new TextStyle(
            color: textColor, fontSize: 18.0, fontWeight: FontWeight.normal),
      ),
    );
    return loginBtn;
  }

}
