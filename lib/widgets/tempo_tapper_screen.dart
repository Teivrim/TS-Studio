import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';

class TempoTapperScreen extends StatefulWidget {
  final ValueChanged<int> onBpmChanged;

  const TempoTapperScreen({super.key, required this.onBpmChanged});

  @override
  State<TempoTapperScreen> createState() => _TempoTapperScreenState();
}

class _TempoTapperScreenState extends State<TempoTapperScreen> {
  final List<DateTime> _taps = [];
  int _calculatedBpm = 0;

  void _handleTap() {
    final now = DateTime.now();
    _taps.add(now);

    if (_taps.length > 5) {
      _taps.removeAt(0);
    }

    if (_taps.length >= 2) {
      final intervals = <int>[];
      for (int i = 1; i < _taps.length; i++) {
        intervals.add(_taps[i].difference(_taps[i - 1]).inMilliseconds);
      }

      final avgInterval = intervals.reduce((a, b) => a + b) / intervals.length;
      final bpm = (60000 / avgInterval).round();

      if (bpm >= 60 && bpm <= 200) {
        setState(() {
          _calculatedBpm = bpm;
        });
        widget.onBpmChanged(bpm);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'TEMPO TAPPER',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
        actions: [
          ModernButton(
            icon: Icons.clear_all_rounded,
            onPressed: () {
              setState(() {
                _taps.clear();
                _calculatedBpm = 0;
              });
            },
            width: 44,
            height: 44,
          ),
        ],
      ),
      body: Column(
        children: [
          // BPM display
          Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Text(
                  '$_calculatedBpm',
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const Text(
                  'BPM',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
          ),
          // Tap area
          Expanded(
            child: GestureDetector(
              onTap: _handleTap,
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: AppTheme.modernPanelDecoration(),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.touch_app_rounded,
                        size: 64,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'TAP TO SET TEMPO',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_taps.length} taps',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
