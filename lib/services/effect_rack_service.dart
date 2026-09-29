import 'dart:async';
import 'dart:math';

class EffectRackService {
  final _effectController = StreamController<EffectEvent>.broadcast();
  Stream<EffectEvent> get effectStream => _effectController.stream;

  Timer? _timer;
  bool _isRunning = false;
  final Map<String, double> _effectValues = {
    'reverb': 0.0,
    'delay': 0.0,
    'distortion': 0.0,
    'chorus': 0.0,
    'filter': 1.0,
    'phaser': 0.0,
    'flanger': 0.0,
    'tremolo': 0.0,
  };

  bool get isRunning => _isRunning;
  Map<String, double> get effectValues => Map.from(_effectValues);

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _updateEffects();
    });
  }

  void stop() {
    _isRunning = false;
    _timer?.cancel();
    _timer = null;
  }

  void setEffect(String name, double value) {
    if (_effectValues.containsKey(name)) {
      _effectValues[name] = value.clamp(0.0, 1.0);
    }
  }

  void _updateEffects() {
    final random = Random();
    for (var key in _effectValues.keys) {
      final current = _effectValues[key]!;
      final target = key == 'filter' ? 0.5 + random.nextDouble() * 0.5 : random.nextDouble() * 0.3;
      _effectValues[key] = current * 0.9 + target * 0.1;
    }
    _effectController.add(EffectEvent(
      values: Map.from(_effectValues),
      timestamp: DateTime.now(),
    ));
  }

  void dispose() {
    _timer?.cancel();
    _effectController.close();
  }
}

class EffectEvent {
  final Map<String, double> values;
  final DateTime timestamp;

  const EffectEvent({
    required this.values,
    required this.timestamp,
  });
}
