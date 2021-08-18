import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/dashboard_resposne.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/dashboard_repository.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/item_booking.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/item_new_request_booking.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/new_request_booking_screen.dart';
import 'package:marketplace_service_provider/src/components/login/model/login_response.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/singleton/login_user_singleton.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/add_image/add_image_bottom_sheet.dart';
import 'package:marketplace_service_provider/src/widgets/common_widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  VoidCallback callback;

  HomeScreen({Key key, this.callback}) : super(key: key);

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  LoginResponse loginResponse;
  List<String> _overviewOptions = List.empty(growable: true);
  List<String> _filterOptions = List.empty(growable: true);
  String _selectedOverviewOption = 'Today';
  final PageController _pageController = PageController(initialPage: 0);
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  DashboardResponse _dashboardResponse;
  BookingResponse _bookingResponse;

  bool isDashboardApiLoading = true;
  bool isBookingApiLoading = true;

  int selectedBookingFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    loginResponse = LoginUserSingleton.instance.loginResponse;
    _overviewOptions.add('Today');
    _overviewOptions.add('Yesterday');
    _overviewOptions.add('7 days');
    //Filter option
    _filterOptions.add('All');
    _filterOptions.add('Upcoming');
    _filterOptions.add('Ongoing');
    _filterOptions.add('Completed');
    _filterOptions.add('Rejected');
    _filterOptions.add('Cancelled');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getDashboardSummary();
      _getMyBookingOrders();
    });
  }

  void _getDashboardSummary(
      {bool isShowLoader = true, String selectedFilter}) async {
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
      isDashboardApiLoading = true;
      _dashboardResponse = await getIt
          .get<DashboardRepository>()
          .getDashboardSummary(
              userId: loginResponse.data.id,
              filterOption: _selectedFilterParam(selectedFilter));
      AppUtils.hideLoader(context);
      isDashboardApiLoading = false;
      _refreshController.refreshCompleted();
      setState(() {});
    } else {
      AppUtils.noNetWorkDialog(context);
    }
  }

  void _getMyBookingOrders({bool isShowLoader = true}) async {
    if (!getIt.get<NetworkConnectionObserver>().offline) {
      if (isShowLoader) AppUtils.showLoader(context);
      isBookingApiLoading = true;
      _bookingResponse = await getIt.get<DashboardRepository>().getBookings(
          userId: loginResponse.data.id,
          status: _getCurrentStatus(selectedBookingFilterIndex));
      _getFilterCount();
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
  }

  void _onRefresh() async {
    _getDashboardSummary(isShowLoader: false,selectedFilter: _selectedOverviewOption);
    _getMyBookingOrders(isShowLoader: false);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: AppTheme.white,
      body: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: Container(
            child: SingleChildScrollView(
          child: Stack(
            children: [
              //User Name
              CommonWidgets.gradientContainer(
                  context,
                  -1,
                  SizeConfig.screenWidth,
                  Container(
                    margin: EdgeInsets.only(
                        left: Dimensions.getScaledSize(45),
                        bottom: Dimensions.getScaledSize(45)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, ${loginResponse.data.fullName} ${loginResponse.data.lastName}",
                          style: TextStyle(
                              fontSize: Dimensions.getScaledSize(20),
                              fontWeight: FontWeight.bold,
                              color: AppTheme.white,
                              fontFamily: AppConstants.fontName),
                        ),
                        SizedBox(
                          height: 20,
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
                margin: EdgeInsets.only(top: Dimensions.getScaledSize(60)),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          Dimensions.getScaledSize(26),
                          Dimensions.getScaledSize(16),
                          Dimensions.getScaledSize(26),
                          0),
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
                          // Flexible(
                          //   child: SizedBox(
                          //     width: 100,
                          //     child: DropdownButtonFormField(
                          //       dropdownColor: Colors.white,
                          //       items: _overviewOptions.map((String options) {
                          //         return DropdownMenuItem(
                          //             value: options,
                          //             child: Container(
                          //               child: Text(
                          //                 options,
                          //                 textAlign: TextAlign.end,
                          //                 style: TextStyle(
                          //                     color: AppTheme.subHeadingTextColor,
                          //                     fontFamily: AppConstants.fontName,
                          //                     fontSize: AppConstants.smallSize),
                          //               ),
                          //             ));
                          //       }).toList(),
                          //       onTap: () {},
                          //       onChanged: (newValue) {
                          //         // do other stuff with _category
                          //         setState(
                          //             () => _selectedOverviewOption = newValue);
                          //       },
                          //       value: _selectedOverviewOption,
                          //       decoration: InputDecoration(
                          //         contentPadding: EdgeInsets.all(0),
                          //         filled: true,
                          //         border: InputBorder.none,
                          //         fillColor: AppTheme.transparent,
                          //         focusColor: AppTheme.transparent,
                          //         hoverColor: AppTheme.transparent,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          Dimensions.getScaledSize(22),
                          0,
                          Dimensions.getScaledSize(22),
                          Dimensions.getScaledSize(10)),
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
                                      height: 27,
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
                                                  fontSize: AppConstants
                                                      .extraSmallSize,
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
                                      height: 27,
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
                          Expanded(
                            child: Card(
                              shadowColor: AppTheme.borderOnFocusedColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              elevation: 4,
                              color: AppTheme.optionTotalCustomerBgColor,
                              margin: EdgeInsets.fromLTRB(Dimensions.pixels_5,
                                  0, Dimensions.pixels_5, 0),
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Image.asset(
                                      AppImages.icon_totalcustomerfullicon,
                                      height: 27,
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
                                                  ?.summery?.totalCustomers ??
                                              '--',
                                          style: TextStyle(
                                              fontSize: AppConstants.largeSize,
                                              fontFamily: AppConstants.fontName,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.white),
                                        ),
                                        Text(
                                          'Total Customer',
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
                        ],
                      ),
                    ),
                    _addNewBookingView(),
                  ],
                ),
              ),
            ],
          ),
        )),
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
            ? ClipRRect(
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(30.0),
                    topRight: const Radius.circular(30.0)),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(30.0),
                          topRight: const Radius.circular(30.0))),
                  child: CommonWidgets.gradientContainer(
                      context,
                      Dimensions.getHeight(percentage: 47),
                      SizeConfig.screenWidth,
                      Padding(
                        padding: EdgeInsets.all(
                          Dimensions.getScaledSize(26),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'New Booking',
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
                                                  _dashboardResponse)),
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
                            SizedBox(
                              height: 16,
                            ),
                            Flexible(
                              child: PageView(
                                /// [PageView.scrollDirection] defaults to [Axis.horizontal].
                                /// Use [Axis.vertical] to scroll vertically.
                                scrollDirection: Axis.horizontal,
                                controller: _pageController,
                                children: _dashboardResponse.bookingRequests
                                    .map((bookingRequest) =>
                                        ItemNewRequestBooking(bookingRequest,
                                            _bookingRequestActionMethod))
                                    .toList(),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SmoothPageIndicator(
                                controller: _pageController,
                                count:
                                    _dashboardResponse.bookingRequests.length,
                                effect: ExpandingDotsEffect(
                                  radius: 8,
                                  dotHeight: 8,
                                  dotWidth: 8,
                                  dotColor: AppTheme.borderOnFocusedColor,
                                  activeDotColor: AppTheme.white,
                                  spacing: 5,
                                )),
                            SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      )),
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
            top: Dimensions.getHeight(
                percentage: _dashboardResponse != null &&
                        _dashboardResponse.bookingRequests != null &&
                        _dashboardResponse.bookingRequests.isNotEmpty
                    ? 43
                    : 0),
          ),
          child: Center(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  Dimensions.getScaledSize(26),
                  Dimensions.getScaledSize(30),
                  Dimensions.getScaledSize(26),
                  Dimensions.getScaledSize(26),
                ),
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
                height: 30,
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 10, right: 10),
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
                          height: 30,
                          margin: EdgeInsets.only(left: 4, right: 4),
                          padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
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
                          child: ListView.builder(
                              padding:
                                  EdgeInsets.all(Dimensions.getScaledSize(10)),
                              shrinkWrap: true,
                              itemCount: _bookingResponse.bookings.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return ItemBooking(
                                    _bookingResponse.bookings[index],
                                    _bookingAction);
                              }),
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

  Future<Function> _bookingRequestActionMethod(
      String type, BookingRequest bookingRequest) async {
    switch (type) {
      case 'Accept':
        if (!getIt.get<NetworkConnectionObserver>().offline) {
          AppUtils.showLoader(context);
          BaseResponse baseResponse = await getIt
              .get<DashboardRepository>()
              .changeBookingRequestAction(
                  userId: loginResponse.data.id,
                  orderId: bookingRequest.id,
                  status: '1');
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
      case 'Reject':
        if (!getIt.get<NetworkConnectionObserver>().offline) {
          AppUtils.showLoader(context);
          BaseResponse baseResponse = await getIt
              .get<DashboardRepository>()
              .changeBookingRequestAction(
                  userId: loginResponse.data.id,
                  orderId: bookingRequest.id,
                  status: '2');
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

  _bookingAction(String type, Booking booking,) async {
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
              userId: loginResponse.data.id,
              orderId: booking.id,
              status: _changeBookingStatus(type));
      AppUtils.hideLoader(context);
      if (baseResponse != null) {
        if (baseResponse.success) {
          int index = _bookingResponse.bookings.indexOf(booking);
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
      case 'Ongoing':
        return '4';
        break;
      case 'Complete':
        return '5';
        break;
    }
  }
}
