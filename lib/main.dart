import 'package:app/app.dart';
import 'package:app/infrastructure/main_configs.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await MainConfigs.configure();

  runApp(App());
}
