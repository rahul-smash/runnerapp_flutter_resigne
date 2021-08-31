import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';

class PendingPayouts extends StatefulWidget {

  PendingPayouts();

  @override
  _PendingPayoutsState createState() {
    return _PendingPayoutsState();
  }
}

class _PendingPayoutsState extends BaseState<PendingPayouts> {

  String _selectedOverviewOption = 'Today';
  List<String> _overviewOptions = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _overviewOptions.add('Today');
    _overviewOptions.add('Yesterday');
    _overviewOptions.add('7 days');
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
          removeTitleSpacing: true,
          callback: (){
            Navigator.of(context).pop();
          },
          backBtnColor: Colors.white,
          backgroundColor: AppTheme.optionTotalCustomerBgColor,
          title: Text('Payout Pending',style: TextStyle(color: Colors.white),),
          appBar: AppBar(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            backwardsCompatibility: false,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: AppTheme.optionTotalCustomerBgColor,
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
            Container(
              margin: EdgeInsets.only(right: 25),
              child: PopupMenuButton(
                elevation: 3.2,
                iconSize: 5.0,
                tooltip: 'Sorting',
                child: Row(
                  children: [
                    Text(
                      _selectedOverviewOption,
                      style: TextStyle(
                          color: AppTheme.white,
                          fontSize: AppConstants.smallSize,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      AppImages.icon_dropdownarrow,
                      height: 5,color: Colors.white,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
                onSelected: (value) {
                  _selectedOverviewOption = value;
                },
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(15.0))),
                itemBuilder: (BuildContext context) {
                  return _overviewOptions.map((String choice) {
                    return PopupMenuItem(
                      value: choice,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            choice,
                            style: TextStyle(
                                color: _selectedOverviewOption ==
                                    choice
                                    ? AppTheme.primaryColorDark
                                    : AppTheme.mainTextColor),
                          ),
                          Visibility(
                              visible: _selectedOverviewOption ==
                                  choice,
                              child: Icon(
                                Icons.check,
                                color: AppTheme.primaryColorDark,
                              ))
                        ],
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ],
        ),
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
                      AppTheme.optionTotalCustomerBgColor,
                      AppTheme.optionTotalCustomerBgColor,
                      AppTheme.optionTotalCustomerBgColor,
                      AppTheme.optionTotalCustomerBgColor,
                    ],
                  ),
                ),
              ),
              Container(
                  width: SizeConfig.screenWidth,
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                          topLeft:  const  Radius.circular(35.0),
                          topRight: const  Radius.circular(35.0))
                  ),
                  margin: EdgeInsets.fromLTRB(25,  100, 25, 0),
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: Dimensions.getScaledSize(10),),
                      Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: (){
                                  if(this.network.offline){
                                    AppUtils.showToast(AppConstants.noInternetMsg, false);
                                    return;
                                  }

                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(5,10,5,0),
                                  decoration: new BoxDecoration(
                                      boxShadow: shadow,
                                      borderRadius: BorderRadius.all(Radius.circular(35)),
                                      color: Colors.white
                                  ),
                                  child: Container(
                                      width: double.infinity,
                                      //height: 140,
                                      margin: EdgeInsets.fromLTRB(0,5,0,0),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(15,15,5,5),
                                            child: Row(
                                              children: [
                                                Text("# 1855 f/1",
                                                    style: TextStyle(color: AppTheme.subHeadingTextColor,
                                                      fontFamily: AppConstants.fontName,)
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(10,0,10,0),
                                                  height: 15,width: 1,color: AppTheme.borderOnFocusedColor,
                                                ),
                                                Text("29 July, 2021, 3:30 PM",
                                                    style: TextStyle(color: AppTheme.subHeadingTextColor,
                                                      fontFamily: AppConstants.fontName,)
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(10,2,10,2),
                                            height: 1,width: double.infinity,color: AppTheme.borderOnFocusedColor,
                                          ),
                                          Container(
                                            height: 45,
                                            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Electricians",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: AppTheme.mainTextColor,
                                                          fontFamily: AppConstants.fontName,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("${AppConstants.currency} ",
                                                              style: TextStyle(
                                                                  color: AppTheme.subHeadingTextColor,
                                                                  fontSize: AppConstants.smallSize,
                                                                  fontWeight: FontWeight.w600)
                                                          ),
                                                          Text("23000",
                                                              style: TextStyle(
                                                                  color: AppTheme.subHeadingTextColor,
                                                                  fontSize: AppConstants.largeSize2X,
                                                                  fontWeight: FontWeight.w600)
                                                          ),
                                                          SizedBox(width: 5,),
                                                          Container(
                                                            decoration: new BoxDecoration(
                                                                color: AppTheme.containerBackgroundColor,
                                                                borderRadius: new BorderRadius.all(Radius.circular(25.0))
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets.only(left: 10,right: 10,top: 3,bottom: 3),
                                                              child: Center(
                                                                  child: Text("Cash",textAlign: TextAlign.center,
                                                                    style: TextStyle(color: AppTheme.mainTextColor),)
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),

                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Your Pending Amount",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          color:AppTheme.mainTextColor,
                                                          fontFamily: AppConstants.fontName,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("${AppConstants.currency} ",
                                                            style: TextStyle(
                                                                color: AppTheme.primaryColor,
                                                                fontSize: AppConstants.smallSize,
                                                                fontWeight: FontWeight.w600)
                                                        ),
                                                        Text("23000",
                                                            style: TextStyle(
                                                                color: AppTheme.primaryColor,
                                                                fontSize: AppConstants.largeSize2X,
                                                                fontWeight: FontWeight.w600)
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
                                            child: Row(
                                              children: [
                                                Icon(Icons.done_all,color: AppTheme.primaryColorDark,size: 20,),
                                                SizedBox(width: 10,),
                                                Text("Cash has been deposited",style: TextStyle(color: AppTheme.primaryColorDark),)

                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                              );
                            },
                          )
                      ),
                    ],
                  )
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      margin: EdgeInsets.fromLTRB(Dimensions.getScaledSize(65), 0, 0, 0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Payout Pending",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white.withOpacity(0.8),
                                  fontFamily: AppConstants.fontName,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${AppConstants.currency} ",
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: AppConstants.smallSize,
                                          fontWeight: FontWeight.w600)
                                  ),
                                  Text("23000",
                                      style: TextStyle(
                                          color: AppTheme.white,
                                          fontSize: AppConstants.largeSize2X,
                                          fontWeight: FontWeight.w600)
                                  )
                                ],
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20,right: 20),
                            width: 1,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Number ofOrders",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white.withOpacity(0.8),
                                  fontFamily: AppConstants.fontName,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 10,),
                                  Text("23",
                                      style: TextStyle(
                                          color: AppTheme.white,
                                          fontSize: AppConstants.largeSize2X,
                                          fontWeight: FontWeight.w600)
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(Dimensions.getScaledSize(65), 30,
                          Dimensions.getScaledSize(40), 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "10 Results",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                              fontFamily: AppConstants.fontName,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.keyboard_arrow_left,color: Colors.white,),
                              Text(
                                "Year 2021",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  fontFamily: AppConstants.fontName,
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_right,color: Colors.white,),
                            ],
                          )

                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: 40.0,
                    foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.5),
                          Colors.white.withOpacity(0.5),
                          Colors.white.withOpacity(0.8),
                          Colors.white
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.5, 0.5, 0.8, 0.5],
                      ),
                    ),
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