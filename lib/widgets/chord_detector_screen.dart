import 'package:flutter/material.dart';
import '../services/chord_detector_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';

class ChordDetectorScreen extends StatefulWidget {
  const ChordDetectorScreen({super.key});

  @override
  State<ChordDetectorScreen> createState() => _ChordDetectorScreenState();
}

class _ChordDetectorScreenState extends State<ChordDetectorScreen> {
  final ChordDetectorService _chordService = ChordDetectorService();
  ChordResult? _lastChord;

  final List<String> _noteNames = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];

  @override
  void initState() {
    super.initState();
    _chordService.chordStream.listen((chord) {
      setState(() => _lastChord = chord);
    });
    _chordService.start();
  }

  @override
  void dispose() {
    _chordService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'CHORD DETECTOR',
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
            icon: _chordService.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
            onPressed: () {
              if (_chordService.isRunning) {
                _chordService.stop();
              } else {
                _chordService.start();
              }
              setState(() {});
            },
            width: 44,
            height: 44,
            isPrimary: _chordService.isRunning,
          ),
          const SizedBox(width: 8),
          ModernButton(
            icon: Icons.clear_all_rounded,
            onPressed: () {
              _chordService.clearNotes();
              setState(() {});
            },
            width: 44,
            height: 44,
          ),
        ],
      ),
      body: Column(
        children: [
          // Chord display
          Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Text(
                  _lastChord?.name ?? 'None',
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const Text(
                  'CHORD',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
          ),
          // Active notes
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Active Notes: ${_chordService.activeNotes.map((n) => _noteNames[n % 12]).join(', ')}',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Note input
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  final noteName = _noteNames[index];
                  final isActive = _chordService.activeNotes.any((n) => n % 12 == index);

                  return GestureDetector(
                    onTap: () {
                      if (isActive) {
                        _chordService.removeNote(index);
                      } else {
                        _chordService.addNote(index + 60);
                      }
                      setState(() {});
                    },
                    child: Container(
                      decoration: AppTheme.modernButtonDecoration(
                        color: isActive
                            ? AppTheme.primaryColor.withValues(alpha: 0.2)
                            : AppTheme.surfaceLightColor,
                        isPrimary: isActive,
                        borderRadius: 16,
                      ),
                      child: Center(
                        child: Text(
                          noteName,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: isActive ? AppTheme.primaryColor : AppTheme.textPrimary,
                          ),
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
    );
  }
}
