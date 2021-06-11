import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension CustomWidgetExtensions on Widget {
  Route get route {
    return MaterialPageRoute(builder: (_) => this);
  }
}
