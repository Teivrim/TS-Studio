import 'dart:async';
import 'dart:math';

class SpectrumService {
  final _spectrumController = StreamController<List<double>>.broadcast();
  Stream<List<double>> get spectrumStream => _spectrumController.stream;

  Timer? _timer;
  bool _isRunning = false;
  final List<double> _spectrum = List.filled(32, 0.0);
  final Random _random = Random();

  bool get isRunning => _isRunning;
  List<double> get spectrum => List.from(_spectrum);

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      _updateSpectrum();
    });
  }

  void stop() {
    _isRunning = false;
    _timer?.cancel();
    _timer = null;
    _spectrum.fillRange(0, _spectrum.length, 0.0);
    _spectrumController.add(List.from(_spectrum));
  }

  void _updateSpectrum() {
    for (int i = 0; i < _spectrum.length; i++) {
      final target = _random.nextDouble() * (1.0 - (i / _spectrum.length) * 0.5);
      _spectrum[i] = _spectrum[i] * 0.8 + target * 0.2;
    }
    _spectrumController.add(List.from(_spectrum));
  }

  void dispose() {
    _timer?.cancel();
    _spectrumController.close();
  }
}
