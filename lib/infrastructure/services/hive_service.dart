import 'package:app/infrastructure/hive_adapters/currency_model/currency_model.dart';
import 'package:app/infrastructure/helpers/my_logger.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  late Box<dynamic> prefsBox;
  late Box<CurrencyModelAdapter> currencyBox;

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    Hive.init(path);
    Hive.registerAdapter(CurrencyModelAdapter());
    currencyBox = await Hive.openBox('currency_box');
    prefsBox = await Hive.openBox('preferences_box');

    simpleLogger.i('HiveService initialized');
  }

  Future<void> storeLastCacheDate(String date) => prefsBox.put('last_cached_date', date);
  String get lastCacheDate => prefsBox.get('last_cached_date');

  Future<void> storeCurrencies(List<CurrencyModel> value) => prefsBox.putAt(0, value);
  List<CurrencyModel> get currencies => currencyBox.getAt(0) as List<CurrencyModel>;

  void close() {
    Hive.close();
  }
}