import 'package:flutter/material.dart';
import '../services/metronome_advanced_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';

class MetronomeAdvancedScreen extends StatefulWidget {
  const MetronomeAdvancedScreen({super.key});

  @override
  State<MetronomeAdvancedScreen> createState() => _MetronomeAdvancedScreenState();
}

class _MetronomeAdvancedScreenState extends State<MetronomeAdvancedScreen> {
  final MetronomeAdvancedService _metronomeService = MetronomeAdvancedService();
  int _currentBeat = 0;
  bool _isAccent = false;

  @override
  void initState() {
    super.initState();
    _metronomeService.beatStream.listen((beat) {
      setState(() {
        _currentBeat = beat.beat;
        _isAccent = beat.isAccent;
      });
    });
  }

  @override
  void dispose() {
    _metronomeService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'METRONOME',
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
            icon: _metronomeService.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            onPressed: () {
              if (_metronomeService.isPlaying) {
                _metronomeService.stop();
              } else {
                _metronomeService.start();
              }
              setState(() {});
            },
            width: 44,
            height: 44,
            isPrimary: _metronomeService.isPlaying,
          ),
        ],
      ),
      body: Column(
        children: [
          // Beat display
          Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Text(
                  '${_currentBeat + 1}',
                  style: TextStyle(
                    fontSize: 120,
                    fontWeight: FontWeight.w800,
                    color: _isAccent ? AppTheme.dangerColor : AppTheme.primaryColor,
                  ),
                ),
                Text(
                  'BEAT',
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
          // Beat indicators
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(_metronomeService.timeSignature, (index) {
                final isCurrent = index == _currentBeat;
                final isAccent = _metronomeService.accentFirst && index == 0;

                return Expanded(
                  child: Container(
                    height: 16,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? (isAccent ? AppTheme.dangerColor : AppTheme.primaryColor)
                          : AppTheme.gridColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 32),
          // Controls
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // BPM
                Row(
                  children: [
                    const Text(
                      'BPM:',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Slider(
                        value: _metronomeService.bpm.toDouble(),
                        min: 40,
                        max: 280,
                        divisions: 240,
                        activeColor: AppTheme.primaryColor,
                        inactiveColor: AppTheme.gridColor,
                        onChanged: (value) {
                          _metronomeService.setBpm(value.round());
                          setState(() {});
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: AppTheme.modernButtonDecoration(
                        color: AppTheme.surfaceLightColor,
                        borderRadius: 12,
                      ),
                      child: Text(
                        '${_metronomeService.bpm}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Time signature
                const Text(
                  'TIME SIGNATURE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [2, 3, 4, 5, 6, 7, 8].map((sig) {
                    final isSelected = _metronomeService.timeSignature == sig;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () {
                            _metronomeService.setTimeSignature(sig);
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: AppTheme.modernButtonDecoration(
                              color: isSelected
                                  ? AppTheme.primaryColor.withValues(alpha: 0.2)
                                  : AppTheme.surfaceLightColor,
                              isPrimary: isSelected,
                              borderRadius: 12,
                            ),
                            child: Center(
                              child: Text(
                                '$sig',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                // Accent toggle
                Row(
                  children: [
                    const Text(
                      'ACCENT FIRST',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: _metronomeService.accentFirst,
                      onChanged: (value) {
                        _metronomeService.setAccentFirst(value);
                        setState(() {});
                      },
                      activeThumbColor: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
