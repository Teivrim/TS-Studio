import 'package:flutter/material.dart';
import '../models/track.dart';
import '../theme/app_theme.dart';
import 'track_header.dart';

class StepSequencer extends StatelessWidget {
  final List<Track> tracks;
  final int currentStep;
  final void Function(int trackIndex, int stepIndex) onStepToggle;
  final void Function(int trackIndex) onTrackMute;

  const StepSequencer({
    super.key,
    required this.tracks,
    required this.currentStep,
    required this.onStepToggle,
    required this.onTrackMute,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Step numbers header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              const SizedBox(width: 120), // Space for track headers
              ...List.generate(16, (index) {
                final isCurrentStep = index == currentStep;
                final isBeat = index % 4 == 0;
                return Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: isCurrentStep
                            ? AppTheme.playheadColor.withOpacity(0.3)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 10,
                          color: isCurrentStep
                              ? AppTheme.playheadColor
                              : isBeat
                                  ? Colors.white70
                                  : Colors.white30,
                          fontWeight: isBeat ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        const Divider(height: 1),
        // Track rows
        Expanded(
          child: ListView.builder(
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              final track = tracks[index];
              return _TrackRow(
                track: track,
                trackIndex: index,
                currentStep: currentStep,
                onStepToggle: onStepToggle,
                onTrackMute: onTrackMute,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TrackRow extends StatelessWidget {
  final Track track;
  final int trackIndex;
  final int currentStep;
  final void Function(int trackIndex, int stepIndex) onStepToggle;
  final void Function(int trackIndex) onTrackMute;

  const _TrackRow({
    required this.track,
    required this.trackIndex,
    required this.currentStep,
    required this.onStepToggle,
    required this.onTrackMute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.gridColor, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Track header
          SizedBox(
            width: 120,
            child: TrackHeader(
              track: track,
              onMute: () => onTrackMute(trackIndex),
            ),
          ),
          // Steps
          Expanded(
            child: Row(
              children: List.generate(16, (stepIndex) {
                final isActive = track.steps[stepIndex];
                final isCurrentStep = stepIndex == currentStep;
                final isBeat = stepIndex % 4 == 0;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onStepToggle(trackIndex, stepIndex),
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Color(track.color)
                            : isCurrentStep
                                ? AppTheme.playheadColor.withOpacity(0.15)
                                : isBeat
                                    ? AppTheme.inactiveStepColor
                                    : AppTheme.gridColor,
                        borderRadius: BorderRadius.circular(4),
                        border: isCurrentStep
                            ? Border.all(
                                color: AppTheme.playheadColor,
                                width: 2,
                              )
                            : null,
                      ),
                      child: isActive
                          ? Center(
                              child: Icon(
                                Icons.circle,
                                size: 8,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            )
                          : null,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
