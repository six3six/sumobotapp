import 'package:flutter/material.dart';

final theme = ThemeData(
// Define the default brightness and colors.
  brightness: Brightness.light,
  primaryColor: Colors.red[700],
  accentColor: Colors.red[900],

  buttonTheme: ButtonThemeData(
    buttonColor: Colors.red[800],
    height: 38,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.white, width: 2),
      borderRadius: BorderRadius.circular(50),
    ),
  ),

  visualDensity: VisualDensity.adaptivePlatformDensity,
);
