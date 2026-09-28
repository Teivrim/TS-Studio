import '../models/loop.dart';

class LoopService {
  static List<Loop> getBuiltInLoops() {
    return [
      Loop(
        id: 'loop_basic',
        name: 'Basic Beat',
        bpm: 120,
        steps: [
          [true, false, false, false, true, false, false, false, true, false, false, false, true, false, false, false],
          [false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false],
          [true, false, true, false, true, false, true, false, true, false, true, false, true, false, true, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
        ],
      ),
      Loop(
        id: 'loop_hiphop',
        name: 'Hip Hop Groove',
        bpm: 90,
        steps: [
          [true, false, false, false, false, false, true, false, false, false, true, false, false, false, false, false],
          [false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false],
          [true, false, true, false, true, false, true, false, true, false, true, false, true, false, true, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
        ],
      ),
      Loop(
        id: 'loop_techno',
        name: 'Techno Drive',
        bpm: 130,
        steps: [
          [true, false, false, false, true, false, false, false, true, false, false, false, true, false, false, false],
          [false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false],
          [true, false, true, false, true, false, true, false, true, false, true, false, true, false, true, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
        ],
      ),
      Loop(
        id: 'loop_trap',
        name: 'Trap Beat',
        bpm: 140,
        steps: [
          [true, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false],
          [false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false],
          [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
        ],
      ),
      Loop(
        id: 'loop_house',
        name: 'House Groove',
        bpm: 125,
        steps: [
          [true, false, false, false, true, false, false, false, true, false, false, false, true, false, false, false],
          [false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false],
          [true, false, true, false, true, false, true, false, true, false, true, false, true, false, true, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
        ],
      ),
      Loop(
        id: 'loop_dnb',
        name: 'Drum & Bass',
        bpm: 174,
        steps: [
          [true, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false],
          [false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false],
          [true, false, true, false, true, false, true, false, true, false, true, false, true, false, true, false],
          [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
        ],
      ),
    ];
  }
}
