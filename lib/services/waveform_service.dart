import 'dart:math';

class WaveformService {
  static List<double> generateSineWave({int samples = 100, double frequency = 1.0}) {
    final result = <double>[];
    for (int i = 0; i < samples; i++) {
      final t = i / samples;
      result.add(sin(2 * pi * frequency * t));
    }
    return result;
  }

  static List<double> generateSquareWave({int samples = 100, double frequency = 1.0}) {
    final result = <double>[];
    for (int i = 0; i < samples; i++) {
      final t = i / samples;
      result.add((t * frequency) % 1.0 < 0.5 ? 1.0 : -1.0);
    }
    return result;
  }

  static List<double> generateSawtoothWave({int samples = 100, double frequency = 1.0}) {
    final result = <double>[];
    for (int i = 0; i < samples; i++) {
      final t = i / samples;
      result.add(2.0 * ((t * frequency) % 1.0) - 1.0);
    }
    return result;
  }

  static List<double> generateTriangleWave({int samples = 100, double frequency = 1.0}) {
    final result = <double>[];
    for (int i = 0; i < samples; i++) {
      final t = i / samples;
      final value = (t * frequency) % 1.0;
      result.add(value < 0.5 ? 4.0 * value - 1.0 : 3.0 - 4.0 * value);
    }
    return result;
  }

  static List<double> generateNoise({int samples = 100}) {
    final random = Random();
    return List.generate(samples, (_) => random.nextDouble() * 2.0 - 1.0);
  }

  static List<double> applyEnvelope(List<double> samples, {double attack = 0.1, double release = 0.1}) {
    final result = <double>[];
    final attackSamples = (samples.length * attack).round();
    final releaseSamples = (samples.length * release).round();

    for (int i = 0; i < samples.length; i++) {
      double envelope = 1.0;
      if (i < attackSamples) {
        envelope = i / attackSamples;
      } else if (i > samples.length - releaseSamples) {
        envelope = (samples.length - i) / releaseSamples;
      }
      result.add(samples[i] * envelope);
    }
    return result;
  }

  static List<double> normalize(List<double> samples) {
    if (samples.isEmpty) return samples;
    final maxVal = samples.reduce((a, b) => a.abs() > b.abs() ? a : b).abs();
    if (maxVal == 0) return samples;
    return samples.map((s) => s / maxVal).toList();
  }
}
