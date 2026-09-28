import 'package:flutter/material.dart';
import '../services/spectrum_service.dart';
import '../theme/app_theme.dart';

class RealtimeSpectrum extends StatefulWidget {
  final SpectrumService spectrumService;
  final double height;

  const RealtimeSpectrum({
    super.key,
    required this.spectrumService,
    this.height = 100,
  });

  @override
  State<RealtimeSpectrum> createState() => _RealtimeSpectrumState();
}

class _RealtimeSpectrumState extends State<RealtimeSpectrum> {
  @override
  void initState() {
    super.initState();
    widget.spectrumService.start();
  }

  @override
  void dispose() {
    widget.spectrumService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: AppTheme.modernPanelDecoration(),
      child: StreamBuilder<List<double>>(
        stream: widget.spectrumService.spectrumStream,
        builder: (context, snapshot) {
          final spectrum = snapshot.data ?? [];
          return CustomPaint(
            painter: _SpectrumPainter(
              spectrum: spectrum,
              barColor: AppTheme.primaryColor,
            ),
            size: Size.infinite,
          );
        },
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
