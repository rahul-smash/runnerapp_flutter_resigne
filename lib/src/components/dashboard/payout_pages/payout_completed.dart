import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/complete_summary_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/payout_pages/payout_completed_details.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/payout_repository.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';

class PayoutCompleted extends StatefulWidget {
  PayoutCompleted();

  @override
  _PayoutCompletedState createState() {
    return _PayoutCompletedState();
  }
}

class _PayoutCompletedState extends BaseState<PayoutCompleted> {
  String _selectedOverviewOption = 'Monthly';
  List<String> _overviewOptions = List.empty(growable: true);
  CompleteSummaryResponse completeSummaryResponse;

  bool isApiLoading = false;

  void _onRefresh() async {
    _getCompletePaymentSummary(isShowLoader: true);
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
      _getCompletePaymentSummary();
    });
  }

  void _getCompletePaymentSummary({bool isShowLoader = true}) async {
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
      completeSummaryResponse = await getIt
          .get<PayoutRepository>()
          .getCompletePayoutList(
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
    return Scaffold(
      appBar: BaseAppBar(
        removeTitleSpacing: true,
        callback: () {
          Navigator.of(context).pop();
        },
        backBtnColor: Colors.white,
        backgroundColor: AppTheme.payoutCompleteGreen,
        title: Text(
          '$labelPayoutComplete',
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
      body: SafeArea(
        child: Container(
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
                      AppTheme.payoutCompleteGreen,
                      AppTheme.payoutCompleteGreen,
                      AppTheme.payoutCompleteGreen,
                      AppTheme.payoutCompleteGreen,
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
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 2.0,
                      ),
                      isApiLoading || completeSummaryResponse == null
                          ? Container()
                          : Expanded(
                              child: ListView.builder(
                              padding: EdgeInsets.only(bottom: 40),
                              shrinkWrap: true,
                              itemCount:
                                  completeSummaryResponse.keysList.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        completeSummaryResponse.keysList[index],
                                        style: TextStyle(
                                            color: AppTheme.mainTextColor,
                                            fontSize: 16)),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: completeSummaryResponse
                                            .completedPayouts[
                                                completeSummaryResponse
                                                    .keysList[index]]
                                            .length,
                                        itemBuilder: (BuildContext context,
                                            int subIndex) {
                                          return _cardItem(
                                              completeSummaryResponse
                                                          .completedPayouts[
                                                      completeSummaryResponse
                                                          .keysList[index]]
                                                  [subIndex]);
                                        }),
                                  ],
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
                      height: Dimensions.getScaledSize(55),
                      margin: EdgeInsets.fromLTRB(
                          Dimensions.getScaledSize(65), 0, 40, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$labelReceivedPendingTitle",
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
                                    Text(
                                        "${isApiLoading || completeSummaryResponse == null ? '--' : '${completeSummaryResponse.summery.totalEarning}'}",
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
                            "${isApiLoading || completeSummaryResponse == null ? '--' : int.parse(completeSummaryResponse.totalRecord) > 0 ? int.parse(completeSummaryResponse.totalRecord) > 1 ? '${completeSummaryResponse.totalRecord} $labelResults' : '${completeSummaryResponse.totalRecord} $labelResult' : labelNoResultFound}",
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardItem(CompletedPayouts completePayout) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => PayoutCompletedDetails(completePayout)));
      },
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
            decoration: new BoxDecoration(
                boxShadow: shadow,
                borderRadius: BorderRadius.all(Radius.circular(35)),
                color: Colors.white),
            child: Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                Text("${completePayout.id}",
                                    style: TextStyle(
                                      color: AppTheme.subHeadingTextColor,
                                      fontFamily: AppConstants.fontName,
                                    )),
                              ],
                            ),
                          ),
                          Text(
                              AppUtils.convertDateFormat(
                                  completePayout.payoutCompletedDate,
                                  parsingPattern:
                                      AppUtils.dateTimeAppDisplayPattern_2),
                              style: TextStyle(
                                color: AppTheme.subHeadingTextColor,
                                fontFamily: AppConstants.fontName,
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          Image.asset(
                            AppImages.icon_next_arrow,
                            color: Colors.grey,
                            height: 15,
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
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$labelNoOfOrders",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: AppConstants.smallSize,
                                      color: AppTheme.mainTextColor,
                                      fontFamily: AppConstants.fontName,
                                      fontWeight: FontWeight.w600),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${completePayout.totalOrders}",
                                        style: TextStyle(
                                            color: AppTheme.mainTextColor,
                                            fontSize: AppConstants.largeSize,
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 3),
                                  width: 30,
                                  height: 2,
                                  color: AppTheme.primaryColor,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${labelYourReceivedAmount}",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: AppConstants.extraSmallSize,
                                      color: AppTheme.primaryColor,
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
                                    Expanded(
                                      child: Text(
                                          "${completePayout.totalPayout}",
                                          style: TextStyle(
                                              color: AppTheme.primaryColor,
                                              fontSize: AppConstants.largeSize,
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
                    SizedBox(
                      height: 10,
                    ),
                    // Row(
                    //   children: [
                    //     Expanded(child: Container()),
                    //     Container(
                    //       margin: EdgeInsets.only(
                    //         left: 5,
                    //         right: 20,
                    //       ),
                    //       width: Dimensions.getScaledSize(150),
                    //       child: GradientElevatedButton(
                    //         onPressed: () {},
                    //         buttonText: labelDownloadPDF,
                    //       ),
                    //       height: 40,
                    //     ),
                    //   ],
                    // ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                )),
          ),
          Image.asset(
            AppImages.icon_tick_shade_on_tile,
            height: 80,
          ),
        ],
      ),
    );
  }
}
