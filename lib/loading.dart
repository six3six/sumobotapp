import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sumobot/loby.dart';

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


// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
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
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: paddingInput),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/sumobot.png"),
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
