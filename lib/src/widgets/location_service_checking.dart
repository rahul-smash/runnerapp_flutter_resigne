import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';

class LocationServiceChecking extends StatefulWidget {
  @override
  _LocationServiceCheckingState createState() =>
      _LocationServiceCheckingState();
}

class _LocationServiceCheckingState extends State<LocationServiceChecking> {
  static const platform =
      MethodChannel('com.marketplace_service_provider.messages');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: InkWell(
              onTap: () async{
                AppUtils.showToast('Pressed', false);
                String data = await platform.invokeMethod("startService");
                debugPrint(data);
              },
              child: Text('Start Service'))),
    );
  }
}
