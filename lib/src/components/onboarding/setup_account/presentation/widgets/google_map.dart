import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../business_detail_screen.dart';

class GoogleMapScreen extends StatefulWidget {

  GoogleMapScreen();

  @override
  _GoogleMapScreenState createState() {
    return _GoogleMapScreenState();
  }
}

class _GoogleMapScreenState extends BaseState<GoogleMapScreen> {

  GoogleMapController myController;
  List<Marker> _markers = <Marker>[];
  final LatLng _center = LatLng(45.521563, -122.677433);
  int valueHolder = 20;
  double radiusValue;
  Set<Circle> circles = {};

  void _onMapCreated(GoogleMapController controller) {
    myController = controller;
  }

  @override
  void initState() {
    super.initState();
    radiusValue = 2000;
    circles = Set.from([
      Circle(
          circleId: CircleId("myCircle"),
          radius: radiusValue,
          center: LatLng(45.521563, -122.677433),
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
            position: LatLng(45.521563, -122.677433),
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
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                    radiusValue = (valueHolder * 1000).toDouble();
                    circles.clear();
                    circles = Set.from([
                      Circle(
                          circleId: CircleId("myCircle"),
                          radius: radiusValue,
                          center: LatLng(45.521563, -122.677433),
                          fillColor: Colors.white.withOpacity(0.5),
                          strokeColor: AppTheme.primaryColor,
                          strokeWidth: 2,
                          onTap: () {
                            print('circle pressed');
                          })
                    ]);
                    print("====meter====${radiusValue}");
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
          margin: EdgeInsets.only(left: 0,top: 5,bottom: 10 ),
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
          height: Dimensions.getHeight(percentage: 30),
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
              zoom: 12.0,
            ),
          ),
        ),
      ],
    );
  }


}
