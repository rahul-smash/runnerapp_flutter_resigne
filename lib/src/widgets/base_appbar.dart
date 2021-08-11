import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final Text title;
  final AppBar appBar;
  final List<Widget> widgets;
  final Widget leading;

  /// you can add more fields that meet your needs
  const BaseAppBar(
      {Key key,
      this.title,
      this.appBar,
      this.leading,
      this.widgets,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: appBar.automaticallyImplyLeading,
      elevation: 0.0,
      title: title,
      leading: leading,
      backgroundColor: backgroundColor,
      actions: widgets,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
