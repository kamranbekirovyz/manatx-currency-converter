import 'dart:io' show Platform;
import 'package:flutter/material.dart';

class BottomPadding extends StatelessWidget {
  const BottomPadding();

  bool get isAndroid => Platform.isAndroid;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = isAndroid ? 16.0 : MediaQuery.of(context).padding.bottom;
    final height = bottomPadding > 0 ? bottomPadding : 16.0;

    return SizedBox(height: height);
  }
}
