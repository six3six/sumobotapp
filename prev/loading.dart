import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sumobot/loby.dart';
import 'package:vibration/vibration.dart';

import 'login.dart';

class AppLoad extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Loading();
}

class Loading extends State<AppLoad> {
  String error = "";

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

      OneSignal.shared.init("4f82f3b1-777e-4b3d-a3cb-47f8a5585044",
          iOSSettings: {
            OSiOSSettings.autoPrompt: false,
            OSiOSSettings.inAppLaunchUrl: false
          });
      OneSignal.shared
          .setInFocusDisplayType(OSNotificationDisplayType.notification);

      OneSignal.shared.setNotificationReceivedHandler((notification) async {
        if (await Vibration.hasVibrator()) {
          await Future.delayed(Duration(seconds: 2));
          Vibration.vibrate(
              pattern: [0, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000],
              amplitude: 255);
        }
      });
      OneSignal.shared.setNotificationOpenedHandler((openedResult) {
        Vibration.cancel();
      });

      await OneSignal.shared
          .promptUserForPushNotificationPermission(fallbackToSettings: true);

      //await Future.delayed(Duration(seconds: 5));
    } catch (e) {
      setState(() {
        error = e.toString();
      });
      return;
    }
    User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Lobby()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: paddingInput),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/sumo_face_500.png",
                height: 100,
              ),
              Container(
                height: 20,
              ),
              Text(error),
            ],
          ),
        ),
      ),
    );
  }
}
