import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
