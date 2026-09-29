import 'dart:math';
import 'package:flutter/material.dart';
import '../services/synth_engine_service.dart';
import '../theme/app_theme.dart';

class SynthKeyboard extends StatefulWidget {
  final SynthEngineService synthService;

  const SynthKeyboard({super.key, required this.synthService});

  @override
  State<SynthKeyboard> createState() => _SynthKeyboardState();
}

class _SynthKeyboardState extends State<SynthKeyboard> {
  final List<String> _notes = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
  final List<int> _octaves = [2, 3, 4, 5];
  int _selectedOctave = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'SYNTH KEYBOARD',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: AppTheme.modernButtonDecoration(
              color: AppTheme.surfaceLightColor,
              borderRadius: 12,
            ),
            child: DropdownButton<int>(
              value: _selectedOctave,
              dropdownColor: AppTheme.surfaceColor,
              underline: const SizedBox(),
              style: const TextStyle(color: AppTheme.textPrimary),
              items: _octaves.map((octave) {
                return DropdownMenuItem(
                  value: octave,
                  child: Text('Oct $octave'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedOctave = value);
                }
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'FREQUENCY',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textSecondary,
                          letterSpacing: 1,
                        ),
                      ),
                      Slider(
                        value: widget.synthService.frequency,
                        min: 20,
                        max: 20000,
                        activeColor: AppTheme.primaryColor,
                        inactiveColor: AppTheme.gridColor,
                        onChanged: (value) {
                          widget.synthService.setFrequency(value);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AMPLITUDE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textSecondary,
                          letterSpacing: 1,
                        ),
                      ),
                      Slider(
                        value: widget.synthService.amplitude,
                        min: 0,
                        max: 1,
                        activeColor: AppTheme.primaryColor,
                        inactiveColor: AppTheme.gridColor,
                        onChanged: (value) {
                          widget.synthService.setAmplitude(value);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['sine', 'square', 'sawtooth', 'triangle'].map((wave) {
                final isSelected = widget.synthService.waveform == wave;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () {
                        widget.synthService.setWaveform(wave);
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: AppTheme.modernButtonDecoration(
                          color: isSelected
                              ? AppTheme.primaryColor.withValues(alpha: 0.2)
                              : AppTheme.surfaceLightColor,
                          isPrimary: isSelected,
                          borderRadius: 12,
                        ),
                        child: Center(
                          child: Text(
                            wave,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: _notes.map((note) {
                  final isBlack = note.contains('#');
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        final noteIndex = _notes.indexOf(note);
                        final freq = 440.0 * pow(2, (noteIndex - 9) / 12) * pow(2, _selectedOctave - 4);
                        widget.synthService.setFrequency(freq);
                        setState(() {});
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: isBlack ? AppTheme.backgroundColor : AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.borderColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            note,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isBlack ? AppTheme.textSecondary : AppTheme.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
