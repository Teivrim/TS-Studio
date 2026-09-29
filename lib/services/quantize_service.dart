class QuantizeService {
  static const Map<String, int> gridDivisions = {
    '1/4': 4,
    '1/8': 8,
    '1/16': 16,
    '1/32': 32,
    '1/4T': 6,
    '1/8T': 12,
    '1/16T': 24,
  };

  static int quantizeStep(int step, String grid) {
    final division = gridDivisions[grid] ?? 16;
    final stepsPerDivision = 16 ~/ division;
    return (step ~/ stepsPerDivision) * stepsPerDivision;
  }

  static List<bool> quantizePattern(List<bool> steps, String grid) {
    final result = List<bool>.filled(steps.length, false);
    final division = gridDivisions[grid] ?? 16;
    final stepsPerDivision = 16 ~/ division;

    for (int i = 0; i < steps.length; i++) {
      if (steps[i]) {
        final quantized = (i ~/ stepsPerDivision) * stepsPerDivision;
        if (quantized < result.length) {
          result[quantized] = true;
        }
      }
    }

    return result;
  }

  static List<int> getGridLines(String grid) {
    final division = gridDivisions[grid] ?? 16;
    final stepsPerDivision = 16 ~/ division;
    final lines = <int>[];
    for (int i = 0; i < 16; i += stepsPerDivision) {
      lines.add(i);
    }
    return lines;
  }
}
