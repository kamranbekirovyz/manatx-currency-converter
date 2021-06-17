import 'package:app/infrastructure/locator.dart';
import 'package:app/infrastructure/services/hive_service.dart';
import 'package:app/presentation/widgets/items/cached_currency_item.dart';
import 'package:app/presentation/widgets/wrapper/hive_listener.dart';
import 'package:app/utilities/constants/theme_globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CachedDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(CupertinoIcons.back),
        ),
        title: Text('Keşlənmiş günlər'),
        centerTitle: true,
      ),
      body: HiveListener(
        box: locator<HiveService>().currencyBox,
        builder: (Box box) {
          if (box.isEmpty) return _buildEmptyIndicator();

          return _buildList(box);
        },
      ),
    );
  }

  Widget _buildEmptyIndicator() {
    return Center(
      child: Text('Keş listiniz boşdur.', style: size16weight400.copyWith(color: Colors.white)),
    );
  }

  Widget _buildList(Box<dynamic> box) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      itemCount: box.keys.length,
      itemBuilder: (_, int index) {
        final cachedDay = box.keys.elementAt(index);

        return CachedCurrencyItem(cachedDay);
      },
      separatorBuilder: (_, __) => SizedBox(height: 4.0),
    );
  }
}
