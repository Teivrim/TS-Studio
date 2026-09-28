import 'package:flutter/material.dart';
import '../models/track.dart';
import '../theme/app_theme.dart';

class ModernTrackHeader extends StatelessWidget {
  final Track track;
  final VoidCallback onMute;
  final ValueChanged<double> onVolumeChanged;

  const ModernTrackHeader({
    super.key,
    required this.track,
    required this.onMute,
    required this.onVolumeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: track.muted
            ? AppTheme.surfaceColor.withValues(alpha: 0.5)
            : AppTheme.surfaceColor,
        border: Border(
          right: BorderSide(
            color: AppTheme.borderColor.withValues(alpha: 0.2),
          ),
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
                height: 36,
                decoration: BoxDecoration(
                  color: Color(track.color),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: Color(track.color).withValues(alpha: 0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  track.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: track.muted ? AppTheme.textMuted : AppTheme.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Volume slider
          SizedBox(
            height: 24,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
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
          const SizedBox(height: 6),
          // Mute button
          GestureDetector(
            onTap: onMute,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: AppTheme.modernButtonDecoration(
                color: track.muted
                    ? AppTheme.dangerColor.withValues(alpha: 0.2)
                    : AppTheme.surfaceLightColor,
                isPrimary: track.muted,
                borderRadius: 8,
              ),
              child: Text(
                track.muted ? 'MUTED' : 'MUTE',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: track.muted ? AppTheme.dangerColor : AppTheme.textSecondary,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
