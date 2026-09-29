import 'dart:async';

class MetronomeAdvancedService {
  final _beatController = StreamController<MetronomeBeat>.broadcast();
  Stream<MetronomeBeat> get beatStream => _beatController.stream;

  Timer? _timer;
  bool _isPlaying = false;
  int _bpm = 120;
  int _timeSignature = 4;
  int _currentBeat = 0;
  bool _accentFirst = true;
  bool _countInEnabled = false;

  bool get isPlaying => _isPlaying;
  int get bpm => _bpm;
  int get timeSignature => _timeSignature;
  int get currentBeat => _currentBeat;
  bool get accentFirst => _accentFirst;
  bool get countInEnabled => _countInEnabled;

  void start() {
    if (_isPlaying) return;
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

  void setBpm(int bpm) {
    _bpm = bpm.clamp(40, 280);
    if (_isPlaying) {
      _restartTimer();
    }
  }

  void setTimeSignature(int signature) {
    _timeSignature = signature.clamp(2, 8);
  }

  void setAccentFirst(bool accent) {
    _accentFirst = accent;
  }

  void setCountInEnabled(bool enabled) {
    _countInEnabled = enabled;
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
    _currentBeat = (_currentBeat + 1) % _timeSignature;
    final isAccent = _accentFirst && _currentBeat == 0;

    _beatController.add(MetronomeBeat(
      beat: _currentBeat,
      isAccent: isAccent,
      timestamp: DateTime.now(),
    ));
  }

  void dispose() {
    _timer?.cancel();
    _beatController.close();
  }
}

class MetronomeBeat {
  final int beat;
  final bool isAccent;
  final DateTime timestamp;

  const MetronomeBeat({
    required this.beat,
    required this.isAccent,
    required this.timestamp,
  });
}
