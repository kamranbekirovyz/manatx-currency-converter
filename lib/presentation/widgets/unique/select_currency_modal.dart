import 'package:app/infrastructure/cubits/currency/currency_cubit.dart';
import 'package:app/infrastructure/hive_adapters/currency_model/currency_model.dart';
import 'package:app/presentation/widgets/animations/slide_right_to_left.dart';
import 'package:app/presentation/widgets/custom/custom_radio_list_tile.dart';
import 'package:app/utilities/constants/theme_globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectCurrencyModal extends StatefulWidget {
  final bool _toCurrency;
  final CurrencyCubit _cubit;

  const SelectCurrencyModal({
    required bool toCurrency,
    required CurrencyCubit cubit,
  })  : _toCurrency = toCurrency,
        _cubit = cubit;

  @override
  _SelectCurrencyModalState createState() => _SelectCurrencyModalState();
}

class _SelectCurrencyModalState extends State<SelectCurrencyModal> {
  final List<CurrencyModel> _currencies = [];
  final _animatedListKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _populateList());
    super.initState();
  }

  Future<void> _populateList() async {
    for (CurrencyModel currency in widget._cubit.currencies) {
      if (_animatedListKey.currentState != null) {
        _currencies.add(currency);
        _animatedListKey.currentState!.insertItem(_currencies.length - 1);
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      height: MediaQuery.of(context).size.height * .75,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: CupertinoScrollbar(
          child: _buildList(),
        ),
      ),
    );
  }

  Widget _buildList() {
    return AnimatedList(
      shrinkWrap: true,
      key: _animatedListKey,
      initialItemCount: _currencies.length,
      itemBuilder: (context, posit, animation) {
        final currency = _currencies.elementAt(posit);

        bool flag;
        if (widget._toCurrency) {
          flag = widget._cubit.toCurrency.code == currency.code;
        } else {
          flag = widget._cubit.fromCurrency.code == currency.code;
        }
        return SlideRightToLeft(
          child: CustomRadioListTile(
            onTap: () {
              Navigator.of(context).pop();
              widget._toCurrency ? widget._cubit.updateToCurrencyByIndex(posit) : widget._cubit.updateFromCurrencyByIndex(posit);
            },
            currency: currency,
            flag: flag,
          ),
        );
      },
    );
  }
}
