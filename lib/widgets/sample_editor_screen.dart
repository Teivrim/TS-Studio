import 'package:flutter/material.dart';
import '../services/sample_editor_service.dart';
import '../services/waveform_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';
import 'modern_panel.dart';
import 'waveform_display.dart';

class SampleEditorScreen extends StatefulWidget {
  const SampleEditorScreen({super.key});

  @override
  State<SampleEditorScreen> createState() => _SampleEditorScreenState();
}

class _SampleEditorScreenState extends State<SampleEditorScreen> {
  List<double> _samples = WaveformService.generateSineWave();
  final List<double> _originalSamples = WaveformService.generateSineWave();

  void _applyEdit(List<double> Function(List<double>) edit) {
    setState(() {
      _samples = edit(_samples);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'SAMPLE EDITOR',
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
            onPressed: _saveSample,
            width: 44,
            height: 44,
          ),
          const SizedBox(width: 8),
          ModernButton(
            icon: Icons.refresh_rounded,
            onPressed: () {
              setState(() {
                _samples = List.from(_originalSamples);
              });
            },
            width: 44,
            height: 44,
          ),
        ],
      ),
      body: Column(
        children: [
          // Waveform display
          Container(
            padding: const EdgeInsets.all(16),
            child: WaveformDisplay(
              samples: _samples,
              height: 150,
            ),
          ),
          // Edit controls
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ModernPanel(
                  title: 'BASIC EDITS',
                  child: Column(
                    children: [
                      _EditButton(
                        label: 'Normalize',
                        onPressed: () => _applyEdit(SampleEditorService.normalize),
                      ),
                      _EditButton(
                        label: 'Reverse',
                        onPressed: () => _applyEdit(SampleEditorService.reverse),
                      ),
                      _EditButton(
                        label: 'Fade In',
                        onPressed: () => _applyEdit((s) => SampleEditorService.fadeIn(s, 0.1)),
                      ),
                      _EditButton(
                        label: 'Fade Out',
                        onPressed: () => _applyEdit((s) => SampleEditorService.fadeOut(s, 0.1)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ModernPanel(
                  title: 'PITCH & TIME',
                  child: Column(
                    children: [
                      _EditButton(
                        label: 'Pitch +1',
                        onPressed: () => _applyEdit((s) => SampleEditorService.pitchShift(s, 1)),
                      ),
                      _EditButton(
                        label: 'Pitch -1',
                        onPressed: () => _applyEdit((s) => SampleEditorService.pitchShift(s, -1)),
                      ),
                      _EditButton(
                        label: 'Time Stretch 1.5x',
                        onPressed: () => _applyEdit((s) => SampleEditorService.timeStretch(s, 1.5)),
                      ),
                      _EditButton(
                        label: 'Time Stretch 0.5x',
                        onPressed: () => _applyEdit((s) => SampleEditorService.timeStretch(s, 0.5)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ModernPanel(
                  title: 'GAIN',
                  child: Column(
                    children: [
                      _EditButton(
                        label: 'Gain +6dB',
                        onPressed: () => _applyEdit((s) => SampleEditorService.applyGain(s, 2.0)),
                      ),
                      _EditButton(
                        label: 'Gain -6dB',
                        onPressed: () => _applyEdit((s) => SampleEditorService.applyGain(s, 0.5)),
                      ),
                      _EditButton(
                        label: 'Gain +12dB',
                        onPressed: () => _applyEdit((s) => SampleEditorService.applyGain(s, 4.0)),
                      ),
                      _EditButton(
                        label: 'Gain -12dB',
                        onPressed: () => _applyEdit((s) => SampleEditorService.applyGain(s, 0.25)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _saveSample() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sample saved')),
    );
    Navigator.of(context).pop();
  }
}

class _EditButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _EditButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ModernButton(
        text: label,
        onPressed: onPressed,
        width: double.infinity,
        height: 48,
      ),
    );
  }
}
