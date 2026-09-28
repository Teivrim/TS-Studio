import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WaveformDisplay extends StatelessWidget {
  final List<double> samples;
  final double height;
  final Color? waveColor;

  const WaveformDisplay({
    super.key,
    required this.samples,
    this.height = 100,
    this.waveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: AppTheme.modernPanelDecoration(),
      child: CustomPaint(
        painter: _WaveformPainter(
          samples: samples,
          waveColor: waveColor ?? AppTheme.primaryColor,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final List<double> samples;
  final Color waveColor;

  _WaveformPainter({required this.samples, required this.waveColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.isEmpty) return;

    final paint = Paint()
      ..color = waveColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = waveColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();
    final midY = size.height / 2;
    final stepX = size.width / samples.length;

    for (int i = 0; i < samples.length; i++) {
      final x = i * stepX;
      final y = midY - (samples[i] * midY * 0.9);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, midY);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, midY);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
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
