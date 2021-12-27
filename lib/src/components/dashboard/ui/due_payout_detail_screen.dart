import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/deposit_history.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/deposit_history_details.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/payout_repository.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';

class DuePayoutDetailScreen extends StatefulWidget {
   DepositDatum depositDatum;

  DuePayoutDetailScreen(this.depositDatum);

  @override
  _DuePayoutDetailScreenState createState() {
    return _DuePayoutDetailScreenState();
  }
}

class _DuePayoutDetailScreenState
    extends BaseState<DuePayoutDetailScreen> {
  String _selectedOverviewOption = 'Monthly';
  List<String> _overviewOptions = List.empty(growable: true);
  bool isApiLoading = false;
  DepositHistoryDetails depositHistoryDetails;

  @override
  void initState() {
    super.initState();
    _overviewOptions.add('Monthly');
    _overviewOptions.add('Yesterday');
    _overviewOptions.add('7 days');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getPendingPayoutSummary();
    });
  }

  void _onRefresh() async {
    _getPendingPayoutSummary(isShowLoader: true);
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
          'Deposit History',
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
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        height: 50,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Text("ID"),
                            ),
                            Expanded(
                              child: Text("Paid Amount"),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                        width: double.infinity,
                        height: 2,
                        color: Colors.grey[350],
                      ),
                      Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: depositHistoryDetails?.deposits?.length ?? 0,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if (this.network.offline) {
                                    AppUtils.showToast(
                                        AppConstants.noInternetMsg, false);
                                    return;
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.fromLTRB(15, 5, 0, 5),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(depositHistoryDetails
                                            ?.deposits[index].displayOrderId),
                                      ),
                                      // Expanded(
                                      //   child: Text(
                                      //     depositHistoryDetails
                                      //         ?.deposits[index].categoryTitle,
                                      //     style: TextStyle(
                                      //         fontWeight: FontWeight.w600,
                                      //         color: AppTheme.mainTextColor),
                                      //   ),
                                      // ),
                                      Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text("${AppConstants.currency}",
                                                      style: TextStyle(
                                                          color: AppTheme
                                                              .subHeadingTextColor,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w600)),
                                                  Text(
                                                      depositHistoryDetails
                                                          ?.deposits[index]
                                                          .cashCollected,
                                                      style: TextStyle(
                                                          color: AppTheme
                                                              .subHeadingTextColor,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600))
                                                ],
                                              ),
                                              Container(
                                                width: 50,
                                                decoration: new BoxDecoration(
                                                    color: AppTheme
                                                        .containerBackgroundColor,
                                                    borderRadius: new BorderRadius.all(
                                                        Radius.circular(25.0))),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5,
                                                      right: 5,
                                                      top: 3,
                                                      bottom: 3),
                                                  child: Center(
                                                      child: Text(
                                                        widget.depositDatum.depositType,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: AppTheme.mainTextColor),
                                                      )),
                                                ),
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                          )),
                    ],
                  )),
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          Dimensions.getScaledSize(55), 0, 40, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Total Deposit",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color:
                                              Colors.white.withOpacity(0.8),
                                              fontFamily: AppConstants.fontName,
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text("${AppConstants.currency}",
                                                  style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                      fontSize: AppConstants
                                                          .smallSize,
                                                      fontWeight:
                                                      FontWeight.w600)),
                                              Text(
                                                  widget.depositDatum
                                                      ?.totalOrdersAmount ??
                                                      0,
                                                  style: TextStyle(
                                                      color: AppTheme.white,
                                                      fontSize: AppConstants
                                                          .extraLargeSize,
                                                      fontWeight:
                                                      FontWeight.w600))
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  width: 1,
                                  height: 40,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "No. of Orders",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color:
                                            Colors.white.withOpacity(0.8),
                                            fontFamily: AppConstants.fontName,
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                widget.depositDatum
                                                    ?.totalOrders ??
                                                    0,
                                                style: TextStyle(
                                                    color: AppTheme.white,
                                                    fontSize: AppConstants
                                                        .largeSize2X,
                                                    fontWeight:
                                                    FontWeight.w600))
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Image.asset(
                              "lib/src/components/dashboard/images/top_header_tick.png",
                              width: Dimensions.getScaledSize(55),
                              height: Dimensions.getScaledSize(55),
                            ),
                          )
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
                            "",
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
                                "${AppUtils.convertDateFromFormat(widget.depositDatum?.depositDateTime?.toString() ?? DateTime.now().toString(), parsingPattern: AppUtils.dateTimeAppDisplayPattern_1)}",
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
            ],
          ),
        ),
      ),
    );
  }

  void _getPendingPayoutSummary({bool isShowLoader = true}) async {
    if (!getIt.get<NetworkConnectionObserver>().offline) {
      if (isShowLoader) AppUtils.showLoader(context);
      isApiLoading = true;
      depositHistoryDetails = await getIt
          .get<PayoutRepository>()
          .getDepositsCompletedPayoutDetail(
          userId: userId, batchId: widget.depositDatum.id);
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
}
