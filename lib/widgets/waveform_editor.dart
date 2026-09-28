import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WaveformEditor extends StatefulWidget {
  final List<double> samples;
  final ValueChanged<List<double>>? onSamplesChanged;
  final double height;

  const WaveformEditor({
    super.key,
    required this.samples,
    this.onSamplesChanged,
    this.height = 120,
  });

  @override
  State<WaveformEditor> createState() => _WaveformEditorState();
}

class _WaveformEditorState extends State<WaveformEditor> {
  late List<double> _samples;

  @override
  void initState() {
    super.initState();
    _samples = List.from(widget.samples);
  }

  void _updateSample(int index, double value) {
    setState(() {
      _samples[index] = value;
      widget.onSamplesChanged?.call(_samples);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: AppTheme.modernPanelDecoration(),
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          final box = context.findRenderObject() as RenderBox;
          final localPosition = details.localPosition;
          final index = ((localPosition.dx / box.size.width) * _samples.length).round();
          if (index >= 0 && index < _samples.length) {
            final value = 1.0 - (localPosition.dy / box.size.height);
            _updateSample(index, value.clamp(0.0, 1.0));
          }
        },
        child: CustomPaint(
          painter: _WaveformEditorPainter(
            samples: _samples,
            waveColor: AppTheme.primaryColor,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _WaveformEditorPainter extends CustomPainter {
  final List<double> samples;
  final Color waveColor;

  _WaveformEditorPainter({required this.samples, required this.waveColor});

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

    // Draw sample points
    final pointPaint = Paint()
      ..color = AppTheme.accentColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < samples.length; i++) {
      final x = i * stepX;
      final y = midY - (samples[i] * midY * 0.9);
      canvas.drawCircle(Offset(x, y), 3, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
