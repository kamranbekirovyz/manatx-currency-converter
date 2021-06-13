import 'package:app/infrastructure/hive_adapters/currency_model/currency_model.dart';
import 'package:app/infrastructure/locator.dart';
import 'package:app/infrastructure/repositories/currency_repository.dart';
import 'package:app/infrastructure/services/hive_service.dart';
import 'package:app/utilities/delegates/my_logger.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';

part 'currency_state.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  CurrencyCubit() : super(CurrencyLoading());

  HiveService get _hiveService => locator<HiveService>();
  CurrencyRepository get _currencyRepository => locator<CurrencyRepository>();

  final List<CurrencyModel> currencies = [
    new CurrencyModel(code: 'AZN', value: 1.0, name: 'Azərbaycan Manatı', nominal: 1),
  ];
  static const max_input = 99999999999;

  final _fromCurrencyController = new BehaviorSubject<CurrencyModel>();
  final _toCurrencyController = new BehaviorSubject<CurrencyModel>();
  final _typedValueController = new BehaviorSubject<int>.seeded(0);
  final _convertedValueController = new BehaviorSubject<double>.seeded(0);
  final _filteredListController = new BehaviorSubject<List<CurrencyModel>>.seeded([]);

  Stream<CurrencyModel> get fromCurrency$ => _fromCurrencyController.stream;
  Stream<CurrencyModel> get toCurrency$ => _toCurrencyController.stream;
  Stream<int> get typedValue$ => _typedValueController.stream;
  Stream<double> get convertedValue$ => _convertedValueController.stream;
  Stream<List<CurrencyModel>> get filteredList$ => _filteredListController.stream;

  int get typedValue => _typedValueController.value;
  CurrencyModel get toCurrency => _toCurrencyController.value;
  CurrencyModel get fromCurrency => _fromCurrencyController.value;
  double get convertedValue => _convertedValueController.value;

  void updateFromCurrencyByIndex(int value) {
    _fromCurrencyController.add(currencies.elementAt(value));
    autoUpdateConversionValue();
  }

  void updateToCurrencyByIndex(int value) {
    _toCurrencyController.add(currencies.elementAt(value));
    autoUpdateConversionValue();
  }

  void addToTypedValue(int value) {
    if (typedValue < max_input) {
      _typedValueController.add((typedValue * 10) + (value));
      autoUpdateConversionValue();
    }
  }

  void dropLastDigitFromTypedValue() {
    _typedValueController.add((typedValue / 10).floor());
    autoUpdateConversionValue();
  }

  void updateFilter(String value) {
    final filtered = currencies.where((currency) {
      return currency.name!.toLowerCase().contains(value.toLowerCase());
    }).toList();
    _filteredListController.add(filtered);
  }

  void autoUpdateConversionValue() {
    _convertedValueController.add(typedValue / toCurrency.value! * fromCurrency.value! / fromCurrency.nominal!);
  }

  void swapCurrencies() {
    final temp = fromCurrency;
    _fromCurrencyController.add(toCurrency);
    _toCurrencyController.add(temp);
    autoUpdateConversionValue();
  }

  void addTwoZerosToTypedValue() {
    _typedValueController.add(typedValue * 100);
    autoUpdateConversionValue();
  }

  @override
  Future<void> close() {
    _fromCurrencyController.close();
    _toCurrencyController.close();
    _typedValueController.close();
    _filteredListController.close();
    _hiveService.close();
    return super.close();
  }

  Future<void> fetchCurrencies() async {
    try {
      emit(CurrencyLoading());
      final formattedToday = DateFormat('dd.MM.yyyy').format(DateTime.now());

      if (_hiveService.currencyBox.isNotEmpty && _hiveService.lastCacheDate == formattedToday) {
        simpleLogger.d('Getting cached data from Hive');

        final currenciesHistory = _hiveService.currencies;
        currencies.addAll(currenciesHistory);
        currenciesHistory.forEach(currencies.add);
        currencies.removeAt(0);
      } else {
        simpleLogger.d('Getting from API');

        final response = await _currencyRepository.fetchCurrencies(formattedToday);

        _hiveService.storeLastCacheDate(formattedToday);
        _hiveService.storeCurrencies(response);
        currencies.addAll(response);
      }

      _fromCurrencyController.add(currencies.elementAt(1));
      _toCurrencyController.add(currencies[0]);
      _typedValueController.add(1000);
      _convertedValueController.add(currencies.elementAt(1).value! * typedValue);
      _filteredListController.add(currencies);
      emit(CurrencyLoaded(currencies: currencies));
    } catch (e, s) {
      print(e);
      print(s);
      emit(CurrencyAlert(message: '$e'));
    }
  }
}
