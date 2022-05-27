import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/deposit_history.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/deposit_history_details.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/due_payout_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/payout_repository.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';

class DuePayoutDetailScreen extends StatefulWidget {
  // DepositDatum depositDatum;

  // DuePayoutDetailScreen(this.depositDatum);

  @override
  _DuePayoutDetailScreenState createState() {
    return _DuePayoutDetailScreenState();
  }
}

class _DuePayoutDetailScreenState extends BaseState<DuePayoutDetailScreen> {
  String _selectedOverviewOption = 'Monthly';
  List<String> _overviewOptions = List.empty(growable: true);
  bool isApiLoading = false;
  DuePayoutResponse duePayoutResponse;

  @override
  void initState() {
    super.initState();
    _overviewOptions.add('Monthly');
    _overviewOptions.add('Yesterday');
    _overviewOptions.add('7 days');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getDuePayoutSummary();
    });
  }

  void _onRefresh() async {
    _getDuePayoutSummary(isShowLoader: true);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        removeTitleSpacing: true,
        callback: () {
          Navigator.of(context).pop();
        },
        backBtnColor: Colors.white,
        backgroundColor: AppTheme.primaryColor,
        title: Text(
          'Due Payout',
          style: TextStyle(color: Colors.white),
        ),
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light),
          elevation: 0.0,
          titleSpacing: 0.0,
        ),
        widgets: <Widget>[],
      ),
      backgroundColor: Color(0xFFECECEC),
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Container(
                height: 180,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(0)),
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
                  margin: EdgeInsets.fromLTRB(0, 115, 0, 0),
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: Dimensions.getScaledSize(10),
                      ),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  height: 50,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "Order ID",
                                        overflow: TextOverflow.visible,
                                        softWrap: true,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "Order recieved",
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "Payment mode",
                                        overflow: TextOverflow.visible,
                                        softWrap: true,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text("Paid by customer",
                                          overflow: TextOverflow.visible,
                                          softWrap: true),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text("Items total",
                                          overflow: TextOverflow.visible,
                                          softWrap: true),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text("Commission",
                                          overflow: TextOverflow.visible,
                                          softWrap: true),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text("Net Recievable from delivery boy",
                                          overflow: TextOverflow.visible,
                                          softWrap: true),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: SizeConfig.getDeviceHeight(context),
                                    width: Dimensions.getWidth(percentage: 200),
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) {
                                        return Divider();
                                      },
                                      shrinkWrap: true,
                                      itemCount:
                                          duePayoutResponse?.data?.length ?? 0,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                            onTap: () {
                                              if (this.network.offline) {
                                                AppUtils.showToast(
                                                    AppConstants.noInternetMsg,
                                                    false);
                                                return;
                                              }
                                            },
                                            child:
                                                // ListView.builder(
                                                //     itemCount: 1,
                                                //     physics: ScrollPhysics(),
                                                //     scrollDirection: Axis.horizontal,
                                                //     shrinkWrap: true,
                                                //     itemBuilder: (context, _) {
                                                //       return
                                                Container(
                                              width: double.infinity,
                                              margin: EdgeInsets.fromLTRB(
                                                  35, 5, 0, 5),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    child: Text(
                                                        duePayoutResponse
                                                            ?.data[index]
                                                            .order
                                                            .displayOrderId,
                                                        overflow: TextOverflow
                                                            .visible,
                                                        softWrap: true),
                                                  ),
                                                  SizedBox(
                                                    width: 30,
                                                  ),
                                                  Container(
                                                    width: Dimensions.getWidth(
                                                        percentage: 25),
                                                    child: Text(
                                                        convertedDate(
                                                            duePayoutResponse
                                                                ?.data[index]
                                                                .order
                                                                .created),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: AppTheme
                                                                .mainTextColor),
                                                        overflow: TextOverflow
                                                            .visible,
                                                        maxLines: 2,
                                                        softWrap: true),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Container(
                                                    width: Dimensions.getWidth(
                                                        percentage: 20),
                                                    child: Text(
                                                        duePayoutResponse
                                                            ?.data[index]
                                                            .order
                                                            .paymentMethod,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: AppTheme
                                                                .mainTextColor),
                                                        overflow: TextOverflow
                                                            .visible,
                                                        softWrap: true),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: Dimensions.getWidth(
                                                        percentage: 35),
                                                    child: Text(
                                                        duePayoutResponse
                                                            ?.data[index]
                                                            .order
                                                            .total,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: AppTheme
                                                                .subHeadingTextColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                        overflow: TextOverflow
                                                            .visible,
                                                        softWrap: true),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    width: Dimensions.getWidth(
                                                        percentage: 20),
                                                    child: Text(
                                                        duePayoutResponse
                                                            ?.data[index]
                                                            .order
                                                            .checkoutBeforeCommission,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: AppTheme
                                                                .subHeadingTextColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                        overflow: TextOverflow
                                                            .visible,
                                                        softWrap: true),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    width: Dimensions.getWidth(
                                                        percentage: 20),
                                                    child: Text(
                                                        duePayoutResponse
                                                            ?.data[index]
                                                            .order
                                                            .commission,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: AppTheme
                                                                .subHeadingTextColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                        overflow: TextOverflow
                                                            .visible,
                                                        softWrap: true),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Container(
                                                    width: Dimensions.getWidth(
                                                        percentage: 20),
                                                    child: Text(
                                                        duePayoutResponse
                                                            ?.data[index]
                                                            .order
                                                            .netPayable
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: AppTheme
                                                                .subHeadingTextColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                        overflow: TextOverflow
                                                            .visible,
                                                        softWrap: true),
                                                  ),
                                                  Divider()
                                                ],
                                              ),
                                              // );
                                              // }
                                              // ),
                                            ));
                                      },
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                      //   width: double.infinity,
                      //   height: 2,
                      //   color: Colors.grey[350],
                      // ),
                      // Expanded(
                      //     child: ListView.separated(
                      //       physics: ScrollPhysics(),
                      //       separatorBuilder: (context, index) {
                      //         return Divider();
                      //       },
                      //   shrinkWrap: true,
                      //   itemCount: duePayoutResponse?.data?.length ?? 0,
                      //   itemBuilder: (context, index) {
                      //     return InkWell(
                      //       onTap: () {
                      //         if (this.network.offline) {
                      //           AppUtils.showToast(
                      //               AppConstants.noInternetMsg, false);
                      //           return;
                      //         }
                      //       },
                      //       child: SizedBox(
                      //         height: 50,
                      //         child: ListView.builder(
                      //
                      //             itemCount: 1,
                      //             physics: AlwaysScrollableScrollPhysics(),
                      //             scrollDirection: Axis.horizontal,
                      //             shrinkWrap: true,
                      //             itemBuilder: (context, _) {
                      //               return Container(
                      //
                      //                 // width: double.infinity,
                      //                 margin: EdgeInsets.fromLTRB(15, 5, 0, 5),
                      //                 child: Row(
                      //                   children: [
                      //                     SizedBox(
                      //                       width: 15,
                      //                     ),
                      //                     Container(width: 60,
                      //                       child: Center(
                      //                         child: Text(
                      //                             duePayoutResponse?.data[index]
                      //                                 .order.displayOrderId,
                      //                             overflow: TextOverflow.visible,
                      //                             softWrap: true),
                      //                       ),
                      //                     ),
                      //                     SizedBox(
                      //                       width: 15,
                      //                     ),
                      //                     Container(width: 80,
                      //                       child: Center(
                      //                         child: Text(
                      //                             convertedDate(duePayoutResponse?.data[index]
                      //                                 .order.created),
                      //                             style: TextStyle(
                      //                                 fontWeight: FontWeight.w600,
                      //                                 color:
                      //                                     AppTheme.mainTextColor),
                      //                             overflow: TextOverflow.visible,maxLines: 2,
                      //                             softWrap: true),
                      //                       ),
                      //                     ),
                      //                     SizedBox(
                      //                       width: 25,
                      //                     ),
                      //                     Container(width: 100,
                      //                       child: Center(
                      //                         child: Text(
                      //                             duePayoutResponse?.data[index]
                      //                                 .order.paymentMethod,
                      //                             style: TextStyle(
                      //                                 fontWeight: FontWeight.w600,
                      //                                 color:
                      //                                     AppTheme.mainTextColor),
                      //                             overflow: TextOverflow.visible,
                      //                             softWrap: true),
                      //                       ),
                      //                     ),
                      //                     SizedBox(
                      //                       width: 15,
                      //                     ),
                      //                     Container(width: 80,
                      //                       child: Center(
                      //                         child: Text(
                      //                             duePayoutResponse
                      //                                 ?.data[index].order.total,
                      //                             style: TextStyle(
                      //                                 color: AppTheme
                      //                                     .subHeadingTextColor,
                      //                                 fontSize: 16,
                      //                                 fontWeight: FontWeight.w600),
                      //                             overflow: TextOverflow.visible,
                      //                             softWrap: true),
                      //                       ),
                      //                     ),
                      //                     SizedBox(
                      //                       width: 15,
                      //                     ),
                      //                     Container(width: 60,
                      //                       child: Center(
                      //                         child: Text(
                      //                             duePayoutResponse
                      //                                 ?.data[index].order.checkoutBeforeCommission,
                      //                             style: TextStyle(
                      //                                 color: AppTheme
                      //                                     .subHeadingTextColor,
                      //                                 fontSize: 16,
                      //                                 fontWeight: FontWeight.w600),
                      //                             overflow: TextOverflow.visible,
                      //                             softWrap: true),
                      //                       ),
                      //                     ),
                      //                     SizedBox(
                      //                       width: 15,
                      //                     ),
                      //                     Container(width: 60,
                      //                       child: Center(
                      //                         child: Text(
                      //                             duePayoutResponse?.data[index]
                      //                                 .order.commission,
                      //                             style: TextStyle(
                      //                                 color: AppTheme
                      //                                     .subHeadingTextColor,
                      //                                 fontSize: 16,
                      //                                 fontWeight: FontWeight.w600),
                      //                             overflow: TextOverflow.visible,
                      //                             softWrap: true),
                      //                       ),
                      //                     ),
                      //                     SizedBox(
                      //                       width: 15,
                      //                     ),
                      //                     Container(width: 60,
                      //                       child: Center(
                      //                         child: Text(
                      //                             duePayoutResponse
                      //                                 ?.data[index].order.netPayable
                      //                                 .toString(),
                      //                             style: TextStyle(
                      //                                 color: AppTheme
                      //                                     .subHeadingTextColor,
                      //                                 fontSize: 16,
                      //                                 fontWeight: FontWeight.w600),
                      //                             overflow: TextOverflow.visible,
                      //                             softWrap: true),
                      //                       ),
                      //                     ),
                      //
                      //                     Divider()
                      //                   ],
                      //                 ),
                      //               );
                      //             }),
                      //       ),
                      //     );
                      //   },
                      //
                      // )),
                    ],
                  )),
              // Align(
              //   alignment: Alignment.topLeft,
              //   child: Column(
              //     children: [
              //       Container(
              //         margin: EdgeInsets.fromLTRB(
              //             Dimensions.getScaledSize(55), 0, 40, 0),
              //         child: Row(
              //           children: [
              //             Expanded(
              //               child: Row(
              //                 children: [
              //                   Container(
              //                     margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
              //                     child: Column(
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                       children: [
              //                         Column(
              //                           crossAxisAlignment:
              //                               CrossAxisAlignment.start,
              //                           children: [
              //                             Text(
              //                               "Total Deposit",
              //                               textAlign: TextAlign.start,
              //                               style: TextStyle(
              //                                 fontSize: 14.0,
              //                                 color:
              //                                     Colors.white.withOpacity(0.8),
              //                                 fontFamily: AppConstants.fontName,
              //                               ),
              //                             ),
              //                             Row(
              //                               crossAxisAlignment:
              //                                   CrossAxisAlignment.start,
              //                               children: [
              //                                 Text("${AppConstants.currency}",
              //                                     style: TextStyle(
              //                                         color: Colors.white
              //                                             .withOpacity(0.8),
              //                                         fontSize: AppConstants
              //                                             .smallSize,
              //                                         fontWeight:
              //                                             FontWeight.w600)),
              //                                 Text("0", //change here
              //                                     style: TextStyle(
              //                                         color: AppTheme.white,
              //                                         fontSize: AppConstants
              //                                             .extraLargeSize,
              //                                         fontWeight:
              //                                             FontWeight.w600))
              //                               ],
              //                             )
              //                           ],
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                   Container(
              //                     margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
              //                     width: 1,
              //                     height: 40,
              //                     color: Colors.white.withOpacity(0.7),
              //                   ),
              //                   Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.start,
              //                         children: [
              //                           Text(
              //                             "No. of Orders",
              //                             textAlign: TextAlign.start,
              //                             style: TextStyle(
              //                               fontSize: 14.0,
              //                               color:
              //                                   Colors.white.withOpacity(0.8),
              //                               fontFamily: AppConstants.fontName,
              //                             ),
              //                           ),
              //                           Row(
              //                             crossAxisAlignment:
              //                                 CrossAxisAlignment.start,
              //                             children: [
              //                               Text("0", //change here
              //                                   style: TextStyle(
              //                                       color: AppTheme.white,
              //                                       fontSize: AppConstants
              //                                           .largeSize2X,
              //                                       fontWeight:
              //                                           FontWeight.w600))
              //                             ],
              //                           )
              //                         ],
              //                       ),
              //                     ],
              //                   ),
              //                 ],
              //               ),
              //             ),
              //             Align(
              //               alignment: Alignment.topCenter,
              //               child: Image.asset(
              //                 "lib/src/components/dashboard/images/top_header_tick.png",
              //                 width: Dimensions.getScaledSize(55),
              //                 height: Dimensions.getScaledSize(55),
              //               ),
              //             )
              //           ],
              //         ),
              //       ),
              //       Container(
              //         margin: EdgeInsets.fromLTRB(Dimensions.getScaledSize(65),
              //             30, Dimensions.getScaledSize(40), 0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               "",
              //               textAlign: TextAlign.center,
              //               style: TextStyle(
              //                 fontSize: 14.0,
              //                 color: Colors.white,
              //                 fontFamily: AppConstants.fontName,
              //               ),
              //             ),
              //             // Row(
              //             //   children: [
              //             //     Text("gkuch bhi",
              //             //       // "${AppUtils.convertDateFromFormat(widget.depositDatum?.depositDateTime?.toString() ?? DateTime.now().toString(), parsingPattern: AppUtils.dateTimeAppDisplayPattern_1)}",
              //             //       textAlign: TextAlign.center,
              //             //       style: TextStyle(
              //             //         fontSize: 14.0,
              //             //         color: Colors.white,
              //             //         fontFamily: AppConstants.fontName,
              //             //       ),
              //             //     ),
              //             //   ],
              //             // )
              //           ],
              //         ),
              //       )
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _getDuePayoutSummary({bool isShowLoader = true}) async {
    if (!getIt.get<NetworkConnectionObserver>().offline) {
      if (isShowLoader) AppUtils.showLoader(context);
      isApiLoading = true;
      duePayoutResponse = await getIt
          .get<PayoutRepository>()
          .getDuePayoutData(runnerID: AppSharedPref.instance.getUserId());
      setState(() {});
      AppUtils.hideLoader(context);
      isApiLoading = false;
    } else {
      AppUtils.noNetWorkDialog(context);
    }
    setState(() {});
  }

  _selectedFilterParam(String selectedFilter) {
    if (selectedFilter != null) {
      if (selectedFilter == _overviewOptions[0]) {
        return 'all';
      } else if (selectedFilter == _overviewOptions[1]) {
        return 'today';
      } else if (selectedFilter == _overviewOptions[2]) {
        return 'yesterday';
      } else if (selectedFilter == _overviewOptions[3]) {
        return 'weekly';
      } else if (selectedFilter == _overviewOptions[4]) {
        return 'monthly';
      } else if (selectedFilter == _overviewOptions[5]) {
        return 'quarterly';
      } else if (selectedFilter == _overviewOptions[6]) {
        return 'yearly';
      }
    } else {
      return 'monthly';
    }
  }

  convertedDate(String date) {
    if (date != null) {
      DateTime tempDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
      String newdate = DateFormat("dd MMM yyyy hh:mm aaa").format(tempDate);
      return newdate.toString();
    } else {
      return "";
    }
  }
}
