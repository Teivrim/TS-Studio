import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';

class ModernTransport extends StatelessWidget {
  final bool isPlaying;
  final int bpm;
  final VoidCallback onPlayPause;
  final VoidCallback onStop;
  final ValueChanged<int> onBpmChanged;
  final bool isRecording;
  final VoidCallback onRecordToggle;

  const ModernTransport({
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderColor.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          // Play button
          ModernButton(
            icon: isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: isPlaying ? AppTheme.primaryColor : null,
            isPrimary: true,
            onPressed: onPlayPause,
            width: 64,
            height: 64,
            borderRadius: 16,
          ),
          const SizedBox(width: 16),
          // Stop button
          ModernButton(
            icon: Icons.stop_rounded,
            onPressed: onStop,
            width: 52,
            height: 52,
            borderRadius: 14,
          ),
          const SizedBox(width: 12),
          // Record button
          ModernButton(
            icon: isRecording ? Icons.stop_circle : Icons.fiber_manual_record,
            color: isRecording ? AppTheme.dangerColor : null,
            isActive: isRecording,
            onPressed: onRecordToggle,
            width: 52,
            height: 52,
            borderRadius: 14,
          ),
          const SizedBox(width: 32),
          // BPM control
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.speed_rounded, size: 20, color: AppTheme.textSecondary),
                const SizedBox(width: 12),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: AppTheme.modernButtonDecoration(
                    color: AppTheme.surfaceLightColor,
                    borderRadius: 12,
                  ),
                  child: Text(
                    '$bpm BPM',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.accentColor,
                      letterSpacing: 0.5,
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
