import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

extension CustomWidgetExtensions on Widget {
  Route get route {
    return CupertinoPageRoute(builder: (_) => this);
  }
}
