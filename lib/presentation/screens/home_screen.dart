import 'package:app/infrastructure/cubits/currency/currency_cubit.dart';
import 'package:app/presentation/screens/currency_calculator_tab.dart';
import 'package:app/presentation/screens/todays_currencies_tab.dart';
import 'package:app/presentation/widgets/custom_app_bar.dart';
import 'package:app/utilities/constants/theme_globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final CurrencyCubit _currencyCubit;

  @override
  void initState() {
    _currencyCubit = BlocProvider.of<CurrencyCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      initialData: 0,
      stream: _currencyCubit.tabIndex$,
      builder: (context, snapshot) {
        final tabIndex = snapshot.data;

        return Scaffold(
          appBar: CustomAppBar(
            height: kToolbarHeight + MediaQuery.of(context).padding.top,
            child: _buildAppBar(),
          ),
          body: (tabIndex == 0) ? CurrencyCalculatorTab() : TodaysCurrenciesTab(),
        );
      },
    );
  }

  Widget _buildTab({
    required String title,
    required int index,
  }) {
    final isCurrent = index == _currencyCubit.tabIndex;

    return Expanded(
      child: InkWell(
        onTap: () => _currencyCubit.updateTabIndex(index),
        child: Container(
          height: 36.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: isCurrent ? greenColor : Colors.white10,
            border: Border.all(color: isCurrent ? greenColor : Colors.white10, width: 2.0),
          ),
          child: Text(
            title.toString(),
            style: (isCurrent ? size15weight500 : size15weight400).copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 8.0, right: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildTab(title: 'Kalkulyator', index: 0),
          SizedBox(width: 8.0),
          _buildTab(title: 'Məzənnələr', index: 1),
        ],
      ),
    );
  }
}
