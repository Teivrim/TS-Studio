import 'package:flutter/material.dart';
import '../models/synth_preset.dart';
import '../services/synth_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';
import 'modern_panel.dart';

class SynthScreen extends StatefulWidget {
  final SynthPreset? initialPreset;
  final ValueChanged<SynthPreset>? onPresetSelected;

  const SynthScreen({
    super.key,
    this.initialPreset,
    this.onPresetSelected,
  });

  @override
  State<SynthScreen> createState() => _SynthScreenState();
}

class _SynthScreenState extends State<SynthScreen> {
  late SynthPreset _preset;
  final List<SynthPreset> _presets = SynthService.getPresets();

  @override
  void initState() {
    super.initState();
    _preset = widget.initialPreset ?? _presets.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'SYNTHESIZER',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
        actions: [
          ModernButton(
            icon: Icons.save_rounded,
            onPressed: _savePreset,
            width: 44,
            height: 44,
          ),
        ],
      ),
      body: Column(
        children: [
          // Preset selector
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _presets.map((preset) {
                  final isSelected = preset.id == _preset.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => _preset = preset),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: AppTheme.modernButtonDecoration(
                          color: isSelected
                              ? AppTheme.primaryColor.withValues(alpha: 0.2)
                              : AppTheme.surfaceLightColor,
                          isPrimary: isSelected,
                          borderRadius: 12,
                        ),
                        child: Text(
                          preset.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Controls
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Oscillators
                ModernPanel(
                  title: 'OSCILLATORS',
                  child: Column(
                    children: [
                      _SynthSlider(
                        label: 'OSC 1 FREQ',
                        value: _preset.oscillator1Freq,
                        min: 20,
                        max: 2000,
                        onChanged: (v) {
                          setState(() {
                            _preset = _preset.copyWith(oscillator1Freq: v);
                          });
                        },
                        displayValue: '${_preset.oscillator1Freq.round()} Hz',
                      ),
                      _SynthSlider(
                        label: 'OSC 2 FREQ',
                        value: _preset.oscillator2Freq,
                        min: 20,
                        max: 2000,
                        onChanged: (v) {
                          setState(() {
                            _preset = _preset.copyWith(oscillator2Freq: v);
                          });
                        },
                        displayValue: '${_preset.oscillator2Freq.round()} Hz',
                      ),
                      _SynthSlider(
                        label: 'DETUNE',
                        value: _preset.oscillator1Detune,
                        min: -100,
                        max: 100,
                        onChanged: (v) {
                          setState(() {
                            _preset = _preset.copyWith(oscillator1Detune: v);
                          });
                        },
                        displayValue: '${_preset.oscillator1Detune.round()} cents',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Filter
                ModernPanel(
                  title: 'FILTER',
                  child: Column(
                    children: [
                      _SynthSlider(
                        label: 'CUTOFF',
                        value: _preset.filterCutoff,
                        min: 20,
                        max: 20000,
                        onChanged: (v) {
                          setState(() {
                            _preset = _preset.copyWith(filterCutoff: v);
                          });
                        },
                        displayValue: '${_preset.filterCutoff.round()} Hz',
                      ),
                      _SynthSlider(
                        label: 'RESONANCE',
                        value: _preset.filterResonance,
                        min: 0,
                        max: 1,
                        onChanged: (v) {
                          setState(() {
                            _preset = _preset.copyWith(filterResonance: v);
                          });
                        },
                        displayValue: '${(_preset.filterResonance * 100).round()}%',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Envelope
                ModernPanel(
                  title: 'ENVELOPE',
                  child: Column(
                    children: [
                      _SynthSlider(
                        label: 'ATTACK',
                        value: _preset.attack,
                        min: 0.001,
                        max: 2,
                        onChanged: (v) {
                          setState(() {
                            _preset = _preset.copyWith(attack: v);
                          });
                        },
                        displayValue: '${(_preset.attack * 1000).round()} ms',
                      ),
                      _SynthSlider(
                        label: 'DECAY',
                        value: _preset.decay,
                        min: 0.001,
                        max: 2,
                        onChanged: (v) {
                          setState(() {
                            _preset = _preset.copyWith(decay: v);
                          });
                        },
                        displayValue: '${(_preset.decay * 1000).round()} ms',
                      ),
                      _SynthSlider(
                        label: 'SUSTAIN',
                        value: _preset.sustain,
                        min: 0,
                        max: 1,
                        onChanged: (v) {
                          setState(() {
                            _preset = _preset.copyWith(sustain: v);
                          });
                        },
                        displayValue: '${(_preset.sustain * 100).round()}%',
                      ),
                      _SynthSlider(
                        label: 'RELEASE',
                        value: _preset.release,
                        min: 0.001,
                        max: 2,
                        onChanged: (v) {
                          setState(() {
                            _preset = _preset.copyWith(release: v);
                          });
                        },
                        displayValue: '${(_preset.release * 1000).round()} ms',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Volume
                ModernPanel(
                  title: 'OUTPUT',
                  child: _SynthSlider(
                    label: 'VOLUME',
                    value: _preset.volume,
                    min: 0,
                    max: 1,
                    onChanged: (v) {
                      setState(() {
                        _preset = _preset.copyWith(volume: v);
                      });
                    },
                    displayValue: '${(_preset.volume * 100).round()}%',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _savePreset() {
    widget.onPresetSelected?.call(_preset);
    Navigator.of(context).pop();
  }
}

class _SynthSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final String displayValue;

  const _SynthSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.displayValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
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
            flex: 3,
            child: Slider(
              value: value,
              min: min,
              max: max,
              activeColor: AppTheme.primaryColor,
              inactiveColor: AppTheme.gridColor,
              onChanged: onChanged,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              displayValue,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.accentColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
