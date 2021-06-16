import 'package:intl/intl.dart';

extension MyNumExtensions on num {
  String get asFormatted {
    return NumberFormat.decimalPattern().format(this).replaceAll(',', ' ');
  }
}