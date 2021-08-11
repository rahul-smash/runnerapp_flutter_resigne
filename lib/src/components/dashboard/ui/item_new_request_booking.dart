import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/dashboard_resposne.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class ItemNewRequestBooking extends StatefulWidget {
  final BookingRequest bookingRequest;

  ItemNewRequestBooking(this.bookingRequest);

  @override
  _ItemNewRequestBookingState createState() => _ItemNewRequestBookingState();
}

class _ItemNewRequestBookingState extends State<ItemNewRequestBooking> {
  List<String> _services;

  final ScrollController _newBookingScrollController =
      ScrollController(initialScrollOffset: 0);

  @override
  void initState() {
    super.initState();
    if (widget.bookingRequest.services.trim().isNotEmpty)
      _services =
          widget.bookingRequest.services.split(',').toList(growable: true);
    else {
      _services = List.empty(growable: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: AppTheme.primaryColorDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.bookingRequest.categoryTitle,
                          style: TextStyle(
                              fontFamily: AppConstants.fontName,
                              fontSize: AppConstants.largeSize,
                              color: AppTheme.mainTextColor,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: Dimensions.pixels_5,
                        ),
                        SizedBox(
                          height: 60,
                          child: Scrollbar(
                            thickness: 2.0,
                            isAlwaysShown: true,
                            controller: _newBookingScrollController,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: ListView.builder(
                                  controller: _newBookingScrollController,
                                  shrinkWrap: true,
                                  itemCount: _services.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Wrap(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              Dimensions.pixels_18,
                                              Dimensions.pixels_5,
                                              Dimensions.pixels_18,
                                              Dimensions.pixels_5),
                                          margin: EdgeInsets.all(
                                              Dimensions.pixels_5),
                                          decoration: BoxDecoration(
                                              color: AppTheme
                                                  .containerBackgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Text(
                                            _services[index].trim(),
                                            style: TextStyle(
                                                fontSize:
                                                    AppConstants.extraSmallSize,
                                                fontWeight: FontWeight.normal,
                                                fontFamily:
                                                    AppConstants.fontName),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Service Charges',
                        style: TextStyle(
                            fontFamily: AppConstants.fontName,
                            fontSize: AppConstants.largeSize,
                            color: AppTheme.mainTextColor,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        widget.bookingRequest.total,
                        style: TextStyle(
                            fontFamily: AppConstants.fontName,
                            fontSize: AppConstants.largeSize,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: Dimensions.pixels_10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Service Date & Time',
                        style: TextStyle(
                            fontFamily: AppConstants.fontName,
                            fontSize: AppConstants.smallSize,
                            color: AppTheme.subHeadingTextColor,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        widget.bookingRequest.bookingDateTime,
                        style: TextStyle(
                            fontFamily: AppConstants.fontName,
                            fontSize: AppConstants.largeSize,
                            color: AppTheme.mainTextColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Estimate Time',
                        style: TextStyle(
                            fontFamily: AppConstants.fontName,
                            fontSize: AppConstants.smallSize,
                            color: AppTheme.subHeadingTextColor,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '${widget.bookingRequest.serviceDuration} mins',
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
              SizedBox(
                height: Dimensions.pixels_10,
              ),
              Container(
                height: 1,
                color: AppTheme.borderOnFocusedColor,
              ),
              SizedBox(
                height: Dimensions.pixels_18,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.borderNotFocusedColor,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        padding: EdgeInsets.fromLTRB(
                            Dimensions.getScaledSize(15),
                            Dimensions.getScaledSize(10),
                            Dimensions.getScaledSize(15),
                            Dimensions.getScaledSize(10)),
                        child: Text(labelReject,
                            style: TextStyle(
                                color: AppTheme.black,
                                fontSize: 15,
                                fontWeight: FontWeight.normal)),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            stops: [0.1, 0.5, 0.7, 0.9],
                            colors: [
                              AppTheme.primaryColorDark,
                              AppTheme.primaryColor,
                              AppTheme.primaryColor,
                              AppTheme.primaryColor,
                            ],
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(
                            Dimensions.getScaledSize(15),
                            Dimensions.getScaledSize(10),
                            Dimensions.getScaledSize(15),
                            Dimensions.getScaledSize(10)),
                        child: Text(labelAccept,
                            style: TextStyle(
                                color: AppTheme.white,
                                fontSize: 15,
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
}
