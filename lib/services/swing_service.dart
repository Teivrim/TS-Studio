class SwingService {
  static List<bool> applySwing(List<bool> steps, double amount) {
    if (amount == 0) return steps;

    final result = List<bool>.from(steps);
    final swingOffset = (amount * 0.5).clamp(0.0, 0.5);

    for (int i = 0; i < steps.length; i++) {
      if (i % 2 == 1 && steps[i]) {
        final shift = (swingOffset * 2).round();
        if (i + shift < steps.length) {
          result[i] = false;
          result[i + shift] = true;
        }
      }
    }

    return result;
  }

  static List<double> generateSwingGrid(int steps, double amount) {
    final result = <double>[];
    for (int i = 0; i < steps; i++) {
      if (i % 2 == 0) {
        result.add(0.0);
      } else {
        result.add(amount * 0.5);
      }
    }
    return result;
  }

  static double calculateSwingOffset(int step, double amount) {
    if (step % 2 == 0) return 0.0;
    return amount * 0.5;
  }
}
