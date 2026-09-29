import 'dart:async';
import 'dart:math';

class LoopRecorderService {
  final _loopController = StreamController<List<double>>.broadcast();
  Stream<List<double>> get loopStream => _loopController.stream;

  Timer? _timer;
  bool _isRecording = false;
  final List<double> _recordedLoop = [];
  final Random _random = Random();

  bool get isRecording => _isRecording;
  List<double> get recordedLoop => List.from(_recordedLoop);

  void startRecording() {
    if (_isRecording) return;
    _isRecording = true;
    _recordedLoop.clear();
    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      _recordSample();
    });
  }

  void stopRecording() {
    _isRecording = false;
    _timer?.cancel();
    _timer = null;
    if (_recordedLoop.isNotEmpty) {
      _loopController.add(List.from(_recordedLoop));
    }
  }

  void _recordSample() {
    final sample = _random.nextDouble() * 2.0 - 1.0;
    _recordedLoop.add(sample);
    if (_recordedLoop.length > 1000) {
      _recordedLoop.removeAt(0);
    }
  }

  void clear() {
    _recordedLoop.clear();
    _loopController.add([]);
  }

  void dispose() {
    _timer?.cancel();
    _loopController.close();
  }
}
