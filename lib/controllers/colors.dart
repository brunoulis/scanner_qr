import 'package:flutter/material.dart';

const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
  50: Color(0xFFFCFFF2),
  100: Color(0xFFF9FFDD),
  200: Color(0xFFF5FFC7),
  300: Color(0xFFF0FEB1),
  400: Color(0xFFEDFEA0),
  500: Color(_primaryPrimaryValue),
  600: Color(0xFFE7FE87),
  700: Color(0xFFE4FE7C),
  800: Color(0xFFE1FE72),
  900: Color(0xFFDBFD60),
});
const int _primaryPrimaryValue = 0xFFEAFE8F;

const MaterialColor primaryAccent =
    MaterialColor(_primaryAccentValue, <int, Color>{
  100: Color(0xFFFFFFFF),
  200: Color(_primaryAccentValue),
  400: Color(0xFFFFFFFF),
  700: Color(0xFFFAFFE8),
});
const int _primaryAccentValue = 0xFFFFFFFF;

const Color accent1 = Color(0xFFE4935D);
const Color accent2 = Color(0xFFBEABA1);
const Color offWhite = Color(0xFFF8ECE5);
const Color caption = Color(0xFF7D7873);
const Color body = Color(0xFF514F4D);
const Color greyStrong = const Color(0xFF272625);
const Color greyMedium = const Color(0xFF9D9995);
const Color white = Colors.white;
const Color black = const Color(0xFF1E1B18);
