import 'dart:async';

class MidiService {
  final _noteController = StreamController<MidiNote>.broadcast();
  Stream<MidiNote> get noteStream => _noteController.stream;

  bool _isEnabled = false;

  bool get isEnabled => _isEnabled;

  void enable() {
    _isEnabled = true;
  }

  void disable() {
    _isEnabled = false;
  }

  void sendNoteOn(int note, int velocity) {
    if (!_isEnabled) return;
    _noteController.add(MidiNote(
      note: note,
      velocity: velocity,
      isNoteOn: true,
    ));
  }

  void sendNoteOff(int note) {
    if (!_isEnabled) return;
    _noteController.add(MidiNote(
      note: note,
      velocity: 0,
      isNoteOn: false,
    ));
  }

  void dispose() {
    _noteController.close();
  }
}

class MidiNote {
  final int note;
  final int velocity;
  final bool isNoteOn;

  const MidiNote({
    required this.note,
    required this.velocity,
    required this.isNoteOn,
  });

  String get noteName {
    final notes = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
    final octave = (note ~/ 12) - 1;
    final noteIndex = note % 12;
    return '${notes[noteIndex]}$octave';
  }
}
