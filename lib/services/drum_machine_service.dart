import 'dart:async';

class DrumMachineService {
  final _beatController = StreamController<int>.broadcast();
  Stream<int> get beatStream => _beatController.stream;

  Timer? _timer;
  bool _isPlaying = false;
  int _currentStep = 0;
  int _bpm = 120;
  final List<List<bool>> _pattern = List.generate(4, (_) => List.filled(16, false));

  bool get isPlaying => _isPlaying;
  int get currentStep => _currentStep;
  int get bpm => _bpm;
  List<List<bool>> get pattern => _pattern;

  void start() {
    if (_isPlaying) return;
    _isPlaying = true;
    _startTimer();
  }

  void stop() {
    _isPlaying = false;
    _timer?.cancel();
    _timer = null;
    _currentStep = 0;
    _beatController.add(_currentStep);
  }

  void setBpm(int bpm) {
    _bpm = bpm.clamp(60, 200);
    if (_isPlaying) {
      _restartTimer();
    }
  }

  void toggleStep(int track, int step) {
    _pattern[track][step] = !_pattern[track][step];
  }

  void clearPattern() {
    for (var track in _pattern) {
      track.fillRange(0, track.length, false);
    }
  }

  void _startTimer() {
    final intervalMs = (60000 / _bpm / 4).round();
    _timer = Timer.periodic(Duration(milliseconds: intervalMs), (_) {
      _currentStep = (_currentStep + 1) % 16;
      _beatController.add(_currentStep);
    });
  }

  void _restartTimer() {
    _timer?.cancel();
    _startTimer();
  }

  void dispose() {
    _timer?.cancel();
    _beatController.close();
  }
}
