import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LevelMeter extends StatelessWidget {
  final double level;
  final double peak;
  final double height;
  final double width;

  const LevelMeter({
    super.key,
    required this.level,
    required this.peak,
    this.height = 16,
    this.width = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CustomPaint(
        painter: _LevelMeterPainter(
          level: level,
          peak: peak,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _LevelMeterPainter extends CustomPainter {
  final double level;
  final double peak;

  _LevelMeterPainter({required this.level, required this.peak});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = AppTheme.gridColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(8),
      ),
      backgroundPaint,
    );

    final levelWidth = size.width * level.clamp(0.0, 1.0);
    final gradient = LinearGradient(
      colors: [
        AppTheme.successColor,
        AppTheme.warningColor,
        AppTheme.dangerColor,
      ],
      stops: const [0.0, 0.6, 1.0],
    );

    final levelPaint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, levelWidth, size.height))
      ..style = PaintingStyle.fill;

    if (levelWidth > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, levelWidth, size.height),
          const Radius.circular(8),
        ),
        levelPaint,
      );
    }

    final peakX = size.width * peak.clamp(0.0, 1.0);
    final peakPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(peakX, 0),
      Offset(peakX, size.height),
      peakPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
