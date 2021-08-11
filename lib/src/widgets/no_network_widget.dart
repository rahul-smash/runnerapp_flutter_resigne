import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';

import 'base_state.dart';

class NoNetworkClass extends StatefulWidget {
  @override
  _NoNetworkClassState createState() => _NoNetworkClassState();
}

class _NoNetworkClassState extends BaseState<NoNetworkClass> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
     AppUtils.noNetWorkDialog(context);
    });
  }

  @override
  Widget builder(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              AppConstants.staticSplash,
            ),
            fit: BoxFit.fill),
      ),
    );
  }

}
