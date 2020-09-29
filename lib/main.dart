import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sumobot/sumobot_observer.dart';

import 'app.dart';

void main() {
  Bloc.observer = SumobotObserver();
  runApp(const SumobotApp());
}
