import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';
import 'modern_panel.dart';

class ChordLibraryScreen extends StatefulWidget {
  final ValueChanged<List<String>>? onProgressionSelected;

  const ChordLibraryScreen({super.key, this.onProgressionSelected});

  @override
  State<ChordLibraryScreen> createState() => _ChordLibraryScreenState();
}

class _ChordLibraryScreenState extends State<ChordLibraryScreen> {
  final List<String> _chords = [];

  final Map<String, List<String>> _progressions = {
    'Pop': ['C', 'G', 'Am', 'F'],
    'Jazz': ['Cmaj7', 'Dm7', 'G7', 'Cmaj7'],
    'Blues': ['C7', 'F7', 'C7', 'G7'],
    'Rock': ['E', 'A', 'E', 'B'],
    'Electronic': ['Am', 'F', 'C', 'G'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'CHORD LIBRARY',
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
                      'Выберите прогрессию или добавьте аккорды',
                      style: TextStyle(color: AppTheme.textSecondary),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _chords.map((chord) {
                        return Container(
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
                        );
                      }).toList(),
                    ),
            ),
          ),
          // Progression presets
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: _progressions.entries.map((entry) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ModernPanel(
                    title: entry.key.toUpperCase(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: entry.value.map((chord) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _chords.add(chord);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: AppTheme.modernButtonDecoration(
                                  color: AppTheme.surfaceLightColor,
                                  borderRadius: 12,
                                ),
                                child: Text(
                                  chord,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                        ModernButton(
                          text: 'Add All',
                          onPressed: () {
                            setState(() {
                              _chords.addAll(entry.value);
                            });
                          },
                          width: 120,
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
