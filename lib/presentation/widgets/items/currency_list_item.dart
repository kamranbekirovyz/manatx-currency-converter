import 'package:app/infrastructure/hive_adapters/currency_model/currency_model.dart';
import 'package:app/utilities/constants/theme_globals.dart';
import 'package:flutter/material.dart';

class CurrencyListItem extends StatelessWidget {
  final CurrencyModel currency;

  const CurrencyListItem(
    this.currency,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: ListTile(
        leading: Image.asset('assets/flags/${currency.code}.png', width: 40.0),
        title: Text('${currency.nominal} ${currency.name}', style: size14weight400.copyWith(color: Colors.white)),
        subtitle: Text('${currency.code}', style: size16weight500.copyWith(color: Colors.white70)),
        trailing: Text('${currency.value} AZN', style: size16weight400.copyWith(color: Colors.white)),
      ),
    );
  }
}
