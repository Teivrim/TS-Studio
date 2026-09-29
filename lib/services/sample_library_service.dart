import 'dart:async';
import 'dart:math';

class SampleLibraryService {
  final _sampleController = StreamController<SampleEvent>.broadcast();
  Stream<SampleEvent> get sampleStream => _sampleController.stream;

  Timer? _timer;
  bool _isPlaying = false;
  double _volume = 0.8;
  double _pitch = 1.0;
  double _playbackRate = 1.0;

  bool get isPlaying => _isPlaying;
  double get volume => _volume;
  double get pitch => _pitch;
  double get playbackRate => _playbackRate;

  void start() {
    if (_isPlaying) return;
    _isPlaying = true;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _triggerSample();
    });
  }

  void stop() {
    _isPlaying = false;
    _timer?.cancel();
    _timer = null;
  }

  void setVolume(double vol) {
    _volume = vol.clamp(0.0, 1.0);
  }

  void setPitch(double pitch) {
    _pitch = pitch.clamp(0.5, 2.0);
  }

  void setPlaybackRate(double rate) {
    _playbackRate = rate.clamp(0.25, 4.0);
  }

  void _triggerSample() {
    final random = Random();
    final event = SampleEvent(
      sampleId: random.nextInt(8),
      volume: _volume * (0.8 + random.nextDouble() * 0.2),
      pitch: _pitch * (0.95 + random.nextDouble() * 0.1),
      timestamp: DateTime.now(),
    );
    _sampleController.add(event);
  }

  void dispose() {
    _timer?.cancel();
    _sampleController.close();
  }
}

class SampleEvent {
  final int sampleId;
  final double volume;
  final double pitch;
  final DateTime timestamp;

  const SampleEvent({
    required this.sampleId,
    required this.volume,
    required this.pitch,
    required this.timestamp,
  });
}
