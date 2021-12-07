import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/dashboard_response_summary.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/dashboard_repository.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/item_booking.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyBookingScreen extends StatefulWidget {
  final VoidCallback menuInteraction;

  MyBookingScreen({Key key, this.menuInteraction}) : super(key: key);

  @override
  _MyBookingScreenState createState() => _MyBookingScreenState();

// Function toggleMenu;

// MyBookingScreen(this.toggleMenu);
}

class _MyBookingScreenState extends BaseState<MyBookingScreen> {
  bool isBookingApiLoading = true;
  BookingResponse _bookingResponse;
  int selectedFilterIndex = 0;
  List<String> _filterOptions = List.empty(growable: true);
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  FilterType _selectedSortingType = FilterType.Delivery_Time_Slot;

  List<String> _sortingType = ['Booking Date', 'Delivery Date'];

  @override
  void initState() {
    super.initState();
    //Filter option
    _filterOptions.add('All');
    _filterOptions.add('Upcoming');
    _filterOptions.add('Ongoing');
    _filterOptions.add('Completed');
    _filterOptions.add('Rejected');
    // _filterOptions.add('Cancelled');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getMyBookingOrders(bookingSorting: FilterType.Delivery_Time_Slot);
    });
  }

  void _getMyBookingOrders(
      {bool isShowLoader = true, FilterType bookingSorting}) async {
    print('_getMyBookingOrders------');
    if (!getIt.get<NetworkConnectionObserver>().offline) {
      if (isShowLoader) AppUtils.showLoader(context);
      isBookingApiLoading = true;
      _bookingResponse = await getIt.get<DashboardRepository>().getBookings(
          userId: userId,
          status: _getCurrentStatus(selectedFilterIndex),
          bookingSorting: bookingSorting ?? FilterType.Delivery_Time_Slot,
          page: 1,
          limit: 1000);
      _getFilterCount();
      AppUtils.hideLoader(context);
      _refreshController.refreshCompleted();
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

  void _onRefresh() async {
    _getMyBookingOrders(
        isShowLoader: false, bookingSorting: _selectedSortingType);
  }

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 8.0,
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
                        _getMyBookingOrders(
                            bookingSorting: _selectedSortingType);
                      });
                    },
                    child: Container(
                        height: 30,
                        margin: EdgeInsets.only(left: 4, right: 4),
                        padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
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
            SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: SmartRefresher(
                enablePullDown: true,
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: isBookingApiLoading
                    ? Container(
                        height: Dimensions.getHeight(percentage: 60),
                      )
                    : _bookingResponse != null &&
                            _bookingResponse.bookings != null &&
                            _bookingResponse.bookings.isNotEmpty
                        ? ListView.separated(
                            padding:
                                EdgeInsets.all(Dimensions.getScaledSize(10)),
                            shrinkWrap: true,
                            itemCount: _bookingResponse.bookings.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ItemBooking(
                                  _bookingResponse.bookings[index],
                                  _bookingAction);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 8.0,
                              );
                            },
                          )
                        : _noOrderContainer(),
              ),
            ),
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

  _bookingAction(String type, dynamic booking) async {
    if (!getIt.get<NetworkConnectionObserver>().offline) {
      if (type == 'refresh') {
        _onRefresh();
        return;
      }
      AppUtils.showLoader(context);
      BaseResponse baseResponse = await getIt
          .get<DashboardRepository>()
          .changeBookingAction(
              userId: userId,
              orderId: booking.id,
              status: _changeBookingStatus(type));
      AppUtils.hideLoader(context);
      if (baseResponse != null) {
        if (baseResponse.success) {
          int tempIndex=-1;
          for(int i=0;i<_bookingResponse.bookings.length;i++){
            if(booking.id==_bookingResponse.bookings[i].id){
              tempIndex=i;
              break;
            }
          }
          // int index = _bookingResponse.bookings.indexOf(booking);
          if(tempIndex==-1){
            return;
          }
          int index = tempIndex;
          _bookingResponse.bookings[index].status = _changeBookingStatus(type);
          if (selectedFilterIndex != 0) {
            _bookingResponse.bookings.removeAt(index);
          }
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

  _getAppBar() {
    return BaseAppBar(
      backgroundColor: AppTheme.white,
      title: Text(
        'My Bookings',
        style: TextStyle(color: AppTheme.black),
      ),
      leading: IconButton(
        iconSize: 20,
        color: AppTheme.white,
        // onPressed: () => widget.toggleMenu(),
        icon: Image(
          image: AssetImage(AppImages.icon_menu),
          height: 25,
          color: AppTheme.black,
        ),
        onPressed: () {
          widget.menuInteraction();
        },
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      widgets: [
        Container(
          child: PopupMenuButton(
            elevation: 3.2,
            iconSize: 5.0,
            onCanceled: () {
              print('You have not chossed anything');
            },
            tooltip: 'Sorting',
            child: Row(
              children: [
                Text(
                  'Sort By',
                  style: TextStyle(
                      color: AppTheme.subHeadingTextColor,
                      fontSize: AppConstants.smallSize,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 5,
                ),
                Image.asset(
                  AppImages.icon_dropdownarrow,
                  height: 5,
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
            onSelected: (value) {
              if (value == 'Booking Date') {
                _selectedSortingType = FilterType.Booking_Date;
              } else {
                _selectedSortingType = FilterType.Delivery_Time_Slot;
              }
              _refreshController.requestRefresh();
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            itemBuilder: (BuildContext context) {
              return _sortingType.map((String choice) {
                return PopupMenuItem(
                  value: choice,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        choice,
                        style: TextStyle(
                            color: _checkSelected(choice)
                                ? AppTheme.primaryColorDark
                                : AppTheme.mainTextColor),
                      ),
                      Visibility(
                          visible: _checkSelected(choice),
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
        )
      ],
    );
  }

  _checkSelected(String choice) {
    if (choice == _sortingType[0] &&
        _selectedSortingType == FilterType.Booking_Date) {
      return true;
    } else if (choice == _sortingType[1] &&
        _selectedSortingType == FilterType.Delivery_Time_Slot) {
      return true;
    }
    return false;
  }
}
