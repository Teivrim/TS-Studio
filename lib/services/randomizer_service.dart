import 'dart:math';
import '../models/track.dart';

class RandomizerService {
  final Random _random = Random();

  List<Track> generateRandomPattern(List<Track> tracks, {double density = 0.3}) {
    return tracks.map((track) {
      final newSteps = List<bool>.generate(16, (_) => _random.nextDouble() < density);
      // Ensure at least one step is active
      if (!newSteps.any((s) => s)) {
        newSteps[_random.nextInt(16)] = true;
      }
      return track.copyWith(steps: newSteps);
    }).toList();
  }

  List<Track> generateKickPattern(List<Track> tracks) {
    return tracks.map((track) {
      if (track.soundType == 'kick') {
        final newSteps = List<bool>.generate(16, (i) => i % 4 == 0);
        return track.copyWith(steps: newSteps);
      }
      return track;
    }).toList();
  }

  List<Track> generateSnarePattern(List<Track> tracks) {
    return tracks.map((track) {
      if (track.soundType == 'snare') {
        final newSteps = List<bool>.generate(16, (i) => i == 4 || i == 12);
        return track.copyWith(steps: newSteps);
      }
      return track;
    }).toList();
  }

  List<Track> generateHiHatPattern(List<Track> tracks) {
    return tracks.map((track) {
      if (track.soundType == 'hihat') {
        final newSteps = List<bool>.generate(16, (i) => i % 2 == 0);
        return track.copyWith(steps: newSteps);
      }
      return track;
    }).toList();
  }

  List<Track> generateBassPattern(List<Track> tracks) {
    return tracks.map((track) {
      if (track.soundType == 'bass') {
        final newSteps = List<bool>.generate(16, (i) => i % 4 == 0 || i % 8 == 3);
        return track.copyWith(steps: newSteps);
      }
      return track;
    }).toList();
  }

  List<Track> generateMelodicPattern(List<Track> tracks) {
    return tracks.map((track) {
      if (track.soundType == 'synth' || track.soundType == 'lead' || track.soundType == 'pluck') {
        final newSteps = List<bool>.generate(16, (i) {
          if (i % 2 == 0) {
            return _random.nextDouble() < 0.6;
          }
          return false;
        });
        return track.copyWith(steps: newSteps);
      }
      return track;
    }).toList();
  }

  List<Track> generateFullPattern(List<Track> tracks) {
    var result = generateKickPattern(tracks);
    result = generateSnarePattern(result);
    result = generateHiHatPattern(result);
    result = generateBassPattern(result);
    result = generateMelodicPattern(result);
    return result;
  }

  List<Track> shuffleSteps(List<Track> tracks) {
    return tracks.map((track) {
      final newSteps = List<bool>.from(track.steps)..shuffle(_random);
      return track.copyWith(steps: newSteps);
    }).toList();
  }

  List<Track> invertSteps(List<Track> tracks) {
    return tracks.map((track) {
      final newSteps = track.steps.map((s) => !s).toList();
      return track.copyWith(steps: newSteps);
    }).toList();
  }

  List<Track> shiftSteps(List<Track> tracks, int shift) {
    return tracks.map((track) {
      final newSteps = List<bool>.generate(16, (i) => track.steps[(i - shift) % 16]);
      return track.copyWith(steps: newSteps);
    }).toList();
  }
}
