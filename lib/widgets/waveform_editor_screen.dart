import 'package:flutter/material.dart';
import '../services/waveform_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';
import 'modern_panel.dart';
import 'waveform_editor.dart';

class WaveformEditorScreen extends StatefulWidget {
  const WaveformEditorScreen({super.key});

  @override
  State<WaveformEditorScreen> createState() => _WaveformEditorScreenState();
}

class _WaveformEditorScreenState extends State<WaveformEditorScreen> {
  List<double> _samples = WaveformService.generateSineWave();
  String _selectedWave = 'Sine';

  final Map<String, List<double> Function()> _waveGenerators = {
    'Sine': () => WaveformService.generateSineWave(),
    'Square': () => WaveformService.generateSquareWave(),
    'Sawtooth': () => WaveformService.generateSawtoothWave(),
    'Triangle': () => WaveformService.generateTriangleWave(),
    'Noise': () => WaveformService.generateNoise(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'WAVEFORM EDITOR',
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
            onPressed: _saveWaveform,
            width: 44,
            height: 44,
          ),
        ],
      ),
      body: Column(
        children: [
          // Wave type selector
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _waveGenerators.keys.map((name) {
                  final isSelected = name == _selectedWave;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedWave = name;
                          _samples = _waveGenerators[name]!();
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: AppTheme.modernButtonDecoration(
                          color: isSelected
                              ? AppTheme.primaryColor.withValues(alpha: 0.2)
                              : AppTheme.surfaceLightColor,
                          isPrimary: isSelected,
                          borderRadius: 12,
                        ),
                        child: Text(
                          name,
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
          // Waveform editor
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: WaveformEditor(
                samples: _samples,
                onSamplesChanged: (samples) {
                  setState(() => _samples = samples);
                },
                height: 200,
              ),
            ),
          ),
          // Controls
          Container(
            padding: const EdgeInsets.all(16),
            child: ModernPanel(
              title: 'ENVELOPE',
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'ATTACK',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textSecondary,
                          letterSpacing: 1,
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: 0.1,
                          min: 0.01,
                          max: 0.5,
                          activeColor: AppTheme.primaryColor,
                          inactiveColor: AppTheme.gridColor,
                          onChanged: (v) {
                            setState(() {
                              _samples = WaveformService.applyEnvelope(_samples, attack: v);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'RELEASE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textSecondary,
                          letterSpacing: 1,
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: 0.1,
                          min: 0.01,
                          max: 0.5,
                          activeColor: AppTheme.primaryColor,
                          inactiveColor: AppTheme.gridColor,
                          onChanged: (v) {
                            setState(() {
                              _samples = WaveformService.applyEnvelope(_samples, release: v);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveWaveform() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Waveform saved')),
    );
    Navigator.of(context).pop();
  }
}
