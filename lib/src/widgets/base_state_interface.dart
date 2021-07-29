import 'package:flutter/material.dart';

abstract class BaseStateInterface {
  Widget customBuilder(BuildContext context);

  Widget builder(BuildContext context);
}
