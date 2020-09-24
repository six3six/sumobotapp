import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:path_provider/path_provider.dart';

import 'loading.dart';

Directory tmpFile;

main() async {
  runApp(App());
}

FirebaseAnalytics analytics = FirebaseAnalytics();

class App extends StatelessWidget {
  InputBorder inputBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0),
  );

  @override
  Widget build(BuildContext context) {
    Crashlytics.instance.enableInDevMode = true;
    FlutterError.onError = Crashlytics.instance.recordFlutterError;
    getTemporaryDirectory().then((value) => tmpFile = value);
    analytics.logAppOpen();

    return MaterialApp(
      title: 'Sumobot',
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.red[800],
        accentColor: Colors.redAccent[800],

        inputDecorationTheme: InputDecorationTheme(
          filled: false,
          hoverColor: Colors.white,
          focusColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(color: Colors.white),
          errorStyle: TextStyle(color: Colors.white70),
          hintStyle: TextStyle(color: Colors.white),
          prefixStyle: TextStyle(color: Colors.white),
          suffixStyle: TextStyle(color: Colors.white),
          helperStyle: TextStyle(color: Colors.white),
          counterStyle: TextStyle(color: Colors.white),
          focusedBorder: inputBorder,
          enabledBorder: inputBorder,
          errorBorder: inputBorder,
          focusedErrorBorder: inputBorder,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        ),

        buttonTheme: ButtonThemeData(
          buttonColor: Colors.transparent,
          hoverColor: Colors.white60,
          splashColor: Colors.white,
          focusColor: Colors.white60,
          highlightColor: Colors.white70,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(50),
          ),
        ),

        // Define the default font family.
        fontFamily: 'Helvetica',

        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AppLoad(),
    );
  }
}
