import 'package:app/infrastructure/repositories/currency_repository.dart';
import 'package:app/infrastructure/services/hive_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => HiveService());
  locator.registerLazySingleton(() => CurrencyRepository());
}