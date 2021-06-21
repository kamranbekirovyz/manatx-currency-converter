import 'package:app/infrastructure/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class KeyboardUnfocusArea extends StatelessWidget {
  final Widget child;

  const KeyboardUnfocusArea({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => HelperFunctions.hideInputAndUnfocus(context),
      child: child,
    );
  }
}
