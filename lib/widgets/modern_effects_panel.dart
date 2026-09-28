import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'modern_panel.dart';
import 'modern_slider.dart';

class ModernEffectsPanel extends StatelessWidget {
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

  const ModernEffectsPanel({
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
    return ModernPanel(
      title: 'EFFECTS',
      borderRadius: 16,
      child: Column(
        children: [
          // Master Volume
          ModernSlider(
            label: 'MASTER',
            value: masterVolume,
            onChanged: onMasterVolumeChanged,
            activeColor: AppTheme.accentColor,
          ),
          const SizedBox(height: 12),
          // EQ Section
          const Text(
            'EQUALIZER',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ModernSlider(
                  label: 'LOW',
                  value: eqLow,
                  onChanged: onEqLowChanged,
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              Expanded(
                child: ModernSlider(
                  label: 'MID',
                  value: eqMid,
                  onChanged: onEqMidChanged,
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              Expanded(
                child: ModernSlider(
                  label: 'HIGH',
                  value: eqHigh,
                  onChanged: onEqHighChanged,
                  activeColor: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Reverb & Delay
          const Text(
            'REVERB & DELAY',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ModernSlider(
                  label: 'REVERB',
                  value: reverbMix,
                  onChanged: onReverbMixChanged,
                  activeColor: AppTheme.secondaryColor,
                ),
              ),
              Expanded(
                child: ModernSlider(
                  label: 'DELAY',
                  value: delayMix,
                  onChanged: onDelayMixChanged,
                  activeColor: AppTheme.secondaryColor,
                ),
              ),
              Expanded(
                child: ModernSlider(
                  label: 'TIME',
                  value: delayTime,
                  onChanged: onDelayTimeChanged,
                  activeColor: AppTheme.secondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Distortion, Chorus, Filter
          const Text(
            'DISTORTION & CHORUS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ModernSlider(
                  label: 'DISTORT',
                  value: distortion,
                  onChanged: onDistortionChanged,
                  activeColor: AppTheme.dangerColor,
                ),
              ),
              Expanded(
                child: ModernSlider(
                  label: 'CHORUS',
                  value: chorus,
                  onChanged: onChorusChanged,
                  activeColor: AppTheme.successColor,
                ),
              ),
              Expanded(
                child: ModernSlider(
                  label: 'FILTER',
                  value: filterCutoff,
                  onChanged: onFilterCutoffChanged,
                  activeColor: AppTheme.warningColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
