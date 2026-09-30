import 'dart:async';
import 'dart:math';

class BeatDetectorService {
  final _beatController = StreamController<BeatEvent>.broadcast();
  Stream<BeatEvent> get beatStream => _beatController.stream;

  Timer? _timer;
  bool _isRunning = false;
  double _energy = 0.0;
  double _threshold = 0.3;
  int _bpm = 120;
  bool _beatDetected = false;

  bool get isRunning => _isRunning;
  double get energy => _energy;
  double get threshold => _threshold;
  int get bpm => _bpm;
  bool get beatDetected => _beatDetected;

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      _detectBeat();
    });
  }

  void stop() {
    _isRunning = false;
    _timer?.cancel();
    _timer = null;
    _energy = 0.0;
    _beatDetected = false;
  }

  void setThreshold(double threshold) {
    _threshold = threshold.clamp(0.1, 1.0);
  }

  void setBpm(int bpm) {
    _bpm = bpm.clamp(60, 200);
  }

  void _detectBeat() {
    final random = Random();
    final newEnergy = random.nextDouble();
    _energy = _energy * 0.95 + newEnergy * 0.05;

    if (_energy > _threshold && !_beatDetected) {
      _beatDetected = true;
      _beatController.add(BeatEvent(
        energy: _energy,
        bpm: _bpm,
        timestamp: DateTime.now(),
      ));
    } else if (_energy < _threshold * 0.5) {
      _beatDetected = false;
    }
  }

  void dispose() {
    _timer?.cancel();
    _beatController.close();
  }
}

class BeatEvent {
  final double energy;
  final int bpm;
  final DateTime timestamp;

  const BeatEvent({
    required this.energy,
    required this.bpm,
    required this.timestamp,
  });
}
