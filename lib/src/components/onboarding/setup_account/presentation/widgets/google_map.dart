import 'dart:math';

import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/business_detail_model.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../business_detail_screen.dart';

class GoogleMapScreen extends StatefulWidget {

  Function(int) callback;
  int radius;
  final BusinessDetailModel businessDetailModel;
  final LatLng userlocation;
  bool isComingFromAccount;

  GoogleMapScreen({@required this.callback,this.radius,this.businessDetailModel, this.userlocation, this.isComingFromAccount});

  @override
  _GoogleMapScreenState createState() {
    return _GoogleMapScreenState();
  }
}

class _GoogleMapScreenState extends BaseState<GoogleMapScreen> {

  GoogleMapController myController;
  List<Marker> _markers = <Marker>[];
  double latitude;
  double longitude;
  LatLng _center;
  int valueHolder;
  Set<Circle> circles = {};

  void _onMapCreated(GoogleMapController controller) {
    myController = controller;
  }

  @override
  void initState() {
    super.initState();

    latitude = widget.userlocation.latitude;
    longitude = widget.userlocation.longitude;

    if(widget.isComingFromAccount && widget.businessDetailModel.data.businessDetail.lat.isNotEmpty && widget.businessDetailModel.data.businessDetail.lng.isNotEmpty){
       latitude = double.parse(widget.businessDetailModel.data.businessDetail.lat);
       longitude = double.parse(widget.businessDetailModel.data.businessDetail.lng);
    }

    valueHolder = widget.radius;
    _center = LatLng(latitude, longitude);
    //print("--radius--${(valueHolder * 1000).toDouble()}-getZoomLevel()-=${getZoomLevel(2000)}");
    widget.callback(widget.radius);
    circles = Set.from([
      Circle(
          circleId: CircleId("myCircle"),
          radius: (valueHolder * 1000).toDouble(),
          center: LatLng(latitude, longitude),
          fillColor: Colors.white.withOpacity(0.5),
          strokeColor: AppTheme.primaryColor,
          strokeWidth: 2,
          onTap: () {
            print('circle pressed');
          })
    ]);
    _markers.add(
        Marker(
            markerId: MarkerId('1122'),
            position: LatLng(latitude, longitude),
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget builder(BuildContext context) {

    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(left: Dimensions.getScaledSize(20),
                right: Dimensions.getScaledSize(20),
            ),
            child: SliderTheme(
              data: SliderThemeData(
                trackShape: CustomTrackShape(),
              ),
              child: Slider(
                  value: valueHolder.toDouble(),
                  min: 1,
                  max: 50,
                  activeColor: AppTheme.primaryColor,
                  inactiveColor: AppTheme.borderOnFocusedColor,
                  label: '${valueHolder.round()}',
                  onChanged: (double newValue) {
                    widget.callback(newValue.toInt());
                    //radiusValue = (valueHolder * 1000).toDouble();
                    circles.clear();
                    circles = Set.from([
                      Circle(
                          circleId: CircleId("myCircle"),
                          radius: (newValue.roundToDouble() * 1000),
                          center: LatLng(latitude, longitude),
                          fillColor: Colors.white.withOpacity(0.5),
                          strokeColor: AppTheme.primaryColor,
                          strokeWidth: 2,
                          onTap: () {
                            print('circle pressed');
                          })
                    ]);
                    myController.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(target: LatLng(latitude, longitude), zoom: getZoomLevel((newValue.roundToDouble() * 1000)))));
                    setState(() {
                      valueHolder = newValue.round();
                    });
                  },
                  semanticFormatterCallback: (double newValue) {
                    return '${newValue.round()}';
                  }
              ),
            )
        ),
        Container(
          margin: EdgeInsets.only(left: 0,top: 5,bottom: 15 ),
          child: Center(
            child: Text(
              "${valueHolder} Km",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 16.0,
                color: AppTheme.mainTextColor,
                fontFamily: AppConstants.fontName,
              ),
            ),
          ),
        ),
        Container(
          height: Dimensions.getHeight(percentage: 60),
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            mapType: MapType.normal,
            markers: Set<Marker>.of(_markers),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            circles: circles,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 10.0,
              //zoom: getZoomLevel((valueHolder * 1000).toDouble()),
            ),
          ),
        ),
      ],
    );
  }

  double getZoomLevel(double radius) {
    double zoomLevel = 11;
    if (radius > 0) {
      double radiusElevated = radius + radius / 2;
      double scale = radiusElevated / 500;
      zoomLevel = 16 - log(scale) / log(2);
    }
    zoomLevel = num.parse(zoomLevel.toStringAsFixed(2));
    return zoomLevel;
  }


}
