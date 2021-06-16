import 'dart:io';

import 'package:app/infrastructure/hive_adapters/currency_model/currency_model.dart';
import 'package:app/infrastructure/locator.dart';
import 'package:app/infrastructure/repositories/currency_repository.dart';
import 'package:app/infrastructure/services/hive_service.dart';
import 'package:app/infrastructure/helpers/my_logger.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';

part 'currency_state.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  CurrencyCubit() : super(CurrencyLoading());

  HiveService get _hiveService => locator<HiveService>();
  CurrencyRepository get _currencyRepository => locator<CurrencyRepository>();
  String get formattedDate => DateFormat('dd.MM.yyyy').format(date);

  final List<CurrencyModel> currencies = [
    new CurrencyModel(code: 'AZN', value: 1.0, name: 'Azərbaycan Manatı', nominal: 1),
  ];
  static const max_input = 99999999999;

  final _fromCurrencyController = new BehaviorSubject<CurrencyModel>();
  final _toCurrencyController = new BehaviorSubject<CurrencyModel>();
  final _typedValueController = new BehaviorSubject<double>.seeded(0);
  final _convertedValueController = new BehaviorSubject<double>.seeded(0);
  final _filteredListController = new BehaviorSubject<List<CurrencyModel>>.seeded([]);
  final _tabIndexController = BehaviorSubject<int>.seeded(0);
  final _dateController = BehaviorSubject<DateTime>.seeded(DateTime.now());

  Stream<CurrencyModel> get fromCurrency$ => _fromCurrencyController.stream;
  Stream<CurrencyModel> get toCurrency$ => _toCurrencyController.stream;
  Stream<double> get typedValue$ => _typedValueController.stream;
  Stream<double> get convertedValue$ => _convertedValueController.stream;
  Stream<List<CurrencyModel>> get filteredList$ => _filteredListController.stream;
  Stream<int> get tabIndex$ => _tabIndexController.stream;
  Stream<DateTime> get date$ => _dateController.stream;

  double get typedValue => _typedValueController.value;
  CurrencyModel get toCurrency => _toCurrencyController.value;
  CurrencyModel get fromCurrency => _fromCurrencyController.value;
  double get convertedValue => _convertedValueController.value;
  int get tabIndex => _tabIndexController.value;
  DateTime get date => _dateController.value;

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
    if (typedValue > 1) {
      _typedValueController.add((typedValue / 10).floorToDouble());
    } else {
      _typedValueController.add(0);
    }
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

    final temp2 = typedValue;
    _typedValueController.add(convertedValue);
    _convertedValueController.add(temp2);
    autoUpdateConversionValue();
  }

  void addTwoZerosToTypedValue() {
    _typedValueController.add(typedValue * 100);
    autoUpdateConversionValue();
  }

  void updateTabIndex(int value) => _tabIndexController.add(value);
  void updateDate(DateTime value) => _dateController.add(value);

  @override
  Future<void> close() {
    _fromCurrencyController.close();
    _toCurrencyController.close();
    _typedValueController.close();
    _filteredListController.close();
    _tabIndexController.close();
    _hiveService.close();
    _dateController.close();
    return super.close();
  }

  Future<void> fetchCurrencies() async {
    try {
      emit(CurrencyLoading());

      if (_hiveService.isDateCached(formattedDate)) {
        simpleLogger.d('Getting cached data from Hive');

        final currenciesHistory = _hiveService.getCachedCurrencieByDate(formattedDate);
        currenciesHistory.forEach(currencies.add);
        currencies.removeAt(0);
      } else {
        simpleLogger.d('Getting from API');

        final response = await _currencyRepository.fetchCurrencies(formattedDate);

        await _hiveService.storeCurrenciesByDate(formattedDate, response);
        currencies.addAll(response);
      }

      _fromCurrencyController.add(currencies.elementAt(1));
      _toCurrencyController.add(currencies[0]);
      _typedValueController.add(1);
      _convertedValueController.add(currencies.elementAt(1).value! * typedValue);
      _filteredListController.add(currencies);

      emit(CurrencyLoaded(currencies: currencies));
    } on SocketException {
      await Future.delayed(const Duration(seconds: 1));
      emit(CurrencyNoInternetConnection());
    } catch (e, s) {
      print(e);
      print(s);
      emit(CurrencyAlert(message: '$e'));
    }
  }
}
