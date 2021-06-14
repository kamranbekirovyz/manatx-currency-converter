import 'dart:io' show Platform;
import 'package:app/utilities/constants/theme_globals.dart';
import 'package:flutter/material.dart';

class BottomPadding extends StatelessWidget {
  final Color? color;
  final double defaultBottom;

  const BottomPadding({
    this.color,
    this.defaultBottom = 16.0
  });

  bool get isAndroid => Platform.isAndroid;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = isAndroid ? defaultBottom : MediaQuery.of(context).padding.bottom;
    final height = bottomPadding > 0 ? bottomPadding : defaultBottom;

    return Container(
      height: height,
      color: color ?? primaryColor,
    );
  }
}
