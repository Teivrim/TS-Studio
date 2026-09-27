import '../models/pattern.dart';

class PresetService {
  static List<Preset> getPresets() {
    return [
      // Basic patterns
      Preset(
        id: 'basic_1',
        name: 'Basic Beat',
        category: 'Basic',
        bpm: 120,
        steps: [
          [true, false, false, false, true, false, false, false, true, false, false, false, true, false, false, false],
          [false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false],
          [true, false, true, false, true, false, true, false, true, false, true, false, true, false, true, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
        ],
      ),
      Preset(
        id: 'basic_2',
        name: 'Four on Floor',
        category: 'Basic',
        bpm: 128,
        steps: [
          [true, false, false, false, true, false, false, false, true, false, false, false, true, false, false, false],
          [false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false],
          [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
        ],
      ),
      // Hip Hop patterns
      Preset(
        id: 'hiphop_1',
        name: 'Hip Hop Groove',
        category: 'Hip Hop',
        bpm: 90,
        steps: [
          [true, false, false, false, false, false, true, false, false, false, true, false, false, false, false, false],
          [false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false],
          [true, false, true, false, true, false, true, false, true, false, true, false, true, false, true, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
        ],
      ),
      // Techno patterns
      Preset(
        id: 'techno_1',
        name: 'Techno Drive',
        category: 'Techno',
        bpm: 130,
        steps: [
          [true, false, false, false, true, false, false, false, true, false, false, false, true, false, false, false],
          [false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false],
          [true, false, true, false, true, false, true, false, true, false, true, false, true, false, true, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
        ],
      ),
      // Trap patterns
      Preset(
        id: 'trap_1',
        name: 'Trap Beat',
        category: 'Trap',
        bpm: 140,
        steps: [
          [true, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false],
          [false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false],
          [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
        ],
      ),
      // House patterns
      Preset(
        id: 'house_1',
        name: 'House Groove',
        category: 'House',
        bpm: 125,
        steps: [
          [true, false, false, false, true, false, false, false, true, false, false, false, true, false, false, false],
          [false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false],
          [true, false, true, false, true, false, true, false, true, false, true, false, true, false, true, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
        ],
      ),
    ];
  }
}
