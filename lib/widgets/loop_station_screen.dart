import 'package:flutter/material.dart';
import '../services/loop_station_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';

class LoopStationScreen extends StatefulWidget {
  const LoopStationScreen({super.key});

  @override
  State<LoopStationScreen> createState() => _LoopStationScreenState();
}

class _LoopStationScreenState extends State<LoopStationScreen> {
  final LoopStationService _loopService = LoopStationService();
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _loopService.loopStream.listen((event) {
      setState(() => _currentStep = event.step);
    });
  }

  @override
  void dispose() {
    _loopService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'LOOP STATION',
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
            icon: _loopService.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            onPressed: () {
              if (_loopService.isPlaying) {
                _loopService.stop();
              } else {
                _loopService.start();
              }
              setState(() {});
            },
            width: 44,
            height: 44,
            isPrimary: _loopService.isPlaying,
          ),
          const SizedBox(width: 8),
          ModernButton(
            icon: Icons.stop_rounded,
            onPressed: () {
              _loopService.stop();
              setState(() {});
            },
            width: 44,
            height: 44,
          ),
          const SizedBox(width: 8),
          ModernButton(
            icon: Icons.shuffle_rounded,
            onPressed: () {
              _loopService.randomizePattern();
              setState(() {});
            },
            width: 44,
            height: 44,
          ),
          const SizedBox(width: 8),
          ModernButton(
            icon: Icons.clear_all_rounded,
            onPressed: () {
              _loopService.clearPattern();
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
                    value: _loopService.bpm.toDouble(),
                    min: 60,
                    max: 200,
                    divisions: 140,
                    activeColor: AppTheme.primaryColor,
                    inactiveColor: AppTheme.gridColor,
                    onChanged: (value) {
                      _loopService.setBpm(value.round());
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
                    '${_loopService.bpm}',
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
          // Loop tracks
          Expanded(
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (context, trackIndex) {
                final trackNames = ['Kick', 'Snare', 'Hi-Hat', 'Clap', 'Tom', 'Rim', 'Crash', 'Perc'];
                final trackColors = [
                  AppTheme.dangerColor,
                  AppTheme.warningColor,
                  AppTheme.accentColor,
                  AppTheme.successColor,
                  AppTheme.primaryColor,
                  AppTheme.secondaryColor,
                  AppTheme.textSecondary,
                  AppTheme.borderColor,
                ];

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: AppTheme.modernPanelDecoration(),
                  child: Column(
                    children: [
                      // Track header
                      Row(
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
                          Expanded(
                            child: Text(
                              trackNames[trackIndex],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ),
                          // Mute/Solo
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _loopService.toggleMute(trackIndex);
                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: AppTheme.modernButtonDecoration(
                                    color: _loopService.mutes[trackIndex]
                                        ? AppTheme.dangerColor.withValues(alpha: 0.2)
                                        : AppTheme.surfaceLightColor,
                                    isPrimary: _loopService.mutes[trackIndex],
                                    borderRadius: 8,
                                  ),
                                  child: Text(
                                    'M',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: _loopService.mutes[trackIndex]
                                          ? AppTheme.dangerColor
                                          : AppTheme.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  _loopService.toggleSolo(trackIndex);
                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: AppTheme.modernButtonDecoration(
                                    color: _loopService.solos[trackIndex]
                                        ? AppTheme.warningColor.withValues(alpha: 0.2)
                                        : AppTheme.surfaceLightColor,
                                    isPrimary: _loopService.solos[trackIndex],
                                    borderRadius: 8,
                                  ),
                                  child: Text(
                                    'S',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: _loopService.solos[trackIndex]
                                          ? AppTheme.warningColor
                                          : AppTheme.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Volume slider
                      SizedBox(
                        height: 24,
                        child: Slider(
                          value: _loopService.volumes[trackIndex],
                          min: 0,
                          max: 1,
                          activeColor: trackColors[trackIndex],
                          inactiveColor: AppTheme.gridColor,
                          onChanged: (value) {
                            _loopService.setVolume(trackIndex, value);
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Step buttons
                      Row(
                        children: List.generate(16, (stepIndex) {
                          final isActive = _loopService.pattern[trackIndex][stepIndex];
                          final isCurrent = stepIndex == _currentStep;
                          final isBeat = stepIndex % 4 == 0;

                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _loopService.toggleStep(trackIndex, stepIndex);
                                setState(() {});
                              },
                              child: Container(
                                height: 32,
                                margin: const EdgeInsets.symmetric(horizontal: 1),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? trackColors[trackIndex]
                                      : isCurrent
                                          ? AppTheme.primaryColor.withValues(alpha: 0.2)
                                          : isBeat
                                              ? AppTheme.inactiveStepColor
                                              : AppTheme.gridColor,
                                  borderRadius: BorderRadius.circular(4),
                                  border: isCurrent
                                      ? Border.all(color: AppTheme.primaryColor, width: 2)
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }),
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
