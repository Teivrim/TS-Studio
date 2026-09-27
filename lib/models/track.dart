import 'package:flutter/foundation.dart';

@immutable
class Track {
  final String id;
  final String name;
  final int color;
  final List<bool> steps;
  final double volume;
  final bool muted;

  const Track({
    required this.id,
    required this.name,
    required this.color,
    required this.steps,
    this.volume = 0.8,
    this.muted = false,
  });

  Track copyWith({
    String? name,
    int? color,
    List<bool>? steps,
    double? volume,
    bool? muted,
  }) {
    return Track(
      id: id,
      name: name ?? this.name,
      color: color ?? this.color,
      steps: steps ?? this.steps,
      volume: volume ?? this.volume,
      muted: muted ?? this.muted,
    );
  }
}

class SequencerState {
  final List<Track> tracks;
  final int bpm;
  final bool isPlaying;
  final int currentStep;
  final int stepsPerTrack;

  const SequencerState({
    required this.tracks,
    this.bpm = 120,
    this.isPlaying = false,
    this.currentStep = 0,
    this.stepsPerTrack = 16,
  });

  SequencerState copyWith({
    List<Track>? tracks,
    int? bpm,
    bool? isPlaying,
    int? currentStep,
  }) {
    return SequencerState(
      tracks: tracks ?? this.tracks,
      bpm: bpm ?? this.bpm,
      isPlaying: isPlaying ?? this.isPlaying,
      currentStep: currentStep ?? this.currentStep,
      stepsPerTrack: stepsPerTrack,
    );
  }
}
