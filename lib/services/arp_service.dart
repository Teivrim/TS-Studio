import 'dart:async';
import 'dart:math';

class ArpService {
  final _noteController = StreamController<ArpNote>.broadcast();
  Stream<ArpNote> get noteStream => _noteController.stream;

  Timer? _timer;
  bool _isPlaying = false;
  int _bpm = 120;
  String _pattern = 'up';
  int _octaves = 2;
  final List<int> _notes = [60, 64, 67, 72];

  bool get isPlaying => _isPlaying;
  int get bpm => _bpm;
  String get pattern => _pattern;
  int get octaves => _octaves;

  void start() {
    if (_isPlaying) return;
    _isPlaying = true;
    _startTimer();
  }

  void stop() {
    _isPlaying = false;
    _timer?.cancel();
    _timer = null;
  }

  void setBpm(int bpm) {
    _bpm = bpm.clamp(60, 200);
    if (_isPlaying) {
      _restartTimer();
    }
  }

  void setPattern(String pattern) {
    _pattern = pattern;
  }

  void setOctaves(int octaves) {
    _octaves = octaves.clamp(1, 4);
  }

  void setNotes(List<int> notes) {
    _notes.clear();
    _notes.addAll(notes);
  }

  void _startTimer() {
    final intervalMs = (60000 / _bpm / 2).round();
    _timer = Timer.periodic(Duration(milliseconds: intervalMs), (_) {
      _playNextNote();
    });
  }

  void _restartTimer() {
    _timer?.cancel();
    _startTimer();
  }

  void _playNextNote() {
    if (_notes.isEmpty) return;

    final random = Random();
    int note;

    switch (_pattern) {
      case 'up':
        note = _notes[random.nextInt(_notes.length)] + (_octaves > 1 ? 12 : 0);
        break;
      case 'down':
        note = _notes[random.nextInt(_notes.length)] + (_octaves > 1 ? 12 : 0);
        break;
      case 'updown':
        note = _notes[random.nextInt(_notes.length)] + (_octaves > 1 ? 12 : 0);
        break;
      case 'random':
        note = _notes[random.nextInt(_notes.length)] + random.nextInt(_octaves) * 12;
        break;
      default:
        note = _notes[random.nextInt(_notes.length)];
    }

    _noteController.add(ArpNote(
      note: note,
      velocity: 0.7 + random.nextDouble() * 0.3,
      timestamp: DateTime.now(),
    ));
  }

  void dispose() {
    _timer?.cancel();
    _noteController.close();
  }
}

class ArpNote {
  final int note;
  final double velocity;
  final DateTime timestamp;

  const ArpNote({
    required this.note,
    required this.velocity,
    required this.timestamp,
  });

  String get noteName {
    final notes = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
    final octave = (note ~/ 12) - 1;
    final noteIndex = note % 12;
    return '${notes[noteIndex]}$octave';
  }
}
