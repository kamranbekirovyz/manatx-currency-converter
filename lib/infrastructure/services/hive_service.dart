import 'package:app/infrastructure/hive_adapters/currency_model.dart';
import 'package:app/utilities/delegates/my_logger.dart';
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

    simpleLogger.i('HiveService initialized');
  }

  Future<void> storeLastCacheDate(String date) async {
    // final formattedNow = DateFormat('dd.MM.yyyy').format(DateTime.now());
    prefsBox.put('last_cached_date', date);
  }

  void close() {
    Hive.close();
  }
}