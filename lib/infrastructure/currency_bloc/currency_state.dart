part of 'currency_bloc.dart';

abstract class CurrencyState extends Equatable {
  const CurrencyState();

  @override
  List<Object> get props => [];
}

class CurrencyInitial extends CurrencyState {}

class CurrencyLoading extends CurrencyState {}

class CurrencyLoaded extends CurrencyState {
  final List<CurrencyModel> currencies;

  const CurrencyLoaded({
    required this.currencies,
  });

  @override
  List<Object> get props => [currencies];
}

class CurrencyAlert extends CurrencyState {
  final String message;

  const CurrencyAlert({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
