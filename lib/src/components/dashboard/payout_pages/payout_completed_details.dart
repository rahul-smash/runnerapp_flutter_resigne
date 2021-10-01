import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/complete_detail_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/complete_summary_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/payout_repository.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class PayoutCompletedDetails extends StatefulWidget {
  CompletedPayouts completePayout;

  PayoutCompletedDetails(this.completePayout);

  @override
  _PayoutCompletedDetailsState createState() {
    return _PayoutCompletedDetailsState();
  }
}

class _PayoutCompletedDetailsState extends BaseState<PayoutCompletedDetails> {
  bool isApiLoading = false;
  CompleteDetailResponse completeDetailsResponse;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getCompletePaymentSummary();
    });
  }

  void _getCompletePaymentSummary({bool isShowLoader = true}) async {
    if (!getIt.get<NetworkConnectionObserver>().offline) {
      if (isShowLoader) AppUtils.showLoader(context);
      isApiLoading = true;
      completeDetailsResponse = await getIt
          .get<PayoutRepository>()
          .getCompletePayoutDetails(
              userId: userId, batchId: widget.completePayout.id);
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
          widgets: <Widget>[],
        ),
        backgroundColor: Color(0xFFECECEC),
        body: Container(
          child: Stack(
            children: [
              Container(
                // height: 180,
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
                  margin: EdgeInsets.fromLTRB(0, 145, 0, 0),
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: Dimensions.getScaledSize(10),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        height: 50,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text("${labelID}"),
                            ),
                            Expanded(
                              child: Text("$labelCategoryName"),
                            ),
                            Expanded(
                              child: Text("$labelCategoryAmount"),
                            ),
                            Expanded(
                              child: Text("$labelReceivedAmount"),
                            )
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
                          child: isApiLoading || completeDetailsResponse == null
                              ? Container()
                              : ListView.separated(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 100),
                                  itemCount:
                                      completeDetailsResponse.payouts.length,
                                  itemBuilder: (context, index) {
                                    return _cardItem(
                                        completeDetailsResponse.payouts[index]);
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
                          Dimensions.getScaledSize(65), 0, 40, 0),
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
                                            labelTotalReceivedAmount,
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
                                              Text("${AppConstants.currency} ",
                                                  style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                      fontSize: AppConstants
                                                          .smallSize,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              Text(
                                                  '${isApiLoading || completeDetailsResponse == null ? '--' : completeDetailsResponse.payoutDetail.totalOrdersAmount}',
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
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 10, 0, 5),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            width: 100,
                                            height: 1,
                                            color:
                                                Colors.white.withOpacity(0.8),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${labelTaxValue}",
                                            textAlign: TextAlign.center,
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
                                              Text("${AppConstants.currency} ",
                                                  style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                      fontSize: AppConstants
                                                          .smallSize,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              Text(
                                                  "${isApiLoading || completeDetailsResponse == null ? '--' : completeDetailsResponse.payoutDetail.tax}",
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
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          labelNoOfOrdersInNextLine,
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
                                            Text("${AppConstants.currency} ",
                                                style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.8),
                                                    fontSize:
                                                        AppConstants.smallSize,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Text(
                                                "${isApiLoading || completeDetailsResponse == null ? '--' : completeDetailsResponse.payoutDetail.totalOrders}",
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
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          width: 100,
                                          height: 1,
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${labelTDS}",
                                          textAlign: TextAlign.center,
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
                                            Text("${AppConstants.currency} ",
                                                style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.8),
                                                    fontSize:
                                                        AppConstants.smallSize,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Text(
                                                "${isApiLoading || completeDetailsResponse == null ? '--' : completeDetailsResponse.payoutDetail.tds}",
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
                              AppImages.icon_top_header_tick,
                              width: 50,
                              height: 50,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(Dimensions.getScaledSize(65),
                          10, Dimensions.getScaledSize(40), 0),
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
                                "${isApiLoading || completeDetailsResponse == null || completeDetailsResponse.payoutDetail.dateTime == null ? '--' : completeDetailsResponse.payoutDetail.dateTime}",
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
                    margin: EdgeInsets.only(left: 50, right: 50, bottom: 20),
                    width: MediaQuery.of(context).size.width,
                    child: GradientElevatedButton(
                      onPressed: () {},
                      buttonText: labelDownloadPDF,
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

  Widget _cardItem(Payout payout) {
    return InkWell(
      onTap: () {
        if (this.network.offline) {
          AppUtils.showToast(AppConstants.noInternetMsg, false);
          return;
        }
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(15, 5, 0, 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text("#${payout.orderId}"),
            ),
            Expanded(
              child: Text("${payout.categoryTitle}"),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${AppConstants.currency} ",
                        style: TextStyle(
                            color: AppTheme.subHeadingTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    Text("${payout.totalAmount}",
                        style: TextStyle(
                            color: AppTheme.subHeadingTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600))
                  ],
                ),
                Container(
                  width: 50,
                  decoration: new BoxDecoration(
                      color: AppTheme.containerBackgroundColor,
                      borderRadius:
                          new BorderRadius.all(Radius.circular(25.0))),
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
                    child: Center(
                        child: Text(
                      "${payout.paymentMethod.toUpperCase()}",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.mainTextColor),
                    )),
                  ),
                )
              ],
            )),
            Expanded(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${AppConstants.currency} ",
                    style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                Text("${payout.runnerPayout}",
                    style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600))
              ],
            ))
          ],
        ),
      ),
    );
  }
}
