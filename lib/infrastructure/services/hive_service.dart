import 'package:app/infrastructure/hive_adapters/currency_model/currency_model.dart';
import 'package:app/infrastructure/helpers/my_logger.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  late Box currencyBox;

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    Hive.init(path);
    Hive.registerAdapter(CurrencyModelAdapter());
    currencyBox = await Hive.openBox('currency_box');

    logger.i('HiveService initialized');
  }

  Future<void> storeCurrenciesByDate(String date, List<CurrencyModel> value) async => await currencyBox.put(date, value);

  dynamic getCachedCurrencieByDate(String date) => currencyBox.get(date, defaultValue: <CurrencyModel>[]);
  bool isDateCached(String date) => currencyBox.containsKey(date);
  Future<void> removeCachedDataForDate(String date) => currencyBox.delete(date);

  void close() {
    Hive.close();
  }
}
