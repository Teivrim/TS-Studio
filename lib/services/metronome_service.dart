import 'dart:async';

class MetronomeService {
  Timer? _timer;
  bool _isPlaying = false;
  int _bpm = 120;
  int _currentBeat = 0;
  bool _accentFirst = true;

  final _beatController = StreamController<int>.broadcast();
  Stream<int> get beatStream => _beatController.stream;

  bool get isPlaying => _isPlaying;
  int get currentBeat => _currentBeat;

  void start({int? bpm, bool accentFirst = true}) {
    if (_isPlaying) return;
    if (bpm != null) _bpm = bpm;
    _accentFirst = accentFirst;
    _isPlaying = true;
    _currentBeat = 0;
    _startTimer();
  }

  void stop() {
    _isPlaying = false;
    _timer?.cancel();
    _timer = null;
    _currentBeat = 0;
  }

  void toggle({int? bpm, bool accentFirst = true}) {
    if (_isPlaying) {
      stop();
    } else {
      start(bpm: bpm, accentFirst: accentFirst);
    }
  }

  void setBpm(int bpm) {
    _bpm = bpm;
    if (_isPlaying) {
      _restartTimer();
    }
  }

  void _startTimer() {
    final intervalMs = (60000 / _bpm).round();
    _timer = Timer.periodic(Duration(milliseconds: intervalMs), (_) {
      _triggerBeat();
    });
  }

  void _restartTimer() {
    _timer?.cancel();
    _startTimer();
  }

  void _triggerBeat() {
    _beatController.add(_currentBeat);
    _currentBeat = (_currentBeat + 1) % 4;
  }

  bool isAccentBeat(int beat) {
    return _accentFirst && beat == 0;
  }

  void dispose() {
    _timer?.cancel();
    _beatController.close();
  }
}
