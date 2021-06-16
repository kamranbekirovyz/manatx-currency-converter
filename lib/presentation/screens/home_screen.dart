import 'package:app/infrastructure/cubits/currency/currency_cubit.dart';
import 'package:app/presentation/screens/cached_data_screen.dart';
import 'package:app/presentation/screens/tabs/currency_calculator_tab.dart';
import 'package:app/presentation/screens/tabs/todays_currencies_tab.dart';
import 'package:app/presentation/widgets/custom/custom_app_bar.dart';
import 'package:app/utilities/constants/theme_globals.dart';
import 'package:app/utilities/extensions/extensions.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final CurrencyCubit _cubit;

  @override
  void initState() {
    _cubit = BlocProvider.of<CurrencyCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      initialData: 0,
      stream: _cubit.tabIndex$,
      builder: (context, snapshot) {
        final tabIndex = snapshot.data;

        return Scaffold(
          appBar: CustomAppBar(
            height: kToolbarHeight + 40.0 + MediaQuery.of(context).padding.top,
            child: _buildAppBar(),
          ),
          body: IndexedStack(
            index: tabIndex ?? 0,
            children: [CurrencyCalculatorTab(), TodaysCurrenciesTab()],
          ),
        );
      },
    );
  }

  Widget _buildTab({
    required String title,
    required int index,
  }) {
    final isCurrent = index == _cubit.tabIndex;

    return Expanded(
      child: InkWell(
        onTap: () => _cubit.updateTabIndex(index),
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
      child: Column(
        children: [
          Container(
            height: 48.0,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCachedDataScreenButton(),
                _buildToday(),
                _buildDatePickerButton(),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildTab(title: 'Kalkulyator', index: 0),
              SizedBox(width: 8.0),
              _buildTab(title: 'Məzənnələr', index: 1),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerButton() {
    return IconButton(
      onPressed: _openTopDatePicker,
      icon: Icon(CupertinoIcons.calendar, color: Colors.white),
    );
  }

  Widget _buildToday() {
    return StreamBuilder<DateTime>(
      initialData: DateTime.now(),
      stream: _cubit.date$,
      builder: (context, snapshot) {
        return Text('${_cubit.formattedDate}', style: GoogleFonts.orbitron(fontSize: 20.0, color: Colors.white, letterSpacing: 2.0));
      },
    );
  }

  Widget _buildCachedDataScreenButton() {
    return IconButton(
      onPressed: () async {
        final result = await Navigator.of(context).push(CachedDataScreen().route);
        if (result != null) {
          final date = DateFormat('dd.MM.yyyy').parse(result);
          _cubit.updateDate(date);
          _cubit.fetchCurrencies();
        }
      },
      icon: Icon(CupertinoIcons.time, color: Colors.white),
    );
  }

  void _openTopDatePicker() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 500),
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, _, __) {
        bool isDateUpdated = false;

        return Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 16.0),
                color: primaryColor,
                child: CalendarTimeline(
                  showYears: true,
                  initialDate: _cubit.date,
                  firstDate: DateTime(2010),
                  lastDate: DateTime.now(),
                  onDateSelected: (DateTime? date) {
                    if (date != null) {
                      _cubit.updateDate(date);
                      isDateUpdated = true;
                    }
                  },
                  leftMargin: 20,
                  monthColor: Colors.blue.withOpacity(.75),
                  dayColor: Colors.white70,
                  dayNameColor: Colors.white70,
                  activeDayColor: Colors.white,
                  activeBackgroundDayColor: greenColor.withOpacity(.75),
                  dotsColor: Colors.white,
                  locale: 'az',
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (isDateUpdated) _cubit.fetchCurrencies();
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: double.maxFinite,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: greenColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                    ),
                  ),
                  child: Icon(Icons.done, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ).drive(Tween<Offset>(
            begin: Offset(0, -1.0),
            end: Offset.zero,
          )),
          child: child,
        );
      },
    );
  }
}
