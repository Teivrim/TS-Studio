import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TapTempoButton extends StatefulWidget {
  final ValueChanged<int> onBpmChanged;

  const TapTempoButton({super.key, required this.onBpmChanged});

  @override
  State<TapTempoButton> createState() => _TapTempoButtonState();
}

class _TapTempoButtonState extends State<TapTempoButton> {
  final List<DateTime> _taps = [];

  void _handleTap() {
    final now = DateTime.now();
    _taps.add(now);

    // Keep only last 5 taps
    if (_taps.length > 5) {
      _taps.removeAt(0);
    }

    // Calculate BPM if we have at least 2 taps
    if (_taps.length >= 2) {
      final intervals = <int>[];
      for (int i = 1; i < _taps.length; i++) {
        intervals.add(_taps[i].difference(_taps[i - 1]).inMilliseconds);
      }

      final avgInterval = intervals.reduce((a, b) => a + b) / intervals.length;
      final bpm = (60000 / avgInterval).round();

      if (bpm >= 60 && bpm <= 200) {
        widget.onBpmChanged(bpm);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.primaryColor),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.touch_app, size: 16, color: AppTheme.primaryColor),
            SizedBox(width: 4),
            Text('Tap', style: TextStyle(fontSize: 12, color: AppTheme.primaryColor)),
          ],
        ),
      ),
    );
  }
}
