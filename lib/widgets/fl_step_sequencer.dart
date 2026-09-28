import 'package:flutter/material.dart';
import '../models/track.dart';
import '../theme/app_theme.dart';
import 'fl_step.dart';
import 'fl_track_header.dart';

class FLStepSequencer extends StatelessWidget {
  final List<Track> tracks;
  final int currentStep;
  final void Function(int trackIndex, int stepIndex) onStepToggle;
  final void Function(int trackIndex) onTrackMute;
  final void Function(int trackIndex, double volume) onTrackVolume;

  const FLStepSequencer({
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
      decoration: AppTheme.flPanelDecoration(),
      child: Column(
        children: [
          // Step numbers header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: const BoxDecoration(
              color: AppTheme.buttonColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
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
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: AppTheme.flLedDecoration(
                          isOn: isCurrentStep,
                          color: isBeat ? AppTheme.primaryColor : AppTheme.accentColor,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: isCurrentStep ? Colors.black : AppTheme.textSecondary,
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
                  height: 64,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppTheme.borderColor.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: FLTrackHeader(
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
                              child: FLStep(
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
