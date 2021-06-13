import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: 20.0 + MediaQuery.of(context).padding.top),
                StreamBuilder<ConnectivityResult>(
                  stream: Connectivity().onConnectivityChanged,
                  builder: (context, snapshot) {
                    String text = 'İnternetiniz bağlıdır.';
                    bool flag = false;
                    if (snapshot.data != ConnectivityResult.none) {
                      text = 'İnternetiniz açıqdır.';
                      flag = true;
                    }
                    return Text(
                      '$text',
                      style: TextStyle(fontSize: 17.0, color: flag ? Colors.teal : Colors.redAccent),
                    );
                  },
                ),
              ],
            ),
            Column(
              children: <Widget>[
                // const SpinKitWanderingCubes(color: Colors.white),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                SizedBox(height: 30.0),
                Text(
                  "Azərbaycan Mərkəzi Bankından məlumatlar toplanılır..",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17.0, color: Colors.white),
                )
              ],
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Tətbiqin işləməsi üçün internetinizin açıq olması vacibdir.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, color: Colors.white70),
                  ),
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}