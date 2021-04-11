import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget {
  final Widget leading;
  final List<Widget> actions;
  final Widget title;
  final double elevation;
  final Color bgColor;
  final bool centerTitle;

  SimpleAppBar(
      {this.leading,
      this.actions,
      this.title,
      this.elevation,
      this.bgColor,
      this.centerTitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      leading: leading,
      actions: actions,
      backgroundColor: bgColor,
      elevation: elevation,
    );
  }
}
