import 'dart:isolate';
import 'dart:math';
import '../models/track.dart';

class PerformanceService {
  static Future<List<double>> computeWaveformSamples(List<Track> tracks, int bpm) async {
    return await Isolate.run(() {
      return _generateWaveformSamples(tracks, bpm);
    });
  }

  static List<double> _generateWaveformSamples(List<Track> tracks, int bpm) {
    const sampleRate = 44100;
    const durationSeconds = 4.0;
    final totalSamples = (sampleRate * durationSeconds).round();
    final audioData = List<double>.filled(totalSamples, 0.0);

    final stepDuration = 60.0 / bpm / 4;

    for (final track in tracks) {
      if (track.muted) continue;
      final frequency = _getTrackFrequency(track);
      final volume = track.volume * 0.8;

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

    // Downsample for visualization
    final downsampleFactor = 100;
    final result = <double>[];
    for (int i = 0; i < totalSamples; i += downsampleFactor) {
      result.add(audioData[i]);
    }

    return result;
  }

  static double _getTrackFrequency(Track track) {
    final pentatonic = [261.63, 293.66, 329.63, 392.00, 440.00, 523.25, 587.33, 659.25];
    final index = track.id.hashCode.abs() % pentatonic.length;
    return pentatonic[index];
  }

  static Future<List<Track>> generateRandomPatternAsync(List<Track> tracks, {double density = 0.3}) async {
    return await Isolate.run(() {
      final random = Random();
      return tracks.map((track) {
        final newSteps = List<bool>.generate(16, (_) => random.nextDouble() < density);
        if (!newSteps.any((s) => s)) {
          newSteps[random.nextInt(16)] = true;
        }
        return track.copyWith(steps: newSteps);
      }).toList();
    });
  }
}
