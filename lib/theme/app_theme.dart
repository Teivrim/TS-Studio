import 'package:flutter/material.dart';

class AppTheme {
  // FL Studio inspired colors
  static const Color primaryColor = Color(0xFFFF8C00); // Orange
  static const Color accentColor = Color(0xFF00FF41); // Green
  static const Color backgroundColor = Color(0xFF1A1A1A);
  static const Color surfaceColor = Color(0xFF2A2A2A);
  static const Color gridColor = Color(0xFF3A3A3A);
  static const Color inactiveStepColor = Color(0xFF4A4A4A);
  static const Color playheadColor = Color(0xFF00FF41);
  static const Color dangerColor = Color(0xFFFF4444);
  static const Color successColor = Color(0xFF00FF41);
  static const Color warningColor = Color(0xFFFFAA00);
  static const Color buttonColor = Color(0xFF3D3D3D);
  static const Color buttonHighlight = Color(0xFF5A5A5A);
  static const Color buttonShadow = Color(0xFF1A1A1A);
  static const Color textPrimary = Color(0xFFE0E0E0);
  static const Color textSecondary = Color(0xFF888888);
  static const Color borderColor = Color(0xFF555555);

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
      sliderTheme: SliderThemeData(
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
      ),
    );
  }

  // FL Studio style button decoration
  static BoxDecoration flButtonDecoration({
    Color? color,
    bool isPressed = false,
    bool isPrimary = false,
  }) {
    return BoxDecoration(
      color: isPressed
          ? (color ?? buttonColor).withValues(alpha: 0.8)
          : (color ?? buttonColor),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(
        color: isPrimary ? primaryColor : borderColor,
        width: isPrimary ? 2 : 1,
      ),
      boxShadow: isPressed
          ? []
          : [
              BoxShadow(
                color: buttonShadow,
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
    );
  }

  // FL Studio style step decoration
  static BoxDecoration flStepDecoration({
    bool isActive = false,
    bool isCurrentStep = false,
    bool isBeat = false,
    Color? activeColor,
  }) {
    final baseColor = activeColor ?? primaryColor;
    return BoxDecoration(
      color: isActive
          ? baseColor
          : isCurrentStep
              ? playheadColor.withValues(alpha: 0.2)
              : isBeat
                  ? inactiveStepColor
                  : gridColor,
      borderRadius: BorderRadius.circular(2),
      border: isCurrentStep
          ? Border.all(color: playheadColor, width: 2)
          : Border.all(color: borderColor.withValues(alpha: 0.3)),
      boxShadow: isActive
          ? [
              BoxShadow(
                color: baseColor.withValues(alpha: 0.6),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ]
          : [],
    );
  }

  // FL Studio style panel decoration
  static BoxDecoration flPanelDecoration() {
    return BoxDecoration(
      color: surfaceColor,
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: borderColor),
    );
  }

  // FL Studio style LED indicator
  static BoxDecoration flLedDecoration({required bool isOn, Color? color}) {
    return BoxDecoration(
      color: isOn ? (color ?? accentColor) : gridColor,
      shape: BoxShape.circle,
      boxShadow: isOn
          ? [
              BoxShadow(
                color: (color ?? accentColor).withValues(alpha: 0.8),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ]
          : [],
    );
  }
}
