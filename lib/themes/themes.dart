import 'package:flutter/material.dart';

// Light Theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color.fromARGB(255, 207, 102, 121),
  scaffoldBackgroundColor: Color(0xFFF9FAFB),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF212121)),
    bodyMedium: TextStyle(color: Color(0xFF929292)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Color(0xFFC9C9C9),
  ),
  colorScheme: ColorScheme.light(
    primary: Color.fromARGB(255, 207, 102, 121),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF929292),
  ).copyWith(surface: Color(0xFFF9FAFB)),
);

// Dark Theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color.fromARGB(255, 207, 102, 121),
  scaffoldBackgroundColor: Color(0xFF151515),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFF1F1F1)),
    bodyMedium: TextStyle(color: Color(0xFF878787)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Color(0xFF434343),
  ),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFFCF6679),
    surface: Color(0xFF1F1F1F),
    onSurface: Color.fromARGB(255, 0, 0, 0),
  ).copyWith(surface: Color(0xFF151515)),
);