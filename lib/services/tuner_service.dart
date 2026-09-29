import 'dart:async';
import 'dart:math';

class TunerService {
  final _tunerController = StreamController<TunerResult>.broadcast();
  Stream<TunerResult> get tunerStream => _tunerController.stream;

  Timer? _timer;
  bool _isRunning = false;
  double _frequency = 440.0;
  String _noteName = 'A';
  int _octave = 4;
  double _cents = 0.0;

  bool get isRunning => _isRunning;
  double get frequency => _frequency;
  String get noteName => _noteName;
  int get octave => _octave;
  double get cents => _cents;

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      _updateTuner();
    });
  }

  void stop() {
    _isRunning = false;
    _timer?.cancel();
    _timer = null;
  }

  void _updateTuner() {
    final random = Random();
    _frequency = 440.0 + (random.nextDouble() - 0.5) * 20;
    _cents = (random.nextDouble() - 0.5) * 50;

    final notes = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
    final noteIndex = ((_frequency / 440.0 * 12).round() + 9) % 12;
    _noteName = notes[noteIndex];
    _octave = (_frequency / 440.0 * 12).floor() ~/ 12 + 4;

    _tunerController.add(TunerResult(
      frequency: _frequency,
      noteName: _noteName,
      octave: _octave,
      cents: _cents,
      isInTune: _cents.abs() < 5,
      timestamp: DateTime.now(),
    ));
  }

  void dispose() {
    _timer?.cancel();
    _tunerController.close();
  }
}

class TunerResult {
  final double frequency;
  final String noteName;
  final int octave;
  final double cents;
  final bool isInTune;
  final DateTime timestamp;

  const TunerResult({
    required this.frequency,
    required this.noteName,
    required this.octave,
    required this.cents,
    required this.isInTune,
    required this.timestamp,
  });
}
