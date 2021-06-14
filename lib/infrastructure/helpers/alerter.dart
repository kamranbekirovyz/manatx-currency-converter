import 'package:app/infrastructure/locator.dart';
import 'package:app/utilities/constants/theme_globals.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Alerter {
  static void showSnackBar({
    required String message,
    required bool positive,
  }) async {
    showFlash(
      context: ctx!,
      duration: const Duration(seconds: 3),
      builder: (context, controller) {
        return Flash.bar(
          style: FlashStyle.grounded,
          controller: controller,
          backgroundColor: positive ? redColor : greenColor,
          position: FlashPosition.top,
          enableDrag: true,
          horizontalDismissDirection: HorizontalDismissDirection.startToEnd,
          child: FlashBar(
            message: Text('$message', textAlign: TextAlign.center, style: size15weight400.copyWith(color: Colors.white)),
          ),
        );
      },
    );
  }
}
