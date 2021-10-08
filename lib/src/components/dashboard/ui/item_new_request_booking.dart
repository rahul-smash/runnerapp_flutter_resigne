import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/dashboard_response_summary.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';

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
        margin: EdgeInsets.symmetric(horizontal: 18.0),
        color: Colors.white,
        elevation: 8.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      bookingRequest.store.storeName,
                      style: TextStyle(
                          fontFamily: AppConstants.fontName,
                          fontSize: AppConstants.largeSize2X,
                          color: AppTheme.mainTextColor,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Order Amount",
                      style: TextStyle(
                          fontFamily: AppConstants.fontName,
                          fontSize: AppConstants.largeSize,
                          color: AppTheme.mainTextColor,
                          fontWeight: FontWeight.w500),
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
                      "${AppConstants.currency}${bookingRequest.total}",
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
                            bookingRequest.bookingRequestUserAddress,
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
                          '${bookingRequest.distance} km',
                          style: TextStyle(
                              fontFamily: AppConstants.fontName,
                              fontSize: AppConstants.smallSize,
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
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Container(
                  height: 1,
                  color: AppTheme.borderOnFocusedColor,
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
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
                            vertical: 10.0, horizontal: 16.0),
                        child: Text(labelReject,
                            style: TextStyle(
                                color: AppTheme.black,
                                fontSize: AppConstants.smallSize,
                                fontWeight: FontWeight.normal)),
                      ),
                    ),
                    SizedBox(
                      width: 16.0,
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
                            vertical: 10.0, horizontal: 16.0),
                        child: Text(labelAccept,
                            style: TextStyle(
                                color: AppTheme.white,
                                fontSize: AppConstants.smallSize,
                                fontWeight: FontWeight.normal)),
                      ),
                    ),
                  ],
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
