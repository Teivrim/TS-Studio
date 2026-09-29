import 'dart:async';

class ChordDetectorService {
  final _chordController = StreamController<ChordResult>.broadcast();
  Stream<ChordResult> get chordStream => _chordController.stream;

  Timer? _timer;
  bool _isRunning = false;
  final List<int> _activeNotes = [];

  bool get isRunning => _isRunning;
  List<int> get activeNotes => List.from(_activeNotes);

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _detectChord();
    });
  }

  void stop() {
    _isRunning = false;
    _timer?.cancel();
    _timer = null;
  }

  void addNote(int note) {
    if (!_activeNotes.contains(note)) {
      _activeNotes.add(note);
      _activeNotes.sort();
    }
  }

  void removeNote(int note) {
    _activeNotes.remove(note);
  }

  void clearNotes() {
    _activeNotes.clear();
  }

  void _detectChord() {
    if (_activeNotes.isEmpty) {
      _chordController.add(ChordResult(
        name: 'None',
        notes: [],
        timestamp: DateTime.now(),
      ));
      return;
    }

    final name = _getChordName(_activeNotes);
    _chordController.add(ChordResult(
      name: name,
      notes: List.from(_activeNotes),
      timestamp: DateTime.now(),
    ));
  }

  String _getChordName(List<int> notes) {
    if (notes.length < 2) return 'Single Note';

    final intervals = <int>[];
    for (int i = 1; i < notes.length; i++) {
      intervals.add(notes[i] - notes[i - 1]);
    }

    if (intervals.length == 1) {
      if (intervals[0] == 4) return 'Major';
      if (intervals[0] == 3) return 'Minor';
      if (intervals[0] == 7) return 'Power';
    }

    if (intervals.length == 2) {
      if (intervals[0] == 4 && intervals[1] == 3) return 'Major';
      if (intervals[0] == 3 && intervals[1] == 4) return 'Minor';
      if (intervals[0] == 4 && intervals[1] == 4) return 'Augmented';
      if (intervals[0] == 3 && intervals[1] == 3) return 'Diminished';
    }

    if (intervals.length == 3) {
      if (intervals[0] == 4 && intervals[1] == 3 && intervals[2] == 4) return 'Major 7';
      if (intervals[0] == 3 && intervals[1] == 4 && intervals[2] == 3) return 'Minor 7';
      if (intervals[0] == 4 && intervals[1] == 3 && intervals[2] == 3) return 'Dominant 7';
    }

    return 'Unknown';
  }

  void dispose() {
    _timer?.cancel();
    _chordController.close();
  }
}

class ChordResult {
  final String name;
  final List<int> notes;
  final DateTime timestamp;

  const ChordResult({
    required this.name,
    required this.notes,
    required this.timestamp,
  });
}
