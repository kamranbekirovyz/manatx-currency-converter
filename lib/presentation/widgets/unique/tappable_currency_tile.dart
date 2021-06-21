import 'package:app/infrastructure/cubits/currency/currency_cubit.dart';
import 'package:app/infrastructure/hive_adapters/currency_model/currency_model.dart';
import 'package:app/presentation/widgets/unique/select_currency_modal.dart';
import 'package:app/utilities/constants/theme_globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TappableCurrencyTile extends StatelessWidget {
  final CurrencyModel? currency;
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
        height: 40.0,
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 11.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: currency != null
              ? Row(
                  key: UniqueKey(),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset('assets/flags/${currency!.code}.png', width: 34.0),
                    Text('${currency!.name} (${currency!.code})', textAlign: TextAlign.center, style: size17weight400.copyWith(color: Colors.white)),
                    Icon(CupertinoIcons.chevron_down, color: Colors.white),
                  ],
                )
              : SizedBox.shrink(),
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
      backgroundColor: Colors.transparent,
      builder: (context) => SelectCurrencyModal(toCurrency: toCurrency, cubit: currencyCubit),
    );
  }
}
