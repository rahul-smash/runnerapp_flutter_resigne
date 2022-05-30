import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_notification_plugin/flutter_notification_plugin.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/dashboard_response_summary.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/dashboard_repository.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/item_new_request_booking.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/utils/callbacks.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';

class NewRequestBookingScreen extends StatefulWidget {
  final String filter;
  final String userId;
  bool isCameFromHomeScreen;

  NewRequestBookingScreen(
      {this.filter, this.userId, this.isCameFromHomeScreen = false});

  @override
  _NewRequestBookingScreenState createState() =>
      _NewRequestBookingScreenState();
}

class _NewRequestBookingScreenState extends BaseState<NewRequestBookingScreen> {
  DashboardResponseSummary _dashboardResponse;
  bool isChangesHappened = false;
  bool isDashboardApiLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getDashboardSummary();
    });
  }

  void _getDashboardSummary({bool isShowLoader = true}) async {
    if (!getIt.get<NetworkConnectionObserver>().offline) {
      if (isShowLoader) AppUtils.showLoader(context);
      isDashboardApiLoading = true;
      _dashboardResponse = await getIt
          .get<DashboardRepository>()
          .getDashboardSummary(
              userId: widget.userId,
              filterOption: widget.filter,
              page: 1,
              limit: 1000);
      AppUtils.hideLoader(context);
      isDashboardApiLoading = false;
      setState(() {});
    } else {
      AppUtils.noNetWorkDialog(context);
    }
  }

  _noOrderContainer() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 60,
          ),
          Image(
            width: Dimensions.getWidth(percentage: 70.0),
            image: AssetImage(AppImages.icon_no_order_graphic),
            fit: BoxFit.fitWidth,
          ),
          Text(
            labelNoOrderYet,
            style: TextStyle(
                color: AppTheme.mainTextColor,
                fontFamily: AppConstants.fontName,
                fontWeight: FontWeight.w500,
                fontSize: AppConstants.extraLargeSize),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            labelNoOrderYetMsg,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppTheme.subHeadingTextColor,
                fontFamily: AppConstants.fontName,
                fontWeight: FontWeight.w400,
                fontSize: AppConstants.largeSize),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  @override
  Widget builder(BuildContext context) {
    return widget.isCameFromHomeScreen
        ? _body()
        : WillPopScope(
            onWillPop: () {
              Navigator.pop(context, isChangesHappened);
              return Future(() => false);
            },
            child: Scaffold(
              backgroundColor: AppTheme.white,
              body: _body(),
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
                  iconSize: 24,
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

  Widget _body() {
    return isDashboardApiLoading
        ? Container()
        : _dashboardResponse == null ||
                (_dashboardResponse != null &&
                    _dashboardResponse.bookingRequests != null &&
                    _dashboardResponse.bookingRequests.isEmpty)
            ? _noOrderContainer()
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, top: 16.0),
                      child: Text(
                        _dashboardResponse.bookingRequests.length == 1
                            ? '${_dashboardResponse.bookingRequests.length} Order'
                            : '${_dashboardResponse.bookingRequests.length} Orders',
                        style: TextStyle(
                            fontSize: AppConstants.smallSize,
                            color: Colors.white,
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
                          return ItemViewOrderRequests(
                            bookingRequest:
                                _dashboardResponse.bookingRequests[index],
                            callback: _bookingActionMethod,
                          );
                        },
                        itemCount: _dashboardResponse.bookingRequests.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(
                            color: AppTheme.transparent,
                            height: 16.0,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
  }

  void _bookingActionMethod(
      BookingRequest bookingRequest, RequestStatus requestStatus) async {
    eventBus.fire(ReminderAlarmEvent.dismissNotification(
        ReminderAlarmEvent.notificationDismiss));
    switch (requestStatus) {
      case RequestStatus.accept:
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
              bool isAccepted =
                  _dashboardResponse.bookingRequests.remove(bookingRequest);
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
      case RequestStatus.reject:
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
              bool isAccepted =
                  _dashboardResponse.bookingRequests.remove(bookingRequest);
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
