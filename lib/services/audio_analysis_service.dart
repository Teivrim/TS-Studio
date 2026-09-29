import 'dart:async';
import 'dart:math';

class AudioAnalysisService {
  final _levelController = StreamController<double>.broadcast();
  Stream<double> get levelStream => _levelController.stream;

  final _peakController = StreamController<double>.broadcast();
  Stream<double> get peakStream => _peakController.stream;

  Timer? _timer;
  bool _isRunning = false;
  double _currentLevel = 0.0;
  double _peakLevel = 0.0;
  final Random _random = Random();

  bool get isRunning => _isRunning;
  double get currentLevel => _currentLevel;
  double get peakLevel => _peakLevel;

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      _updateAnalysis();
    });
  }

  void stop() {
    _isRunning = false;
    _timer?.cancel();
    _timer = null;
    _currentLevel = 0.0;
    _peakLevel = 0.0;
    _levelController.add(0.0);
    _peakController.add(0.0);
  }

  void _updateAnalysis() {
    final target = _random.nextDouble() * 0.8;
    _currentLevel = _currentLevel * 0.7 + target * 0.3;

    if (_currentLevel > _peakLevel) {
      _peakLevel = _currentLevel;
    } else {
      _peakLevel *= 0.99;
    }

    _levelController.add(_currentLevel);
    _peakController.add(_peakLevel);
  }

  void dispose() {
    _timer?.cancel();
    _levelController.close();
    _peakController.close();
  }
}
