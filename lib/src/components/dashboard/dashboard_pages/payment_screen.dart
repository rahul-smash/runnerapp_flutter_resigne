import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/payout_summary_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/payout_pages/deposit_cash_screen.dart';
import 'package:marketplace_service_provider/src/components/dashboard/payout_pages/deposit_history_screen.dart';
import 'package:marketplace_service_provider/src/components/dashboard/payout_pages/payout_completed.dart';
import 'package:marketplace_service_provider/src/components/dashboard/payout_pages/pending_payouts.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/payout_repository.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/common_widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PaymentScreen extends StatefulWidget {
  VoidCallback menuInteraction;

  @override
  _PaymentScreenState createState() => _PaymentScreenState();

  PaymentScreen(this.menuInteraction);
}

class _PaymentScreenState extends BaseState<PaymentScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String _selectedOverviewOption = 'Today';
  List<String> _overviewOptions = List.empty(growable: true);
  PayoutSummaryResponse payoutSummaryResponse;

  bool isApiLoading = false;

  void _onRefresh() async {
    _getPaymentSummary(isShowLoader: false);
  }

  @override
  void initState() {
    super.initState();
    _overviewOptions.add('Today');
    _overviewOptions.add('Yesterday');
    _overviewOptions.add('7 days');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getPaymentSummary();
    });
  }

  void _getPaymentSummary({bool isShowLoader = true}) async {
    _selectedFilterParam(String selectedFilter) {
      if (selectedFilter != null) {
        if (selectedFilter == _overviewOptions[0]) {
          return 'today';
        } else if (selectedFilter == _overviewOptions[1]) {
          return 'yesterday';
        } else if (selectedFilter == _overviewOptions[2]) {
          return 'sevendays';
        }
      } else {
        return 'today';
      }
    }

    if (!getIt.get<NetworkConnectionObserver>().offline) {
      if (isShowLoader) AppUtils.showLoader(context);
      isApiLoading = true;
      payoutSummaryResponse = await getIt
          .get<PayoutRepository>()
          .getPayoutSummary(
              userId: loginResponse.data.id,
              filterOption: _selectedFilterParam(_selectedOverviewOption));
      setState(() {});
      AppUtils.hideLoader(context);
      _refreshController.refreshCompleted();
      isApiLoading = false;
    } else {
      AppUtils.noNetWorkDialog(context);
    }
    setState(() {});
  }

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        toolbarHeight: 0.5,
        elevation: 0.0,
      ),
      backgroundColor: AppTheme.white,
      body: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: Container(
            child: Stack(
          children: [
            CommonWidgets.gradientContainer(
                context,
                140,
                SizeConfig.screenWidth,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            iconSize: 20,
                            color: AppTheme.white,
                            onPressed: () {
                              widget.menuInteraction();
                            },
                            icon: Image(
                              image: AssetImage(AppImages.icon_menu),
                              height: 25,
                              color: AppTheme.white,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    labelPayments,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Dimensions.getScaledSize(
                                            AppConstants.largeSize2X),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    height: 2,
                                    width: 20,
                                    margin: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                        color: AppTheme.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            iconSize: 20,
                            color: AppTheme.white,
                            onPressed: () {
                              _refreshController.requestRefresh();
                            },
                            icon: Image(
                              image: AssetImage(AppImages.icon_refresh),
                              height: 25,
                              color: AppTheme.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(child: Container()),
                          PopupMenuButton(
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
                                  color: AppTheme.white,
                                  height: 5,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                              ],
                            ),
                            onSelected: (value) {
                              _selectedOverviewOption = value;
                              _refreshController.requestRefresh();
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
                                          visible:
                                              _selectedOverviewOption == choice,
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
                        ],
                      ),
                    ),
                  ],
                ),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
                  0.0,
                  0.3,
                  0.7,
                  0.9
                ],
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor,
                  AppTheme.primaryColorLight,
                  AppTheme.primaryColorLight
                ]),
            Container(
              width: SizeConfig.screenWidth,
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(30.0),
                      topRight: const Radius.circular(30.0))),
              margin: EdgeInsets.only(top: Dimensions.getScaledSize(110)),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.asset(AppImages.icon_payout_bottom_bg),
                  Container(
                    height: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              Dimensions.getScaledSize(26),
                              Dimensions.getScaledSize(26),
                              Dimensions.getScaledSize(26),
                              0),
                          child: Text(
                            labelPayout,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: Dimensions.getScaledSize(
                                    AppConstants.largeSize2X),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              Dimensions.getScaledSize(22),
                              0,
                              Dimensions.getScaledSize(22),
                              Dimensions.getScaledSize(0)),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) =>
                                                PendingPayouts()));
                                  },
                                  child: _createTopCard(
                                    AppTheme.optionTotalCustomerBgColor,
                                    AppImages.icon_pending_graphics,
                                    '${isApiLoading || payoutSummaryResponse == null ? '--' : payoutSummaryResponse.summery.pendingPayout.bookingCount}',
                                    labelPayoutPendingTitle,
                                    '${isApiLoading || payoutSummaryResponse == null ? '--' : payoutSummaryResponse.summery.pendingPayout.bookingPayout}',
                                    '${isApiLoading || payoutSummaryResponse == null ? '--' : payoutSummaryResponse.summery.pendingPayout.lastUpdated}',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) =>
                                                PayoutCompleted()));
                                  },
                                  child: _createTopCard(
                                    AppTheme.optionTotalEarningColor,
                                    AppImages.icon_received_graphics,
                                    '${isApiLoading || payoutSummaryResponse == null ? '--' : payoutSummaryResponse.summery.completedPayout.bookingCount}',
                                    labelReceivedPendingTitle,
                                    '${isApiLoading || payoutSummaryResponse == null ? '--' : payoutSummaryResponse.summery.completedPayout.bookingPayout}',
                                    '${isApiLoading || payoutSummaryResponse == null ? '--' : payoutSummaryResponse.summery.completedPayout.lastUpdated}',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              Dimensions.getScaledSize(26),
                              Dimensions.getScaledSize(15),
                              Dimensions.getScaledSize(26),
                              Dimensions.getScaledSize(10)),
                          child: Text(
                            labelDeposits,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: Dimensions.getScaledSize(
                                    AppConstants.largeSize2X),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              Dimensions.getScaledSize(22),
                              0,
                              Dimensions.getScaledSize(22),
                              0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          DepositCashScreen()));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25.0),
                              child: Card(
                                shadowColor: AppTheme.borderOnFocusedColor,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color:
                                          AppTheme.optionTotalBookingBgColor),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                elevation: 4,
                                color: AppTheme.optionTotalBookingBgColor,
                                margin: EdgeInsets.zero,
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 15, 10, 15),
                                        decoration: BoxDecoration(
                                          color: AppTheme.white,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(30)),
                                        ),
                                        child: Image.asset(
                                          AppImages.icon_next_arrow,
                                          height: 12,
                                          color: AppTheme
                                              .optionTotalCustomerBgColor,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        Dimensions.getScaledSize(20),
                                        Dimensions.getScaledSize(20),
                                        Dimensions.getScaledSize(20),
                                        Dimensions.getScaledSize(15),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: CircularPercentIndicator(
                                                  radius: 70.0,
                                                  lineWidth: 6.0,
                                                  percent: isApiLoading ||
                                                          payoutSummaryResponse ==
                                                              null
                                                      ? 0.0
                                                      : double.parse(
                                                              payoutSummaryResponse
                                                                  .summery
                                                                  .deposite
                                                                  .depositePercentage) /
                                                          100,
                                                  circularStrokeCap:
                                                      CircularStrokeCap.round,
                                                  animation: true,
                                                  animationDuration: 500,
                                                  center: new Text(
                                                    '${isApiLoading || payoutSummaryResponse == null ? '--' : payoutSummaryResponse.summery.deposite.depositePercentage}%',
                                                    style: TextStyle(
                                                        color: AppTheme.white,
                                                        fontSize: AppConstants
                                                            .largeSize,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  progressColor: AppTheme.white,
                                                  backgroundColor: AppTheme.darken(
                                                      AppTheme
                                                          .optionTotalBookingBgColor,
                                                      .05),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: Row(
                                                children: [
                                                  Flexible(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          labelDepositCash,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  AppConstants
                                                                      .smallSize,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  2.0),
                                                          child: Text(
                                                            labelCashInHand,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize:
                                                                    AppConstants
                                                                        .extraSmallSize,
                                                                color: Colors
                                                                    .white70),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8.0,
                                                                  right: 8.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                AppConstants
                                                                    .currency,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        AppConstants
                                                                            .extraSmallSize,
                                                                    color: Colors
                                                                        .white70),
                                                              ),
                                                              SizedBox(
                                                                width: 2,
                                                              ),
                                                              Text(
                                                                '${isApiLoading || payoutSummaryResponse == null ? '--' : payoutSummaryResponse.summery.deposite.cashInHand}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        AppConstants
                                                                            .largeSize,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Flexible(
                                                    child: Container(
                                                      width: double.maxFinite,
                                                      padding: EdgeInsets.only(
                                                          left: 5, right: 5),
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              left: BorderSide(
                                                                  color: AppTheme
                                                                      .white))),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            labelCashLimit,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize:
                                                                    AppConstants
                                                                        .smallSize,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8.0,
                                                                    right: 8.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  AppConstants
                                                                      .currency,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          AppConstants
                                                                              .extraSmallSize,
                                                                      color: Colors
                                                                          .white70),
                                                                ),
                                                                SizedBox(
                                                                  width: 2,
                                                                ),
                                                                Text(
                                                                  '${isApiLoading || payoutSummaryResponse == null ? '--' : payoutSummaryResponse.summery.deposite.cashLimit}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          AppConstants
                                                                              .largeSize,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                          Visibility(
                                            visible: false,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 8.0, right: 8.0),
                                              child: Text(
                                                '${labelUpdatedAt}${isApiLoading || payoutSummaryResponse == null ? '--' : payoutSummaryResponse.summery.deposite.lastUpdated}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize:
                                                        AppConstants.tinySize,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            _openDepositHistoryScreen();
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: Dimensions.getScaledSize(22),
                              right: Dimensions.getScaledSize(22),
                            ),
                            padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                            decoration: BoxDecoration(
                                color: AppTheme.white,
                                border: Border.all(
                                    color: AppTheme.primaryColor, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    labelDepositHistory,
                                    style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontSize: AppConstants.largeSize,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomRight,
                                      end: Alignment.topRight,
                                      stops: [0.1, 0.9],
                                      colors: [
                                        AppTheme.primaryColorDark,
                                        AppTheme.primaryColor,
                                      ],
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Image.asset(
                                        AppImages.icon_next_arrow,
                                        height: 12,
                                        color: AppTheme.white,
                                      ),
                                    ],
                                  ),
                                ),
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
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  void _openDepositHistoryScreen() {
    //TODO: handle this
    Navigator.push(context,
        MaterialPageRoute(builder: (builder) => DepositHistoryScreen()));
  }

  Widget _createTopCard(
      Color cardBackgroundColor,
      String imageGraphic,
      String bookingCount,
      String labelTitle,
      String bookingPayout,
      String lastUpdated) {
    return Card(
      shadowColor: AppTheme.borderOnFocusedColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: cardBackgroundColor),
        borderRadius: BorderRadius.circular(25.0),
      ),
      elevation: 4,
      color: cardBackgroundColor,
      margin:
          EdgeInsets.fromLTRB(Dimensions.pixels_5, 0, Dimensions.pixels_5, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 15, 10, 15),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(30)),
                ),
                child: Image.asset(
                  AppImages.icon_next_arrow,
                  height: 12,
                  color: cardBackgroundColor,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(height: 15),
                  Image.asset(
                    imageGraphic,
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      labelNumberOfOrder,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: AppConstants.extraSmallSize,
                          color: Colors.white),
                    ),
                  ),
                  Text(
                    bookingCount,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppConstants.extraSmallSize,
                        color: Colors.white),
                  ),
                  Container(
                    width: 40,
                    height: 1,
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(30)),
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                  ),
                  Text(
                    labelTitle,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: AppConstants.smallSize,
                        color: Colors.white),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConstants.currency,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: AppConstants.extraSmallSize,
                              color: Colors.white70),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          bookingPayout,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppConstants.largeSize,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: false,
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5.0),
                      child: Text(
                        '${labelUpdatedAt}${lastUpdated}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: AppConstants.tinySize,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
