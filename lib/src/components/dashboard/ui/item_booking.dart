import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/dashboard_response_summary.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/booking_details_screen.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/add_image/add_image_bottom_sheet.dart';
import 'package:marketplace_service_provider/src/widgets/cash_collection_bottom_sheet.dart';

class ItemBooking extends StatefulWidget {
  final BookingRequest booking;
  final Function callBackMethod;

  ItemBooking(this.booking, this.callBackMethod);

  @override
  _ItemBookingState createState() => _ItemBookingState();
}

class _ItemBookingState extends State<ItemBooking> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    BookingDetailsScreen(widget.booking, (status) {
                      widget.booking.status = status;
                      setState(() {});
                      widget.callBackMethod('refresh', widget.booking);
                    })));
      },
      child: Card(
        shadowColor: AppTheme.borderNotFocusedColor,
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '#${widget.booking.displayOrderId} | ${AppUtils.convertDateFromFormat(widget.booking.created)}',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.subHeadingTextColor,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Visibility(
                      visible: widget.booking.user.phone.isNotEmpty,
                      child: Row(
                        children: [
                          InkWell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Image(
                                  image: AssetImage(
                                    AppImages.icon_whatsapp,
                                  ),
                                  height: 25,
                                ),
                              ),
                              onTap: () {
                                AppUtils.launchWhatsApp(
                                    widget.booking.user.phone);
                              }),
                          InkWell(
                              child: Image(
                                image: AssetImage(AppImages.icon_call),
                                height: 25,
                              ),
                              onTap: () {
                                AppUtils.launchCaller(
                                    widget.booking.user.phone);
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.booking.store?.storeName ?? "",
                      style: TextStyle(
                          fontFamily: AppConstants.fontName,
                          fontSize: AppConstants.largeSize2X,
                          color: AppTheme.mainTextColor,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "",
                      style: TextStyle(
                          fontFamily: AppConstants.fontName,
                          fontSize: AppConstants.largeSize,
                          color: AppTheme.mainTextColor,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.booking.cart.length} ${widget.booking.cart.length > 1 ? "Items" : "Item"}",
                      style: TextStyle(
                          fontFamily: AppConstants.fontName,
                          fontSize: AppConstants.smallSize,
                          color: AppTheme.subHeadingTextColor,
                          fontWeight: FontWeight.normal),
                    ),
                    Text(
                      "",
                      style: TextStyle(
                          fontFamily: AppConstants.fontName,
                          fontSize: AppConstants.largeSize,
                          color: AppTheme.mainTextColor,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        getStoreAddress(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: AppConstants.fontName,
                            fontSize: AppConstants.smallSize,
                            color: AppTheme.mainTextColor,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "${AppConstants.currency}${widget.booking.total}",
                      style: TextStyle(
                          fontFamily: AppConstants.fontName,
                          fontSize: AppConstants.largeSize,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer Address',
                            style: TextStyle(
                                fontFamily: AppConstants.fontName,
                                fontSize: AppConstants.smallSize,
                                color: AppTheme.subHeadingTextColor,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            widget.booking.bookingRequestUserAddress,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontFamily: AppConstants.fontName,
                                fontSize: AppConstants.smallSize,
                                color: AppTheme.mainTextColor,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Distance',
                          style: TextStyle(
                              fontFamily: AppConstants.fontName,
                              fontSize: AppConstants.smallSize,
                              color: AppTheme.subHeadingTextColor,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          '${widget.booking.distance} km',
                          style: TextStyle(
                              fontFamily: AppConstants.fontName,
                              fontSize: AppConstants.largeSize,
                              color: AppTheme.mainTextColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: _getWidgetAccordingToStatus(),
                ),
              ),
              SizedBox(
                height: 16.0,
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
      case '1':
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
                    width: 5,
                  ),
                  Text('UpComming',
                      style: TextStyle(
                          color: Color(0xFF1CCDCD),
                          fontSize: 15,
                          fontWeight: FontWeight.normal)),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: AppTheme.subHeadingTextColor,
            ),
            SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: () {
                widget.callBackMethod('Ongoing', widget.booking);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.optionTotalBookingBgColor,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Image.asset(
                      AppImages.icon_ongoing,
                      color: AppTheme.white,
                      height: 10,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Ongoing',
                        style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 15,
                            fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
            ),
          ],
        );
        break;
      case '2':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Row(
                children: [
                  Image.asset(
                    AppImages.icon_rejected,
                    height: 14,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Rejected',
                      style: TextStyle(
                          color: AppTheme.errorRed,
                          fontSize: 15,
                          fontWeight: FontWeight.normal)),
                ],
              ),
            ),
          ],
        );
        break;
      case '4':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Row(
                children: [
                  Image.asset(
                    AppImages.icon_ongoing,
                    height: 10,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Ongoing',
                      style: TextStyle(
                          color: AppTheme.optionTotalBookingBgColor,
                          fontSize: 15,
                          fontWeight: FontWeight.normal)),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: AppTheme.subHeadingTextColor,
            ),
            SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: () {
                if (widget.booking.paymentMethod
                    .toLowerCase()
                    .trim()
                    .contains('cod')) {
                  CashCollectionBottomSheet(context, widget.booking,
                      widget.callBackMethod, 'Complete', '0');
                } else {
                  widget.callBackMethod('Complete', widget.booking);
                  AddImageBottomSheet(context, widget.booking, 'online');
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColorDark,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Image.asset(
                      AppImages.icon_complete,
                      color: AppTheme.white,
                      height: 10,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Complete',
                        style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 15,
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
                    height: 10,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Completed',
                      style: TextStyle(
                          color: AppTheme.primaryColorDark,
                          fontSize: 15,
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
                    height: 14,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Cancelled',
                      style: TextStyle(
                          color: AppTheme.errorRed,
                          fontSize: 15,
                          fontWeight: FontWeight.normal)),
                ],
              ),
            ),
          ],
        );
        break; // cancelled
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
}
