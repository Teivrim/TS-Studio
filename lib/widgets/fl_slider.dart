import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FLSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final Color? activeColor;
  final double height;
  final String? label;

  const FLSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.height = 24,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? AppTheme.primaryColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Text(
            label!,
            style: const TextStyle(
              fontSize: 9,
              color: AppTheme.textSecondary,
            ),
          ),
        SizedBox(
          height: height,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              activeTrackColor: color,
              inactiveTrackColor: AppTheme.gridColor,
              thumbColor: color,
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
