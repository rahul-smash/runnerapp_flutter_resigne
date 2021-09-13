import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/complete_summary_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/deposit_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/payout_pages/payout_completed_details.dart';
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
import 'package:percent_indicator/circular_percent_indicator.dart';

class DepositCashScreen extends StatefulWidget {
  DepositCashScreen();

  @override
  _DepositCashScreenState createState() {
    return _DepositCashScreenState();
  }
}

class _DepositCashScreenState extends BaseState<DepositCashScreen> {
  String _selectedOverviewOption = 'Monthly';
  List<String> _overviewOptions = List.empty(growable: true);
  DepositResponse depositCashResponse;

  bool isApiLoading = false;

  double _selectedDepositCash = 0.00;
  List<CashCollection> _selectCashCollection = new List.empty(growable: true);

  void _onRefresh() async {
    _getDepositPaymentSummary(isShowLoader: true);
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
      _getDepositPaymentSummary();
    });
  }

  void _getDepositPaymentSummary({bool isShowLoader = true}) async {
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
      depositCashResponse = await getIt
          .get<PayoutRepository>()
          .getDepositCashList(
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
          backgroundColor: AppTheme.optionTotalBookingBgColor,
          title: Text(
            '$labelDepositCash',
            style: TextStyle(color: Colors.white),
          ),
          appBar: AppBar(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            backwardsCompatibility: false,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: AppTheme.optionTotalBookingBgColor,
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
                tooltip: labelSorting,
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
                height: Dimensions.getScaledSize(180),
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
                      AppTheme.optionTotalBookingBgColor,
                      AppTheme.optionTotalBookingBgColor,
                      AppTheme.optionTotalBookingBgColor,
                      AppTheme.optionTotalBookingBgColor,
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
                      25, Dimensions.getScaledSize(130), 25, 0),
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: Dimensions.getScaledSize(10),
                      ),
                      isApiLoading || depositCashResponse == null
                          ? Container()
                          : Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(bottom: 130),
                                  itemCount:
                                      depositCashResponse.cashCollection.length,
                                  itemBuilder:
                                      (BuildContext context, int subIndex) {
                                    return _cardItem(
                                        subIndex,
                                        depositCashResponse
                                            .cashCollection[subIndex]);
                                  })),
                    ],
                  )),
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(
                            Dimensions.getScaledSize(40),
                            0,
                            Dimensions.getScaledSize(40),
                            0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: CircularPercentIndicator(
                                    radius: 70.0,
                                    lineWidth: 6.0,
                                    percent: isApiLoading ||
                                            depositCashResponse == null
                                        ? 0.0
                                        : double.parse(depositCashResponse
                                                .summery.depositPercentage) /
                                            100,
                                    circularStrokeCap: CircularStrokeCap.round,
                                    animation: true,
                                    animationDuration: 500,
                                    center: new Text(
                                      '${isApiLoading || depositCashResponse == null ? '--' : depositCashResponse.summery.depositPercentage}%',
                                      style: TextStyle(
                                          color: AppTheme.white,
                                          fontSize: AppConstants.largeSize,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    progressColor: AppTheme.white,
                                    backgroundColor: AppTheme.darken(
                                        AppTheme.optionTotalBookingBgColor,
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
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            labelDepositCash,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    AppConstants.smallSize,
                                                color: Colors.white),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: Text(
                                              labelCashInHand,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: AppConstants
                                                      .extraSmallSize,
                                                  color: Colors.white70),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 8.0, right: 8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  AppConstants.currency,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: AppConstants
                                                          .extraSmallSize,
                                                      color: Colors.white70),
                                                ),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Text(
                                                  '${isApiLoading || depositCashResponse == null ? '--' : depositCashResponse.summery.cashInHand}',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: AppConstants
                                                          .largeSize,
                                                      color: Colors.white),
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
                                        padding:
                                            EdgeInsets.only(left: 5, right: 5),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                left: BorderSide(
                                                    color: AppTheme.white))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              labelCashLimit,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize:
                                                      AppConstants.smallSize,
                                                  color: Colors.white),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 8.0, right: 8.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    AppConstants.currency,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: AppConstants
                                                            .extraSmallSize,
                                                        color: Colors.white70),
                                                  ),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Text(
                                                    '${isApiLoading || depositCashResponse == null ? '--' : depositCashResponse.summery.cashLimit}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: AppConstants
                                                            .largeSize,
                                                        color: Colors.white),
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
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.fromLTRB(Dimensions.getScaledSize(40),
                          30, Dimensions.getScaledSize(40), 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${isApiLoading || depositCashResponse == null ? '--' : depositCashResponse.totalRecord > 0 ? depositCashResponse.totalRecord > 1 ? '${depositCashResponse.totalRecord} $labelResults' : '${depositCashResponse.totalRecord} $labelResult' : labelNoResultFound}",
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
                          //       "Aug 2021",
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
                        stops: [0.5, 0.5, 0.8, 0.5],
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _selectCashCollection.isNotEmpty,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                        stops: [0.1, 0.5, 0.7, 0.9],
                        colors: [
                          AppTheme.primaryColorDark,
                          AppTheme.primaryColor,
                          AppTheme.primaryColor,
                          AppTheme.primaryColor,
                        ],
                      ),
                    ),
                    margin: EdgeInsets.only(left: 50, right: 50, bottom: 40),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Image.asset(
                            AppImages.icon_tick_full_shade,
                            height: 40,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, bottom: 10, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Text(
                                      labelSelectedAmount,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: AppConstants.extraSmallSize,
                                          color: Colors.white70),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, right: 8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppConstants.currency,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize:
                                                  AppConstants.extraSmallSize,
                                              color: Colors.white70),
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Flexible(
                                          child: Text(
                                            '${_selectedDepositCash.toStringAsFixed(2)}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    AppConstants.smallSize,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  labelDepositAmount,
                                  style: TextStyle(
                                      color: AppTheme.white,
                                      fontSize: AppConstants.smallSize,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
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

  Widget _cardItem(int subIndex, CashCollection completePayout) {
    return InkWell(
      onTap: () {
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (builder) => DepositCashScreenDetails(completePayout)));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
        decoration: new BoxDecoration(
            boxShadow: shadow,
            borderRadius: BorderRadius.all(Radius.circular(35)),
            color: Colors.white),
        child: Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 15, 5, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text("$labelBatchID: ",
                                      style: TextStyle(
                                        color: AppTheme.mainTextColor,
                                        fontFamily: AppConstants.fontName,
                                      )),
                                  Text(
                                      "${completePayout.orderId} | ${AppUtils.convertDateFormat(completePayout.cashCollectionDateTime, parsingPattern: AppUtils.dateTimeAppDisplayPattern_2)}",
                                      style: TextStyle(
                                        color: AppTheme.subHeadingTextColor,
                                        fontFamily: AppConstants.fontName,
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
                        height: 1,
                        width: double.infinity,
                        color: AppTheme.borderOnFocusedColor,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                "${completePayout.categoryTitle}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: AppConstants.smallSize,
                                    color: AppTheme.mainTextColor,
                                    fontFamily: AppConstants.fontName,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${labelCashAmount}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: AppConstants.extraSmallSize,
                                        color: AppTheme.mainTextColor,
                                        fontFamily: AppConstants.fontName,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${AppConstants.currency} ",
                                          style: TextStyle(
                                              color: AppTheme.primaryColor,
                                              fontSize: AppConstants.smallSize,
                                              fontWeight: FontWeight.w600)),
                                      Expanded(
                                        child: Text(
                                            "${completePayout.cashCollected}",
                                            style: TextStyle(
                                                color: AppTheme.primaryColor,
                                                fontSize:
                                                    AppConstants.largeSize2X,
                                                fontWeight: FontWeight.w600)),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (_selectCashCollection.contains(completePayout)) {
                        _selectCashCollection.remove(completePayout);
                      } else {
                        _selectCashCollection.add(completePayout);
                      }
                      _selectedDepositCash = 0.0;
                      for (int i = 0; i < _selectCashCollection.length; i++) {
                        _selectedDepositCash += double.parse(
                            _selectCashCollection[i].cashCollected);
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: _selectCashCollection.contains(completePayout)
                            ? LinearGradient(
                                begin: Alignment.bottomRight,
                                end: Alignment.topRight,
                                stops: [0.1, 0.9],
                                colors: [
                                  AppTheme.primaryColorDark,
                                  AppTheme.primaryColor,
                                ],
                              )
                            : null,
                        color: _selectCashCollection.contains(completePayout)
                            ? null
                            : AppTheme.borderOnFocusedColor),
                    child: _selectCashCollection.contains(completePayout)
                        ? Icon(
                            Icons.done,
                            size: 20,
                            color: AppTheme.white,
                          )
                        : SizedBox(
                            height: 20,
                            width: 20,
                          ),
                  ),
                ),
                SizedBox(
                  width: 15,
                )
              ],
            )),
      ),
    );
  }
}
