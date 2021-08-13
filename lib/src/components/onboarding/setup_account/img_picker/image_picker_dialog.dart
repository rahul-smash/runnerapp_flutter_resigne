import 'dart:async';
import 'package:flutter/material.dart';
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
    return new Material(
        type: MaterialType.transparency,
        child: new Opacity(
          opacity: 1.0,
          child: new Container(
            padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                 GestureDetector(
                  onTap: () => _listener.openCamera(),
                  child: roundedButton(
                      "Camera",
                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      AppTheme.primaryColor,
                      const Color(0xFFFFFFFF)),
                ),
                 GestureDetector(
                  onTap: () => _listener.openGallery(),
                  child: roundedButton(
                      "Gallery",
                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      AppTheme.primaryColor,
                      const Color(0xFFFFFFFF)),
                ),
                SizedBox(height: 15.0),
                GestureDetector(
                  onTap: () => dismissDialog(),
                  child: new Padding(
                    padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                    child: roundedButton(
                        "Cancel",
                        EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        AppTheme.primaryColor,
                        const Color(0xFFFFFFFF)),
                  ),
                ),
              ],
            ),
          ),
        ));
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
