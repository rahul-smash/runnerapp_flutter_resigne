import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/pending_summary_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/payout_repository.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class ChoosePaymentMethods extends StatefulWidget {
  ChoosePaymentMethods();

  @override
  _ChoosePaymentMethodsState createState() {
    return _ChoosePaymentMethodsState();
  }
}

class _ChoosePaymentMethodsState extends BaseState<ChoosePaymentMethods> {

  bool isCashOptionSelected = true;
  @override
  void initState() {
    super.initState();
    isCashOptionSelected = true;
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
          callback: () {
            Navigator.of(context).pop();
          },
          backBtnColor: Colors.white,
          backgroundColor: AppTheme.primaryColor,
          title: Text(
            "",
            style: TextStyle(color: Colors.white),
          ),
          appBar: AppBar(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            backwardsCompatibility: false,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: AppTheme.optionTotalCustomerBgColor,
                statusBarIconBrightness: Brightness.dark),
            elevation: 0.0,
            titleSpacing: 0.0,
          ),
          widgets: <Widget>[
          ],
        ),
        backgroundColor: AppTheme.backgroundGeryColor,
        body: Container(
          child: Stack(
            children: [
              Container(
                height: Dimensions.getScaledSize(160),
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
                          topLeft: const Radius.circular(35.0),
                          topRight: const Radius.circular(35.0))),
                  margin: EdgeInsets.fromLTRB(25, Dimensions.getScaledSize(100), 25, 0),
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: Dimensions.getScaledSize(10),
                      ),
                       Expanded(
                         child: Container(
                           margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                           child: Row(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Expanded(
                                 child: Stack(
                                   children: [
                                     Container(
                                       height: 200,
                                       width: 200,
                                       color: Colors.white,
                                       child: Column(
                                         children: [
                                           SizedBox(height: 10,),
                                           InkWell(
                                             onTap: (){
                                               setState(() {
                                                 isCashOptionSelected = true;
                                               });
                                             },
                                             child: Container(
                                               height: 150,width: double.infinity,
                                               decoration: BoxDecoration(
                                                 boxShadow: isCashOptionSelected ? null : shadow,
                                                 color: Colors.white,
                                                 border: isCashOptionSelected
                                                     ? Border.all(
                                                   color: AppTheme.payoutCompleteGreen,
                                                   width: 1.0 ,
                                                 )
                                                     : null,
                                                 borderRadius: BorderRadius.circular(25),
                                               ),
                                               child: Column(
                                                 mainAxisAlignment: MainAxisAlignment.center,
                                                 crossAxisAlignment: CrossAxisAlignment.center,
                                                 children: [
                                                   Container(
                                                     height: 80,
                                                     width: 80,
                                                     decoration: BoxDecoration(
                                                       color: AppTheme.payoutCompleteGreen,
                                                       shape: BoxShape.circle,
                                                     ),
                                                     padding: EdgeInsets.only(left: 25,right: 25),
                                                     child: Image.asset("lib/src/components/dashboard/images/cash_icon.png",
                                                       width: 20,height: 20,fit: BoxFit.scaleDown,),
                                                   ),
                                                   SizedBox(height: 10,),
                                                   Text(
                                                     "Cash",
                                                     textAlign: TextAlign.center,
                                                     style: TextStyle(
                                                       fontSize: 16.0,
                                                       color: AppTheme.mainTextColor,
                                                       fontWeight: FontWeight.w500,
                                                       fontFamily: AppConstants.fontName,
                                                     ),
                                                   ),
                                                 ],
                                               ),
                                             ),
                                           ),
                                         ],
                                       ),
                                     ),
                                     Visibility(
                                       visible: isCashOptionSelected ? true : false,
                                       child: Positioned.fill(
                                         child: Align(
                                           alignment: Alignment.topRight,
                                           child: Container(
                                             //margin: EdgeInsets.only(left: 40, right: 0,bottom: 20),
                                               height: 30,
                                               width: 30,
                                               decoration: BoxDecoration(
                                                 color: AppTheme.payoutCompleteGreen,
                                                 shape: BoxShape.circle,
                                               ),
                                               child: Icon(Icons.done,color: Colors.white,)
                                           ),
                                         ),
                                       ),
                                     )
                                   ],
                                 )
                               ),
                               SizedBox(width: 20,),
                               Expanded(
                                 child: Stack(
                                   children: [
                                     Container(
                                       height: 200,
                                       width: 200,
                                       color: Colors.white,
                                       child: Column(
                                         children: [
                                           SizedBox(height: 10,),
                                           InkWell(
                                             onTap: (){
                                               setState(() {
                                                 isCashOptionSelected = false;
                                               });
                                             },
                                             child: Container(
                                               height: 150,
                                               width: double.infinity,
                                               decoration: BoxDecoration(
                                                 boxShadow: isCashOptionSelected ? shadow : null,
                                                 color: Colors.white,
                                                 border: isCashOptionSelected
                                                     ? null
                                                     : Border.all(
                                                   color: AppTheme.payoutCompleteGreen,
                                                   width: 1.0 ,
                                                 ),
                                                 borderRadius: BorderRadius.circular(25),
                                               ),
                                               child: Column(
                                                 mainAxisAlignment: MainAxisAlignment.center,
                                                 crossAxisAlignment: CrossAxisAlignment.center,
                                                 children: [
                                                   Container(
                                                     height: 80,
                                                     width: 80,
                                                     decoration: BoxDecoration(
                                                       color: AppTheme.orange,
                                                       shape: BoxShape.circle,
                                                     ),
                                                     padding: EdgeInsets.only(left: 25,right: 25),
                                                     child: Image.asset("lib/src/components/dashboard/images/bank_transfer_icon.png",
                                                       width: 20,height: 20,fit: BoxFit.scaleDown,),
                                                   ),
                                                   SizedBox(height: 10,),
                                                   Text(
                                                     "Bank Transfer",
                                                     textAlign: TextAlign.center,
                                                     style: TextStyle(
                                                       fontSize: 16.0,
                                                       color: AppTheme.mainTextColor,
                                                       fontWeight: FontWeight.w500,
                                                       fontFamily: AppConstants.fontName,
                                                     ),
                                                   ),
                                                 ],
                                               ),
                                             ),
                                           ),
                                         ],
                                       ),
                                     ),
                                     Visibility(
                                       visible: isCashOptionSelected ? false : true,
                                       child: Positioned.fill(
                                         child: Align(
                                           alignment: Alignment.topRight,
                                           child: Container(
                                             //margin: EdgeInsets.only(left: 40, right: 0,bottom: 20),
                                               height: 30,
                                               width: 30,
                                               decoration: BoxDecoration(
                                                 color: AppTheme.payoutCompleteGreen,
                                                 shape: BoxShape.circle,
                                               ),
                                               child: Icon(Icons.done,color: Colors.white,)
                                           ),
                                         ),
                                       ),
                                     )
                                   ],
                                 )
                               )
                             ],
                           ),
                         ),
                       )
                    ],
                  )),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 40,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    labelChoosePaymentMethodTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppConstants.fontName,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 30,height: 3,color: Colors.white,
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      margin: EdgeInsets.only(left: 40, right: 40,bottom: 80),
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset("lib/src/components/dashboard/images/payment_method_graphic.png",
                      width: Dimensions.getScaledSize(150),height: Dimensions.getScaledSize(150),)
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.only(left: 50, right: 50,bottom: 20),
                    width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
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
                        Row(
                          children: [
                            SizedBox(width: 20,),
                            Text("${AppConstants.currency} ",
                                style: TextStyle(
                                    color: AppTheme.white.withOpacity(0.7),
                                    fontSize: AppConstants.extraSmallSize,
                                    fontWeight: FontWeight.w600)
                            ),
                            Text("23000",
                                style: TextStyle(
                                    color: AppTheme.white,
                                    fontSize: AppConstants.largeSize2X,
                                    fontWeight: FontWeight.w600)
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Text("Pay",
                              style: TextStyle(
                                  color: AppTheme.white,
                                  fontSize: AppConstants.largeSize2X,
                                  fontWeight: FontWeight.w600)
                          ),
                        ),
                      ],
                    )
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _cardItem(PendingPayout pendingPayout) {
    return InkWell(
      onTap: () {
        if (this.network.offline) {
          AppUtils.showToast(AppConstants.noInternetMsg, false);
          return;
        }
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
        decoration: new BoxDecoration(
            boxShadow: shadow,
            borderRadius: BorderRadius.all(Radius.circular(35)),
            color: Colors.white),
        child: Container(
            width: double.infinity,
            //height: 140,
            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 15, 5, 5),
                  child: Text(
                      "#${pendingPayout.orderId} | ${AppUtils.convertDateFormat(pendingPayout.bookingDateTime, parsingPattern: AppUtils.dateTimeAppDisplayPattern_1)}",
                      style: TextStyle(
                        color: AppTheme.subHeadingTextColor,
                        fontSize: AppConstants.extraSmallSize,
                        fontFamily: AppConstants.fontName,
                      )),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
                  height: 1,
                  width: double.maxFinite,
                  color: AppTheme.borderOnFocusedColor,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${pendingPayout.categoryTitle}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: AppConstants.largeSize,
                                  color: AppTheme.mainTextColor,
                                  fontFamily: AppConstants.fontName,
                                  fontWeight: FontWeight.w600),
                            ),
                            Wrap(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${AppConstants.currency} ",
                                    style: TextStyle(
                                        color: AppTheme.subHeadingTextColor,
                                        fontSize: AppConstants.smallSize,
                                        fontWeight: FontWeight.w600)),
                                Text("${pendingPayout.totalAmount}",
                                    style: TextStyle(
                                        color: AppTheme.subHeadingTextColor,
                                        fontSize: AppConstants.largeSize,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  width: 5,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: new BoxDecoration(
                                          color:
                                              AppTheme.containerBackgroundColor,
                                          borderRadius: new BorderRadius.all(
                                              Radius.circular(25.0))),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 3,
                                            bottom: 3),
                                        child: Center(
                                            child: Text(
                                          '${pendingPayout.paymentMethod.toUpperCase()}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppTheme.mainTextColor),
                                        )),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              labelYourPendingAmount,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: AppTheme.mainTextColor,
                                  fontFamily: AppConstants.fontName,
                                  fontWeight: FontWeight.w600),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${AppConstants.currency} ",
                                    style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontSize: AppConstants.smallSize,
                                        fontWeight: FontWeight.w600)),
                                Text("--",
                                    style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontSize: AppConstants.largeSize2X,
                                        fontWeight: FontWeight.w600))
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: pendingPayout.cashDeposit != '0',
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.done_all,
                          color: AppTheme.primaryColorDark,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          labelCashHasBeenDeposited,
                          style: TextStyle(color: AppTheme.primaryColorDark),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
              ],
            )),
      ),
    );
  }
}
