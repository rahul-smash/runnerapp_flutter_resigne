import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/dashboard_repository.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/item_booking.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';

class MyBookingScreen extends StatefulWidget {
  @override
  _MyBookingScreenState createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends BaseState<MyBookingScreen> {
  bool isBookingApiLoading = true;
  BookingResponse _bookingResponse;
  int selectedFilterIndex = 0;
  List<String> _filterOptions = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    //Filter option
    _filterOptions.add('All');
    _filterOptions.add('Upcoming');
    _filterOptions.add('Ongoing');
    _filterOptions.add('Completed');
    _filterOptions.add('Rejected');
    _filterOptions.add('Cancelled');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getMyBookingOrders();
    });
  }

  void _getMyBookingOrders({bool isShowLoader = true}) async {
    if (!getIt.get<NetworkConnectionObserver>().offline) {
      if (isShowLoader) AppUtils.showLoader(context);
      isBookingApiLoading = true;
      _bookingResponse = await getIt.get<DashboardRepository>().getBookings(
          userId: loginResponse.data.id,
          status: _getCurrentStatus(selectedFilterIndex));
      _getFilterCount();
      AppUtils.hideLoader(context);
      isBookingApiLoading = false;
    } else {
      AppUtils.noNetWorkDialog(context);
    }
    setState(() {});
  }

  _getFilterCount() {
    if (_bookingResponse != null && _bookingResponse.bookingCounts != null) {
      _filterOptions[0] = '${_bookingResponse.bookingCounts.all} | All';
      _filterOptions[1] =
          '${_bookingResponse.bookingCounts.upcoming} | Upcoming';
      _filterOptions[2] = '${_bookingResponse.bookingCounts.ongoing} | Ongoing';
      _filterOptions[3] =
          '${_bookingResponse.bookingCounts.completed} | Completed';
      _filterOptions[4] =
          '${_bookingResponse.bookingCounts.rejected} | Rejected';
    }
  }

  _getCurrentStatus(int selectedFilterIndex) {
//    0 => 'pending',
//    1 =>'accepted',
//    2 =>'rejected',
//    4 =>'ongoing',
//    5 =>'completed',
//    6 => 'cancelled' // cancelled by customer
    switch (selectedFilterIndex) {
      case 0:
        return '0';
        break; // all
      case 1:
        return '1';
        break; // upcoming
      case 2:
        return '4';
        break; // ongoing
      case 3:
        return '5';
        break; // completed
      case 4:
        return '2';
        break; // rejected
      case 5:
        return '6';
        break; // cancelled
    }
  }

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 30,
              child: ListView.builder(
                padding: EdgeInsets.only(left: 10, right: 10),
                itemCount: _filterOptions.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      setState(() {
                        selectedFilterIndex = index;
                        _getMyBookingOrders();
                      });
                    },
                    child: Container(
                        height: 30,
                        margin: EdgeInsets.only(left: 4, right: 4),
                        padding: EdgeInsets.fromLTRB(20, 3, 20, 3),
                        decoration: BoxDecoration(
                            color: selectedFilterIndex == index
                                ? AppTheme.primaryColor.withOpacity(0.1)
                                : AppTheme.borderNotFocusedColor,
                            border: Border.all(
                                color: selectedFilterIndex == index
                                    ? AppTheme.primaryColor
                                    : AppTheme.borderNotFocusedColor,
                                width: 1),
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          children: [
                            Text('${_filterOptions[index]}',
                                style: TextStyle(
                                    color: AppTheme.mainTextColor,
                                    fontSize: AppConstants.smallSize)),
                          ],
                        )),
                  );
                },
              ),
            ),
            isBookingApiLoading
                ? Container(
                    height: Dimensions.getHeight(percentage: 60),
                  )
                : _bookingResponse != null &&
                        _bookingResponse.bookings != null &&
                        _bookingResponse.bookings.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                            padding:
                                EdgeInsets.all(Dimensions.getScaledSize(10)),
                            shrinkWrap: true,
                            itemCount: _bookingResponse.bookings.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ItemBooking(
                                  _bookingResponse.bookings[index],
                                  _bookingAction);
                            }),
                      )
                    : _noOrderContainer(),
          ],
        ),
      ),
    );
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

  _bookingAction(String type, Booking booking) async {
    if (!getIt.get<NetworkConnectionObserver>().offline) {
      AppUtils.showLoader(context);
      BaseResponse baseResponse = await getIt
          .get<DashboardRepository>()
          .changeBookingAction(
              userId: loginResponse.data.id,
              orderId: booking.id,
              status: _changeBookingStatus(type));
      AppUtils.hideLoader(context);
      if (baseResponse != null) {
        if (baseResponse.success) {
          _bookingResponse.bookings[_bookingResponse.bookings.indexOf(booking)]
              .status = _changeBookingStatus(type);
          setState(() {});
        } else {
          AppUtils.showToast(baseResponse.message, false);
        }
      }
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
            height: 50,
          ),
          Image(
            image: AssetImage(AppImages.icon_no_order_graphic),
            height: Dimensions.getScaledSize(135),
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
            height: 5,
          ),
          Text(
            labelNoOrderYetMsg,
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
}
