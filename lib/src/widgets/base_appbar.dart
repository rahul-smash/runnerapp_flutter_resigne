import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final Text title;
  final AppBar appBar;
  final List<Widget> widgets;
  Widget leading;
  final bool centerTitle;
  final Color backBtnColor;
  final VoidCallback callback;

  /// you can add more fields that meet your needs
  BaseAppBar(
      {Key key,
      this.title,
      this.appBar,
      this.backBtnColor = Colors.black,
      this.leading,
      this.widgets,
      this.backgroundColor,
      this.centerTitle = false,
      this.callback})
      : super(key: key) {
    if (leading == null) {
      leading = IconButton(
        icon: Icon(Icons.arrow_back, color: this.backBtnColor),
        onPressed: () {
          this.callback();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: this.centerTitle,
      automaticallyImplyLeading: appBar.automaticallyImplyLeading,
      elevation: appBar.elevation,
      title: title,
      leading: leading,
      backgroundColor: backgroundColor,
      actions: widgets,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
