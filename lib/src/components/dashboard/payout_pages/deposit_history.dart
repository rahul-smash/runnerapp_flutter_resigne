import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/pending_summary_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/payout_pages/deposit_history_details.dart';
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

class DepositHistory extends StatefulWidget {
  DepositHistory();

  @override
  _DepositHistoryState createState() {
    return _DepositHistoryState();
  }
}

class _DepositHistoryState extends BaseState<DepositHistory> {
  String _selectedOverviewOption = 'Monthly';
  List<String> _overviewOptions = List.empty(growable: true);

  bool isApiLoading = false;
  BaseResponse pendingSummaryResponse;

  void _onRefresh() async {
    _getPendingPayoutSummary(isShowLoader: true);
  }

  @override
  void initState() {
    super.initState();
    _overviewOptions.add('All');
    _overviewOptions.add('Today');
    _overviewOptions.add('Yesterday');
    _overviewOptions.add('Weekly');
    _overviewOptions.add('Monthly');
    _overviewOptions.add('Quarterly');
    _overviewOptions.add('Yearly');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getPendingPayoutSummary();
    });
  }

  void _getPendingPayoutSummary({bool isShowLoader = true}) async {
    // today
    // yesterday
    // weekly
    // monthly //default
    // quarterly
    // yearly
    // all
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

    if (!getIt.get<NetworkConnectionObserver>().offline) {
      if (isShowLoader) AppUtils.showLoader(context);
      isApiLoading = true;
      pendingSummaryResponse = await getIt
          .get<PayoutRepository>()
          .getDepositsCompletedPayoutsList(
              userId: loginResponse.data.id,
              filterOption: _selectedFilterParam(_selectedOverviewOption));
      setState(() {});
      AppUtils.hideLoader(context);
      isApiLoading = false;
    } else {
      AppUtils.noNetWorkDialog(context);
    }
    setState(() {});
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
            labelDepositHistory,
            style: TextStyle(color: Colors.white),
          ),
          appBar: AppBar(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            backwardsCompatibility: false,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: AppTheme.payoutCompleteGreen,
                statusBarIconBrightness: Brightness.dark),
            elevation: 0.0,
            titleSpacing: 0.0,
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
                      height: 5,
                      color: Colors.white,
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
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                itemBuilder: (BuildContext context) {
                  return _overviewOptions.map((String choice) {
                    return PopupMenuItem(
                      value: choice,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            choice,
                            style: TextStyle(
                                color: _selectedOverviewOption == choice
                                    ? AppTheme.primaryColorDark
                                    : AppTheme.mainTextColor),
                          ),
                          Visibility(
                              visible: _selectedOverviewOption == choice,
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
                  margin: EdgeInsets.fromLTRB(25, 100, 25, 0),
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: Dimensions.getScaledSize(10),
                      ),
                      Expanded(
                          child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 10,
                        padding: EdgeInsets.only(bottom: 100),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (builder)=>DepositHistoryDetails()));
                            },
                            child: Container(
                                margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                                decoration: new BoxDecoration(
                                    boxShadow: shadow,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(35)),
                                    color: Colors.white),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          AppImages.icon_tick_full_shade,
                                          width: Dimensions.getScaledSize(70),
                                          height: Dimensions.getScaledSize(70),
                                        ),
                                      ),
                                    ),
                                    Container(
                                        width: double.infinity,
                                        //height: 140,
                                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  15, 15, 5, 5),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                            "${labelBatchID}: ",
                                                            style: TextStyle(
                                                              color: AppTheme
                                                                  .mainTextColor,
                                                              fontFamily:
                                                                  AppConstants
                                                                      .fontName,
                                                            )),
                                                        Text("1855 to 1121",
                                                            style: TextStyle(
                                                              color: AppTheme
                                                                  .subHeadingTextColor,
                                                              fontFamily:
                                                                  AppConstants
                                                                      .fontName,
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  // Text("29 July, 2021, 3:30 PM",
                                                  //     style: TextStyle(color: AppTheme.subHeadingTextColor,
                                                  //       fontFamily: AppConstants.fontName,)
                                                  // ),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 2, 10, 2),
                                              height: 1,
                                              width: double.infinity,
                                              color:
                                                  AppTheme.borderOnFocusedColor,
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 10, 10, 0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${labelNoOfOrders}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              color: AppTheme
                                                                  .mainTextColor,
                                                              fontFamily:
                                                                  AppConstants
                                                                      .fontName,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text("54",
                                                                style: TextStyle(
                                                                    color: AppTheme
                                                                        .mainTextColor,
                                                                    fontSize:
                                                                        AppConstants
                                                                            .largeSize2X,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700)),
                                                          ],
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 3),
                                                          width: 30,
                                                          height: 2,
                                                          color: AppTheme
                                                              .primaryColor,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        labelPaidAmount,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            color: AppTheme
                                                                .subHeadingTextColor,
                                                            fontFamily:
                                                                AppConstants
                                                                    .fontName,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              "${AppConstants.currency} ",
                                                              style: TextStyle(
                                                                  color: AppTheme
                                                                      .primaryColor,
                                                                  fontSize:
                                                                      AppConstants
                                                                          .smallSize,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                          Text("23000",
                                                              style: TextStyle(
                                                                  color: AppTheme
                                                                      .primaryColor,
                                                                  fontSize:
                                                                      AppConstants
                                                                          .largeSize2X,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Container(
                                                            decoration: new BoxDecoration(
                                                                color: AppTheme
                                                                    .containerBackgroundColor,
                                                                borderRadius:
                                                                    new BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            25.0))),
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      right: 10,
                                                                      top: 3,
                                                                      bottom:
                                                                          3),
                                                              child: Center(
                                                                  child: Text(
                                                                "Cash",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: AppTheme
                                                                        .mainTextColor),
                                                              )),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 10, 10, 0),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.done_all,
                                                          color: AppTheme
                                                              .primaryColorDark,
                                                          size: 20,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            labelDepositConfirmed,
                                                            style: TextStyle(
                                                                color: AppTheme
                                                                    .primaryColorDark),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    left: 15,
                                                    top: 10,
                                                    bottom: 10,
                                                    right: 15,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: AppTheme
                                                              .buttonShadowColor,
                                                          offset: Offset(0, 8),
                                                          blurRadius: 5.0)
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30)),
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topRight,
                                                      end: Alignment.bottomLeft,
                                                      stops: [
                                                        0.1,
                                                        0.5,
                                                        0.7,
                                                        0.9
                                                      ],
                                                      colors: [
                                                        AppTheme
                                                            .primaryColorDark,
                                                        AppTheme.primaryColor,
                                                        AppTheme.primaryColor,
                                                        AppTheme.primaryColor,
                                                      ],
                                                    ),
                                                  ),
                                                  // width:
                                                  //     Dimensions.getScaledSize(
                                                  //
                                                  //         150),
                                                  child: Text(labelDownloadPDF,
                                                      style: TextStyle(
                                                          color: AppTheme.white,
                                                          fontSize: AppConstants
                                                              .extraSmallSize,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            )
                                          ],
                                        )),
                                  ],
                                )),
                          );
                        },
                      )),
                    ],
                  )),
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      margin: EdgeInsets.fromLTRB(
                          Dimensions.getScaledSize(65), 0, 40, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  labelTotalDeposit,
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
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            fontSize: AppConstants.smallSize,
                                            fontWeight: FontWeight.w600)),
                                    Text("23000",
                                        style: TextStyle(
                                            color: AppTheme.white,
                                            fontSize: AppConstants.largeSize2X,
                                            fontWeight: FontWeight.w600))
                                  ],
                                )
                              ],
                            ),
                          ),
                          Image.asset(AppImages.icon_top_header_tick)
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(Dimensions.getScaledSize(65),
                          30, Dimensions.getScaledSize(40), 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "4 Results",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                              fontFamily: AppConstants.fontName,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "Aug 2021",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  fontFamily: AppConstants.fontName,
                                ),
                              ),
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
