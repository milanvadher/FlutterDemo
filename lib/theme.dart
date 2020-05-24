import 'package:flutter/material.dart';

class AppTheme {
  static ShapeBorder shapeBoarder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(4.0),
  );

  static CardTheme cardTheme = CardTheme(shape: shapeBoarder);

  static ButtonThemeData buttonThemeData = ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
    shape: shapeBoarder,
  );

  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(),
  );

  static final ColorScheme darkColorScheme = ColorScheme.dark(
    primary: Colors.deepPurple.shade200,
    primaryVariant: Colors.deepPurple.shade700,
    secondary: Colors.orange.shade200,
    background: Color(0xFF121212),
    surface: Color(0xFF121212),
    error: Color(0xFFCF6679),
    onPrimary: Color(0xFF000000),
    onSecondary: Color(0xFF000000),
    onBackground: Color(0xFFFFFFFF),
    onSurface: Color(0xFFFFFFFF),
    onError: Color(0xFF000000),
  );

  static final ColorScheme lightColorScheme = ColorScheme.light(
    primary: Colors.deepPurple.shade500,
    primaryVariant: Colors.deepPurple.shade700,
    secondary: Colors.orange.shade200,
    secondaryVariant: Colors.orange.shade900,
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    error: Color(0xFFB00020),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFF000000),
    onBackground: Color(0xFF000000),
    onSurface: Color(0xFF000000),
    onError: Color(0xFFFFFFFF),
  );

  static final ThemeData darkTheme = ThemeData.from(
    colorScheme: darkColorScheme,
    textTheme: TextTheme().apply(fontFamily: 'Google'),
  ).copyWith(
    buttonTheme: buttonThemeData,
    cardTheme: cardTheme,
    inputDecorationTheme: inputDecorationTheme,
  );

  static final ThemeData lightTheme = ThemeData.from(
    colorScheme: lightColorScheme,
    textTheme: TextTheme().apply(fontFamily: 'Google'),
  ).copyWith(
    buttonTheme: buttonThemeData,
    cardTheme: cardTheme,
    inputDecorationTheme: inputDecorationTheme,
  );
}
