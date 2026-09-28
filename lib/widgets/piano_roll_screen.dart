import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';

class PianoRollScreen extends StatefulWidget {
  final int bpm;
  final ValueChanged<int>? onBpmChanged;

  const PianoRollScreen({
    super.key,
    required this.bpm,
    this.onBpmChanged,
  });

  @override
  State<PianoRollScreen> createState() => _PianoRollScreenState();
}

class _PianoRollScreenState extends State<PianoRollScreen> {
  final List<String> _noteNames = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
  final int _octaves = 4;
  final Set<String> _activeNotes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'PIANO ROLL',
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
            onPressed: () => setState(() => _activeNotes.clear()),
            width: 44,
            height: 44,
          ),
        ],
      ),
      body: Column(
        children: [
          // Toolbar
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'BPM:',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Slider(
                    value: widget.bpm.toDouble(),
                    min: 60,
                    max: 200,
                    divisions: 140,
                    activeColor: AppTheme.primaryColor,
                    inactiveColor: AppTheme.gridColor,
                    onChanged: (value) => widget.onBpmChanged?.call(value.round()),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: AppTheme.modernButtonDecoration(
                    color: AppTheme.surfaceLightColor,
                    borderRadius: 12,
                  ),
                  child: Text(
                    '${widget.bpm}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Piano roll
          Expanded(
            child: Row(
              children: [
                // Piano keys
                SizedBox(
                  width: 64,
                  child: ListView.builder(
                    itemCount: _octaves * 12,
                    itemBuilder: (context, index) {
                      final noteIndex = _octaves * 12 - 1 - index;
                      final noteName = _noteNames[noteIndex % 12];
                      final octave = noteIndex ~/ 12;
                      final isBlack = noteName.contains('#');
                      final noteId = '$noteName$octave';

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_activeNotes.contains(noteId)) {
                              _activeNotes.remove(noteId);
                            } else {
                              _activeNotes.add(noteId);
                            }
                          });
                        },
                        child: Container(
                          height: 28,
                          decoration: BoxDecoration(
                            color: isBlack
                                ? AppTheme.backgroundColor
                                : AppTheme.surfaceColor,
                            border: Border.all(
                              color: AppTheme.borderColor.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$noteName$octave',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: isBlack ? AppTheme.textSecondary : AppTheme.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Grid
                Expanded(
                  child: Container(
                    decoration: AppTheme.modernPanelDecoration(),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 16,
                        childAspectRatio: 1,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount: _octaves * 12 * 16,
                      itemBuilder: (context, index) {
                        final noteIndex = index ~/ 16;
                        final stepIndex = index % 16;
                        final noteName = _noteNames[noteIndex % 12];
                        final octave = noteIndex ~/ 12;
                        final noteId = '$noteName$octave';
                        final isActive = _activeNotes.contains(noteId);
                        final isBeat = stepIndex % 4 == 0;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isActive) {
                                _activeNotes.remove(noteId);
                              } else {
                                _activeNotes.add(noteId);
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppTheme.primaryColor
                                  : isBeat
                                      ? AppTheme.inactiveStepColor
                                      : AppTheme.gridColor,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isActive
                                    ? AppTheme.primaryColor.withValues(alpha: 0.5)
                                    : Colors.white.withValues(alpha: 0.05),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
