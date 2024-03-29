import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/dashboard_response_summary.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/dashboard_repository.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/booking_details_screen.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/edit_order_screen.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/step_viewer.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/utils/callbacks.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/cash_collection_bottom_sheet.dart';

import '../../../utils/app_strings.dart';
import 'InvoiceImageView.dart';

class ItemBooking extends StatefulWidget {
  final BookingRequest booking;
  final Function callBackMethod;
  final bool isRejected;
  final VoidCallback readStatusChange;

  ItemBooking(this.booking, this.callBackMethod,
      {this.readStatusChange, this.isRejected});

  @override
  _ItemBookingState createState() => _ItemBookingState();
}

class _ItemBookingState extends BaseState<ItemBooking> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget builder(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.booking.readStatus = '1';
        widget.readStatusChange();

        print(widget.isRejected);
        setState(() {});

        if (widget.isRejected) {
          print("status 2");
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => BookingDetailsScreen(
                          widget.booking, callBackMethod: (status) {
                        widget.booking.status = status;
                        if (mounted) {
                          setState(() {});
                        }
                        widget.callBackMethod('refresh', widget.booking);
                      })));
        }
      },
      child: Card(
        color: Colors.white,
        elevation: 8.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Container(
          padding: EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#${widget.booking.displayOrderId} | ${AppUtils.convertDateTime(widget.booking.created)}',
                style: TextStyle(
                    fontSize: 12.0,
                    color: AppTheme.subHeadingTextColor,
                    fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                'Pickup Address',
                style: TextStyle(
                    fontFamily: AppConstants.fontName,
                    fontSize: 14.0,
                    color: AppTheme.subHeadingTextColor,
                    fontWeight: FontWeight.normal),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        Text(
                          widget.booking.store.storeName,
                          style: TextStyle(
                              fontFamily: AppConstants.fontName,
                              fontSize: 18.0,
                              color: AppTheme.mainTextColor,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        SizedBox.fromSize(
                          child: Text(
                            getStoreAddress(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: AppConstants.fontName,
                                fontSize: 14.0,
                                color: AppTheme.mainTextColor,
                                fontWeight: FontWeight.normal),
                          ),
                          size: Size.fromHeight(36.0),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Order Amount",
                        style: TextStyle(
                            fontFamily: AppConstants.fontName,
                            fontSize: 16.0,
                            color: AppTheme.mainTextColor,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        "${AppConstants.currency}${widget.booking.total}",
                        style: TextStyle(
                            fontFamily: AppConstants.fontName,
                            fontSize: 16.0,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600),
                      ),
                      // Visibility(
                      //   visible:
                      //       widget.booking.paymentMethod.toLowerCase() != 'cod',
                      //   child: Text(
                      //     "PAID",
                      //     style: TextStyle(
                      //         fontFamily: AppConstants.fontName,
                      //         fontSize: 16.0,
                      //         color: AppTheme.primaryColor,
                      //         fontWeight: FontWeight.w600),
                      //   ),
                      // ),
                      Visibility(
                        visible:
                            widget.booking.paymentMethod.toLowerCase() == 'cod',
                        child: Container(
                          margin: EdgeInsets.only(top: 2.0),
                          decoration: BoxDecoration(
                              color: AppTheme.containerBackgroundColor,
                              borderRadius: BorderRadius.circular(16.0)),
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          child: Text(
                            "${widget.booking.paymentMethod.toUpperCase()}",
                            style: TextStyle(
                                fontFamily: AppConstants.fontName,
                                fontSize: 10.0,
                                color: AppTheme.mainTextColor,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                'Delivery Address',
                style: TextStyle(
                    fontFamily: AppConstants.fontName,
                    fontSize: AppConstants.smallSize,
                    color: AppTheme.subHeadingTextColor,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 4.0,
              ),
              SizedBox.fromSize(
                child: Text(
                  widget.booking.bookingRequestUserAddress,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: AppConstants.fontName,
                      fontSize: 14.0,
                      color: AppTheme.mainTextColor,
                      fontWeight: FontWeight.normal),
                ),
                size: Size.fromHeight(36.0),
              ),
              SizedBox(
                height: 8.0,
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InvoiceImageView(
                                    booking: widget.booking,
                                    imageType: "0",
                                  )));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.borderNotFocusedColor,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      child: Text("Invoice",
                          style: TextStyle(
                              color: AppTheme.black,
                              fontSize: AppConstants.smallSize,
                              fontWeight: FontWeight.normal)),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InvoiceImageView(
                                    booking: widget.booking,
                                    imageType: "1",
                                  )));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.borderNotFocusedColor,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      child: Text("Doorstep",
                          style: TextStyle(
                              color: AppTheme.black,
                              fontSize: AppConstants.smallSize,
                              fontWeight: FontWeight.normal)),
                    ),
                  )
                  // Container(
                  //   child: Wrap(children: [
                  //     Row(
                  //       children: [
                  //         TextButton(
                  //             onPressed: () {
                  //               Navigator.push(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                       builder: (context) => InvoiceImageView(
                  //                             booking: widget.booking,
                  //                             imageType: "0",
                  //                           )));
                  //             },
                  //             child: Text("Invoice")),
                  //         TextButton(
                  //             onPressed: () {
                  //               Navigator.push(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                       builder: (context) => InvoiceImageView(
                  //                             booking: widget.booking,
                  //                             imageType: "1",
                  //                           )));
                  //             },
                  //             child: Text("Doorstep")),
                  //       ],
                  //     ),
                  //   ]),
                  // ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              SizedBox(
                height: 10.0,
              ),
              Visibility(
                visible: widget.booking.runnerDeliveryAccepted == '1',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child:
                          /*StepViewer(
                        stopsRadius: 8.0,
                        pathColor: AppTheme.primaryColor,
                        stopColor: AppTheme.primaryColor,
                        stopValues: [
                      'You',
                      'Pickup',
                      'Delivery',
                        ],
                        distanceValues: [
                      '600m',
                      '1.5km',
                        ],
                      )*/
                          Container(),
                    ),
                    SizedBox(width: 8.0),
                    _getWidgetAccordingToStatus()
                  ],
                ),
              ),
              Visibility(
                visible: widget.booking.runnerDeliveryAccepted == '1' &&
                    widget.booking.isManualAssignment == '1' &&
                    widget.booking.readStatus == '0',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        eventBus.fire(ReminderAlarmEvent.dismissNotification(
                            ReminderAlarmEvent.notificationDismiss));
                        _getReadOrder(widget.booking);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            stops: [0.1, 0.5, 0.5, 0.9],
                            colors: [
                              AppTheme.primaryColorDark,
                              AppTheme.primaryColor,
                              AppTheme.primaryColor,
                              AppTheme.primaryColor,
                            ],
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        child: Text('Mark as read',
                            style: TextStyle(
                                color: AppTheme.white,
                                fontSize: AppConstants.extraSmallSize,
                                fontWeight: FontWeight.normal)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getWidgetAccordingToStatus() {
    //    0 => 'pending',
//    1 =>'accepted',
//    2 =>'rejected',
//    4 =>'ongoing',
//    5 =>'completed',
//    6 => 'cancelled' // cancelled by customer\

    //ongoing
    //Complete
    switch (widget.booking.status) {
      case '0':
        Container();
        break; // all
      case '2':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Row(
                children: [
                  Image.asset(
                    AppImages.icon_rejected,
                    height: 14.0,
                  ),
                  SizedBox(
                    width: 2.0,
                  ),
                  Text('Rejected',
                      style: TextStyle(
                          color: AppTheme.errorRed,
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal)),
                ],
              ),
            ),
          ],
        );
        break;
      case '7':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Row(
                children: [
                  Image.asset(
                    AppImages.icon_ongoing,
                    height: 10.0,
                  ),
                  SizedBox(
                    width: 2.0,
                  ),
                  Text(_getCurrentOrderStatus(widget.booking),
                      style: TextStyle(
                          color: AppTheme.optionTotalBookingBgColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal)),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.subHeadingTextColor,
              size: 16.0,
            ),
            SizedBox(
              width: 2.0,
            ),
            InkWell(
              onTap: () {
                if (!isDutyOn()) {
                  return;
                }
                if (widget.booking.paymentMethod
                    .toLowerCase()
                    .trim()
                    .contains('cod')) {
                  CashCollectionBottomSheet(context, widget.booking,
                      widget.callBackMethod, 'Complete', '0');
                } else {
                  widget.callBackMethod('Complete', widget.booking);
                  // AddImageBottomSheet(context, widget.booking, 'online');
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColorDark,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                child: Row(
                  children: [
                    Image.asset(
                      AppImages.icon_complete,
                      color: AppTheme.white,
                      height: 8.0,
                    ),
                    SizedBox(
                      width: 2.0,
                    ),
                    Text('Complete',
                        style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
            ),
          ],
        );
        break;
      case '5':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Row(
                children: [
                  Image.asset(
                    AppImages.icon_complete,
                    height: 8.0,
                  ),
                  SizedBox(
                    width: 2.0,
                  ),
                  Text('Completed',
                      style: TextStyle(
                          color: AppTheme.primaryColorDark,
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal)),
                ],
              ),
            ),
          ],
        );
        break;
      case '6':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Row(
                children: [
                  Image.asset(
                    AppImages.icon_rejected,
                    height: 14.0,
                  ),
                  SizedBox(
                    width: 2.0,
                  ),
                  Text('Cancelled',
                      style: TextStyle(
                          color: AppTheme.errorRed,
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal)),
                ],
              ),
            ),
          ],
        );
        break; // cancelled
      case '1':
      case '8':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Row(
                children: [
                  Image.asset(
                    AppImages.icon_upcoming,
                    height: 14,
                  ),
                  SizedBox(
                    width: 2.0,
                  ),
                  Text(_getCurrentOrderStatus(widget.booking),
                      style: TextStyle(
                          color: Color(0xFF1CCDCD),
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal)),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.subHeadingTextColor,
              size: 16.0,
            ),
            SizedBox(
              width: 2.0,
            ),
            Visibility(
              visible: widget.booking.status == '8',
              child: InkWell(
                onTap: () {
                  if (!isDutyOn()) {
                    return;
                  }
                  //TODO: check status if order is Ready To Picked
                  if (widget.booking.status == '8')
                    widget.callBackMethod('On the way', widget.booking);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.optionTotalBookingBgColor,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                  child: Row(
                    children: [
                      Image.asset(
                        AppImages.icon_ongoing,
                        color: AppTheme.white,
                        height: 10,
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      Text('On the way',
                          style: TextStyle(
                              color: AppTheme.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
        break;
    }
  }

  String getStoreAddress() {
    String address = widget.booking.store?.location ?? "";
    if (widget.booking.store?.city != null &&
        widget.booking.store.city.isNotEmpty) {
      address += ", ${widget.booking.store?.city}";
    }
    if (widget.booking.store?.state != null &&
        widget.booking.store.state.isNotEmpty) {
      address += ", ${widget.booking.store?.state}";
    }
    return address;
  }

  String _getCurrentOrderStatus(BookingRequest booking) {
    switch (booking.status) {
      case '0':
        return 'Due';
        break; //Due
      case '1':
        return 'Processing';
        break; //Processing
      case '2':
        return 'Rejected';
        break; //Rejected
      case '5':
        return 'Delivered';
        break; //Delivered
      case '6':
        return 'Cancel';
        break; //Cancel
      case '7':
        return 'On the way';
        break; //On the way
      case '8':
        return 'Ready to be picked';
        break; //Ready to be picked
    }

    return '';
  }

  void _getReadOrder(
    BookingRequest booking,
  ) async {
    if (!getIt.get<NetworkConnectionObserver>().offline) {
      BaseResponse baseResponse = await getIt
          .get<DashboardRepository>()
          .getReadBooking(userId: userId, orderId: booking.id);
      if (baseResponse != null && baseResponse.success) {
        widget.booking.readStatus = '1';
        widget.readStatusChange();
        setState(() {});
      }
    } else {
      AppUtils.noNetWorkDialog(context);
    }
    setState(() {});
  }
}
