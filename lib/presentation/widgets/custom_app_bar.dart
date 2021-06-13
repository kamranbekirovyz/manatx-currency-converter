import 'package:app/utilities/constants/theme_globals.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  final Widget child;
  final double height;

  CustomAppBar({
    required this.child,
    this.height = 56.0,
  }) : super(
          preferredSize: Size.fromHeight(height),
          child: child,
        );

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      color: primaryColor,
      alignment: Alignment.center,
      child: child,
    );
  }
}
