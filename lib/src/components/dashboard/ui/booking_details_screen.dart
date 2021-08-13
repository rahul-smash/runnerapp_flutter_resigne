import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_details_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/dashboard_repository.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
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

  @override
  void initState() {
    super.initState();
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
                              Text('Date and Time of booking Request')
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

  _getWidgetAccordingToStatus() {
    //    0 => 'pending',
//    1 =>'accepted',
//    2 =>'rejected',
//    4 =>'ongoing',
//    5 =>'completed',
//    6 => 'cancelled' // cancelled by customer\

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
                widget.callBackMethod(
                    'Ongoing', _bookingDetailsResponse.bookings);
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
                widget.callBackMethod(
                    'Complete', _bookingDetailsResponse.bookings);
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

  cancelOrderBottomSheet(context, Bookings booking) async {
    final commentController = TextEditingController();
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return SafeArea(
                  child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                            borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text(
                          labelBookingOrderCancel,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        Container(
                          height: 130,
                          margin: EdgeInsets.fromLTRB(10, 25, 10, 10),
                          decoration: new BoxDecoration(
                            color: AppTheme.grayLightColor,
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(5.0)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
                            child: TextField(
                              textAlign: TextAlign.left,
                              maxLength: 250,
                              keyboardType: TextInputType.text,
                              maxLines: null,
                              textCapitalization: TextCapitalization.sentences,
                              controller: commentController,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  border: InputBorder.none,
                                  fillColor: AppTheme.grayLightColor,
                                  hintText: hintAddReason),
                            ),
                          ),
                        ),
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
                                    //TODO: hit Api
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
          .getBookingsdetails(
              userId: loginResponse.data.id, orderId: booking.id);
      AppUtils.hideLoader(context);
      isBookingDetailsApiLoading = false;
    } else {
      AppUtils.noNetWorkDialog(context);
    }
    setState(() {});
  }
}
