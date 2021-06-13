import 'package:app/presentation/screens/root_screen.dart';
import 'package:app/utilities/constants/app_constants.dart';
import 'package:app/utilities/constants/theme_globals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.app_name,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primaryColor: primaryColor,
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            headline6: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 19.0)),
          ),
          color: primaryColor,
          elevation: 0,
        ),
      ),
      home: RootScreen(),
    );
  }
}
