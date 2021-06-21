import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class HelperFunctions {
  static void hideInputAndUnfocus(BuildContext context) async {
    await SystemChannels.textInput.invokeMethod('TextInput.hide');

    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
  }
}
