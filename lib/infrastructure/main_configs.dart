import 'package:app/infrastructure/locator.dart';
import 'package:app/infrastructure/helpers/my_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainConfigs {
  static Future<void> configure() async {
    WidgetsFlutterBinding.ensureInitialized();

    setupLocator();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp],
    );

    Bloc.observer = MyBlocObserver();
  }
}
