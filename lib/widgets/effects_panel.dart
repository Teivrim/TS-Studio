import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EffectsPanel extends StatelessWidget {
  final double masterVolume;
  final double reverbMix;
  final double delayMix;
  final double delayTime;
  final ValueChanged<double> onMasterVolumeChanged;
  final ValueChanged<double> onReverbMixChanged;
  final ValueChanged<double> onDelayMixChanged;
  final ValueChanged<double> onDelayTimeChanged;

  const EffectsPanel({
    super.key,
    required this.masterVolume,
    required this.reverbMix,
    required this.delayMix,
    required this.delayTime,
    required this.onMasterVolumeChanged,
    required this.onReverbMixChanged,
    required this.onDelayMixChanged,
    required this.onDelayTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          top: BorderSide(color: AppTheme.gridColor, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.volume_up, size: 16, color: Colors.white54),
              const SizedBox(width: 8),
              const Text('Master', style: TextStyle(fontSize: 11, color: Colors.white54)),
              Expanded(
                child: Slider(
                  value: masterVolume,
                  min: 0,
                  max: 1,
                  activeColor: AppTheme.accentColor,
                  inactiveColor: AppTheme.gridColor,
                  onChanged: onMasterVolumeChanged,
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '${(masterVolume * 100).round()}%',
                  style: const TextStyle(fontSize: 10, color: Colors.white54),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.waves, size: 16, color: Colors.white54),
              const SizedBox(width: 8),
              const Text('Reverb', style: TextStyle(fontSize: 11, color: Colors.white54)),
              Expanded(
                child: Slider(
                  value: reverbMix,
                  min: 0,
                  max: 1,
                  activeColor: AppTheme.primaryColor,
                  inactiveColor: AppTheme.gridColor,
                  onChanged: onReverbMixChanged,
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '${(reverbMix * 100).round()}%',
                  style: const TextStyle(fontSize: 10, color: Colors.white54),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.timer, size: 16, color: Colors.white54),
              const SizedBox(width: 8),
              const Text('Delay', style: TextStyle(fontSize: 11, color: Colors.white54)),
              Expanded(
                child: Slider(
                  value: delayMix,
                  min: 0,
                  max: 1,
                  activeColor: AppTheme.primaryColor,
                  inactiveColor: AppTheme.gridColor,
                  onChanged: onDelayMixChanged,
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '${(delayMix * 100).round()}%',
                  style: const TextStyle(fontSize: 10, color: Colors.white54),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.timer_outlined, size: 16, color: Colors.white54),
              const SizedBox(width: 8),
              const Text('Time', style: TextStyle(fontSize: 11, color: Colors.white54)),
              Expanded(
                child: Slider(
                  value: delayTime,
                  min: 0.1,
                  max: 1.0,
                  activeColor: AppTheme.primaryColor,
                  inactiveColor: AppTheme.gridColor,
                  onChanged: onDelayTimeChanged,
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '${(delayTime * 100).round()}%',
                  style: const TextStyle(fontSize: 10, color: Colors.white54),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
