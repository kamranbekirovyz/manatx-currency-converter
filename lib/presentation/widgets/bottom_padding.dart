import 'dart:io' show Platform;
import 'package:app/utilities/constants/theme_globals.dart';
import 'package:flutter/material.dart';

class BottomPadding extends StatelessWidget {
  final Color? color;

  const BottomPadding({
    this.color,
  });

  bool get isAndroid => Platform.isAndroid;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = isAndroid ? 16.0 : MediaQuery.of(context).padding.bottom;
    final height = bottomPadding > 0 ? bottomPadding : 16.0;

    return Container(
      height: height,
      color: color ?? primaryColor,
    );
  }
}
