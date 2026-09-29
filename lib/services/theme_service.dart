import 'package:flutter/material.dart';

class ThemeService {
  static const Map<String, Color> accentColors = {
    'indigo': Color(0xFF6366F1),
    'violet': Color(0xFF8B5CF6),
    'cyan': Color(0xFF06B6D4),
    'emerald': Color(0xFF10B981),
    'amber': Color(0xFFF59E0B),
    'rose': Color(0xFFF43F5E),
    'blue': Color(0xFF3B82F6),
    'purple': Color(0xFFA855F7),
  };

  static ThemeData getThemeWithAccent(Color accentColor) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: accentColor,
        secondary: accentColor,
        surface: const Color(0xFF1A1A24),
      ),
      scaffoldBackgroundColor: const Color(0xFF0F0F13),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }

  static Color getAccentColor(String name) {
    return accentColors[name] ?? accentColors['indigo']!;
  }

  static List<String> getAccentColorNames() {
    return accentColors.keys.toList();
  }
}
