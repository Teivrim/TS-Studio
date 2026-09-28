import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SpectrumVisualizer extends StatelessWidget {
  final List<double> spectrum;
  final double height;
  final Color? barColor;

  const SpectrumVisualizer({
    super.key,
    required this.spectrum,
    this.height = 80,
    this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _SpectrumPainter(
          spectrum: spectrum,
          barColor: barColor ?? AppTheme.primaryColor,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _SpectrumPainter extends CustomPainter {
  final List<double> spectrum;
  final Color barColor;

  _SpectrumPainter({required this.spectrum, required this.barColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (spectrum.isEmpty) return;

    final barWidth = size.width / spectrum.length;
    final gradient = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        barColor,
        barColor.withValues(alpha: 0.5),
      ],
    );

    for (int i = 0; i < spectrum.length; i++) {
      final barHeight = spectrum[i] * size.height;
      final rect = Rect.fromLTWH(
        i * barWidth + 1,
        size.height - barHeight,
        barWidth - 2,
        barHeight,
      );

      final paint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(2)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
