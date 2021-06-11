import 'package:app/infrastructure/hive_adapters/currency_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';
import 'dart:convert' show utf8;
import 'package:xml/xml.dart' as xml;

part 'currency_event.dart';
part 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
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
      return currency.name.toLowerCase().contains(value.toLowerCase());
    }).toList();
    _filteredListController.add(filtered);
  }

  void autoUpdateConversionValue() {
    _convertedValueController.add(typedValue / toCurrency.value * fromCurrency.value / fromCurrency.nominal);
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
    return super.close();
  }

  CurrencyBloc() : super(CurrencyLoading());

  @override
  Stream<CurrencyState> mapEventToState(CurrencyEvent event) async* {
    if (event is FetchCurrencies) {
      yield* mapCurrenciesToState(event);
    }
  }

  Stream<CurrencyState> mapCurrenciesToState(FetchCurrencies event) async* {
    yield CurrencyLoading();
    try {
      final today = DateFormat('dd.MM.yyyy').format(DateTime.now());
      final currenciesBox = await Hive.openBox('currencies');
      final prefsBox = await Hive.openBox('preferences');
      
      final lastDate = prefsBox.get('last_date');
      if (currenciesBox.isNotEmpty && lastDate == today) {
        print('-- Getting from hive');
        final currenciesHistory = await currenciesBox.getAt(0);
        currenciesHistory.forEach(currencies.add);
        currencies.removeAt(0);
      } else {
        print('-- Getting from API');
        final api = "https://www.cbar.az/currencies/$today.xml";
        print('API -> $api');
        final response = await http.get(api);
        final decoded = utf8.decode(response.bodyBytes);
        final raw = xml.parse(decoded);
        final elements = raw.findAllElements('Valute');
        const ignoreds = ["XPD", "XPT", "XAG", "XAU", "SDR"];
        for (var element in elements) {
          final code = element.getAttribute('Code');
          if (ignoreds.contains(code)) continue;
          final nominal = int.tryParse(element.findElements('Nominal').first.text);
          String name = element.findElements('Name').first.text;
          int spaceIndex = name.indexOf(" ");
          if (spaceIndex > 0) name = name.substring(name.indexOf(" ") + 1);
          final value = double.tryParse(element.findElements('Value').first.text);
          final model = new CurrencyModel(code: code, name: name, nominal: nominal, value: value);
          currencies.add(model);
        }
        prefsBox.put('last_date', today);
        currenciesBox.put(0, currencies);
      }
      _fromCurrencyController.add(currencies.elementAt(35));
      _toCurrencyController.add(currencies[0]);
      _typedValueController.add(1000);
      _convertedValueController.add(currencies.elementAt(35).value * typedValue);
      _filteredListController.add(currencies);
      yield CurrencyLoaded(currencies: currencies);
    } catch (e) {
      print(e);
      yield CurrencyFailure(error: '$e');
    }
  }
}