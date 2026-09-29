import 'dart:async';
import 'dart:math';

class LoopStationService {
  final _loopController = StreamController<LoopEvent>.broadcast();
  Stream<LoopEvent> get loopStream => _loopController.stream;

  Timer? _timer;
  bool _isPlaying = false;
  int _currentStep = 0;
  int _bpm = 120;
  final List<List<bool>> _pattern = List.generate(8, (_) => List.filled(16, false));
  final List<double> _volumes = List.filled(8, 0.8);
  final List<bool> _mutes = List.filled(8, false);
  final List<bool> _solos = List.filled(8, false);

  bool get isPlaying => _isPlaying;
  int get currentStep => _currentStep;
  int get bpm => _bpm;
  List<List<bool>> get pattern => _pattern;
  List<double> get volumes => _volumes;
  List<bool> get mutes => _mutes;
  List<bool> get solos => _solos;

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
    _loopController.add(LoopEvent(step: _currentStep, track: -1, volume: 0));
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

  void setVolume(int track, double volume) {
    _volumes[track] = volume.clamp(0.0, 1.0);
  }

  void toggleMute(int track) {
    _mutes[track] = !_mutes[track];
  }

  void toggleSolo(int track) {
    _solos[track] = !_solos[track];
  }

  void clearPattern() {
    for (var track in _pattern) {
      track.fillRange(0, track.length, false);
    }
  }

  void randomizePattern() {
    final random = Random();
    for (int t = 0; t < _pattern.length; t++) {
      for (int s = 0; s < _pattern[t].length; s++) {
        _pattern[t][s] = random.nextDouble() < 0.3;
      }
    }
  }

  void _startTimer() {
    final intervalMs = (60000 / _bpm / 4).round();
    _timer = Timer.periodic(Duration(milliseconds: intervalMs), (_) {
      _currentStep = (_currentStep + 1) % 16;

      for (int t = 0; t < _pattern.length; t++) {
        if (_pattern[t][_currentStep]) {
          final hasSolo = _solos.any((s) => s);
          final isAudible = hasSolo ? _solos[t] : !_mutes[t];

          if (isAudible) {
            _loopController.add(LoopEvent(
              step: _currentStep,
              track: t,
              volume: _volumes[t],
            ));
          }
        }
      }
    });
  }

  void _restartTimer() {
    _timer?.cancel();
    _startTimer();
  }

  void dispose() {
    _timer?.cancel();
    _loopController.close();
  }
}

class LoopEvent {
  final int step;
  final int track;
  final double volume;

  const LoopEvent({
    required this.step,
    required this.track,
    required this.volume,
  });
}
