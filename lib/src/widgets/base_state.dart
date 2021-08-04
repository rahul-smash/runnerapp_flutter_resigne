import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/login/model/login_response.dart';
import 'package:marketplace_service_provider/src/utils/language_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_state_interface.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T>  implements BaseStateInterface {

  final NetworkConnectionObserver network = getIt.get<NetworkConnectionObserver>();

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
