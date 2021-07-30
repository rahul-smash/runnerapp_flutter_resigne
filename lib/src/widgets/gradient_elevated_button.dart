import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';

class GradientElevatedButton extends StatelessWidget {
  final Function onPressed;
  final String buttonText;
  bool isButtonEnable = true;

  GradientElevatedButton(
      {Key key, this.onPressed, this.buttonText, this.isButtonEnable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: AppTheme.buttonShadowColor,
              offset: Offset(0, 8),
              blurRadius: 5.0)
        ],
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
      child: ElevatedButton(
        onPressed: isButtonEnable ? onPressed : () {},
        child: Text(buttonText,
            style: TextStyle(
                color: isButtonEnable ? AppTheme.white : AppTheme.whiteDisable,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
