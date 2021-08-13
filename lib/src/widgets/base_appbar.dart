import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final Text title;
  final AppBar appBar;
  final List<Widget> widgets;
  final Widget leading;
  final bool centerTitle;
  final Color backBtnColor;
  final VoidCallback callback;

  /// you can add more fields that meet your needs
  const BaseAppBar({Key key, this.title, this.appBar,this.backBtnColor = Colors.black,
    this.widgets,this.backgroundColor,this.centerTitle = false,this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: this.backBtnColor),
        onPressed: () {
          this.callback();
        },
      ),
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
