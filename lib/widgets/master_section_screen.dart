import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'modern_panel.dart';

class MasterSectionScreen extends StatefulWidget {
  final double masterVolume;
  final double reverbMix;
  final double delayMix;
  final ValueChanged<double> onMasterVolumeChanged;
  final ValueChanged<double> onReverbMixChanged;
  final ValueChanged<double> onDelayMixChanged;

  const MasterSectionScreen({
    super.key,
    required this.masterVolume,
    required this.reverbMix,
    required this.delayMix,
    required this.onMasterVolumeChanged,
    required this.onReverbMixChanged,
    required this.onDelayMixChanged,
  });

  @override
  State<MasterSectionScreen> createState() => _MasterSectionScreenState();
}

class _MasterSectionScreenState extends State<MasterSectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'MASTER SECTION',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Master Volume
          ModernPanel(
            title: 'MASTER VOLUME',
            child: Column(
              children: [
                _MasterSlider(
                  label: 'VOLUME',
                  value: widget.masterVolume,
                  onChanged: widget.onMasterVolumeChanged,
                  displayValue: '${(widget.masterVolume * 100).round()}%',
                ),
                const SizedBox(height: 16),
                // Volume meter
                Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.gridColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor: widget.masterVolume,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.successColor,
                                AppTheme.warningColor,
                                AppTheme.dangerColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Reverb
          ModernPanel(
            title: 'REVERB',
            child: _MasterSlider(
              label: 'MIX',
              value: widget.reverbMix,
              onChanged: widget.onReverbMixChanged,
              displayValue: '${(widget.reverbMix * 100).round()}%',
            ),
          ),
          const SizedBox(height: 16),
          // Delay
          ModernPanel(
            title: 'DELAY',
            child: _MasterSlider(
              label: 'MIX',
              value: widget.delayMix,
              onChanged: widget.onDelayMixChanged,
              displayValue: '${(widget.delayMix * 100).round()}%',
            ),
          ),
        ],
      ),
    );
  }
}

class _MasterSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final String displayValue;

  const _MasterSlider({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.displayValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: 0,
            max: 1,
            activeColor: AppTheme.primaryColor,
            inactiveColor: AppTheme.gridColor,
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 60,
          child: Text(
            displayValue,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.accentColor,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
