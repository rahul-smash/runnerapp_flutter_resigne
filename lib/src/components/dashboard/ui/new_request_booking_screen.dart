import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_notification_plugin/flutter_notification_plugin.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/dashboard_resposne.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/dashboard_repository.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/item_new_request_booking.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';

class NewRequestBookingScreen extends StatefulWidget {
  DashboardResponse dashboardResponse;

  NewRequestBookingScreen(this.dashboardResponse);

  @override
  _NewRequestBookingScreenState createState() =>
      _NewRequestBookingScreenState(dashboardResponse);
}

class _NewRequestBookingScreenState extends BaseState<NewRequestBookingScreen> {
  DashboardResponse _dashboardResponse;
  bool isChangesHappened = false;

  _NewRequestBookingScreenState(this._dashboardResponse);

  @override
  Widget builder(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, isChangesHappened);
          return Future(() => false);
        },
        child: Scaffold(
          backgroundColor: AppTheme.white,
          body: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  AppTheme.primaryColorDark,
                  AppTheme.primaryColorDark,
                  AppTheme.primaryColor,
                  AppTheme.primaryColor,
                ],
              ),
            ),
            padding: EdgeInsets.fromLTRB(
              Dimensions.getScaledSize(16),
              Dimensions.getScaledSize(16),
              Dimensions.getScaledSize(16),
              Dimensions.getScaledSize(0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    '${_dashboardResponse.bookingRequests.length} Orders',
                    style: TextStyle(
                        fontSize: AppConstants.smallSize,
                        color: AppTheme.subHeadingTextColor,
                        fontWeight: FontWeight.normal,
                        fontFamily: AppConstants.fontName),
                  ),
                ),
                SizedBox(
                  height: Dimensions.getScaledSize(16),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.only(
                      bottom: Dimensions.getScaledSize(16),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return ItemNewRequestBooking(
                          _dashboardResponse.bookingRequests[index],
                          _bookingActionMethod);
                    },
                    itemCount: _dashboardResponse.bookingRequests.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(
                        color: AppTheme.transparent,
                        height: Dimensions.pixels_5,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          appBar: BaseAppBar(
            backgroundColor: AppTheme.white,
            title: Text(
              'New Bookings',
              style: TextStyle(
                  color: AppTheme.black,
                  fontWeight: FontWeight.normal,
                  fontFamily: AppConstants.fontName),
            ),
            leading: IconButton(
              iconSize: 20,
              color: AppTheme.black,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, isChangesHappened);
              },
            ),
            appBar: AppBar(
              elevation: 0,
            ),
          ),
        ));
  }

  Future<Function> _bookingActionMethod(
      String type, BookingRequest bookingRequest) async {
    switch (type) {
      case 'Accept':
        if (!getIt.get<NetworkConnectionObserver>().offline) {
          await FlutterNotificationPlugin.stopForegroundService();
          AppUtils.showLoader(context);
          BaseResponse baseResponse = await getIt
              .get<DashboardRepository>()
              .changeBookingRequestAction(
                  userId: userId, orderId: bookingRequest.id, status: '1');
          AppUtils.hideLoader(context);
          if (baseResponse != null) {
            if (baseResponse.success) {
              bool isAccepted = widget.dashboardResponse.bookingRequests
                  .remove(bookingRequest);
              setState(() {});
              if (isAccepted) {
                appPrintLog('Your Booking request is accepted');
              }
              isChangesHappened = true;
            } else {
              AppUtils.showToast(baseResponse.message, false);
            }
          }
        } else {
          AppUtils.noNetWorkDialog(context);
        }
        break;
      case 'Reject':
        if (!getIt.get<NetworkConnectionObserver>().offline) {
          await FlutterNotificationPlugin.stopForegroundService();
          AppUtils.showLoader(context);
          BaseResponse baseResponse = await getIt
              .get<DashboardRepository>()
              .changeBookingRequestAction(
                  userId: userId, orderId: bookingRequest.id, status: '2');
          AppUtils.hideLoader(context);
          if (baseResponse != null) {
            if (baseResponse.success) {
              bool isAccepted = widget.dashboardResponse.bookingRequests
                  .remove(bookingRequest);
              setState(() {});
              if (isAccepted) {
                appPrintLog('Your Booking request is Rejected');
              }
              isChangesHappened = true;
            } else {
              AppUtils.showToast(baseResponse.message, false);
            }
          }
        } else {
          AppUtils.noNetWorkDialog(context);
        }
        break;
    }
  }
}
