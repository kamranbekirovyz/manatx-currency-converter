import 'package:app/infrastructure/cubits/currency/currency_cubit.dart';
import 'package:app/infrastructure/locator.dart';
import 'package:app/infrastructure/services/connectivity_service.dart';
import 'package:app/presentation/widgets/common/bottom_padding.dart';
import 'package:app/utilities/constants/theme_globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  final bool showRetryButton;

  const SplashScreen({
    this.showRetryButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: 16.0 + MediaQuery.of(context).padding.top),
              _buildConnectionIndicator(),
            ],
          ),
          showRetryButton ? _buildRetry(context) : _buildLoading(),
          _buildInternetConnectionAlert(),
        ],
      ),
    );
  }

  Widget _buildInternetConnectionAlert() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Tətbiqin işləməsi üçün internetinizin açıq olması vacibdir.",
            textAlign: TextAlign.center,
            style: size16weight400.copyWith(color: Colors.white70),
          ),
        ),
        BottomPadding(),
      ],
    );
  }

  Widget _buildLoading() {
    return Column(
      children: <Widget>[
        Text(
          "Azərbaycan Mərkəzi Bankından məlumatlar toplanılır..",
          textAlign: TextAlign.center,
          style: size17weight400.copyWith(color: Colors.white),
        ),
        SizedBox(height: 32.0),
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ],
    );
  }

  Widget _buildRetry(BuildContext context) {
    return Column(
      children: [
        Text(
          "İnternet əlaqəniz olmadığı üçün cari məzənnələri almaq mümkün olmadı 🙁",
          textAlign: TextAlign.center,
          style: size17weight400.copyWith(color: Colors.white),
        ),
        SizedBox(height: 32.0),
        CupertinoButton(
          child: Text('Yenidən cəhd edin'),
          onPressed: () => BlocProvider.of<CurrencyCubit>(context).fetchCurrencies(),
          color: greenColor,
        ),
      ],
    );
  }

  Widget _buildConnectionIndicator() {
    return StreamBuilder<bool>(
      stream: locator<ConnectivityService>().hasConnection$,
      builder: (context, snapshot) {
        String text = 'İnternetiniz bağlıdır.';
        if (snapshot.hasData && snapshot.data!) text = 'İnternetiniz açıqdır.';

        return Text(
          '$text',
          style: size17weight400.copyWith(color: snapshot.data ?? false ? greenColor : redColor),
        );
      },
    );
  }
}
