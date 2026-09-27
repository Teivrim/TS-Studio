import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
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
  double _masterVolume = 0.8;

  final _stepController = StreamController<int>.broadcast();
  Stream<int> get stepStream => _stepController.stream;

  bool get isPlaying => _isPlaying;
  int get currentStep => _currentStep;

  void updateTracks(List<Track> tracks) {
    _tracks = tracks;
  }

  void updateBpm(int bpm) {
    _bpm = bpm;
    if (_isPlaying) _restartTimer();
  }

  void updateMasterVolume(double volume) {
    _masterVolume = volume;
    _player.setVolume(volume);
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
    final intervalMs = (60000 / _bpm / 4).round();
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
    final frequency = _getTrackFrequency(track);
    _playTone(frequency, track.volume * _masterVolume, track.soundType);
  }

  double _getTrackFrequency(Track track) {
    final pentatonic = [261.63, 293.66, 329.63, 392.00, 440.00, 523.25, 587.33, 659.25];
    final index = track.id.hashCode.abs() % pentatonic.length;
    return pentatonic[index];
  }

  void _playTone(double frequency, double volume, String soundType) {
    try {
      debugPrint('Playing $soundType: $frequency Hz at volume $volume');
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  Uint8List generateWav(List<Track> tracks, int bpm, {double masterVolume = 0.8}) {
    const sampleRate = 44100;
    const durationSeconds = 4.0;
    final totalSamples = (sampleRate * durationSeconds).round();
    final audioData = Float32List(totalSamples);

    final stepDuration = 60.0 / bpm / 4;

    for (final track in tracks) {
      if (track.muted) continue;
      final frequency = _getTrackFrequency(track);
      final volume = track.volume * masterVolume;

      for (int step = 0; step < 16; step++) {
        if (!track.steps[step]) continue;

        final startSample = (step * stepDuration * sampleRate).round();
        final stepSamples = (stepDuration * sampleRate).round();

        for (int i = 0; i < stepSamples && startSample + i < totalSamples; i++) {
          final t = i / sampleRate;
          final envelope = exp(-t * 8);
          final sample = sin(2 * pi * frequency * t) * envelope * volume;
          audioData[startSample + i] += sample;
        }
      }
    }

    return _float32ToWav(audioData, sampleRate);
  }

  Uint8List _float32ToWav(Float32List samples, int sampleRate) {
    final byteData = ByteData(samples.length * 2);
    for (int i = 0; i < samples.length; i++) {
      final sample = samples[i].clamp(-1.0, 1.0);
      byteData.setInt16(i * 2, (sample * 32767).round(), Endian.little);
    }

    final wavHeader = ByteData(44);
    wavHeader.setUint8(0, 0x52); // R
    wavHeader.setUint8(1, 0x49); // I
    wavHeader.setUint8(2, 0x46); // F
    wavHeader.setUint8(3, 0x46); // F
    wavHeader.setUint32(4, 36 + samples.length * 2, Endian.little);
    wavHeader.setUint8(8, 0x57); // W
    wavHeader.setUint8(9, 0x41); // A
    wavHeader.setUint8(10, 0x56); // V
    wavHeader.setUint8(11, 0x45); // E
    wavHeader.setUint8(12, 0x66); // f
    wavHeader.setUint8(13, 0x6D); // m
    wavHeader.setUint8(14, 0x74); // t
    wavHeader.setUint8(15, 0x20);
    wavHeader.setUint32(16, 16, Endian.little);
    wavHeader.setUint16(20, 1, Endian.little);
    wavHeader.setUint16(22, 1, Endian.little);
    wavHeader.setUint32(24, sampleRate, Endian.little);
    wavHeader.setUint32(28, sampleRate * 2, Endian.little);
    wavHeader.setUint16(32, 2, Endian.little);
    wavHeader.setUint16(34, 16, Endian.little);
    wavHeader.setUint8(36, 0x64); // d
    wavHeader.setUint8(37, 0x61); // a
    wavHeader.setUint8(38, 0x74); // t
    wavHeader.setUint8(39, 0x61); // a
    wavHeader.setUint32(40, samples.length * 2, Endian.little);

    return Uint8List.fromList([...wavHeader.buffer.asUint8List(), ...byteData.buffer.asUint8List()]);
  }

  void dispose() {
    _timer?.cancel();
    _player.dispose();
    _stepController.close();
  }
}
