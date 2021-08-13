import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/dashboard_resposne.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/booking_details_screen.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class ItemBooking extends StatefulWidget {
  final Booking booking;
  Function callBackMethod;

  ItemBooking(this.booking, this.callBackMethod);

  @override
  _ItemBookingState createState() => _ItemBookingState();
}

class _ItemBookingState extends State<ItemBooking> {
  List<String> _services;

  final ScrollController _newBookingScrollController =
      ScrollController(initialScrollOffset: 0);

  @override
  void initState() {
    super.initState();
    if (widget.booking.services.trim().isNotEmpty)
      _services = widget.booking.services.split(',').toList(growable: true);
    else {
      _services = List.empty(growable: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => BookingDetailsScreen(widget.booking,widget.callBackMethod)));
      },
      child: Card(
        shadowColor: AppTheme.borderNotFocusedColor,
        elevation: 8,
        borderOnForeground: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(18.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '#${widget.booking.displayOrderId} | ${widget.booking.bookingDateTime}',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.subHeadingTextColor,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Visibility(
                      visible: widget.booking.customerPhone.isNotEmpty,
                      child: Row(
                        children: [
                          InkWell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Image(
                                  image: AssetImage(
                                    AppImages.icon_whatsapp,
                                  ),
                                  height: 25,
                                ),
                              ),
                              onTap: () {
                                AppUtils.launchWhatsApp(
                                    widget.booking.customerPhone);
                              }),
                          InkWell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Image(
                                  image: AssetImage(AppImages.icon_call),
                                  height: 25,
                                ),
                              ),
                              onTap: () {
                                AppUtils.launchCaller(
                                    widget.booking.customerPhone);
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.booking.categoryTitle,
                      style: TextStyle(
                          fontFamily: AppConstants.fontName,
                          fontSize: AppConstants.largeSize,
                          color: AppTheme.mainTextColor,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: Dimensions.pixels_5,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: AppTheme.primaryColorDark,
                              borderRadius: BorderRadius.circular(30)),
                          width: 8,
                          height: 8,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${widget.booking.serviceCount}${widget.booking.serviceCount == '1' ? ' Service' : ' Services'}',
                          style: TextStyle(
                              fontFamily: AppConstants.fontName,
                              fontSize: AppConstants.smallSize,
                              color: AppTheme.subHeadingTextColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConstants.currency,
                          style: TextStyle(
                              fontFamily: AppConstants.fontName,
                              fontSize: AppConstants.extraSmallSize,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.booking.total,
                          style: TextStyle(
                              fontFamily: AppConstants.fontName,
                              fontSize: AppConstants.largeSize,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Visibility(
                          visible: widget.booking.paymentMethod != null &&
                              widget.booking.paymentMethod.trim().isNotEmpty,
                          child: Container(
                              margin: EdgeInsets.only(left: 6),
                              padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFE6E6E6)),
                                color: Color(0xFFE6E6E6),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                              ),
                              child: Text(
                                  '${widget.booking.paymentMethod.trim().toUpperCase()}',
                                  style: TextStyle(
                                    color: Color(0xFF39444D),
                                    fontSize: 13,
                                  ))),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: _getWidgetAccordingToStatus(),
                ),
              ],
            ),
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
              padding: EdgeInsets.fromLTRB(
                  Dimensions.getScaledSize(10),
                  Dimensions.getScaledSize(10),
                  Dimensions.getScaledSize(0),
                  Dimensions.getScaledSize(10)),
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
                padding: EdgeInsets.fromLTRB(
                    Dimensions.getScaledSize(20),
                    Dimensions.getScaledSize(10),
                    Dimensions.getScaledSize(20),
                    Dimensions.getScaledSize(10)),
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
              padding: EdgeInsets.fromLTRB(
                  Dimensions.getScaledSize(10),
                  Dimensions.getScaledSize(10),
                  Dimensions.getScaledSize(10),
                  Dimensions.getScaledSize(10)),
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
              padding: EdgeInsets.fromLTRB(
                  Dimensions.getScaledSize(10),
                  Dimensions.getScaledSize(10),
                  Dimensions.getScaledSize(0),
                  Dimensions.getScaledSize(10)),
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
                widget.callBackMethod('Complete', widget.booking);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColorDark,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                padding: EdgeInsets.fromLTRB(
                    Dimensions.getScaledSize(20),
                    Dimensions.getScaledSize(10),
                    Dimensions.getScaledSize(20),
                    Dimensions.getScaledSize(10)),
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
              padding: EdgeInsets.fromLTRB(
                  Dimensions.getScaledSize(10),
                  Dimensions.getScaledSize(10),
                  Dimensions.getScaledSize(10),
                  Dimensions.getScaledSize(10)),
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
              padding: EdgeInsets.fromLTRB(
                  Dimensions.getScaledSize(10),
                  Dimensions.getScaledSize(10),
                  Dimensions.getScaledSize(10),
                  Dimensions.getScaledSize(10)),
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
}
