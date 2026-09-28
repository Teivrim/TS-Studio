import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ModernSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final Color? activeColor;
  final double height;
  final String? label;

  const ModernSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.height = 32,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? AppTheme.primaryColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              label!,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
        SizedBox(
          height: height,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
              activeTrackColor: color,
              inactiveTrackColor: AppTheme.gridColor,
              thumbColor: color,
              trackShape: const RectangularSliderTrackShape(),
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 1,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
