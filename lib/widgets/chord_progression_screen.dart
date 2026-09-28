import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';
import 'modern_panel.dart';

class ChordProgressionScreen extends StatefulWidget {
  final ValueChanged<List<String>>? onProgressionSelected;

  const ChordProgressionScreen({super.key, this.onProgressionSelected});

  @override
  State<ChordProgressionScreen> createState() => _ChordProgressionScreenState();
}

class _ChordProgressionScreenState extends State<ChordProgressionScreen> {
  final List<String> _chords = [];
  final List<String> _availableChords = [
    'C', 'Cm', 'C#', 'C#m', 'D', 'Dm', 'D#', 'D#m',
    'E', 'Em', 'F', 'Fm', 'F#', 'F#m', 'G', 'Gm',
    'G#', 'G#m', 'A', 'Am', 'A#', 'A#m', 'B', 'Bm',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'CHORD PROGRESSIONS',
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
            icon: Icons.clear_all_rounded,
            onPressed: () => setState(() => _chords.clear()),
            width: 44,
            height: 44,
          ),
          ModernButton(
            icon: Icons.check_rounded,
            onPressed: () {
              widget.onProgressionSelected?.call(_chords);
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
          // Current progression
          Container(
            padding: const EdgeInsets.all(16),
            child: ModernPanel(
              title: 'PROGRESSION',
              child: _chords.isEmpty
                  ? const Text(
                      'Добавьте аккорды',
                      style: TextStyle(color: AppTheme.textSecondary),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _chords.asMap().entries.map((entry) {
                        final index = entry.key;
                        final chord = entry.value;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _chords.removeAt(index);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: AppTheme.modernButtonDecoration(
                              color: AppTheme.primaryColor.withValues(alpha: 0.2),
                              borderRadius: 12,
                            ),
                            child: Text(
                              chord,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ),
          // Chord grid
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'MAJOR',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableChords
                      .where((c) => !c.endsWith('m'))
                      .map((chord) => _ChordButton(
                            chord: chord,
                            onTap: () {
                              setState(() {
                                _chords.add(chord);
                              });
                            },
                          ))
                      .toList(),
                ),
                const SizedBox(height: 24),
                const Text(
                  'MINOR',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableChords
                      .where((c) => c.endsWith('m'))
                      .map((chord) => _ChordButton(
                            chord: chord,
                            onTap: () {
                              setState(() {
                                _chords.add(chord);
                              });
                            },
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChordButton extends StatelessWidget {
  final String chord;
  final VoidCallback onTap;

  const _ChordButton({required this.chord, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: AppTheme.modernButtonDecoration(
          color: AppTheme.surfaceLightColor,
          borderRadius: 12,
        ),
        child: Center(
          child: Text(
            chord,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
