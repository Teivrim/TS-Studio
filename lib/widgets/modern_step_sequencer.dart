import 'package:flutter/material.dart';
import '../models/track.dart';
import '../theme/app_theme.dart';
import 'modern_step.dart';
import 'modern_track_header.dart';

class ModernStepSequencer extends StatelessWidget {
  final List<Track> tracks;
  final int currentStep;
  final void Function(int trackIndex, int stepIndex) onStepToggle;
  final void Function(int trackIndex) onTrackMute;
  final void Function(int trackIndex, double volume) onTrackVolume;

  const ModernStepSequencer({
    super.key,
    required this.tracks,
    required this.currentStep,
    required this.onStepToggle,
    required this.onTrackMute,
    required this.onTrackVolume,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.modernPanelDecoration(borderRadius: 16),
      child: Column(
        children: [
          // Step numbers header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLightColor.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.borderColor.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 120),
                ...List.generate(16, (index) {
                  final isCurrentStep = index == currentStep;
                  final isBeat = index % 4 == 0;
                  return Expanded(
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 24,
                        height: 24,
                        decoration: AppTheme.ledDecoration(
                          isOn: isCurrentStep,
                          color: isBeat ? AppTheme.primaryColor : AppTheme.accentColor,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: isCurrentStep ? Colors.white : AppTheme.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          // Track rows
          Expanded(
            child: ListView.builder(
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                final track = tracks[index];
                return Container(
                  height: 72,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppTheme.borderColor.withValues(alpha: 0.15),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: ModernTrackHeader(
                          track: track,
                          onMute: () => onTrackMute(index),
                          onVolumeChanged: (v) => onTrackVolume(index, v),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: List.generate(16, (stepIndex) {
                            final isActive = track.steps[stepIndex];
                            final isCurrentStep = stepIndex == currentStep;
                            final isBeat = stepIndex % 4 == 0;

                            return Expanded(
                              child: ModernStep(
                                isActive: isActive,
                                isCurrentStep: isCurrentStep,
                                isBeat: isBeat,
                                activeColor: Color(track.color),
                                onTap: () => onStepToggle(index, stepIndex),
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
