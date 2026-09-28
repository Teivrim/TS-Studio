import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'fl_panel.dart';
import 'fl_slider.dart';

class FLEffectsPanel extends StatelessWidget {
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

  const FLEffectsPanel({
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
    return FLPanel(
      title: 'EFFECTS',
      child: Column(
        children: [
          // Master Volume
          FLSlider(
            label: 'MASTER',
            value: masterVolume,
            onChanged: onMasterVolumeChanged,
            activeColor: AppTheme.accentColor,
          ),
          const SizedBox(height: 8),
          // EQ Section
          const Text('EQUALIZER', style: TextStyle(fontSize: 9, color: AppTheme.textSecondary, letterSpacing: 1)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: FLSlider(
                  label: 'LOW',
                  value: eqLow,
                  onChanged: onEqLowChanged,
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              Expanded(
                child: FLSlider(
                  label: 'MID',
                  value: eqMid,
                  onChanged: onEqMidChanged,
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              Expanded(
                child: FLSlider(
                  label: 'HIGH',
                  value: eqHigh,
                  onChanged: onEqHighChanged,
                  activeColor: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Reverb & Delay
          const Text('REVERB & DELAY', style: TextStyle(fontSize: 9, color: AppTheme.textSecondary, letterSpacing: 1)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: FLSlider(
                  label: 'REVERB',
                  value: reverbMix,
                  onChanged: onReverbMixChanged,
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              Expanded(
                child: FLSlider(
                  label: 'DELAY',
                  value: delayMix,
                  onChanged: onDelayMixChanged,
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              Expanded(
                child: FLSlider(
                  label: 'TIME',
                  value: delayTime,
                  onChanged: onDelayTimeChanged,
                  activeColor: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Distortion, Chorus, Filter
          const Text('DISTORTION & CHORUS', style: TextStyle(fontSize: 9, color: AppTheme.textSecondary, letterSpacing: 1)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: FLSlider(
                  label: 'DISTORT',
                  value: distortion,
                  onChanged: onDistortionChanged,
                  activeColor: AppTheme.dangerColor,
                ),
              ),
              Expanded(
                child: FLSlider(
                  label: 'CHORUS',
                  value: chorus,
                  onChanged: onChorusChanged,
                  activeColor: AppTheme.successColor,
                ),
              ),
              Expanded(
                child: FLSlider(
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
