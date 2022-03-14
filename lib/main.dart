import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sumobot/sumobot_observer.dart';
import 'dart:io' show Platform;

import 'app.dart';

bool oneSignalAvailable = Platform.isAndroid || Platform.isIOS;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (oneSignalAvailable) {
    OneSignal.shared.setAppId("4f82f3b1-777e-4b3d-a3cb-47f8a5585044");
    OneSignal.shared.promptUserForPushNotificationPermission();
  }

  EquatableConfig.stringify = kDebugMode;
  //Bloc.observer = SumobotObserver();
  runApp(App(authenticationRepository: AuthenticationRepository()));
}
