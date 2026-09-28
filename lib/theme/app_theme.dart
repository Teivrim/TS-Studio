import 'package:flutter/material.dart';

class AppTheme {
  // Modern DAW color palette
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color secondaryColor = Color(0xFF8B5CF6); // Violet
  static const Color accentColor = Color(0xFF06B6D4); // Cyan
  static const Color successColor = Color(0xFF10B981); // Emerald
  static const Color warningColor = Color(0xFFF59E0B); // Amber
  static const Color dangerColor = Color(0xFFEF4444); // Red

  static const Color backgroundColor = Color(0xFF0F0F13);
  static const Color surfaceColor = Color(0xFF1A1A24);
  static const Color surfaceLightColor = Color(0xFF252532);
  static const Color gridColor = Color(0xFF2A2A3A);
  static const Color inactiveStepColor = Color(0xFF3A3A4A);
  static const Color playheadColor = Color(0xFF06B6D4);

  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  static const Color borderColor = Color(0xFF334155);
  static const Color glassColor = Color(0x1AFFFFFF);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
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

  // Glassmorphism card decoration
  static BoxDecoration glassDecoration({
    double borderRadius = 16,
    Color? color,
    Border? border,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      color: color ?? glassColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: border ??
          Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
      boxShadow: shadows ??
          [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.05),
          Colors.white.withValues(alpha: 0.02),
        ],
      ),
    );
  }

  // Modern button decoration
  static BoxDecoration modernButtonDecoration({
    Color? color,
    bool isPressed = false,
    bool isPrimary = false,
    double borderRadius = 12,
  }) {
    final baseColor = color ?? surfaceLightColor;
    return BoxDecoration(
      color: isPressed
          ? baseColor.withValues(alpha: 0.8)
          : baseColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: isPrimary
            ? primaryColor.withValues(alpha: 0.5)
            : Colors.white.withValues(alpha: 0.1),
        width: isPrimary ? 2 : 1,
      ),
      boxShadow: isPressed
          ? []
          : [
              BoxShadow(
                color: isPrimary
                    ? primaryColor.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.2),
                blurRadius: isPrimary ? 16 : 8,
                offset: const Offset(0, 4),
              ),
            ],
      gradient: isPrimary
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryColor,
                secondaryColor,
              ],
            )
          : null,
    );
  }

  // Modern step decoration
  static BoxDecoration modernStepDecoration({
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
              ? playheadColor.withValues(alpha: 0.15)
              : isBeat
                  ? inactiveStepColor
                  : gridColor,
      borderRadius: BorderRadius.circular(8),
      border: isCurrentStep
          ? Border.all(color: playheadColor, width: 2)
          : Border.all(
              color: isActive
                  ? baseColor.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.05),
            ),
      boxShadow: isActive
          ? [
              BoxShadow(
                color: baseColor.withValues(alpha: 0.4),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ]
          : [],
    );
  }

  // Modern panel decoration
  static BoxDecoration modernPanelDecoration({double borderRadius = 16}) {
    return BoxDecoration(
      color: surfaceColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: borderColor.withValues(alpha: 0.5)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  // LED indicator decoration
  static BoxDecoration ledDecoration({required bool isOn, Color? color}) {
    final ledColor = color ?? accentColor;
    return BoxDecoration(
      color: isOn ? ledColor : gridColor,
      shape: BoxShape.circle,
      boxShadow: isOn
          ? [
              BoxShadow(
                color: ledColor.withValues(alpha: 0.6),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ]
          : [],
    );
  }

  // Gradient text style
  static TextStyle gradientTextStyle({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      foreground: Paint()
        ..shader = LinearGradient(
          colors: [primaryColor, secondaryColor, accentColor],
        ).createShader(const Rect.fromLTWH(0, 0, 200, 50)),
    );
  }
}
