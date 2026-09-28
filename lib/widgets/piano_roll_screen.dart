import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'fl_button.dart';

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
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
        actions: [
          FLButton(
            icon: Icons.clear_all,
            onPressed: () => setState(() => _activeNotes.clear()),
            width: 40,
            height: 40,
          ),
        ],
      ),
      body: Column(
        children: [
          // Toolbar
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Text('BPM:', style: TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                const SizedBox(width: 8),
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: AppTheme.flButtonDecoration(color: AppTheme.buttonColor),
                  child: Text(
                    '${widget.bpm}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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
                  width: 60,
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
                          height: 24,
                          decoration: BoxDecoration(
                            color: isBlack
                                ? AppTheme.backgroundColor
                                : AppTheme.surfaceColor,
                            border: Border.all(color: AppTheme.borderColor.withValues(alpha: 0.3)),
                          ),
                          child: Center(
                            child: Text(
                              '$noteName$octave',
                              style: TextStyle(
                                fontSize: 8,
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
                    decoration: AppTheme.flPanelDecoration(),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 16,
                        childAspectRatio: 1,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
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
                              borderRadius: BorderRadius.circular(2),
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
