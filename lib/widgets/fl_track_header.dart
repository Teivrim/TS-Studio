import 'package:flutter/material.dart';
import '../models/track.dart';
import '../theme/app_theme.dart';

class FLTrackHeader extends StatelessWidget {
  final Track track;
  final VoidCallback onMute;
  final ValueChanged<double> onVolumeChanged;

  const FLTrackHeader({
    super.key,
    required this.track,
    required this.onMute,
    required this.onVolumeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: track.muted ? AppTheme.gridColor.withValues(alpha: 0.5) : AppTheme.surfaceColor,
        border: Border(
          right: BorderSide(color: AppTheme.borderColor.withValues(alpha: 0.3)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Color indicator and name
          Row(
            children: [
              Container(
                width: 4,
                height: 32,
                decoration: BoxDecoration(
                  color: Color(track.color),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  track.name,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: track.muted ? AppTheme.textSecondary : AppTheme.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Volume slider
          SizedBox(
            height: 20,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                activeTrackColor: AppTheme.primaryColor,
                inactiveTrackColor: AppTheme.gridColor,
                thumbColor: AppTheme.primaryColor,
              ),
              child: Slider(
                value: track.volume,
                min: 0,
                max: 1,
                onChanged: onVolumeChanged,
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Mute button
          GestureDetector(
            onTap: onMute,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: AppTheme.flButtonDecoration(
                color: track.muted ? AppTheme.dangerColor.withValues(alpha: 0.3) : AppTheme.buttonColor,
                isPrimary: track.muted,
              ),
              child: Text(
                track.muted ? 'MUTED' : 'MUTE',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: track.muted ? AppTheme.dangerColor : AppTheme.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
