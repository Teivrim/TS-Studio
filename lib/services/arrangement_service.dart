import 'dart:async';

class ArrangementService {
  final _positionController = StreamController<int>.broadcast();
  Stream<int> get positionStream => _positionController.stream;

  Timer? _timer;
  bool _isPlaying = false;
  int _currentPosition = 0;
  int _totalSteps = 64;
  int _bpm = 120;

  bool get isPlaying => _isPlaying;
  int get currentPosition => _currentPosition;
  int get totalSteps => _totalSteps;

  void play() {
    if (_isPlaying) return;
    _isPlaying = true;
    _startTimer();
  }

  void pause() {
    _isPlaying = false;
    _timer?.cancel();
    _timer = null;
  }

  void stop() {
    pause();
    _currentPosition = 0;
    _positionController.add(_currentPosition);
  }

  void seek(int position) {
    _currentPosition = position.clamp(0, _totalSteps - 1);
    _positionController.add(_currentPosition);
  }

  void setBpm(int bpm) {
    _bpm = bpm;
    if (_isPlaying) {
      _restartTimer();
    }
  }

  void setTotalSteps(int steps) {
    _totalSteps = steps;
    if (_currentPosition >= _totalSteps) {
      _currentPosition = 0;
      _positionController.add(_currentPosition);
    }
  }

  void _startTimer() {
    final intervalMs = (60000 / _bpm / 4).round();
    _timer = Timer.periodic(Duration(milliseconds: intervalMs), (_) {
      _currentPosition = (_currentPosition + 1) % _totalSteps;
      _positionController.add(_currentPosition);
    });
  }

  void _restartTimer() {
    _timer?.cancel();
    _startTimer();
  }

  void dispose() {
    _timer?.cancel();
    _positionController.close();
  }
}
