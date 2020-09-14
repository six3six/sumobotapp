import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:sumobot/edition.dart';
import 'package:sumobot/loby.dart';
import 'package:sumobot/login.dart';
import 'package:sumobot/profile.dart';
import 'package:sumobot/robot.dart';
import 'package:sumobot/robot_admin.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'loading.dart';

void main() {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(App());
}

class App extends StatelessWidget {
  /*final router = new fluro.Router();

  void defineRoutes(fluro.Router router) {
    router.define("/main", handler: fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return Lobby();
    }));

    router.define("/robot/:id", handler: fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return Robot(robotId: int.parse(params["id"][0]));
    }));

    router.define("/login", handler: fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return Login();
    }));

    router.define("/profile", handler: fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return Profile();
    }));

    router.define("/edition/:year", handler: fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return Edition();
    }));

    router.define("/admin/robot/:id", handler: fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return RobotAdmin();
    }));
  }
*/
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //defineRoutes(router);

    return MaterialApp(
      title: 'Sumobot',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.red[800],
        accentColor: Colors.redAccent[800],

        buttonColor: Colors.red[800],

        inputDecorationTheme: InputDecorationTheme(
            contentPadding: EdgeInsets.symmetric(vertical: 10)),

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
