import 'dart:async';
import 'dart:math';

class SynthEngineService {
  final _noteController = StreamController<SynthNote>.broadcast();
  Stream<SynthNote> get noteStream => _noteController.stream;

  Timer? _timer;
  bool _isPlaying = false;
  double _frequency = 440.0;
  double _amplitude = 0.5;
  String _waveform = 'sine';

  bool get isPlaying => _isPlaying;
  double get frequency => _frequency;
  double get amplitude => _amplitude;
  String get waveform => _waveform;

  void start() {
    if (_isPlaying) return;
    _isPlaying = true;
    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      _generateNote();
    });
  }

  void stop() {
    _isPlaying = false;
    _timer?.cancel();
    _timer = null;
  }

  void setFrequency(double freq) {
    _frequency = freq.clamp(20.0, 20000.0);
  }

  void setAmplitude(double amp) {
    _amplitude = amp.clamp(0.0, 1.0);
  }

  void setWaveform(String wave) {
    _waveform = wave;
  }

  void _generateNote() {
    final random = Random();
    final note = SynthNote(
      frequency: _frequency + (random.nextDouble() - 0.5) * 10,
      amplitude: _amplitude * (0.8 + random.nextDouble() * 0.2),
      waveform: _waveform,
      timestamp: DateTime.now(),
    );
    _noteController.add(note);
  }

  void dispose() {
    _timer?.cancel();
    _noteController.close();
  }
}

class SynthNote {
  final double frequency;
  final double amplitude;
  final String waveform;
  final DateTime timestamp;

  const SynthNote({
    required this.frequency,
    required this.amplitude,
    required this.waveform,
    required this.timestamp,
  });
}
