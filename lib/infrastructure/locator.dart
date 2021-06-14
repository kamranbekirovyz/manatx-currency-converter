import 'package:app/infrastructure/repositories/currency_repository.dart';
import 'package:app/infrastructure/services/connectivity_service.dart';
import 'package:app/infrastructure/services/hive_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

final navigatorKey = GlobalKey<NavigatorState>();
final ctx = navigatorKey.currentContext;

void setupLocator() {
  locator.registerLazySingleton(() => HiveService());
  locator.registerLazySingleton(() => navigatorKey);
  locator.registerLazySingleton(() => CurrencyRepository());
  locator.registerLazySingleton(() => ConnectivityService());
}