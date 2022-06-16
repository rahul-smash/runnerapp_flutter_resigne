import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/dashboard_response_summary.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:step_viewer/step_viewer.dart';

enum RequestStatus { accept, reject }

typedef OrderRequestCallback = void Function(BookingRequest, RequestStatus);

class ItemViewOrderRequests extends StatelessWidget {
  final BookingRequest bookingRequest;
  final OrderRequestCallback callback;

  ItemViewOrderRequests({this.bookingRequest, this.callback});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 18.0,
        ),
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
                '#${bookingRequest.displayOrderId} | ${AppUtils.convertDateTime(bookingRequest.created)}',
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
                          bookingRequest.store.storeName,
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
                      Visibility(
                        visible:
                            bookingRequest.paymentMethod.toLowerCase() == 'cod',
                        child: Text(
                          "${AppConstants.currency}${bookingRequest.total}",
                          style: TextStyle(
                              fontFamily: AppConstants.fontName,
                              fontSize: 16.0,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Visibility(
                        visible:
                            bookingRequest.paymentMethod.toLowerCase() != 'cod',
                        child: Text(
                          "${bookingRequest.total}",
                          style: TextStyle(
                              fontFamily: AppConstants.fontName,
                              fontSize: 16.0,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Visibility(
                        visible:
                            bookingRequest.paymentMethod.toLowerCase() == 'cod',
                        child: Container(
                          margin: EdgeInsets.only(top: 2.0),
                          decoration: BoxDecoration(
                              color: AppTheme.containerBackgroundColor,
                              borderRadius: BorderRadius.circular(16.0)),
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          child: Text(
                            "${bookingRequest.paymentMethod.toUpperCase()}",
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
                  bookingRequest.bookingRequestUserAddress,
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
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Flexible(
                  //     child: StepViewer(
                  //   stopsRadius: 8.0,
                  //   pathColor: AppTheme.primaryColor,
                  //   stopColor: AppTheme.primaryColor,
                  //   stopValues: [
                  //     'You',
                  //     'Pickup',
                  //     'Delivery',
                  //   ],
                  //   distanceValues: [
                  //     '600m',
                  //     '1.5km',
                  //   ],
                  // )),
                  Expanded(child: Container()),
                  // SizedBox(width: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () =>
                            callback(bookingRequest, RequestStatus.reject),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.borderNotFocusedColor,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          child: Text(labelReject,
                              style: TextStyle(
                                  color: AppTheme.black,
                                  fontSize: AppConstants.smallSize,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      InkWell(
                        onTap: () =>
                            callback(bookingRequest, RequestStatus.accept),
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
                          child: Text(labelAccept,
                              style: TextStyle(
                                  color: AppTheme.white,
                                  fontSize: AppConstants.smallSize,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getStoreAddress() {
    String address = bookingRequest.store.location ?? "";
    if (bookingRequest.store.city != null &&
        bookingRequest.store.city.isNotEmpty) {
      address += ", ${bookingRequest.store.city}";
    }
    if (bookingRequest.store.state != null &&
        bookingRequest.store.state.isNotEmpty) {
      address += ", ${bookingRequest.store.state}";
    }
    return address;
  }
}
