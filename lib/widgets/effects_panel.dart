import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EffectsPanel extends StatelessWidget {
  final double masterVolume;
  final double reverbMix;
  final double delayMix;
  final double delayTime;
  final double eqLow;
  final double eqMid;
  final double eqHigh;
  final double distortion;
  final double chorus;
  final double filterCutoff;
  final ValueChanged<double> onMasterVolumeChanged;
  final ValueChanged<double> onReverbMixChanged;
  final ValueChanged<double> onDelayMixChanged;
  final ValueChanged<double> onDelayTimeChanged;
  final ValueChanged<double> onEqLowChanged;
  final ValueChanged<double> onEqMidChanged;
  final ValueChanged<double> onEqHighChanged;
  final ValueChanged<double> onDistortionChanged;
  final ValueChanged<double> onChorusChanged;
  final ValueChanged<double> onFilterCutoffChanged;

  const EffectsPanel({
    super.key,
    required this.masterVolume,
    required this.reverbMix,
    required this.delayMix,
    required this.delayTime,
    required this.eqLow,
    required this.eqMid,
    required this.eqHigh,
    required this.distortion,
    required this.chorus,
    required this.filterCutoff,
    required this.onMasterVolumeChanged,
    required this.onReverbMixChanged,
    required this.onDelayMixChanged,
    required this.onDelayTimeChanged,
    required this.onEqLowChanged,
    required this.onEqMidChanged,
    required this.onEqHighChanged,
    required this.onDistortionChanged,
    required this.onChorusChanged,
    required this.onFilterCutoffChanged,
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
          // Master Volume
          _SliderRow(
            icon: Icons.volume_up,
            label: 'Master',
            value: masterVolume,
            onChanged: onMasterVolumeChanged,
            color: AppTheme.accentColor,
          ),
          // EQ Section
          const SizedBox(height: 8),
          const Text('EQ', style: TextStyle(fontSize: 10, color: Colors.white54, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(child: _SliderRow(icon: Icons.waves, label: 'Low', value: eqLow, onChanged: onEqLowChanged, color: AppTheme.primaryColor)),
              Expanded(child: _SliderRow(icon: Icons.waves, label: 'Mid', value: eqMid, onChanged: onEqMidChanged, color: AppTheme.primaryColor)),
              Expanded(child: _SliderRow(icon: Icons.waves, label: 'High', value: eqHigh, onChanged: onEqHighChanged, color: AppTheme.primaryColor)),
            ],
          ),
          // Reverb & Delay
          const SizedBox(height: 8),
          const Text('FX', style: TextStyle(fontSize: 10, color: Colors.white54, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(child: _SliderRow(icon: Icons.water, label: 'Reverb', value: reverbMix, onChanged: onReverbMixChanged, color: AppTheme.primaryColor)),
              Expanded(child: _SliderRow(icon: Icons.timer, label: 'Delay', value: delayMix, onChanged: onDelayMixChanged, color: AppTheme.primaryColor)),
              Expanded(child: _SliderRow(icon: Icons.timer_outlined, label: 'Time', value: delayTime, onChanged: onDelayTimeChanged, color: AppTheme.primaryColor)),
            ],
          ),
          // Distortion, Chorus, Filter
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _SliderRow(icon: Icons.broken_image, label: 'Distort', value: distortion, onChanged: onDistortionChanged, color: AppTheme.dangerColor)),
              Expanded(child: _SliderRow(icon: Icons.auto_awesome, label: 'Chorus', value: chorus, onChanged: onChorusChanged, color: AppTheme.successColor)),
              Expanded(child: _SliderRow(icon: Icons.filter_alt, label: 'Filter', value: filterCutoff, onChanged: onFilterCutoffChanged, color: AppTheme.warningColor)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final Color color;

  const _SliderRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: Colors.white54),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(fontSize: 9, color: Colors.white54)),
              const Spacer(),
              Text('${(value * 100).round()}%', style: const TextStyle(fontSize: 8, color: Colors.white38)),
            ],
          ),
          Slider(
            value: value,
            min: 0,
            max: 1,
            activeColor: color,
            inactiveColor: AppTheme.gridColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
