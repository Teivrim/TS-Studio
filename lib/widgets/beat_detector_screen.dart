import 'package:flutter/material.dart';
import '../services/beat_detector_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';

class BeatDetectorScreen extends StatefulWidget {
  const BeatDetectorScreen({super.key});

  @override
  State<BeatDetectorScreen> createState() => _BeatDetectorScreenState();
}

class _BeatDetectorScreenState extends State<BeatDetectorScreen> {
  final BeatDetectorService _beatService = BeatDetectorService();
  double _energy = 0.0;
  bool _beatDetected = false;

  @override
  void initState() {
    super.initState();
    _beatService.beatStream.listen((event) {
      setState(() {
        _energy = event.energy;
        _beatDetected = true;
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) setState(() => _beatDetected = false);
      });
    });
    _beatService.start();
  }

  @override
  void dispose() {
    _beatService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'BEAT DETECTOR',
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
            icon: _beatService.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
            onPressed: () {
              if (_beatService.isRunning) {
                _beatService.stop();
              } else {
                _beatService.start();
              }
              setState(() {});
            },
            width: 44,
            height: 44,
            isPrimary: _beatService.isRunning,
          ),
        ],
      ),
      body: Column(
        children: [
          // Beat indicator
          Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: _beatDetected
                        ? AppTheme.primaryColor
                        : AppTheme.surfaceColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _beatDetected
                          ? AppTheme.primaryColor
                          : AppTheme.borderColor,
                      width: 4,
                    ),
                    boxShadow: _beatDetected
                        ? [
                            BoxShadow(
                              color: AppTheme.primaryColor.withValues(alpha: 0.5),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      _beatDetected ? 'BEAT' : 'WAIT',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: _beatDetected ? Colors.white : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'BPM: ${_beatService.bpm}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentColor,
                  ),
                ),
              ],
            ),
          ),
          // Energy meter
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'ENERGY',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.gridColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor: _energy,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.successColor,
                                AppTheme.warningColor,
                                AppTheme.dangerColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'THRESHOLD',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Slider(
                  value: _beatService.threshold,
                  min: 0.1,
                  max: 1.0,
                  activeColor: AppTheme.primaryColor,
                  inactiveColor: AppTheme.gridColor,
                  onChanged: (value) {
                    _beatService.setThreshold(value);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
