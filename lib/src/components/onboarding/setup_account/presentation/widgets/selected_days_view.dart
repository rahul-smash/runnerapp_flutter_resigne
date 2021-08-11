import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/callbacks.dart';

class SelectedDaysView extends StatefulWidget {
  SelectedDaysView();

  @override
  _SelectedDaysViewState createState() {
    return _SelectedDaysViewState();
  }
}

class _SelectedDaysViewState extends State<SelectedDaysView> {

  List<String> selectedDaysList = [];
  String openTime;
  String closeTime;
  bool isSaveBtnPressed = false;

  @override
  void initState() {
    super.initState();
    eventBus.on<DaysSelected>().listen((event) {
      print("event.daysList=${event.daysList} isSaveBtnPressed=${event.isSaveBtnPressed}");
      if(event.isSaveBtnPressed){
        setState(() {
          isSaveBtnPressed = event.isSaveBtnPressed;
          selectedDaysList = event.daysList;
          openTime = event.openTime;
          closeTime = event.closeTime;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20,top: 10, bottom: 20),
      width: double.infinity,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: selectedDaysList.length,
        itemBuilder: (context,index){

          return Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Text(
                      "${selectedDaysList[index]}",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: AppTheme.mainTextColor,
                        fontFamily: AppConstants.fontName,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      "${openTime}",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: AppTheme.mainTextColor,
                        fontFamily: AppConstants.fontName,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      "${closeTime}",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: AppTheme.mainTextColor,
                        fontFamily: AppConstants.fontName,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: InkWell(
                      onTap: (){

                      },
                      child: Container(
                        child: Icon(Icons.clear),
                      ),
                    )
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}