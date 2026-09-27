import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF7C4DFF);
  static const Color accentColor = Color(0xFF00E5FF);
  static const Color backgroundColor = Color(0xFF121212);
  static const Color surfaceColor = Color(0xFF1E1E1E);
  static const Color gridColor = Color(0xFF2A2A2A);
  static const Color activeStepColor = Color(0xFF7C4DFF);
  static const Color inactiveStepColor = Color(0xFF3A3A3A);
  static const Color playheadColor = Color(0xFF00E5FF);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
