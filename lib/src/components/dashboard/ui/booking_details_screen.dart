import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_details_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/dashboard_repository.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/model/store_response_model.dart';
import 'package:marketplace_service_provider/src/singleton/versio_api_singleton.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/cash_collection_bottom_sheet.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class BookingDetailsScreen extends StatefulWidget {
  Booking booking;
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
          iconSize: 20,
          color: AppTheme.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        appBar: AppBar(),
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
              padding: EdgeInsets.all(Dimensions.getScaledSize(16)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      shadowColor: AppTheme.borderNotFocusedColor,
                      elevation: 8,
                      margin: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0),
                      borderOnForeground: true,
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
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '#${_bookingDetailsResponse.bookings.displayOrderId} | ${_bookingDetailsResponse.bookings.bookingDateTime}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.subHeadingTextColor,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _bookingDetailsResponse
                                        .bookings.userAddress.mobile.isNotEmpty,
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
                                                  _bookingDetailsResponse
                                                      .bookings
                                                      .userAddress
                                                      .mobile);
                                            }),
                                        InkWell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Image(
                                                image: AssetImage(
                                                    AppImages.icon_call),
                                                height: 25,
                                              ),
                                            ),
                                            onTap: () {
                                              AppUtils.launchCaller(
                                                  _bookingDetailsResponse
                                                      .bookings
                                                      .userAddress
                                                      .mobile);
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
                                    _bookingDetailsResponse
                                        .bookings.categoryTitle,
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
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        width: 8,
                                        height: 8,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        '${_bookingDetailsResponse.bookings.serviceCount}${_bookingDetailsResponse.bookings.serviceCount == '1' ? ' Service' : ' Services'}',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppConstants.currency,
                                        style: TextStyle(
                                            fontFamily: AppConstants.fontName,
                                            fontSize:
                                                AppConstants.extraSmallSize,
                                            color: AppTheme.primaryColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        _bookingDetailsResponse.bookings.total,
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
                                        visible: _bookingDetailsResponse
                                                    .bookings.paymentMethod !=
                                                null &&
                                            _bookingDetailsResponse
                                                .bookings.paymentMethod
                                                .trim()
                                                .isNotEmpty,
                                        child: Container(
                                            margin: EdgeInsets.only(left: 6),
                                            padding:
                                                EdgeInsets.fromLTRB(8, 3, 8, 3),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xFFE6E6E6)),
                                              color: Color(0xFFE6E6E6),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0)),
                                            ),
                                            child: Text(
                                                '${_bookingDetailsResponse.bookings.paymentMethod.trim().toUpperCase()}',
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
                              Container(
                                height: 1,
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                color: AppTheme.borderNotFocusedColor,
                              ),
                              Text(
                                'Date and Time of booking Request',
                                style: TextStyle(
                                    color: AppTheme.subHeadingTextColor),
                              ),
                              Text(
                                '${AppUtils.convertDateFormat(_bookingDetailsResponse.bookings.created)}',
                                style: TextStyle(
                                    color: AppTheme.subHeadingTextColor),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text('Delivery Details',
                                  style: TextStyle(
                                      color: AppTheme.subHeadingTextColor,
                                      fontSize: AppConstants.smallSize)),
                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                            '${_bookingDetailsResponse.bookings.userAddress.firstName} ${_bookingDetailsResponse.bookings.userAddress.lastName}',
                                            style: TextStyle(
                                                color: AppTheme.mainTextColor,
                                                fontSize:
                                                    AppConstants.largeSize,
                                                fontWeight: FontWeight.w500)),
                                        Text(
                                            '${_bookingDetailsResponse.bookings.userAddress.completAddress}',
                                            style: TextStyle(
                                                color: AppTheme
                                                    .subHeadingTextColor,
                                                fontSize:
                                                    AppConstants.smallSize,
                                                fontWeight: FontWeight.normal))
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: _bookingDetailsResponse.bookings
                                            .userAddress.lat.isNotEmpty &&
                                        _bookingDetailsResponse.bookings
                                            .userAddress.lng.isNotEmpty,
                                    child: GestureDetector(
                                      onTap: () {
                                        AppUtils.openMap(
                                            _bookingDetailsResponse
                                                .bookings.userAddress.lat,
                                            _bookingDetailsResponse
                                                .bookings.userAddress.lng);
                                      },
                                      child: Image.asset(
                                        AppImages.icon_map,
                                        height: 25,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Date & Time',
                                          style: TextStyle(
                                              color:
                                                  AppTheme.subHeadingTextColor),
                                        ),
                                        Text(
                                          '${_bookingDetailsResponse.bookings.bookingDateTime}',
                                          style: TextStyle(
                                              color: AppTheme.mainTextColor,
                                              fontSize: AppConstants.largeSize,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Delivery Slot',
                                          style: TextStyle(
                                            color: AppTheme.subHeadingTextColor,
                                          ),
                                        ),
                                        Text(
                                          '${AppUtils.convertTimeSlot(_bookingDetailsResponse.bookings.deliveryTimeSlot)}',
                                          style: TextStyle(
                                              color: AppTheme.mainTextColor,
                                              fontSize: AppConstants.largeSize,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.fromLTRB(4.0, 0, 4.0, 4.0),
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
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _bookingDetailsResponse
                                    .bookings.cart.length,
                                itemBuilder: (context, index) {
                                  return listItem(context, index);
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Container(
                                    margin: EdgeInsets.only(top: 8, bottom: 8),
                                    color: Color(0xFFE1E1E1),
                                    height: 1,
                                  );
                                },
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 8, bottom: 8),
                                        color: Color(0xFFE1E1E1),
                                        height: 1,
                                      ),
                                      Visibility(
                                          visible: _bookingDetailsResponse
                                                      .bookings
                                                      .shippingCharges ==
                                                  "0.00"
                                              ? false
                                              : true,
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 8, bottom: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Flexible(
                                                    child: Text(
                                                        'Delivery Charges',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        )),
                                                  ),
                                                  Text(
                                                      "${AppConstants.currency} ${_bookingDetailsResponse.bookings.shippingCharges}",
                                                      style: TextStyle(
                                                          color: AppTheme.black,
                                                          fontSize: AppConstants
                                                              .smallSize,
                                                          fontWeight:
                                                              FontWeight.w600))
                                                ],
                                              ))),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 8.0, bottom: 8.0),
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
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                            ),
                                            Text(
                                                "${AppConstants.currency} ${_bookingDetailsResponse.bookings.checkout}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600))
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                          visible: _bookingDetailsResponse
                                                      .bookings.cartSaving !=
                                                  null &&
                                              (_bookingDetailsResponse
                                                      .bookings.cartSaving !=
                                                  '0.00'),
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 8, bottom: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Flexible(
                                                    child: Text('MRP Discount',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff74BA33),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        )),
                                                  ),
                                                  Text(
                                                      "${AppConstants.currency} ${_bookingDetailsResponse.bookings.cartSaving != null ? _bookingDetailsResponse.bookings.cartSaving : '0.00'}",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff74BA33),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600))
                                                ],
                                              ))),
                                      Visibility(
                                          visible: _bookingDetailsResponse
                                                  .bookings
                                                  .discount
                                                  .isNotEmpty &&
                                              _bookingDetailsResponse
                                                      .bookings.discount !=
                                                  '0.00',
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 8, bottom: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Flexible(
                                                    child: Text('Discount',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff74BA33),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        )),
                                                  ),
                                                  Text(
                                                      "${AppConstants.currency} ${_bookingDetailsResponse.bookings.discount != null ? _bookingDetailsResponse.bookings.discount : '0.00'}",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff74BA33),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600))
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
                                                  top: 8, bottom: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                                      "${AppConstants.currency} ${_bookingDetailsResponse.bookings.tax}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: AppConstants
                                                              .smallSize,
                                                          fontWeight:
                                                              FontWeight.w600))
                                                ],
                                              ))),
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 8, bottom: 8),
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
                                                  "${AppConstants.currency} ${_bookingDetailsResponse.bookings.total}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          )
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 16, bottom: 20),
                                        padding:
                                            EdgeInsets.fromLTRB(20, 15, 20, 15),
                                        decoration: BoxDecoration(
                                          color: AppTheme.cyanColor,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Flexible(
                                              child: Text(
                                                  'Service Provide Payable amount',
                                                  style: TextStyle(
                                                    color:
                                                        AppTheme.cyanColorDark,
                                                    fontSize:
                                                        AppConstants.smallSize,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                            ),
                                            Text(
                                                "${AppConstants.currency} ${_bookingDetailsResponse.bookings.total}",
                                                style: TextStyle(
                                                    color:
                                                        AppTheme.cyanColorDark,
                                                    fontSize:
                                                        AppConstants.smallSize,
                                                    fontWeight:
                                                        FontWeight.w600))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
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
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                        child: ClipRRect(
                            borderRadius: new BorderRadius.circular(15),
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
                                    height: 80, width: 80, fit: BoxFit.cover))),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              '${_bookingDetailsResponse.bookings.cart[index].productName}',
                              style: TextStyle(
                                  color: AppTheme.mainTextColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: AppConstants.largeSize)),
                          Container(
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppTheme.borderNotFocusedColor),
                                color: AppTheme.borderNotFocusedColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                              ),
                              child: Text(
                                  '${_bookingDetailsResponse.bookings.categoryTitle}',
                                  style: TextStyle(
                                    color: Color(0xFF39444D),
                                    fontSize: 13,
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
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                ],
              ),
              SizedBox(
                width: 2,
              ),
              Text(
                _bookingDetailsResponse.bookings.cart[index].price,
                style: TextStyle(
                    fontFamily: AppConstants.fontName,
                    fontSize: AppConstants.largeSize,
                    color: AppTheme.mainTextColor,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 5,
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
                      fontSize: AppConstants.largeSize,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    _bookingDetailsResponse.bookings.cart[index].comment,
                    style: TextStyle(
                        color: AppTheme.mainTextColor,
                        fontSize: AppConstants.largeSize,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
        ],
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
//    7 => 'cancelled // cancelled by runner\

    //ongoing
    //Complete
    switch (_bookingDetailsResponse.bookings.status) {
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
                _bookingAction('Ongoing', _bookingDetailsResponse.bookings);
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
                if (widget.booking.paymentMethod
                    .toLowerCase()
                    .trim()
                    .contains('cod')) {
                  CashCollectionBottomSheet(
                      context,
                      _bookingDetailsResponse.bookings,
                      _bookingAction,
                      'Complete',
                      '1');
                } else {
                  _bookingAction('Complete', _bookingDetailsResponse.bookings);
                }
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
      case '7':
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
                              storeResponse.brand.bookingCancelReason.length,
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

  void _getBookingdetails(Booking booking, {bool isShowLoader = true}) async {
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
