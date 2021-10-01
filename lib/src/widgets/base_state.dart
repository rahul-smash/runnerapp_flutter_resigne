import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/login/model/login_response.dart';
import 'package:marketplace_service_provider/src/components/side_menu/model/duty_status_observer.dart';
import 'package:marketplace_service_provider/src/model/config_model.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/singleton/login_user_singleton.dart';
import 'package:marketplace_service_provider/src/singleton/store_config_singleton.dart';
import 'package:marketplace_service_provider/src/utils/language_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_state_interface.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T>  implements BaseStateInterface {

  final NetworkConnectionObserver network = getIt.get<NetworkConnectionObserver>();
  final DutyStatusObserver dutyStatusObserver = getIt.get<DutyStatusObserver>();
  final String userId = AppSharedPref.instance.getUserId();
  final ConfigModel configModel = StoreConfigurationSingleton.instance.configModel;

  Widget futureBuild<T>(
      {Future<T> future,
      Widget Function(BuildContext, T) builder,
      Widget placeholder,
      bool showSpinner}) {
    var decoratedBuilder = (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          var error = snapshot.error;
          throw error;
        } else {
          return builder(context, snapshot.data);
        }
      } else {
        return showSpinner == true
            ? Center(child: CircularProgressIndicator())
            : placeholder != null
                ? placeholder
                : Container(color: Colors.white);
      }
    };

    return FutureBuilder(future: future, builder: decoratedBuilder);
  }

  @override
  Widget build(BuildContext context) {
    return customBuilder(context);
  }

  Widget customBuilder(BuildContext context) {
    return this.keyboardDismisser(
        context: context,
        child: Directionality(
          textDirection: LanguageUtil.getTextDirection(),
          child: builder(context),
        ));
  }

  Widget keyboardDismisser({BuildContext context, Widget child}) {
    final gesture = GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: child,
    );
    return gesture;
  }
}
