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
  // This widget is the root of your application.
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

        buttonColor: Colors.red[800],

        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),

        // Define the default font family.
        fontFamily: 'Helvetica',

        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AppLoad(),
      // onGenerateRoute: router.generator,
    );
  }
}
