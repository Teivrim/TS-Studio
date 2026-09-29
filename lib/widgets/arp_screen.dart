import 'package:flutter/material.dart';
import '../services/arp_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';

class ArpScreen extends StatefulWidget {
  const ArpScreen({super.key});

  @override
  State<ArpScreen> createState() => _ArpScreenState();
}

class _ArpScreenState extends State<ArpScreen> {
  final ArpService _arpService = ArpService();
  ArpNote? _lastNote;

  @override
  void initState() {
    super.initState();
    _arpService.noteStream.listen((note) {
      setState(() => _lastNote = note);
    });
  }

  @override
  void dispose() {
    _arpService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'ARPEGGIATOR',
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
            icon: _arpService.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            onPressed: () {
              if (_arpService.isPlaying) {
                _arpService.stop();
              } else {
                _arpService.start();
              }
              setState(() {});
            },
            width: 44,
            height: 44,
            isPrimary: _arpService.isPlaying,
          ),
        ],
      ),
      body: Column(
        children: [
          // Note display
          Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Text(
                  _lastNote?.noteName ?? '---',
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const Text(
                  'NOTE',
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
                        value: _arpService.bpm.toDouble(),
                        min: 60,
                        max: 200,
                        divisions: 140,
                        activeColor: AppTheme.primaryColor,
                        inactiveColor: AppTheme.gridColor,
                        onChanged: (value) {
                          _arpService.setBpm(value.round());
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
                        '${_arpService.bpm}',
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
                // Pattern selector
                const Text(
                  'PATTERN',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: ['up', 'down', 'updown', 'random'].map((pattern) {
                    final isSelected = _arpService.pattern == pattern;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () {
                            _arpService.setPattern(pattern);
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
                                pattern,
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
                // Octaves
                const Text(
                  'OCTAVES',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [1, 2, 3, 4].map((octave) {
                    final isSelected = _arpService.octaves == octave;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () {
                            _arpService.setOctaves(octave);
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
                                '$octave',
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
