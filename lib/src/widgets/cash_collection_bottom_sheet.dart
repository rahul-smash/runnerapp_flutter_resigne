import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/dashboard_repository.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class CashCollectionBottomSheet {
  //typeScreen ==0 //Dashboard and other listing
  //typeScreen ==1 //Booking details
  // type== 'complete or Ongoing
  CashCollectionBottomSheet(BuildContext context, dynamic booking,
      Function callBackMethod, String type, String typeScreen) {
    openCashCollectorBottomSheet(
        context, booking, callBackMethod, type, typeScreen);
  }

  openCashCollectorBottomSheet(context, dynamic booking,
      Function callBackMethod, String type, String typeScreen) async {
    await showModalBottomSheet(
        context: context,
        backgroundColor: AppTheme.transparent,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return SafeArea(
                  child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(30.0),
                          topRight: const Radius.circular(30.0))),
                  child: Wrap(children: <Widget>[
                    Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Image.asset(
                                AppImages.icon_popupcancelicon,
                                height: 20,
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Text(
                            "Collect Cash",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                              color: AppTheme.black,
                              borderRadius: BorderRadius.circular(30)),
                          width: 30,
                          height: 3,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Text(
                            "Please make the payment, after that you can enjoy all the service and benefits.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff797C82),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Amount',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppConstants.largeSize2X),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Text(
                                AppConstants.currency,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppConstants.extraLargeSize),
                              ),
                            ),
                            Container(
                              decoration: new BoxDecoration(
                                color: AppTheme.grayLightColor,
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(30.0)),
                              ),
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Text(
                                booking.total,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppConstants.extraLargeSize),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.only(left: 30, right: 30),
                            child: GradientElevatedButton(
                              buttonText: 'Amount Collected',
                              onPressed: () {
                                _callCashCollectedApi(context, booking, type,
                                    typeScreen, callBackMethod);
                              },
                            )),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ]),
                ),
              ));
            },
          );
        });
  }

  openCashCollectedBottomSheet(context, String cashAmount) async {
    await showModalBottomSheet(
        context: context,
        backgroundColor: AppTheme.transparent,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return SafeArea(
                  child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(30.0),
                          topRight: const Radius.circular(30.0))),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    width: AppUtils.getDeviceWidth(context),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(AppImages.icon_thankyou_popup_bg),
                            fit: BoxFit.cover),
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(30.0),
                            topRight: const Radius.circular(30.0))),
                    child: Wrap(children: <Widget>[
                      Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Image.asset(
                                  AppImages.icon_popupcancelicon,
                                  height: 20,
                                )),
                          ),
                          Image.asset(
                            AppImages.icon_small_tick,
                            height: 100,
                          ),
                          Text(
                            'Payment Collected',
                            style: TextStyle(
                                color: AppTheme.mainTextColor,
                                fontSize: AppConstants.extraLargeSize,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Your transaction was successful.',
                            style: TextStyle(
                                color: AppTheme.subHeadingTextColor,
                                fontSize: AppConstants.smallSize,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: 80,
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ));
            },
          );
        });
  }

  _changeBookingStatus(String type) {
    switch (type) {
      case 'Ongoing':
        return '4';
        break;
      case 'Complete':
        return '5';
        break;
    }
  }

  void _callCashCollectedApi(BuildContext context, dynamic booking, String type,
      String typeScreen, Function callBackMethod) async {
    if (!getIt.get<NetworkConnectionObserver>().offline) {
      AppUtils.showLoader(context);
      BaseResponse baseResponse = await getIt
          .get<DashboardRepository>()
          .changeBookingCashCollectionAction(
            userId: AppSharedPref.instance.getUserId(),
            orderId: booking.id,
            paymentMethod: 'cod',
            total: booking.total,
          );
      AppUtils.hideLoader(context);
      if (baseResponse != null) {
        if (baseResponse.success) {
          if (typeScreen == '1')
            callBackMethod('Complete', booking);
          else if (typeScreen == '0') callBackMethod('Complete', booking);

          Navigator.pop(context);
          // AddImageBottomSheet(context, booking, 'cod');
          openCashCollectedBottomSheet(context, booking.total);
        } else {
          AppUtils.showToast(baseResponse.message, false);
        }
      }
    } else {
      AppUtils.noNetWorkDialog(context);
    }
  }
}
