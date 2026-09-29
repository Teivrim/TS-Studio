import 'package:flutter/material.dart';
import '../services/drum_machine_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';

class DrumMachineScreen extends StatefulWidget {
  const DrumMachineScreen({super.key});

  @override
  State<DrumMachineScreen> createState() => _DrumMachineScreenState();
}

class _DrumMachineScreenState extends State<DrumMachineScreen> {
  final DrumMachineService _drumService = DrumMachineService();
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _drumService.beatStream.listen((step) {
      setState(() => _currentStep = step);
    });
  }

  @override
  void dispose() {
    _drumService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'DRUM MACHINE',
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
            icon: _drumService.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            onPressed: () {
              if (_drumService.isPlaying) {
                _drumService.stop();
              } else {
                _drumService.start();
              }
              setState(() {});
            },
            width: 44,
            height: 44,
            isPrimary: _drumService.isPlaying,
          ),
          const SizedBox(width: 8),
          ModernButton(
            icon: Icons.stop_rounded,
            onPressed: () {
              _drumService.stop();
              setState(() {});
            },
            width: 44,
            height: 44,
          ),
          const SizedBox(width: 8),
          ModernButton(
            icon: Icons.clear_all_rounded,
            onPressed: () {
              _drumService.clearPattern();
              setState(() {});
            },
            width: 44,
            height: 44,
          ),
        ],
      ),
      body: Column(
        children: [
          // BPM control
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
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
                    value: _drumService.bpm.toDouble(),
                    min: 60,
                    max: 200,
                    divisions: 140,
                    activeColor: AppTheme.primaryColor,
                    inactiveColor: AppTheme.gridColor,
                    onChanged: (value) {
                      _drumService.setBpm(value.round());
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
                    '${_drumService.bpm}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Step indicators
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(16, (index) {
                final isCurrent = index == _currentStep;
                final isBeat = index % 4 == 0;

                return Expanded(
                  child: Container(
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? AppTheme.primaryColor
                          : isBeat
                              ? AppTheme.inactiveStepColor
                              : AppTheme.gridColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          // Drum pads
          Expanded(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, trackIndex) {
                final trackNames = ['Kick', 'Snare', 'Hi-Hat', 'Clap'];
                final trackColors = [
                  AppTheme.dangerColor,
                  AppTheme.warningColor,
                  AppTheme.accentColor,
                  AppTheme.successColor,
                ];

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: AppTheme.modernPanelDecoration(),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: trackColors[trackIndex],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              trackNames[trackIndex],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: List.generate(16, (stepIndex) {
                            final isActive = _drumService.pattern[trackIndex][stepIndex];
                            final isCurrent = stepIndex == _currentStep;
                            final isBeat = stepIndex % 4 == 0;

                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _drumService.toggleStep(trackIndex, stepIndex);
                                  setState(() {});
                                },
                                child: Container(
                                  height: 48,
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? trackColors[trackIndex]
                                        : isCurrent
                                            ? AppTheme.primaryColor.withValues(alpha: 0.2)
                                            : isBeat
                                                ? AppTheme.inactiveStepColor
                                                : AppTheme.gridColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: isCurrent
                                        ? Border.all(color: AppTheme.primaryColor, width: 2)
                                        : null,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
