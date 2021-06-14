import 'package:app/infrastructure/hive_adapters/currency_model/currency_model.dart';
import 'package:app/utilities/constants/theme_globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRadioListTile extends StatelessWidget {
  final CurrencyModel currency;
  final Function onTap;
  final bool flag;

  const CustomRadioListTile({
    required this.currency,
    required this.onTap,
    required this.flag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: ListTile(
        onTap: () {
          Navigator.of(context).pop();
        },
        leading: Image.asset('assets/flags/${currency.code}.png', width: 40.0),
        title: Text('${currency.name} (${currency.code})'),
        trailing: Icon(
          flag ? Icons.radio_button_checked : Icons.radio_button_unchecked,
          color: flag ? greenColor : Colors.grey,
        ),
      ),
    );
  }
}
