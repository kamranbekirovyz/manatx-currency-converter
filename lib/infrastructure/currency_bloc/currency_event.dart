part of 'currency_bloc.dart';

abstract class CurrencyEvent extends Equatable {
  const CurrencyEvent();

  @override
  List<Object> get props => [];
}

class FetchCurrencies extends CurrencyEvent {}