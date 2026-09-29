import 'package:flutter/material.dart';
import '../services/audio_analysis_service.dart';
import '../theme/app_theme.dart';
import 'level_meter.dart';
import 'modern_panel.dart';

class LevelMeterScreen extends StatefulWidget {
  const LevelMeterScreen({super.key});

  @override
  State<LevelMeterScreen> createState() => _LevelMeterScreenState();
}

class _LevelMeterScreenState extends State<LevelMeterScreen> {
  final AudioAnalysisService _analysisService = AudioAnalysisService();
  double _currentLevel = 0.0;
  double _peakLevel = 0.0;

  @override
  void initState() {
    super.initState();
    _analysisService.levelStream.listen((level) {
      setState(() {
        _currentLevel = level;
      });
    });
    _analysisService.peakStream.listen((peak) {
      setState(() {
        _peakLevel = peak;
      });
    });
    _analysisService.start();
  }

  @override
  void dispose() {
    _analysisService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'LEVEL METER',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
      ),
      body: Column(
        children: [
          // Level meter
          Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                LevelMeter(
                  level: _currentLevel,
                  peak: _peakLevel,
                  height: 32,
                  width: double.infinity,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Level: ${(_currentLevel * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      'Peak: ${(_peakLevel * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Multiple meters
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ModernPanel(
                  title: 'CHANNEL METERS',
                  child: Column(
                    children: List.generate(8, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: Text(
                                'CH ${index + 1}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ),
                            Expanded(
                              child: LevelMeter(
                                level: _currentLevel * (1.0 - index * 0.1),
                                peak: _peakLevel * (1.0 - index * 0.1),
                                height: 16,
                                width: double.infinity,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
