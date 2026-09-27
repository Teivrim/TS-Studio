import 'package:flutter/material.dart';
import '../models/track.dart';
import '../theme/app_theme.dart';

class TrackHeader extends StatelessWidget {
  final Track track;
  final VoidCallback onMute;

  const TrackHeader({
    super.key,
    required this.track,
    required this.onMute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          // Color indicator
          Container(
            width: 4,
            height: 32,
            decoration: BoxDecoration(
              color: Color(track.color),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          // Track name
          Expanded(
            child: Text(
              track.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: track.muted ? Colors.white38 : Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Mute button
          GestureDetector(
            onTap: onMute,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: track.muted
                    ? Colors.red.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                track.muted ? Icons.volume_off : Icons.volume_up,
                size: 16,
                color: track.muted ? Colors.red : Colors.white54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
