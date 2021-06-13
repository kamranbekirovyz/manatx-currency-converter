import 'package:app/infrastructure/cubits/currency/currency_cubit.dart';
import 'package:app/infrastructure/locator.dart';
import 'package:app/infrastructure/services/hive_service.dart';
import 'package:app/presentation/screens/currency_calculator_screen.dart';
import 'package:app/presentation/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final _currencyCubit = CurrencyCubit();

  HiveService get _hiveService => locator<HiveService>();

  @override
  void initState() {
    super.initState();
    _hiveService.init().then((_) {
      _currencyCubit.fetchCurrencies();
    });
  }

  @override
  void dispose() {
    _currencyCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _currencyCubit,
      child: BlocBuilder<CurrencyCubit, CurrencyState>(
        builder: (context, state) {
          if (state is CurrencyLoaded) {
            return CurrencyCalculatorScreen();
          }

          return const SplashScreen();
        },
      ),
    );
  }
}
