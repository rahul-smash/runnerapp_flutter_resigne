import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/TaxCalculationResponse.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/TaxOrderProductItem.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_details_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/dashboard_response_summary.dart';
import 'package:marketplace_service_provider/src/components/dashboard/provider/booking_provider.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/dashboard_repository.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/add%20product/order_cart.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/dashboard_screen.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/step_viewer.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/model/store_response_model.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/singleton/versio_api_singleton.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/utils/callbacks.dart';
import 'package:marketplace_service_provider/src/utils/map_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/cash_collection_bottom_sheet.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';
import 'package:provider/provider.dart';

import 'add product/book_order_screen.dart';
import 'chip/variant_chip_widget.dart';

class EditBookingDetailsScreen extends StatefulWidget {
  BookingRequest booking;
  Function callBackMethod;

  EditBookingDetailsScreen(this.booking, {this.callBackMethod});

  @override
  _EditBookingDetailsScreenState createState() =>
      _EditBookingDetailsScreenState();
}

class _EditBookingDetailsScreenState
    extends BaseState<EditBookingDetailsScreen> {
  bool isBookingDetailsApiLoading = true;
  BookingDetailsResponse _bookingDetailsResponse;
  StoreResponse storeResponse;

  TaxCalculationResponse taxCalculationResponse;
  List<dynamic> editCartList = new List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    storeResponse = VersionApiSingleton.instance.storeResponse;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //Clearing existing cart
      OderCart.clearOrderCartMap();
      _getBookingdetails(widget.booking, isShowLoader: false);
    });
    eventBus.fire(ReminderAlarmEvent.dismissNotification(
        ReminderAlarmEvent.notificationDismiss));
  }

  getLatLng(Position position) async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget builder(BuildContext builderContext) {
    return Scaffold(
      backgroundColor: AppTheme.borderNotFocusedColor,
      appBar: BaseAppBar(
        backgroundColor: AppTheme.white,
        title: Text(
          'Edit Order Detail',
          style: TextStyle(
              color: AppTheme.black,
              fontWeight: FontWeight.normal,
              fontFamily: AppConstants.fontName),
        ),
        leading: IconButton(
          iconSize: 24.0,
          color: AppTheme.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(builderContext);
          },
        ),
        appBar: AppBar(
          elevation: 0.0,
        ),
        widgets: <Widget>[],
      ),
      body: isBookingDetailsApiLoading
          ? Center(
              child: CircularProgressIndicator(
                  backgroundColor: Colors.black26,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black26)),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 16.0,
                    ),
                    Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
                      shadowColor: AppTheme.borderNotFocusedColor,
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '#${widget.booking.displayOrderId} | ${AppUtils.convertDateFromFormat(widget.booking.created)}',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: AppTheme.subHeadingTextColor,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                Visibility(
                                  visible: widget
                                      .booking.store.contactNumber.isNotEmpty,
                                  child: Row(
                                    children: [
                                      InkWell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Image(
                                              image: AssetImage(
                                                AppImages.icon_whatsapp,
                                              ),
                                              height: 25,
                                            ),
                                          ),
                                          onTap: () {
                                            AppUtils.launchWhatsApp(widget
                                                .booking.store.contactNumber);
                                          }),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      InkWell(
                                          child: Image(
                                            image:
                                                AssetImage(AppImages.icon_call),
                                            height: 25,
                                          ),
                                          onTap: () {
                                            print("call");
                                            AppUtils.launchCaller(widget
                                                .booking.store.contactNumber);
                                          }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.0,
                            ),
                            Text(
                              'Pickup Address',
                              style: TextStyle(
                                  fontFamily: AppConstants.fontName,
                                  fontSize: 14.0,
                                  color: AppTheme.subHeadingTextColor,
                                  fontWeight: FontWeight.normal),
                            ),
                            Text(
                              widget.booking.store?.storeName ?? "",
                              style: TextStyle(
                                  fontFamily: AppConstants.fontName,
                                  fontSize: 18.0,
                                  color: AppTheme.mainTextColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "${widget.booking.cart.length} ${widget.booking.cart.length > 1 ? "Items" : "Item"}",
                              style: TextStyle(
                                  fontFamily: AppConstants.fontName,
                                  fontSize: 14.0,
                                  color: AppTheme.subHeadingTextColor,
                                  fontWeight: FontWeight.normal),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              getStoreAddress(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: AppConstants.fontName,
                                  fontSize: AppConstants.smallSize,
                                  color: AppTheme.mainTextColor,
                                  fontWeight: FontWeight.normal),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Visibility(
                                      visible: widget.booking.paymentMethod
                                              .toLowerCase() ==
                                          'cod',
                                      child: Text(
                                        "${AppConstants.currency}${widget.booking.total}",
                                        style: TextStyle(
                                            fontFamily: AppConstants.fontName,
                                            fontSize: 16.0,
                                            color: AppTheme.primaryColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Visibility(
                                      visible: widget.booking.paymentMethod
                                              .toLowerCase() !=
                                          'cod',
                                      child: Text(
                                        "PAID",
                                        style: TextStyle(
                                            fontFamily: AppConstants.fontName,
                                            fontSize: 16.0,
                                            color: AppTheme.primaryColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Visibility(
                                      visible: widget.booking.paymentMethod
                                              .toLowerCase() ==
                                          'cod',
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(top: 2.0, left: 5),
                                        decoration: BoxDecoration(
                                            color: AppTheme
                                                .containerBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(16.0)),
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
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Flexible(child: Container()),
                                    _getWidgetAccordingToStatus(),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            // Visibility(
                            //   visible: widget.booking.runnerDeliveryAccepted ==
                            //           '1' &&
                            //       widget.booking.isManualAssignment == '1' &&
                            //       widget.booking.readStatus == '0',
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       InkWell(
                            //         onTap: () {
                            //           _getReadOrder(widget.booking);
                            //         },
                            //         child: Container(
                            //           decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.all(
                            //                 Radius.circular(30)),
                            //             gradient: LinearGradient(
                            //               begin: Alignment.topRight,
                            //               end: Alignment.bottomLeft,
                            //               stops: [0.1, 0.5, 0.5, 0.9],
                            //               colors: [
                            //                 AppTheme.primaryColorDark,
                            //                 AppTheme.primaryColor,
                            //                 AppTheme.primaryColor,
                            //                 AppTheme.primaryColor,
                            //               ],
                            //             ),
                            //           ),
                            //           padding: EdgeInsets.symmetric(
                            //               vertical: 8.0, horizontal: 12.0),
                            //           child: Text('Mark as read',
                            //               style: TextStyle(
                            //                   color: AppTheme.white,
                            //                   fontSize:
                            //                       AppConstants.extraSmallSize,
                            //                   fontWeight: FontWeight.normal)),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Delivery Address',
                                    style: TextStyle(
                                        fontSize: 14.0,
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
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
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
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      InkWell(
                                          child: Image(
                                            image:
                                                AssetImage(AppImages.icon_call),
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
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              '${widget.booking.user.fullName}',
                              style: TextStyle(
                                  fontFamily: AppConstants.fontName,
                                  fontSize: AppConstants.largeSize,
                                  color: AppTheme.mainTextColor,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.booking.bookingRequestUserAddress,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontFamily: AppConstants.fontName,
                                        fontSize: AppConstants.smallSize,
                                        color: AppTheme.mainTextColor,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Visibility(
                                  visible:
                                      _bookingDetailsResponse
                                                  .bookings.userAddress.lat !=
                                              null &&
                                          _bookingDetailsResponse.bookings
                                              .userAddress.lat.isNotEmpty &&
                                          _bookingDetailsResponse
                                                  .bookings.userAddress.lng !=
                                              null &&
                                          _bookingDetailsResponse.bookings
                                              .userAddress.lng.isNotEmpty,
                                  child: InkWell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Icon(
                                          Icons.gps_fixed_outlined,
                                          size: 25.0,
                                        ),
                                      ),
                                      onTap: () {
                                        AppUtils.openMap(
                                            _bookingDetailsResponse
                                                .bookings.userAddress.lat,
                                            _bookingDetailsResponse
                                                .bookings.userAddress.lng);
                                      }),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date & Time',
                                  style: TextStyle(
                                      fontSize: AppConstants.smallSize,
                                      color: AppTheme.subHeadingTextColor,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  '${AppUtils.convertDateFromFormat(widget.booking.created)}',
                                  style: TextStyle(
                                      fontSize: AppConstants.smallSize,
                                      color: AppTheme.mainTextColor,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Text(
                              'Delivery Slot',
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
                              widget.booking.deliveryTimeSlot.substring(
                                  widget.booking.deliveryTimeSlot.indexOf(" ") +
                                      1),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: AppConstants.fontName,
                                  fontSize: AppConstants.smallSize,
                                  color: AppTheme.mainTextColor,
                                  fontWeight: FontWeight.normal),
                            ),
                            Visibility(
                              visible: false,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  StepViewer(
                                    current: getCurrent(),
                                    stopsRadius: 8.0,
                                    pathColor: Colors.grey,
                                    stopColor: Colors.grey,
                                    selectedPathColor: AppTheme.primaryColor,
                                    selectedStopColor: AppTheme.primaryColor,
                                    stopValues: [
                                      'You',
                                      'Pickup',
                                      'Delivery',
                                    ],
                                    distanceValues: [
                                      _bookingDetailsResponse?.bookings != null
                                          ? "${_bookingDetailsResponse.bookings.riderToStoreDistance.toString()} km"
                                          : "",
                                      _bookingDetailsResponse?.bookings != null
                                          ? "${_bookingDetailsResponse.bookings.distance.toString()} km"
                                          : "",
                                    ],
                                    showProgress: true,
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        double lat = double.tryParse(
                                                getCurrent() == 0
                                                    ? widget.booking.store.lat
                                                    : widget.booking.userAddress
                                                        .lat) ??
                                            0;
                                        double lng = double.tryParse(
                                                getCurrent() == 0
                                                    ? widget.booking.store.lng
                                                    : widget.booking.userAddress
                                                        .lng) ??
                                            0;
                                        MapUtils.openMap(lat, lng);
                                      },
                                      child: Text(
                                        'Map View',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: AppTheme.primaryColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.0),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36.0),
                      child: MySeparator(
                        height: 2.0,
                        color: Colors.white,
                      ),
                    ),
                    Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: editCartList.length,
                                itemBuilder: (context, index) {
                                  return listItem(context, index);
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Divider();
                                },
                              ),
                              Divider(),
                              Visibility(
                                visible: _bookingDetailsResponse
                                    .bookings.note.isNotEmpty,
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$labelOrderComment: ',
                                          style: TextStyle(
                                              color:
                                                  AppTheme.subHeadingTextColor,
                                              fontSize: AppConstants.smallSize,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        SizedBox(
                                          width: 12.0,
                                        ),
                                        Flexible(
                                          child: Text(
                                            _bookingDetailsResponse
                                                .bookings.note,
                                            style: TextStyle(
                                                color: AppTheme.mainTextColor,
                                                fontSize:
                                                    AppConstants.smallSize,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                  ],
                                ),
                              ),
                              Column(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        logicBuilder(builderContext,
                                            hitPlaceOrder: false);
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.refresh_sharp,
                                            color: AppTheme.primaryColor,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            labelRefresh,
                                            style: TextStyle(
                                                color: AppTheme.primaryColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 4.0, bottom: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Flexible(
                                          child: Text('Total',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    AppConstants.smallSize,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ),
                                        Text(
                                            "${AppConstants.currency}${taxCalculationResponse != null ? taxCalculationResponse.taxCalculation.itemSubTotal : _bookingDetailsResponse.bookings.checkout}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    AppConstants.smallSize,
                                                fontWeight: FontWeight.w500))
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                      visible: taxCalculationResponse != null
                                          ? taxCalculationResponse
                                                  .taxCalculation
                                                  .discount
                                                  .isNotEmpty &&
                                              taxCalculationResponse
                                                      .taxCalculation
                                                      .discount !=
                                                  '0.00'
                                          : _bookingDetailsResponse
                                                      .bookings.discount ==
                                                  "0.00"
                                              ? false
                                              : true,
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 4, bottom: 4),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Flexible(
                                                child: Text('Discount',
                                                    style: TextStyle(
                                                      color: Color(0xff74BA33),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                              ),
                                              Text(
                                                  "${AppConstants.currency}${taxCalculationResponse != null ? taxCalculationResponse.taxCalculation.discount : _bookingDetailsResponse.bookings.discount}",
                                                  style: TextStyle(
                                                      color: AppTheme.black,
                                                      fontSize: AppConstants
                                                          .smallSize,
                                                      fontWeight:
                                                          FontWeight.w500))
                                            ],
                                          ))),
                                  Visibility(
                                      visible: taxCalculationResponse != null
                                          ? taxCalculationResponse
                                                  .taxCalculation
                                                  .shipping
                                                  .isNotEmpty &&
                                              taxCalculationResponse
                                                      .taxCalculation
                                                      .shipping !=
                                                  '0.00' &&
                                              taxCalculationResponse
                                                      .taxCalculation
                                                      .shipping !=
                                                  '0'
                                          : _bookingDetailsResponse.bookings
                                                      .shippingCharges ==
                                                  "0.00"
                                              ? false
                                              : true,
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 4, bottom: 4),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Flexible(
                                                child: Text('Delivery Charges',
                                                    style: TextStyle(
                                                      color: AppTheme
                                                          .lightGreenColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                              ),
                                              Text(
                                                  "${AppConstants.currency}${taxCalculationResponse != null ? taxCalculationResponse.taxCalculation.shipping : _bookingDetailsResponse.bookings.shippingCharges != null ? _bookingDetailsResponse.bookings.shippingCharges : '0.00'}",
                                                  style: TextStyle(
                                                      color: AppTheme
                                                          .lightGreenColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500))
                                            ],
                                          ))),
                                  Visibility(
                                      visible: taxCalculationResponse != null
                                          ? taxCalculationResponse
                                                  .taxCalculation
                                                  .tax
                                                  .isNotEmpty &&
                                              taxCalculationResponse
                                                      .taxCalculation.tax !=
                                                  '0.00'
                                          : _bookingDetailsResponse
                                                      .bookings.tax ==
                                                  "0.00"
                                              ? false
                                              : true,
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 4, bottom: 4),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Flexible(
                                                child: Text('Tax Charges',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: AppConstants
                                                          .smallSize,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                              ),
                                              Text(
                                                  "${AppConstants.currency}${taxCalculationResponse != null ? taxCalculationResponse.taxCalculation.tax : _bookingDetailsResponse.bookings.tax}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: AppConstants
                                                          .smallSize,
                                                      fontWeight:
                                                          FontWeight.w600))
                                            ],
                                          ))),
                                  Container(
                                    margin: EdgeInsets.only(top: 4, bottom: 4),
                                    color: Color(0xFFE1E1E1),
                                    height: 1,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Flexible(
                                        child: Text('Payable Amount',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                            )),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                              "${AppConstants.currency}${taxCalculationResponse != null ? taxCalculationResponse.taxCalculation.total : _bookingDetailsResponse.bookings.total}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      bool returnValue = await Navigator.push(
                                          builderContext,
                                          MaterialPageRoute(
                                              builder: (context) => BookOrder(
                                                  storeId:
                                                      _bookingDetailsResponse
                                                          .bookings.storeId)));
                                      if (returnValue) {
                                        for (int i = 0;
                                            i <
                                                OderCart.orderCartMap.values
                                                    .toList()
                                                    .length;
                                            i++) {
                                          dynamic product = OderCart
                                              .orderCartMap.values
                                              .toList()[i];
                                          dynamic selectedVariant =
                                              product.variants[
                                                  product.selectedVariantIndex];
                                          String userId =
                                              _bookingDetailsResponse
                                                  .bookings.cart.first.userId;
                                          String orderId =
                                              _bookingDetailsResponse
                                                  .bookings.cart.first.orderId;
                                          String deviceId =
                                              _bookingDetailsResponse
                                                  .bookings.cart.first.deviceId;
                                          String deviceToken =
                                              _bookingDetailsResponse.bookings
                                                  .cart.first.deviceToken;
                                          String platform =
                                              _bookingDetailsResponse
                                                  .bookings.cart.first.platform;
                                          dynamic toBeAddProduct =
                                              AppUtils.copyWithProduct(
                                                  product,
                                                  selectedVariant,
                                                  userId,
                                                  orderId,
                                                  deviceId,
                                                  deviceToken,
                                                  platform);
                                          bool productFound = false;
                                          for (int j = 0;
                                              j < editCartList.length;
                                              j++) {
                                            if (editCartList[j].productId ==
                                                OderCart.orderCartMap.values
                                                    .toList()[i]
                                                    .id) {
                                              productFound = true;
                                              //update New Product here
                                              if (selectedVariant.id !=
                                                  editCartList[j].variantId) {
                                                editCartList
                                                    .add(toBeAddProduct);
                                              } else {
                                                editCartList[j].quantity =
                                                    OderCart.orderCartMap.values
                                                        .toList()[i]
                                                        .count
                                                        .toString();
                                              }

                                              // break;
                                            }
                                          }
                                          if (!productFound) {
                                            editCartList.add(toBeAddProduct);
                                          }
                                        }
                                      }
                                      setState(() {});
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          size: 12,
                                          color: AppTheme.primaryColor,
                                        ),
                                        Text(
                                          "Add Product",
                                          style: TextStyle(
                                              color: AppTheme.primaryColor,
                                              decoration:
                                                  TextDecoration.underline),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  MaterialButton(
                                    height: 40,
                                    elevation: 8,
                                    onPressed: () {
                                      logicBuilder(context);
                                    },
                                    color: AppTheme.primaryColor,
                                    minWidth:
                                        Dimensions.getWidth(percentage: 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 6.0),
                                    child: Text(
                                      'Send Invoice',
                                      style: TextStyle(
                                          color: AppTheme.white,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
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

  /// Draw a border with rectangular border
  Widget get rectBorderWidget {
    return DottedBorder(
      dashPattern: [8, 4],
      strokeWidth: 1,
      child: Container(
        height: 0.1,
        color: AppTheme.black,
      ),
    );
  }

  Widget listItem(BuildContext context, int index) {
    double totalPrice = (double.parse(editCartList[index].price)) *
        (int.parse(editCartList[index].quantity));
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 6.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: new BorderRadius.circular(16),
                        child: editCartList[index].image300200.isNotEmpty
                            ? Image.network(
                                editCartList[index].image300200,
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(AppImages.icon_img_place_holder,
                                height: 80, width: 80, fit: BoxFit.fill)),
                    SizedBox(
                      width: 12.0,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${editCartList[index].productName}',
                              style: TextStyle(
                                  color: AppTheme.mainTextColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: AppConstants.largeSize)),
                          Visibility(
                            visible: _bookingDetailsResponse
                                .bookings.categoryTitle
                                .trim()
                                .isNotEmpty,
                            child: Container(
                                margin: EdgeInsets.only(top: 6.0),
                                padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppTheme.borderNotFocusedColor),
                                  color: AppTheme.borderNotFocusedColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                ),
                                child: Text(
                                    '${_bookingDetailsResponse.bookings.categoryTitle}',
                                    style: TextStyle(
                                      color: AppTheme.subHeadingTextColor,
                                      fontSize: 13.0,
                                    ))),
                          ),
                          Row(
                            children: [
                              Visibility(
                                visible: !editCartList[index].isEditPrice,
                                child: Text(
                                    "${AppConstants.currency} ${editCartList[index].price}",
                                    style: TextStyle(
                                        color: AppTheme.black,
                                        fontSize: AppConstants.smallSize,
                                        fontWeight: FontWeight.w700)),
                              ),
                              Visibility(
                                visible: editCartList[index].isEditPrice,
                                child: SizedBox(
                                  width: 50,
                                  child: TextFormField(
                                    controller: TextEditingController(
                                        text: editCartList[index].price),
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) =>
                                        value.isEmpty ? 'enter amount' : null,
                                    style: TextStyle(
                                        color: AppTheme.mainTextColor),
                                    onFieldSubmitted: (value) {
                                      editCartList[index].price = value;
                                      editCartList[index].mrpPrice = value;
                                    },
                                    onChanged: (value) {
                                      editCartList[index].price = value;
                                      editCartList[index].mrpPrice = value;
                                    },
                                    decoration: InputDecoration(
                                      counterText: '',
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppTheme
                                                  .borderNotFocusedColor)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppTheme
                                                  .borderOnFocusedColor)),
                                      hintText: labelPrice,
                                      hintStyle: TextStyle(
                                          color: AppTheme.subHeadingTextColor,
                                          fontSize: 14),
                                      labelStyle: TextStyle(
                                          color: AppTheme.mainTextColor,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    editCartList[index].isEditPrice =
                                        !editCartList[index].isEditPrice;
                                    setState(() {});
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      editCartList[index].isEditPrice
                                          ? Icons.check
                                          : Icons.edit,
                                      color: AppTheme.black,
                                      size: editCartList[index].isEditPrice
                                          ? 20
                                          : 14,
                                    ),
                                  )),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: AppTheme.backgroundColor,
                                    border: Border.all(color: AppTheme.black)),
                                child: Row(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          int quantityInt = int.parse(
                                                      editCartList[index]
                                                          .quantity) >
                                                  0
                                              ? int.parse(editCartList[index]
                                                      .quantity) -
                                                  1
                                              : 0;
                                          editCartList[index].quantity =
                                              quantityInt.toString();
                                          setState(() {});
                                        },
                                        child: Icon(
                                          Icons.remove,
                                          color: AppTheme.black,
                                          size: 16,
                                        )),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 3),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 2),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          color: AppTheme.backgroundColor),
                                      child: Text(
                                        '${editCartList[index].quantity.toString()}',
                                        style: TextStyle(
                                            color: AppTheme.black,
                                            fontSize: 16),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          int quantityInt = int.parse(
                                                  editCartList[index]
                                                      .quantity) +
                                              1;
                                          editCartList[index].quantity =
                                              quantityInt.toString();
                                          setState(() {});
                                        },
                                        child: Icon(
                                          Icons.add,
                                          color: AppTheme.black,
                                          size: 16,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text("${AppConstants.currency} $totalPrice",
                                style: TextStyle(
                                    color: AppTheme.black,
                                    fontSize: AppConstants.extraSmallSize,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Visibility(
            visible: editCartList[index].variants != null &&
                editCartList[index].variants.isNotEmpty,
            child: VariantChips(
              variant: editCartList[index].variants,
              variantID: editCartList[index].variantId,
              onOptionSelected: (value) {
                editCartList[index].variantId = value.id;
                setState(() {});
              },
            ),
          ),
          Visibility(
            visible: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Comment: ",
                    style: AppTheme.theme.textTheme.subtitle2.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: AppTheme.subHeadingTextColor)),
                Expanded(
                  child: Text(
                    '${editCartList[index].comment}',
                    style: AppTheme.theme.textTheme.subtitle2.copyWith(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: AppTheme.black,
                    ),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 6.0,
          ),
          Visibility(
            visible: false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$labelComment: ',
                  style: TextStyle(
                      color: AppTheme.subHeadingTextColor,
                      fontSize: AppConstants.smallSize,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  width: 12.0,
                ),
                Flexible(
                  child: Text(
                    editCartList[index].comment,
                    style: TextStyle(
                        color: AppTheme.mainTextColor,
                        fontSize: AppConstants.smallSize,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int getCurrent() {
    switch (widget.booking.status) {
      case '0':
      case '1':
      case '2':
      case '6':
        return 0;
      case '4':
        return 1;
      case '5':
        return 2;
    }
    return 0;
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
      case '8':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Wrap(children: [
                Row(
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
              ]),
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
                  _bookingAction(
                      'On the way', _bookingDetailsResponse.bookings);
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
                  Text('On the way',
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
                  CashCollectionBottomSheet(
                      context, widget.booking, _bookingAction, 'Complete', '1');
                } else {
                  _bookingAction('Complete', _bookingDetailsResponse.bookings);
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
    }
  }

  cancelOrderBottomSheet(context, Bookings booking) async {
    final commentController = TextEditingController();

    String _selectedReason = '';
    if (storeResponse.brand.bookingCancelReason != null &&
        storeResponse.brand.bookingCancelReason.isNotEmpty)
      _selectedReason = storeResponse.brand.bookingCancelReason.first;

    await showModalBottomSheet(
        context: context,
        backgroundColor: AppTheme.transparent,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return SafeArea(
                  child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(30.0),
                          topRight: const Radius.circular(30.0))),
                  child: Wrap(children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Text(
                            labelCancelConfirm,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          height: 2,
                          width: Dimensions.getScaledSize(40),
                          decoration: BoxDecoration(
                              color: AppTheme.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          labelBookingOrderCancel,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              storeResponse.brand.bookingCancelReason?.length ??
                                  0,
                          itemBuilder: (context, index) {
                            String label =
                                storeResponse.brand.bookingCancelReason[index];
                            return RadioListTile<String>(
                              title: Text(label),
                              value: label,
                              groupValue: _selectedReason,
                              onChanged: (String value) {
                                setState(() {
                                  _selectedReason = value;
                                });
                              },
                            );
                          },
                        ),
                        // Container(
                        //   height: 130,
                        //   margin: EdgeInsets.fromLTRB(10, 25, 10, 10),
                        //   decoration: new BoxDecoration(
                        //     color: AppTheme.grayLightColor,
                        //     borderRadius:
                        //         new BorderRadius.all(new Radius.circular(5.0)),
                        //   ),
                        //   child: Padding(
                        //     padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
                        //     child: TextField(
                        //       textAlign: TextAlign.left,
                        //       maxLength: 250,
                        //       keyboardType: TextInputType.text,
                        //       maxLines: null,
                        //       textCapitalization: TextCapitalization.sentences,
                        //       controller: commentController,
                        //       decoration: InputDecoration(
                        //           contentPadding: EdgeInsets.all(10.0),
                        //           border: InputBorder.none,
                        //           fillColor: AppTheme.grayLightColor,
                        //           hintText: hintAddReason),
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Expanded(
                                  child: Container(
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(5.0)),
                                ),
                                child: GradientElevatedButton(
                                  buttonText: 'Yes, cancel this order',
                                  onPressed: () {
                                    String comment = commentController.text;
                                    AppUtils.hideKeyboard(context);
                                    Navigator.pop(context);
                                    _cancelOrderApi(booking, _selectedReason,
                                        _selectedReason);
                                  },
                                ),
                              ))
                            ],
                          ),
                        ),
                      ],
                    )
                  ]),
                ),
              ));
            },
          );
        });
  }

  bool showCancelButton(status) {
    bool showCancelButton;
    //    0 => 'pending',
//    1 =>'accepted',
//    2 =>'rejected',
//    4 =>'ongoing',
//    5 =>'completed',
//    6 => 'cancelled' // cancelled by customer\
    if (status == "0" || status == "1" || status == "4") {
      showCancelButton = true;
    } else {
      showCancelButton = false;
    }
    return showCancelButton;
  }

  void _getBookingdetails(BookingRequest booking,
      {bool isShowLoader = true}) async {
    if (!getIt.get<NetworkConnectionObserver>().offline) {
      if (isShowLoader) AppUtils.showLoader(context);
      isBookingDetailsApiLoading = true;
      _bookingDetailsResponse = await getIt
          .get<DashboardRepository>()
          .getBookingsdetails(userId: userId, orderId: booking.id);
      AppUtils.hideLoader(context);
      if (_bookingDetailsResponse != null && _bookingDetailsResponse.success) {
        editCartList.clear();
        // editCartList.addAll(_bookingDetailsResponse.bookings.cart);
        editCartList = _bookingDetailsResponse.bookings.cart
            .map((e) => e.copyObject(item: e))
            .toList();
      }
      isBookingDetailsApiLoading = false;
    } else {
      AppUtils.noNetWorkDialog(context);
    }
    setState(() {});
  }

  void _getReadOrder(
    BookingRequest booking,
  ) async {
    if (!getIt.get<NetworkConnectionObserver>().offline) {
      BaseResponse baseResponse = await getIt
          .get<DashboardRepository>()
          .getReadBooking(userId: userId, orderId: booking.id);
      if (baseResponse != null) {
        // widget.booking.readStatus = '1';
        // _bookingDetailsResponse.bookings.readStatus = '1';
        setState(() {});
      }
    } else {
      AppUtils.noNetWorkDialog(context);
    }
    setState(() {});
  }

  void _cancelOrderApi(Bookings booking, String reasonOption, String reason,
      {bool isShowLoader = true}) async {
    if (!getIt.get<NetworkConnectionObserver>().offline) {
      if (isShowLoader) AppUtils.showLoader(context);
      BaseResponse baseResponse = await getIt
          .get<DashboardRepository>()
          .bookingsCancelBookingByRunner(
              userId: userId,
              orderId: booking.id,
              reasonOption: reasonOption,
              reason: reason);
      AppUtils.hideLoader(context);
      if (baseResponse != null && baseResponse.success) {
        widget.callBackMethod(_changeBookingStatus('cancel'));
        _getBookingdetails(widget.booking);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => DashboardScreen()));
      }
    } else {
      AppUtils.noNetWorkDialog(context);
    }
    setState(() {});
  }

  _bookingAction(String type, dynamic booking) async {
    if (!getIt.get<NetworkConnectionObserver>().offline) {
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
          _bookingDetailsResponse.bookings.status = _changeBookingStatus(type);
          widget.booking.status = _changeBookingStatus(type);
          widget.callBackMethod(_changeBookingStatus(type));
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
        break; //O
      // case 'Ongoing':
      //   return '4';
      //   break;
      case 'Complete':
        return '5';
        break;
      // case 'cancel':
      //   return '';
      //   break;
    }
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

  void logicBuilder(BuildContext buildContext,
      {bool hitPlaceOrder = true}) async {
    String noChanges = '0',
        quantityChanges = '1',
        removed = '2',
        newlyAdded = '3';
    List<TaxOrderProductItem> editJsonList = List.empty(growable: true);

    //Loop and condition to check for removed products
    for (int cartCounter = 0;
        cartCounter < _bookingDetailsResponse.bookings.cart.length;
        cartCounter++) {
      bool productFound = false;
      innerLoop:
      for (int editListCounter = 0;
          editListCounter < editCartList.length;
          editListCounter++) {
        if (editCartList[editListCounter].productId ==
            _bookingDetailsResponse.bookings.cart[cartCounter].productId) {
          productFound = true;
          break innerLoop;
        }
      }

      if (!productFound) {
        //removed product
        editJsonList.add(TaxOrderProductItem.copyWith(
            item: _bookingDetailsResponse.bookings.cart[cartCounter],
            variantId:
                _bookingDetailsResponse.bookings.cart[cartCounter].variantId,
            price: _bookingDetailsResponse.bookings.cart[cartCounter].price,
            oldQuantity:
                _bookingDetailsResponse.bookings.cart[cartCounter].quantity,
            quantity: '0',
            changeStatus: removed));
      }
    }

    for (int editListCounter = 0;
        editListCounter < editCartList.length;
        editListCounter++) {
      bool productFound = false;
      for (int cartCounter = 0;
          cartCounter < _bookingDetailsResponse.bookings.cart.length;
          cartCounter++) {
        if (editCartList[editListCounter].productId ==
            _bookingDetailsResponse.bookings.cart[cartCounter].productId) {
          productFound = true;
          if (editCartList[editListCounter].variantId !=
              _bookingDetailsResponse.bookings.cart[cartCounter].variantId) {
            //Variant changed
            //add new variant and old added as removed

            //removed product
            editJsonList.add(TaxOrderProductItem.copyWith(
                item: _bookingDetailsResponse.bookings.cart[cartCounter],
                variantId: _bookingDetailsResponse
                    .bookings.cart[cartCounter].variantId,
                price: _bookingDetailsResponse.bookings.cart[cartCounter].price,
                oldQuantity:
                    _bookingDetailsResponse.bookings.cart[cartCounter].quantity,
                quantity: '0',
                changeStatus: removed));

            //new added product
            editJsonList.add(TaxOrderProductItem.copyWith(
                item: editCartList[editListCounter],
                variantId: editCartList[editListCounter].variantId,
                price: editCartList[editListCounter].price,
                oldQuantity: editCartList[editListCounter].quantity,
                quantity: editCartList[editListCounter].quantity,
                changeStatus: newlyAdded));
          } else if (editCartList[editListCounter].quantity !=
              _bookingDetailsResponse.bookings.cart[cartCounter].quantity) {
            //check if all quantity is zero then remove this product
            if (int.parse(editCartList[editListCounter].quantity) == 0) {
              //removed product
              editJsonList.add(TaxOrderProductItem.copyWith(
                  item: editCartList[editListCounter],
                  variantId: editCartList[editListCounter].variantId,
                  price: editCartList[editListCounter].price,
                  oldQuantity: _bookingDetailsResponse
                      .bookings.cart[cartCounter].quantity,
                  quantity: editCartList[editListCounter].quantity,
                  changeStatus: removed));
            } else {
              //add new quantity and old quantity
              //new added product
              editJsonList.add(TaxOrderProductItem.copyWith(
                  item: editCartList[editListCounter],
                  variantId: editCartList[editListCounter].variantId,
                  price: editCartList[editListCounter].price,
                  oldQuantity: _bookingDetailsResponse
                      .bookings.cart[cartCounter].quantity,
                  quantity: editCartList[editListCounter].quantity,
                  changeStatus: quantityChanges));
            }
          } else {
            //No change
            // add same product
            editJsonList.add(TaxOrderProductItem.copyWith(
                item: editCartList[editListCounter],
                variantId: editCartList[editListCounter].variantId,
                price: editCartList[editListCounter].price,
                oldQuantity: editCartList[editListCounter].quantity,
                quantity: editCartList[editListCounter].quantity,
                changeStatus: noChanges));
          }
          break;
        }
      }

      if (!productFound) {
        //TODO: handle this new added product
        // 3 => newly added
        editJsonList.add(TaxOrderProductItem.copyWith(
            item: editCartList[editListCounter],
            variantId: editCartList[editListCounter].variantId,
            price: editCartList[editListCounter].price,
            oldQuantity: editCartList[editListCounter].quantity,
            quantity: editCartList[editListCounter].quantity,
            changeStatus: newlyAdded));
      }
    }

    //
    List jsonList = TaxOrderProductItem.encodeListToJson(editJsonList);
    if (jsonList.length != 0) {
      String orderDetail = jsonEncode(jsonList);
      if (!getIt.get<NetworkConnectionObserver>().offline) {
        if (hitPlaceOrder) AppUtils.showLoader(buildContext);
        taxCalculationResponse = await getIt
            .get<DashboardRepository>()
            .taxCalculationApi(
                userId: userId,
                shipping: _bookingDetailsResponse.bookings.shippingCharges,
                discount: _bookingDetailsResponse.bookings.discount,
                tax: _bookingDetailsResponse.bookings.tax,
                fixedDiscountAmount: _bookingDetailsResponse.bookings.discount,
                userWallet: '0',
                orderDetail: orderDetail,
                storeID: _bookingDetailsResponse.bookings.storeId);
        if (taxCalculationResponse != null &&
            taxCalculationResponse.success &&
            hitPlaceOrder) {
          placeOrderApi(orderDetail);
        } else {
          if (hitPlaceOrder) AppUtils.hideLoader(buildContext);
        }
        setState(() {});
        isBookingDetailsApiLoading = false;
      } else {
        AppUtils.noNetWorkDialog(context);
      }
    } else {
      return null;
    }
  }

  void placeOrderApi(String orderDetail) async {
    String orders =
        jsonEncode(taxCalculationResponse.taxCalculation.orderDetail);
    String deviceId = AppSharedPref.instance.getDeviceId();
    String deviceToken = AppSharedPref.instance.getDeviceToken();
    String platform = Platform.isIOS ? "IOS" : "Android";
    if (!getIt.get<NetworkConnectionObserver>().offline) {
      AppUtils.showLoader(context);
      BaseResponse baseResponse = await getIt
          .get<DashboardRepository>()
          .editPlaceOrder(
              orderId: _bookingDetailsResponse.bookings.id,
              deviceId: deviceId,
              deviceToken: deviceToken,
              userAddressId: _bookingDetailsResponse.bookings.userAddressId,
              userAddress:
                  _bookingDetailsResponse.bookings.userAddress.completAddress,
              platform: platform,
              total: taxCalculationResponse.taxCalculation.total,
              discount: taxCalculationResponse.taxCalculation.discount,
              paymentMethod: _bookingDetailsResponse.bookings.paymentMethod,
              couponCode: _bookingDetailsResponse.bookings.couponCode,
              checkout: taxCalculationResponse.taxCalculation.itemSubTotal,
              userId: _bookingDetailsResponse.bookings.userAddress.userId,
              shippingCharges: taxCalculationResponse.taxCalculation.shipping,
              userWallet: '0',
              tax: taxCalculationResponse.taxCalculation.tax,
              fixedDiscountAmount:
                  taxCalculationResponse.taxCalculation.discount,
              orders: orderDetail,
              storeID: _bookingDetailsResponse.bookings.storeId);
      AppUtils.hideLoader(context);
      if (baseResponse != null && baseResponse.success) {
        Navigator.pop(context, 'refreshPage');
      }
      isBookingDetailsApiLoading = false;
    } else {
      AppUtils.noNetWorkDialog(context);
    }
  }
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 8.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
