import 'package:flutter/material.dart';

class AppTheme {
  static final ColorScheme darkTheme = ColorScheme.dark(
    brightness: Brightness.dark,
    primary: Colors.purple.shade200,
    primaryVariant: Colors.purple.shade700,
    secondary: Colors.teal.shade200,
    background: Color(0xFF121212),
    surface: Color(0xFF121212),
    error: Color(0xFFCF6679),
    onPrimary: Color(0xFF000000),
    onSecondary: Color(0xFF000000),
    onBackground: Color(0xFFFFFFFF),
    onSurface: Color(0xFFFFFFFF),
    onError: Color(0xFF000000),
  );

  static final ColorScheme lightTheme = ColorScheme.light(
    brightness: Brightness.light,
    primary: Colors.purple.shade500,
    primaryVariant: Colors.purple.shade700,
    secondary: Colors.teal.shade200,
    secondaryVariant: Colors.teal.shade900,
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    error: Color(0xFFB00020),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFF000000),
    onBackground: Color(0xFF000000),
    onSurface: Color(0xFF000000),
    onError: Color(0xFFFFFFFF),
  );
}
