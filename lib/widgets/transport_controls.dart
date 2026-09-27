import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TransportControls extends StatelessWidget {
  final bool isPlaying;
  final int bpm;
  final VoidCallback onPlayPause;
  final VoidCallback onStop;
  final ValueChanged<int> onBpmChanged;

  const TransportControls({
    super.key,
    required this.isPlaying,
    required this.bpm,
    required this.onPlayPause,
    required this.onStop,
    required this.onBpmChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          bottom: BorderSide(color: AppTheme.gridColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          _TransportButton(
            icon: isPlaying ? Icons.pause : Icons.play_arrow,
            color: AppTheme.accentColor,
            onPressed: onPlayPause,
            size: 48,
          ),
          const SizedBox(width: 12),
          _TransportButton(
            icon: Icons.stop,
            color: Colors.white70,
            onPressed: onStop,
            size: 40,
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.speed, size: 20, color: Colors.white54),
                const SizedBox(width: 8),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                    ),
                    child: Slider(
                      value: bpm.toDouble(),
                      min: 60,
                      max: 200,
                      divisions: 140,
                      activeColor: AppTheme.primaryColor,
                      inactiveColor: AppTheme.gridColor,
                      onChanged: (value) => onBpmChanged(value.round()),
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
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

class _TransportButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final double size;

  const _TransportButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: Icon(icon, color: color, size: size * 0.5),
      ),
    );
  }
}
