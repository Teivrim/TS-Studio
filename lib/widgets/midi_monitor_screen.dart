import 'package:flutter/material.dart';
import '../services/midi_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';

class MidiMonitorScreen extends StatefulWidget {
  final MidiService midiService;

  const MidiMonitorScreen({super.key, required this.midiService});

  @override
  State<MidiMonitorScreen> createState() => _MidiMonitorScreenState();
}

class _MidiMonitorScreenState extends State<MidiMonitorScreen> {
  final List<MidiNote> _notes = [];
  final int _maxNotes = 50;

  @override
  void initState() {
    super.initState();
    widget.midiService.noteStream.listen((note) {
      setState(() {
        _notes.insert(0, note);
        if (_notes.length > _maxNotes) {
          _notes.removeLast();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'MIDI MONITOR',
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
            icon: widget.midiService.isEnabled ? Icons.pause_rounded : Icons.play_arrow_rounded,
            onPressed: () {
              if (widget.midiService.isEnabled) {
                widget.midiService.disable();
              } else {
                widget.midiService.enable();
              }
              setState(() {});
            },
            width: 44,
            height: 44,
            isPrimary: widget.midiService.isEnabled,
          ),
          const SizedBox(width: 8),
          ModernButton(
            icon: Icons.clear_all_rounded,
            onPressed: () => setState(() => _notes.clear()),
            width: 44,
            height: 44,
          ),
        ],
      ),
      body: Column(
        children: [
          // Status
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: AppTheme.ledDecoration(
                    isOn: widget.midiService.isEnabled,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.midiService.isEnabled ? 'MIDI Enabled' : 'MIDI Disabled',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_notes.length} events',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Note list
          Expanded(
            child: _notes.isEmpty
                ? const Center(
                    child: Text(
                      'Нет MIDI событий',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  )
                : ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      final note = _notes[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: AppTheme.modernPanelDecoration(),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: AppTheme.modernButtonDecoration(
                                color: note.isNoteOn
                                    ? AppTheme.successColor.withValues(alpha: 0.2)
                                    : AppTheme.dangerColor.withValues(alpha: 0.2),
                                borderRadius: 12,
                              ),
                              child: Center(
                                child: Text(
                                  note.isNoteOn ? 'ON' : 'OFF',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: note.isNoteOn
                                        ? AppTheme.successColor
                                        : AppTheme.dangerColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    note.noteName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    'Note: ${note.note} • Velocity: ${note.velocity}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
