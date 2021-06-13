import 'package:app/infrastructure/cubits/currency/currency_cubit.dart';
import 'package:app/infrastructure/hive_adapters/currency_model/currency_model.dart';
import 'package:app/utilities/constants/theme_globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TappableCurrencyTile extends StatelessWidget {
  final CurrencyModel currency;
  final bool toCurrency;

  const TappableCurrencyTile({
    required this.currency,
    required this.toCurrency,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openCurrencyPicker(context: context, toCurrency: toCurrency),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 11.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset('assets/flags/${currency.code}.png', width: 34.0),
            Text('${currency.name} (${currency.code})', textAlign: TextAlign.center, style: size17weight400.copyWith(color: Colors.white)),
            Icon(CupertinoIcons.chevron_down, color: Colors.white),
          ],
        ),
      ),
    );
  }

  void openCurrencyPicker({
    required BuildContext context,
    bool toCurrency = false,
  }) {
    final currencyCubit = BlocProvider.of<CurrencyCubit>(context);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Material(
          child: CupertinoScrollbar(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: currencyCubit.currencies.length,
              itemBuilder: (context, posit) {
                final currency = currencyCubit.currencies.elementAt(posit);

                bool flag;
                if (toCurrency) {
                  flag = currencyCubit.toCurrency.code == currency.code;
                } else {
                  flag = currencyCubit.fromCurrency.code == currency.code;
                }
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
                  child: ListTile(
                    onTap: () {
                      if (toCurrency)
                        currencyCubit.updateToCurrencyByIndex(posit);
                      else
                        currencyCubit.updateFromCurrencyByIndex(posit);
                      Navigator.of(context).pop();
                    },
                    leading: Image.asset('assets/flags/${currency.code}.png', width: 40.0),
                    title: Text('${currency.name} (${currency.code})'),
                    trailing: Icon(
                      flag ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      color: flag ? Theme.of(context).primaryColor : Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
