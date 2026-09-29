import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';
import 'modern_panel.dart';

class PatternGeneratorScreen extends StatefulWidget {
  final ValueChanged<List<List<bool>>> onPatternGenerated;

  const PatternGeneratorScreen({super.key, required this.onPatternGenerated});

  @override
  State<PatternGeneratorScreen> createState() => _PatternGeneratorScreenState();
}

class _PatternGeneratorScreenState extends State<PatternGeneratorScreen> {
  double _density = 0.3;
  double _complexity = 0.5;
  double _syncopation = 0.3;
  final Random _random = Random();

  List<List<bool>> _generatePattern() {
    final tracks = 4;
    final steps = 16;
    final pattern = List.generate(tracks, (_) => List<bool>.filled(steps, false));

    for (int track = 0; track < tracks; track++) {
      for (int step = 0; step < steps; step++) {
        final isBeat = step % 4 == 0;
        final isOffBeat = step % 2 == 1;

        double probability = _density;

        if (isBeat) {
          probability += 0.3;
        }

        if (isOffBeat) {
          probability += _syncopation * 0.2;
        }

        probability += _complexity * 0.1 * _random.nextDouble();

        pattern[track][step] = _random.nextDouble() < probability;
      }
    }

    return pattern;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'PATTERN GENERATOR',
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
            icon: Icons.check_rounded,
            onPressed: () {
              widget.onPatternGenerated(_generatePattern());
              Navigator.of(context).pop();
            },
            width: 44,
            height: 44,
            isPrimary: true,
          ),
        ],
      ),
      body: Column(
        children: [
          // Controls
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _GeneratorSlider(
                  label: 'DENSITY',
                  value: _density,
                  onChanged: (v) => setState(() => _density = v),
                ),
                const SizedBox(height: 16),
                _GeneratorSlider(
                  label: 'COMPLEXITY',
                  value: _complexity,
                  onChanged: (v) => setState(() => _complexity = v),
                ),
                const SizedBox(height: 16),
                _GeneratorSlider(
                  label: 'SYNCOPATION',
                  value: _syncopation,
                  onChanged: (v) => setState(() => _syncopation = v),
                ),
              ],
            ),
          ),
          // Preview
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: ModernPanel(
                title: 'PREVIEW',
                child: _buildPreview(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    final pattern = _generatePattern();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pattern.map((track) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: track.map((step) {
              return Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: step ? AppTheme.primaryColor : AppTheme.gridColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _GeneratorSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const _GeneratorSlider({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
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
            divisions: 100,
            activeColor: AppTheme.primaryColor,
            inactiveColor: AppTheme.gridColor,
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 50,
          child: Text(
            '${(value * 100).round()}%',
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
