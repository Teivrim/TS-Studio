import 'dart:math';

class SampleEditorService {
  static List<double> normalize(List<double> samples) {
    if (samples.isEmpty) return samples;
    final maxVal = samples.reduce((a, b) => a.abs() > b.abs() ? a : b).abs();
    if (maxVal == 0) return samples;
    return samples.map((s) => s / maxVal).toList();
  }

  static List<double> reverse(List<double> samples) {
    return samples.reversed.toList();
  }

  static List<double> fadeIn(List<double> samples, double duration) {
    final result = <double>[];
    final fadeSamples = (samples.length * duration).round();
    for (int i = 0; i < samples.length; i++) {
      if (i < fadeSamples) {
        result.add(samples[i] * (i / fadeSamples));
      } else {
        result.add(samples[i]);
      }
    }
    return result;
  }

  static List<double> fadeOut(List<double> samples, double duration) {
    final result = <double>[];
    final fadeSamples = (samples.length * duration).round();
    for (int i = 0; i < samples.length; i++) {
      if (i > samples.length - fadeSamples) {
        result.add(samples[i] * ((samples.length - i) / fadeSamples));
      } else {
        result.add(samples[i]);
      }
    }
    return result;
  }

  static List<double> pitchShift(List<double> samples, double semitones) {
    final ratio = pow(2, semitones / 12).toDouble();
    final result = <double>[];
    for (int i = 0; i < samples.length; i++) {
      final newIndex = (i * ratio).round();
      if (newIndex < samples.length) {
        result.add(samples[newIndex]);
      }
    }
    return result;
  }

  static List<double> timeStretch(List<double> samples, double factor) {
    final result = <double>[];
    final newLength = (samples.length * factor).round();
    for (int i = 0; i < newLength; i++) {
      final index = (i / factor).round();
      if (index < samples.length) {
        result.add(samples[index]);
      }
    }
    return result;
  }

  static List<double> applyGain(List<double> samples, double gain) {
    return samples.map((s) => (s * gain).clamp(-1.0, 1.0)).toList();
  }

  static List<double> mix(List<double> samples1, List<double> samples2, double mix) {
    final result = <double>[];
    final maxLength = max(samples1.length, samples2.length);
    for (int i = 0; i < maxLength; i++) {
      final s1 = i < samples1.length ? samples1[i] : 0.0;
      final s2 = i < samples2.length ? samples2[i] : 0.0;
      result.add(s1 * (1 - mix) + s2 * mix);
    }
    return result;
  }
}
