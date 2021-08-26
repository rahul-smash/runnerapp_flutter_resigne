import 'package:flutter/material.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/dashboard_screen.dart';
import 'package:marketplace_service_provider/src/components/side_menu/repository/menu_option_repository_impl.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/utils/callbacks.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';

class DutySwitchScreen extends StatefulWidget {
  @override
  DutySwitchState createState() => new DutySwitchState();
}

class DutySwitchState extends BaseState<DutySwitchScreen> {
  bool isSwitched = false;

  /// 0=>off duty, 1=>on duty

  @override
  void initState() {
    super.initState();
    isSwitched = dutyStatusObserver.status == "1" ? true : false;
  }

  @override
  Widget builder(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: Dimensions.getScaledSize(30),
          left: Dimensions.getScaledSize(30),
          right: Dimensions.getScaledSize(20)),
      child: Row(
        children: [
          Expanded(child: Container()),
          Text(
            "Duty",
            style: TextStyle(
                color: Colors.white,
                fontSize: Dimensions.getScaledSize(18),
                fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 10),
          CustomSwitch(
            value: isSwitched,
            activeColor: AppTheme.greenColor,
            onChanged: (value) async {
              AppUtils.showLoader(context);
              BaseResponse baseresponse = await getIt
                  .get<MenuOptionRepositoryImpl>()
                  .updateDutyStatus(
                      userId: loginResponse.data.id,
                      status: value ? "1" : "0",
                      lng: "0.0",
                      lat: "0.0",
                      address: "");
              AppUtils.hideLoader(context);
              if (baseresponse != null)
                AppUtils.showToast(baseresponse.message, true);
              AppUtils.hideKeyboard(context);
              this
                  .dutyStatusObserver
                  .changeStatus(baseresponse.newDuty.toString());
              await AppSharedPref.instance
                  .saveDutyStatus(baseresponse.newDuty.toString());
              loginResponse.data.onDuty = baseresponse.newDuty.toString();
              await AppSharedPref.instance.saveUser(loginResponse);
              if (baseresponse.newDuty.toString() == '1')
                startLocationSetup(context, loginResponse);
              else {
                eventBus.fire(AlarmEvent.cancelAllAlarm('cancel'));
              }
              setState(() {
                isSwitched = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
