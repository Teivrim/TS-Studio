import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../models/track.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  Timer? _timer;
  int _currentStep = 0;
  List<Track> _tracks = [];
  int _bpm = 120;
  bool _isPlaying = false;

  final _stepController = StreamController<int>.broadcast();
  Stream<int> get stepStream => _stepController.stream;

  bool get isPlaying => _isPlaying;
  int get currentStep => _currentStep;

  void updateTracks(List<Track> tracks) {
    _tracks = tracks;
  }

  void updateBpm(int bpm) {
    _bpm = bpm;
    if (_isPlaying) {
      _restartTimer();
    }
  }

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
    _currentStep = 0;
    _stepController.add(_currentStep);
  }

  void togglePlay() {
    if (_isPlaying) {
      pause();
    } else {
      play();
    }
  }

  void _startTimer() {
    final intervalMs = (60000 / _bpm / 4).round(); // 16th notes
    _timer = Timer.periodic(Duration(milliseconds: intervalMs), (_) {
      _triggerStep();
    });
  }

  void _restartTimer() {
    _timer?.cancel();
    _startTimer();
  }

  void _triggerStep() {
    _stepController.add(_currentStep);

    for (final track in _tracks) {
      if (track.muted) continue;
      if (track.steps[_currentStep]) {
        _playSound(track);
      }
    }

    _currentStep = (_currentStep + 1) % 16;
  }

  void _playSound(Track track) {
    // Generate a simple synthesized sound based on track properties
    // In a real app, you'd load samples here
    final frequency = _getTrackFrequency(track);
    _playTone(frequency, track.volume);
  }

  double _getTrackFrequency(Track track) {
    // Map track index to a pentatonic scale frequency
    final pentatonic = [261.63, 293.66, 329.63, 392.00, 440.00, 523.25, 587.33, 659.25];
    final index = track.id.hashCode.abs() % pentatonic.length;
    return pentatonic[index];
  }

  void _playTone(double frequency, double volume) {
    // For now, we'll use a simple approach with AudioPlayer
    // In production, you'd use a more sophisticated audio synthesis
    try {
      // This is a placeholder - in a real app you'd generate audio buffers
      // or use a synthesizer package
      debugPrint('Playing tone: $frequency Hz at volume $volume');
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  void dispose() {
    _timer?.cancel();
    _player.dispose();
    _stepController.close();
  }
}
