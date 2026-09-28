import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'fl_button.dart';

class FLTransport extends StatelessWidget {
  final bool isPlaying;
  final int bpm;
  final VoidCallback onPlayPause;
  final VoidCallback onStop;
  final ValueChanged<int> onBpmChanged;
  final bool isRecording;
  final VoidCallback onRecordToggle;

  const FLTransport({
    super.key,
    required this.isPlaying,
    required this.bpm,
    required this.onPlayPause,
    required this.onStop,
    required this.onBpmChanged,
    required this.isRecording,
    required this.onRecordToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Play button
          FLButton(
            icon: isPlaying ? Icons.pause : Icons.play_arrow,
            color: isPlaying ? AppTheme.primaryColor : null,
            isPrimary: true,
            onPressed: onPlayPause,
            width: 56,
            height: 56,
          ),
          const SizedBox(width: 12),
          // Stop button
          FLButton(
            icon: Icons.stop,
            onPressed: onStop,
            width: 48,
            height: 48,
          ),
          const SizedBox(width: 12),
          // Record button
          FLButton(
            icon: isRecording ? Icons.stop_circle : Icons.fiber_manual_record,
            color: isRecording ? AppTheme.dangerColor : null,
            isActive: isRecording,
            onPressed: onRecordToggle,
            width: 48,
            height: 48,
          ),
          const SizedBox(width: 24),
          // BPM control
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.speed, size: 20, color: AppTheme.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                      activeTrackColor: AppTheme.primaryColor,
                      inactiveTrackColor: AppTheme.gridColor,
                      thumbColor: AppTheme.primaryColor,
                    ),
                    child: Slider(
                      value: bpm.toDouble(),
                      min: 60,
                      max: 200,
                      divisions: 140,
                      onChanged: (value) => onBpmChanged(value.round()),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: AppTheme.flButtonDecoration(
                    color: AppTheme.buttonColor,
                  ),
                  child: Text(
                    '$bpm BPM',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentColor,
                    ),
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
