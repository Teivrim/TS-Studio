import 'dart:async';
import 'dart:math';

class AudioMixerService {
  final _levelController = StreamController<List<double>>.broadcast();
  Stream<List<double>> get levelStream => _levelController.stream;

  Timer? _timer;
  bool _isRunning = false;
  final List<double> _levels = List.filled(8, 0.0);
  final List<double> _peaks = List.filled(8, 0.0);
  final Random _random = Random();

  bool get isRunning => _isRunning;
  List<double> get levels => List.from(_levels);
  List<double> get peaks => List.from(_peaks);

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      _updateLevels();
    });
  }

  void stop() {
    _isRunning = false;
    _timer?.cancel();
    _timer = null;
    _levels.fillRange(0, _levels.length, 0.0);
    _peaks.fillRange(0, _peaks.length, 0.0);
    _levelController.add(List.from(_levels));
  }

  void _updateLevels() {
    for (int i = 0; i < _levels.length; i++) {
      final target = _random.nextDouble() * (1.0 - i * 0.05);
      _levels[i] = _levels[i] * 0.7 + target * 0.3;

      if (_levels[i] > _peaks[i]) {
        _peaks[i] = _levels[i];
      } else {
        _peaks[i] *= 0.995;
      }
    }
    _levelController.add(List.from(_levels));
  }

  void dispose() {
    _timer?.cancel();
    _levelController.close();
  }
}
