import 'package:app/infrastructure/locator.dart';
import 'package:app/infrastructure/services/hive_service.dart';
import 'package:app/utilities/constants/theme_globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CachedCurrencyItem extends StatelessWidget {
  final String cachedDay;

  const CachedCurrencyItem(this.cachedDay);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        children: [
          SizedBox(width: 16.0),
          Text(cachedDay.toString(), style: size14weight400.copyWith(color: Colors.white)),
          Spacer(),
          IconButton(
            onPressed: () => Navigator.of(context).pop(cachedDay),
            icon: Icon(CupertinoIcons.arrow_up_right_square, color: CupertinoColors.activeBlue.withOpacity(.75)),
          ),
          IconButton(
            onPressed: () => locator<HiveService>().removeCachedDataForDate(cachedDay),
            icon: Icon(CupertinoIcons.delete, color: CupertinoColors.destructiveRed.withOpacity(.75)),
          ),
        ],
      ),
    );
  }
}
