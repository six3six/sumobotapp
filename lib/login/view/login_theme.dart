part of 'login_widgets.dart';

TextStyle fieldTheme = TextStyle(color: Colors.white);

InputBorder inputBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: Colors.white, width: 1.0),
);

InputDecorationTheme loginInputDecorationTheme = InputDecorationTheme(
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
);
