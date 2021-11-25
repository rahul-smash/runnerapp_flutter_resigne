import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_details_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/dashboard_response_summary.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/dashboard_repository.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/step_viewer.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/model/store_response_model.dart';
import 'package:marketplace_service_provider/src/singleton/versio_api_singleton.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/utils/map_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/cash_collection_bottom_sheet.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class BookingDetailsScreen extends StatefulWidget {
  BookingRequest booking;
  Function callBackMethod;

  BookingDetailsScreen(this.booking, this.callBackMethod);

  @override
  _BookingDetailsScreenState createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends BaseState<BookingDetailsScreen> {
  bool isBookingDetailsApiLoading = true;
  BookingDetailsResponse _bookingDetailsResponse;
  StoreResponse storeResponse;

  @override
  void initState() {
    super.initState();
    storeResponse = VersionApiSingleton.instance.storeResponse;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getBookingdetails(widget.booking, isShowLoader: false);
    });
  }

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.borderNotFocusedColor,
      appBar: BaseAppBar(
        backgroundColor: AppTheme.white,
        title: Text(
          'Order Detail',
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
            Navigator.pop(context);
          },
        ),
        appBar: AppBar(
          elevation: 0.0,
        ),
        widgets: <Widget>[
          Visibility(
            visible: _bookingDetailsResponse?.bookings != null &&
                showCancelButton(_bookingDetailsResponse.bookings.status),
            child: InkWell(
                onTap: () async {
                  cancelOrderBottomSheet(
                      context, _bookingDetailsResponse.bookings);
                },
                child: Center(
                  child: Padding(
                      padding: EdgeInsets.only(right: 16, left: 16),
                      child: Text(
                        'Cancel Order',
                        style: TextStyle(
                            color: AppTheme.primaryColorDark,
                            fontSize: AppConstants.smallSize,
                            fontWeight: FontWeight.w400),
                      )),
                )),
          ),
        ],
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
                            Row(
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
                                        margin: EdgeInsets.only(top: 2.0),
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
                                _getWidgetAccordingToStatus(),
                              ],
                            ),
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
                                  double lat = double.tryParse(getCurrent() == 0
                                          ? widget.booking.store.lat
                                          : widget.booking.userAddress.lat) ??
                                      0;
                                  double lng = double.tryParse(getCurrent() == 0
                                          ? widget.booking.store.lng
                                          : widget.booking.userAddress.lng) ??
                                      0;
                                  MapUtils.openMap(lat, lng);
                                },
                                child: Text(
                                  'Map View',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0),
                                ),
                              ),
                            )
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
                              /*  itemCount: _bookingDetailsResponse
                                    .bookings.cart.length,*/
                              itemCount: _bookingDetailsResponse?.bookings?.cart?.length ?? 0,

                                itemBuilder: (context, index) {
                                  return listItem(context, index);
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Divider();
                                },
                              ),
                              Divider(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
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
                                            "${AppConstants.currency}${_bookingDetailsResponse.bookings.checkout}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    AppConstants.smallSize,
                                                fontWeight: FontWeight.w500))
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                      visible: _bookingDetailsResponse
                                                  .bookings.shippingCharges ==
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
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                              ),
                                              Text(
                                                  "${AppConstants.currency}${_bookingDetailsResponse.bookings.shippingCharges}",
                                                  style: TextStyle(
                                                      color: AppTheme.black,
                                                      fontSize: AppConstants
                                                          .smallSize,
                                                      fontWeight:
                                                          FontWeight.w500))
                                            ],
                                          ))),
                                  Visibility(
                                      visible: _bookingDetailsResponse
                                                  .bookings.cartSaving !=
                                              null &&
                                          (_bookingDetailsResponse
                                                  .bookings.cartSaving !=
                                              '0.00'),
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
                                                child: Text('MRP Discount',
                                                    style: TextStyle(
                                                      color: Color(0xff74BA33),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                              ),
                                              Text(
                                                  "${AppConstants.currency}${_bookingDetailsResponse.bookings.cartSaving != null ? _bookingDetailsResponse.bookings.cartSaving : '0.00'}",
                                                  style: TextStyle(
                                                      color: Color(0xff74BA33),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500))
                                            ],
                                          ))),
                                  Visibility(
                                      visible: _bookingDetailsResponse
                                              .bookings.discount.isNotEmpty &&
                                          _bookingDetailsResponse
                                                  .bookings.discount !=
                                              '0.00',
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
                                                  "${AppConstants.currency}${_bookingDetailsResponse.bookings.discount != null ? _bookingDetailsResponse.bookings.discount : '0.00'}",
                                                  style: TextStyle(
                                                      color: Color(0xff74BA33),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500))
                                            ],
                                          ))),
                                  Visibility(
                                      visible: _bookingDetailsResponse
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
                                                child: Text('Tax & Charges',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: AppConstants
                                                          .smallSize,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                              ),
                                              Text(
                                                  "${AppConstants.currency}${_bookingDetailsResponse.bookings.tax}",
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
                                              "${AppConstants.currency}${_bookingDetailsResponse.bookings.total}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
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
                        child: _bookingDetailsResponse
                                .bookings.cart[index].image300200.isNotEmpty
                            ? Image.network(
                                _bookingDetailsResponse
                                    .bookings.cart[index].image300200,
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
                          Text(
                              '${_bookingDetailsResponse.bookings.cart[index].productName}',
                              style: TextStyle(
                                  color: AppTheme.mainTextColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: AppConstants.largeSize)),
                          Text(
                              'Qunatity: ${_bookingDetailsResponse.bookings.cart[index].quantity}',
                              style: TextStyle(
                                  color: AppTheme.mainTextColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: AppConstants.largeSize)),
                          Container(
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    AppConstants.currency,
                    style: TextStyle(
                        fontFamily: AppConstants.fontName,
                        fontSize: AppConstants.extraSmallSize,
                        color: AppTheme.mainTextColor,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                ],
              ),
              Text(
                _bookingDetailsResponse.bookings.cart[index].price,
                style: TextStyle(
                    fontFamily: AppConstants.fontName,
                    fontSize: AppConstants.largeSize,
                    color: AppTheme.mainTextColor,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(
            height: 6.0,
          ),
          Visibility(
            visible:
                _bookingDetailsResponse.bookings.cart[index].comment.isNotEmpty,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Comment: ',
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
                    _bookingDetailsResponse.bookings.cart[index].comment,
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
                  Text('UpComing',
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
            InkWell(
              onTap: () {
                widget.callBackMethod('Ongoing', widget.booking);
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
                    Text('Ongoing',
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
      case '4':
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
                  Text('Ongoing',
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
      isBookingDetailsApiLoading = false;
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
      }
    } else {
      AppUtils.noNetWorkDialog(context);
    }
    setState(() {});
  }

  _bookingAction(String type, Bookings booking) async {
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
      case 'Ongoing':
        return '4';
        break;
      case 'Complete':
        return '5';
        break;
      case 'cancel':
        return '7';
        break;
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
