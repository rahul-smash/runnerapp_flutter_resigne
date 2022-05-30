import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/payout_summary_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/payout_pages/deposit_cash_screen.dart';
import 'package:marketplace_service_provider/src/components/dashboard/payout_pages/deposit_history_screen.dart';
import 'package:marketplace_service_provider/src/components/dashboard/payout_pages/payout_completed.dart';
import 'package:marketplace_service_provider/src/components/dashboard/payout_pages/pending_payouts.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/payout_repository.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/due_payout_detail_screen.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/new_request_booking_screen.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/common_widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeNewBookingRequestScreen extends StatefulWidget {
  VoidCallback menuInteraction;

  @override
  _HomeNewBookingRequestScreenState createState() => _HomeNewBookingRequestScreenState();

  HomeNewBookingRequestScreen(this.menuInteraction);
}

class _HomeNewBookingRequestScreenState extends BaseState<HomeNewBookingRequestScreen> {
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  String _selectedOverviewOption = 'Today';
  List<String> _overviewOptions = List.empty(growable: true);
  PayoutSummaryResponse payoutSummaryResponse;

  bool isApiLoading = false;

  void _onRefresh() async {

  }

  @override
  void initState() {
    super.initState();
    _overviewOptions.add('Today');
    _overviewOptions.add('Yesterday');
    _overviewOptions.add('7 days');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    });
  }

  _getAppBar() {
    return BaseAppBar(
      backgroundColor: AppTheme.white,
      title: Text(
        labelNewBookingRequest,
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
        // Container(
        //   child: PopupMenuButton(
        //     elevation: 3.2,
        //     iconSize: 5.0,
        //     onCanceled: () {
        //       print('You have not choosed anything');
        //     },
        //     tooltip: 'Sorting',
        //     child: Row(
        //       children: [
        //         Text(
        //           'Sort By',
        //           style: TextStyle(
        //               color: AppTheme.subHeadingTextColor,
        //               fontSize: AppConstants.smallSize,
        //               fontWeight: FontWeight.w500),
        //         ),
        //         SizedBox(
        //           width: 5,
        //         ),
        //         Image.asset(
        //           AppImages.icon_dropdownarrow,
        //           height: 5,
        //         ),
        //         SizedBox(
        //           width: 15,
        //         ),
        //       ],
        //     ),
        //     onSelected: (value) {
        //       if (value == 'Booking Date') {
        //         _selectedSortingType = FilterType.Booking_Date;
        //       } else {
        //         _selectedSortingType = FilterType.Delivery_Time_Slot;
        //       }
        //       _refreshController.requestRefresh();
        //     },
        //     shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.all(Radius.circular(15.0))),
        //     itemBuilder: (BuildContext context) {
        //       return _sortingType.map((String choice) {
        //         return PopupMenuItem(
        //           value: choice,
        //           child: Row(
        //             mainAxisSize: MainAxisSize.max,
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               Text(
        //                 choice,
        //                 style: TextStyle(
        //                     color: _checkSelected(choice)
        //                         ? AppTheme.primaryColorDark
        //                         : AppTheme.mainTextColor),
        //               ),
        //               Visibility(
        //                   visible: _checkSelected(choice),
        //                   child: Icon(
        //                     Icons.check,
        //                     color: AppTheme.primaryColorDark,
        //                   ))
        //             ],
        //           ),
        //         );
        //       }).toList();
        //     },
        //   ),
        // )
      ],
    );
  }
  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      backgroundColor: AppTheme.white,
      body: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
      // child: Container(),
        child: Container(
            child:  NewRequestBookingScreen(
                userId: userId,
                filter: _selectedFilterParam(
                _selectedOverviewOption
              ),
            isCameFromHomeScreen: true),
      ),

      )
    );
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

  void _openDepositHistoryScreen() {
    //TODO: handle this
    Navigator.push(context,
        MaterialPageRoute(builder: (builder) => DepositHistoryScreen()));
  }

  void _openDuePayoutDetail() {
    //TODO: handle this
    Navigator.push(context,
        MaterialPageRoute(builder: (builder) => DuePayoutDetailScreen()));
  }

  Widget _createTopCard(
      Color cardBackgroundColor,
      String imageGraphic,
      String bookingCount,
      String labelTitle,
      String bookingPayout,
      String lastUpdated) {
    return Card(
      shadowColor: AppTheme.borderOnFocusedColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: cardBackgroundColor),
        borderRadius: BorderRadius.circular(25.0),
      ),
      elevation: 4,
      color: cardBackgroundColor,
      margin:
      EdgeInsets.fromLTRB(Dimensions.pixels_5, 0, Dimensions.pixels_5, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 15, 10, 15),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(30)),
                ),
                child: Image.asset(
                  AppImages.icon_next_arrow,
                  height: 12,
                  color: cardBackgroundColor,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(height: 15),
                  Image.asset(
                    imageGraphic,
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      labelNumberOfOrder,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: AppConstants.extraSmallSize,
                          color: Colors.white),
                    ),
                  ),
                  Text(
                    bookingCount,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppConstants.extraSmallSize,
                        color: Colors.white),
                  ),
                  Container(
                    width: 40,
                    height: 1,
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(30)),
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                  ),
                  Text(
                    labelTitle,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: AppConstants.smallSize,
                        color: Colors.white),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConstants.currency,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: AppConstants.extraSmallSize,
                              color: Colors.white70),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          bookingPayout,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppConstants.largeSize,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: false,
                    child: Padding(
                      padding:
                      EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5.0),
                      child: Text(
                        '${labelUpdatedAt}${lastUpdated}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: AppConstants.tinySize,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
