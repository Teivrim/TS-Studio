import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WaveformWidget extends StatelessWidget {
  final List<double> samples;
  final double height;
  final Color color;

  const WaveformWidget({
    super.key,
    required this.samples,
    this.height = 60,
    this.color = AppTheme.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _WaveformPainter(samples: samples, color: color),
        size: Size.infinite,
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final List<double> samples;
  final Color color;

  _WaveformPainter({required this.samples, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    final midY = size.height / 2;
    final stepX = size.width / samples.length;

    for (int i = 0; i < samples.length; i++) {
      final x = i * stepX;
      final y = midY - (samples[i] * midY * 0.9);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw center line
    final centerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, midY), Offset(size.width, midY), centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
