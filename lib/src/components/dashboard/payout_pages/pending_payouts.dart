import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/pending_summary_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/payout_repository.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
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
  String _selectedOverviewOption = 'Monthly';
  List<String> _overviewOptions = List.empty(growable: true);

  bool isApiLoading = false;
  PendingSummaryResponse pendingSummaryResponse;

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
          .getPendingPayout(
              userId: userId,
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
          backgroundColor: AppTheme.optionTotalCustomerBgColor,
          title: Text(
            labelPayoutPendingTitle,
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
                  _onRefresh();
                  setState(() {});
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                itemBuilder: (BuildContext c8ontext) {
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
                          topLeft: const Radius.circular(35.0),
                          topRight: const Radius.circular(35.0))),
                  margin: EdgeInsets.fromLTRB(
                      25, Dimensions.getScaledSize(110), 25, 0),
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: Dimensions.getScaledSize(10),
                      ),
                      isApiLoading || pendingSummaryResponse == null
                          ? Container()
                          : Expanded(
                              child: ListView.separated(
                              padding: EdgeInsets.only(bottom: 40),
                              shrinkWrap: true,
                              itemCount: pendingSummaryResponse.keysList.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(pendingSummaryResponse.keysList[index],
                                        style: TextStyle(
                                            color: AppTheme.mainTextColor,
                                            fontSize: 16)),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: pendingSummaryResponse
                                            .pendingPayouts[
                                                pendingSummaryResponse
                                                    .keysList[index]]
                                            .length,
                                        itemBuilder: (BuildContext context,
                                            int subIndex) {
                                          return _cardItem(
                                              pendingSummaryResponse
                                                          .pendingPayouts[
                                                      pendingSummaryResponse
                                                          .keysList[index]]
                                                  [subIndex]);
                                        }),
                                  ],
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: 10,
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
                          Dimensions.getScaledSize(65), 0, 0, 0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                labelPayoutPendingTitle,
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
                                          fontWeight: FontWeight.w600)),
                                  Text(
                                      "${isApiLoading || pendingSummaryResponse == null ? '--' : '${pendingSummaryResponse.summery.totalEarning}'}",
                                      style: TextStyle(
                                          color: AppTheme.white,
                                          fontSize: AppConstants.largeSize2X,
                                          fontWeight: FontWeight.w600))
                                ],
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            width: 1,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                labelNumberOfOrder,
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
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                      "${isApiLoading || pendingSummaryResponse == null ? '--' : '${pendingSummaryResponse.summery.totalBookings}'}",
                                      style: TextStyle(
                                          color: AppTheme.white,
                                          fontSize: AppConstants.largeSize2X,
                                          fontWeight: FontWeight.w600))
                                ],
                              )
                            ],
                          ),
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
                            "${isApiLoading || pendingSummaryResponse == null ? '--' : int.parse(pendingSummaryResponse.totalRecord) > 0 ? int.parse(pendingSummaryResponse.totalRecord) > 1 ? '${pendingSummaryResponse.totalRecord} $labelResults' : '${pendingSummaryResponse.totalRecord} $labelResult' : labelNoResultFound}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                              fontFamily: AppConstants.fontName,
                            ),
                          ),
                          // Row(
                          //   children: [
                          //     Icon(
                          //       Icons.keyboard_arrow_left,
                          //       color: Colors.white,
                          //     ),
                          //     Text(
                          //       "Year 2021",
                          //       textAlign: TextAlign.center,
                          //       style: TextStyle(
                          //         fontSize: 14.0,
                          //         color: Colors.white,
                          //         fontFamily: AppConstants.fontName,
                          //       ),
                          //     ),
                          //     Icon(
                          //       Icons.keyboard_arrow_right,
                          //       color: Colors.white,
                          //     ),
                          //   ],
                          // )
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
                        stops: [0.1, 0.3, 0.8, 0.9],
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
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: new BoxDecoration(
            boxShadow: shadow,
            borderRadius: BorderRadius.all(Radius.circular(35)),
            color: Colors.white),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
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
                                    fontSize: AppConstants.extraSmallSize,
                                    fontWeight: FontWeight.w600)),
                            Text("${pendingPayout.totalAmount}",
                                style: TextStyle(
                                    color: AppTheme.subHeadingTextColor,
                                    fontSize: AppConstants.smallSize,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(
                              width: 5,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  decoration: new BoxDecoration(
                                      color: AppTheme.containerBackgroundColor,
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(25.0))),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, top: 3, bottom: 3),
                                    child: Center(
                                        child: Text(
                                      '${pendingPayout.paymentMethod.toUpperCase()}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize:
                                              AppConstants.extraXSmallSize,
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
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        labelYourPendingAmount,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: AppConstants.extraSmallSize,
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
                          Text("${pendingPayout.runnerPayout}",
                              style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontSize: AppConstants.largeSize,
                                  fontWeight: FontWeight.w600))
                        ],
                      )
                    ],
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
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
