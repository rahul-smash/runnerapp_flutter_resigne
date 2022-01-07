import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/dashboard_response_summary.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/dashboard_repository.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/item_booking.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/item_new_request_booking.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/new_request_booking_screen.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/utils/callbacks.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback callback;

  HomeScreen({Key key, this.callback}) : super(key: key);

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends BaseState<HomeScreen> {
  String userId;
  List<String> _overviewOptions = List.empty(growable: true);
  List<String> _filterOptions = List.empty(growable: true);
  String _selectedOverviewOption = 'Today';
  final PageController _pageController = PageController(initialPage: 0);
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  DashboardResponseSummary _dashboardResponse;
  BookingResponse _bookingResponse;

  bool isDashboardApiLoading = true;
  bool isBookingApiLoading = true;

  int selectedBookingFilterIndex = 0;
  StreamSubscription fcmEventStream;
  StreamSubscription refreshEventStream;

  @override
  void initState() {
    super.initState();
    userId = AppSharedPref.instance.getUserId();
    _overviewOptions.add('Today');
    _overviewOptions.add('Yesterday');
    _overviewOptions.add('7 days');
    //Filter option
    _filterOptions.add('All');
    _filterOptions.add('Active');
    _filterOptions.add('Ready To Be Picked');
    _filterOptions.add('On the way');
    _filterOptions.add('Completed');
    _filterOptions.add('Rejected');
    // _filterOptions.add('Cancelled');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getDashboardSummary();
      _getMyBookingOrders();
    });
    fcmEventStream = eventBus.on<FCMNotificationEvent>().listen((event) {
      if (event != null && event.data != null)
        switch (event.data.notifyType) {
          case "runner_allocation":
            //TODO:
            _refreshController.requestRefresh();
            break;
          case "user_runner_assigned":
            //TODO: refresh page Home page and open order detail page
            selectedBookingFilterIndex = 1;
            _refreshController.requestRefresh();
            break;
          case "ORDER_READY_DELIVERYBOY":
            //TODO: refresh page Home page and open order detail page
            selectedBookingFilterIndex = 2;
            _refreshController.requestRefresh();

            break;
        }
    });

    refreshEventStream = eventBus.on<RefreshEvent>().listen((event) {
      if (mounted && _refreshController != null)
        _refreshController.requestRefresh();
    });
  }

  void _getDashboardSummary(
      {bool isShowLoader = true, String selectedFilter}) async {
    if (!getIt.get<NetworkConnectionObserver>().offline) {
      if (isShowLoader) AppUtils.showLoader(context);
      isDashboardApiLoading = true;
      _dashboardResponse = await getIt
          .get<DashboardRepository>()
          .getDashboardSummary(
              userId: userId,
              filterOption: _selectedFilterParam(selectedFilter));
      AppUtils.hideLoader(context);
      isDashboardApiLoading = false;
      _refreshController.refreshCompleted();
      setState(() {});
    } else {
      AppUtils.noNetWorkDialog(context);
    }
  }

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

  void _getMyBookingOrders({bool isShowLoader = true}) async {
    if (!getIt.get<NetworkConnectionObserver>().offline) {
      if (isShowLoader) AppUtils.showLoader(context);
      isBookingApiLoading = true;
      _bookingResponse = await getIt.get<DashboardRepository>().getBookings(
          userId: userId,
          status:
              _getCurrentStatus(_filterOptions[selectedBookingFilterIndex]));
      _getFilterCount();
      setState(() {});
      AppUtils.hideLoader(context);
      isBookingApiLoading = false;
    } else {
      AppUtils.noNetWorkDialog(context);
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    if (fcmEventStream != null) fcmEventStream.cancel();
    if (refreshEventStream != null) refreshEventStream.cancel();
  }

  void _onRefresh() async {
    _getDashboardSummary(
        isShowLoader: false, selectedFilter: _selectedOverviewOption);
    _getMyBookingOrders(isShowLoader: false);
  }

  @override
  Widget builder(BuildContext context) {
    return new Scaffold(
      backgroundColor: AppTheme.white,
      body: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left: 40.0),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi, ${AppSharedPref.instance.getUserName()} ${AppSharedPref.instance.getUserLastName()}",
                      style: TextStyle(
                          fontSize: Dimensions.getScaledSize(20),
                          fontWeight: FontWeight.bold,
                          color: AppTheme.white,
                          fontFamily: AppConstants.fontName),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    //TODO: Handle this Date Concept
//                      Text(
//                        "Today, Thu 5 August",
//                        style: TextStyle(
//                            fontSize: Dimensions.getScaledSize(16),
//                            fontWeight: FontWeight.normal,
//                            color: AppTheme.subHeadingTextColor,
//                            fontFamily: AppConstants.fontName),
//                      ),
                  ],
                ),
                height: Dimensions.getHeight(percentage: 10.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.2, 0.9],
                    colors: [
                      AppTheme.primaryColorDark,
                      AppTheme.primaryColor,
                    ],
                  ),
                ),
              ),
              Container(
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0))),
                margin:
                    EdgeInsets.only(top: Dimensions.getHeight(percentage: 6.0)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 26.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Overview',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Dimensions.getScaledSize(
                                      AppConstants.largeSize),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            child: PopupMenuButton(
                              elevation: 3.2,
                              iconSize: 5.0,
                              tooltip: 'Sorting',
                              child: Row(
                                children: [
                                  Text(
                                    _selectedOverviewOption,
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
                                            visible: _selectedOverviewOption ==
                                                choice,
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
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              shadowColor: AppTheme.borderOnFocusedColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              elevation: 4,
                              color: AppTheme.optionTotalEarningColor,
                              margin: EdgeInsets.fromLTRB(Dimensions.pixels_5,
                                  0, Dimensions.pixels_5, 0),
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Image.asset(
                                      AppImages.icon_totalearningfullicon,
                                      height: 30,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.all(Dimensions.pixels_10),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text.rich(
                                            TextSpan(
                                              text: '${AppConstants.currency} ',
                                              style: TextStyle(
                                                  fontSize:
                                                      AppConstants.smallSize,
                                                  color: AppTheme.white,
                                                  fontFamily:
                                                      AppConstants.fontName,
                                                  fontWeight:
                                                      FontWeight.normal),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: _dashboardResponse
                                                            ?.summery
                                                            ?.totalEarning ??
                                                        '--',
                                                    style: TextStyle(
                                                        fontSize: AppConstants
                                                            .largeSize,
                                                        color: AppTheme.white,
                                                        fontFamily: AppConstants
                                                            .fontName,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                            textAlign: TextAlign.center),
                                        Text(
                                          'Total Earnings',
                                          style: TextStyle(
                                              color: AppTheme.white,
                                              fontFamily: AppConstants.fontName,
                                              fontSize:
                                                  AppConstants.extraSmallSize),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              shadowColor: AppTheme.borderOnFocusedColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              elevation: 4,
                              color: AppTheme.optionTotalBookingBgColor,
                              margin: EdgeInsets.fromLTRB(Dimensions.pixels_5,
                                  0, Dimensions.pixels_5, 0),
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Image.asset(
                                      AppImages.icon_totalbookingfullicon,
                                      height: 30,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.all(Dimensions.pixels_10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          _dashboardResponse
                                                  ?.summery?.totalBookings ??
                                              '--',
                                          style: TextStyle(
                                              fontSize: AppConstants.largeSize,
                                              fontFamily: AppConstants.fontName,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.white),
                                        ),
                                        Text(
                                          'Total Bookings',
                                          style: TextStyle(
                                              color: AppTheme.white,
                                              fontFamily: AppConstants.fontName,
                                              fontSize:
                                                  AppConstants.extraSmallSize),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Expanded(
                          //   child: Card(
                          //     shadowColor: AppTheme.borderOnFocusedColor,
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(25.0),
                          //     ),
                          //     elevation: 4,
                          //     color: AppTheme.optionTotalCustomerBgColor,
                          //     margin: EdgeInsets.fromLTRB(Dimensions.pixels_5,
                          //         0, Dimensions.pixels_5, 0),
                          //     child: Stack(
                          //       alignment: Alignment.topCenter,
                          //       children: [
                          //         Align(
                          //           alignment: Alignment.topRight,
                          //           child: Image.asset(
                          //             AppImages.icon_totalcustomerfullicon,
                          //             height: 27,
                          //           ),
                          //         ),
                          //         Padding(
                          //           padding:
                          //               EdgeInsets.all(Dimensions.pixels_10),
                          //           child: Column(
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.center,
                          //             children: [
                          //               SizedBox(
                          //                 height: 15,
                          //               ),
                          //               Text(
                          //                 _dashboardResponse
                          //                         ?.summery?.totalCustomers ??
                          //                     '--',
                          //                 style: TextStyle(
                          //                     fontSize: AppConstants.largeSize,
                          //                     fontFamily: AppConstants.fontName,
                          //                     fontWeight: FontWeight.bold,
                          //                     color: AppTheme.white),
                          //               ),
                          //               Text(
                          //                 'Total Customer',
                          //                 style: TextStyle(
                          //                     color: AppTheme.white,
                          //                     fontFamily: AppConstants.fontName,
                          //                     fontSize:
                          //                         AppConstants.extraSmallSize),
                          //               ),
                          //               SizedBox(
                          //                 height: 10,
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _addNewBookingView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addNewBookingView() {
    return Stack(
      children: [
        !isDashboardApiLoading &&
                _dashboardResponse != null &&
                _dashboardResponse.bookingRequests != null &&
                _dashboardResponse.bookingRequests.isNotEmpty
            ? Container(
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      topLeft: Radius.circular(30.0)),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 18.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Request',
                            style: TextStyle(
                                fontSize: AppConstants.smallSize,
                                color: AppTheme.white,
                                fontFamily: AppConstants.fontName),
                          ),
                          InkWell(
                            onTap: () async {
                              bool refreshData =
                                  await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NewRequestBookingScreen(
                                          userId: userId,
                                          filter: _selectedFilterParam(
                                              _selectedOverviewOption),
                                        )),
                              );
                              if (refreshData != null && refreshData) {
                                _refreshController.requestRefresh();
                              }
                            },
                            child: Text(
                              'View All',
                              style: TextStyle(
                                  fontSize: AppConstants.smallSize,
                                  color: AppTheme.white,
                                  fontFamily: AppConstants.fontName),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 250,
                      child: PageView(
                        scrollDirection: Axis.horizontal,
                        controller: _pageController,
                        children: _dashboardResponse.bookingRequests
                            .map((bookingRequest) => ItemViewOrderRequests(
                                bookingRequest: bookingRequest,
                                callback: _bookingRequestActionMethod))
                            .toList(),
                      ),
                    ),
                    SmoothPageIndicator(
                        controller: _pageController,
                        count: _dashboardResponse.bookingRequests.length,
                        effect: ExpandingDotsEffect(
                          radius: 8,
                          dotHeight: 6,
                          dotWidth: 6,
                          expansionFactor: 4,
                          dotColor: Colors.white30,
                          activeDotColor: AppTheme.white,
                          spacing: 5,
                        )),
                  ],
                ),
              )
            : Container(),
        Container(
          decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.getScaledSize(30)),
                topRight: Radius.circular(Dimensions.getScaledSize(30)),
              )),
          margin: EdgeInsets.only(
            top: _dashboardResponse != null &&
                    _dashboardResponse.bookingRequests != null &&
                    _dashboardResponse.bookingRequests.isNotEmpty
                ? 320
                : 0,
          ),
          child: Center(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Orders',
                      style: TextStyle(
                          fontSize: AppConstants.smallSize,
                          color: AppTheme.subHeadingTextColor,
                          fontFamily: AppConstants.fontName),
                    ),
                    InkWell(
                      onTap: () async {
                        if (widget.callback != null) widget.callback();
                      },
                      child: Text(
                        'View All',
                        style: TextStyle(
                            fontSize: AppConstants.smallSize,
                            color: AppTheme.primaryColor,
                            fontFamily: AppConstants.fontName),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 36.0,
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  itemCount: _filterOptions.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        setState(() {
                          selectedBookingFilterIndex = index;
                          _getMyBookingOrders();
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.only(left: 4, right: 4),
                          padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                          decoration: BoxDecoration(
                              color: selectedBookingFilterIndex == index
                                  ? AppTheme.primaryColor.withOpacity(0.1)
                                  : AppTheme.borderNotFocusedColor,
                              border: Border.all(
                                  color: selectedBookingFilterIndex == index
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
                      ? Container(
                          child: ListView.separated(
                            padding: EdgeInsets.all(18.0),
                            shrinkWrap: true,
                            itemCount: _bookingResponse.bookings.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return ItemBooking(
                                _bookingResponse.bookings[index],
                                _bookingAction,
                                readStatusChange: () {
                                  _bookingResponse.bookings[index].readStatus =
                                      '1';
                                },
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 8.0,
                              );
                            },
                          ),
                        )
                      : _noOrderContainer(),
            ],
          )),
        ),
      ],
    );
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

  _getCurrentStatus(String status) {
//    0 => 'pending',
//    1 =>'accepted',
//    2 =>'rejected',
//    4 =>'ongoing',
//    5 =>'completed',
//    6 => 'cancelled' // cancelled by customer
//    7 => 'On the way'
//    8 => 'Ready to be picked'
    if (status.toLowerCase().contains('all')) {
      return '0';
    } else if (status.toLowerCase().contains('active')) {
      //processing
      return '1';
    } else if (status.toLowerCase().contains('ready to be picked')) {
      return '8';
    } else if (status.toLowerCase().contains('on the way')) {
      return '7';
    } else if (status.toLowerCase().contains('rejected')) {
      return '2';
    } else if (status.toLowerCase().contains('completed')) {
      return '5';
    } else if (status.toLowerCase().contains('cancelled')) {
      return '6';
    } else {
      return '0';
    }
  }

  _getFilterCount() {
    if (_bookingResponse != null && _bookingResponse.bookingCounts != null) {
      _filterOptions[0] = '${_bookingResponse.bookingCounts.all} | All';
      _filterOptions[1] =
          '${_bookingResponse.bookingCounts.active != null ? _bookingResponse.bookingCounts.active : "0"} | Active';
      _filterOptions[2] =
          '${_bookingResponse.bookingCounts.readyToBePicked} | Ready To Be Picked';
      _filterOptions[3] =
          '${_bookingResponse.bookingCounts.onTheWay} | On the way';
      _filterOptions[4] =
          '${_bookingResponse.bookingCounts.completed} | Completed';
      _filterOptions[5] =
          '${_bookingResponse.bookingCounts.rejected} | Rejected';
    }
  }

  void _bookingRequestActionMethod(
      BookingRequest bookingRequest, RequestStatus status) async {
    eventBus.fire(ReminderAlarmEvent.dismissNotification(
        ReminderAlarmEvent.notificationDismiss));
    if (!isDutyOn()) {
      return;
    }
    switch (status) {
      case RequestStatus.accept:
        if (!getIt.get<NetworkConnectionObserver>().offline) {
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
              _pageController.jumpToPage(0);
              if (isAccepted) {
                appPrintLog('Your Booking request is accepted');
                setState(() {});
                _getMyBookingOrders();
              }
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
          AppUtils.showLoader(context);
          BaseResponse baseResponse = await getIt
              .get<DashboardRepository>()
              .changeBookingRequestAction(
                  userId: userId, orderId: bookingRequest.id, status: '2');
          AppUtils.hideLoader(context);
          if (baseResponse != null) {
            if (baseResponse.success) {
              bool isDeleted =
                  _dashboardResponse.bookingRequests.remove(bookingRequest);
              _pageController.jumpToPage(0);
              if (isDeleted) {
                appPrintLog('Your Booking request is Rejected');
                setState(() {});
                _getMyBookingOrders();
              }
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

  _bookingAction(
    String type,
    dynamic booking,
  ) async {
    if (!getIt.get<NetworkConnectionObserver>().offline) {
      if (type == 'refresh') {
        _onRefresh();
        setState(() {});
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
          int tempIndex = -1;
          for (int i = 0; i < _bookingResponse.bookings.length; i++) {
            if (booking.id == _bookingResponse.bookings[i].id) {
              tempIndex = i;
              break;
            }
          }
          // int index = _bookingResponse.bookings.indexOf(booking);
          if (tempIndex == -1) {
            return;
          }
          int index = tempIndex;
          _changeCounterStatus(type);
          _bookingResponse.bookings[index].status = _changeBookingStatus(type);
          if (selectedBookingFilterIndex != 0) {
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

  _changeBookingStatus(String type) {
    switch (type) {
      case 'On the way':
        return '7';
        break;
      case 'Complete':
        return '5';
        break;
    }
  }

  _changeCounterStatus(String type) {
    switch (type) {
      case 'On the way':
        int ongoingCounter = int.parse(_bookingResponse.bookingCounts.onTheWay);
        ongoingCounter = ongoingCounter + 1;
        _bookingResponse.bookingCounts.onTheWay = ongoingCounter.toString();
        int readyToBePickedCounter =
            int.parse(_bookingResponse.bookingCounts.readyToBePicked);
        readyToBePickedCounter = readyToBePickedCounter - 1;
        _bookingResponse.bookingCounts.readyToBePicked =
            readyToBePickedCounter.toString();
        print("active===${_bookingResponse.bookingCounts.readyToBePicked}");
        break;
      case 'Complete':
        int ongoingCounter = int.parse(_bookingResponse.bookingCounts.onTheWay);
        ongoingCounter = ongoingCounter - 1;
        _bookingResponse.bookingCounts.onTheWay = ongoingCounter.toString();

        int completedCounter =
            int.parse(_bookingResponse.bookingCounts.completed);
        completedCounter = completedCounter + 1;
        _bookingResponse.bookingCounts.completed = completedCounter.toString();
        break;
    }
    _getFilterCount();
  }
}
