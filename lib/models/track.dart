import 'package:flutter/foundation.dart';

@immutable
class Track {
  final String id;
  final String name;
  final int color;
  final List<bool> steps;
  final double volume;
  final double pan;
  final bool muted;
  final String sampleFile;
  final String soundType;

  const Track({
    required this.id,
    required this.name,
    required this.color,
    required this.steps,
    this.volume = 0.8,
    this.pan = 0.0,
    this.muted = false,
    this.sampleFile = '',
    this.soundType = 'synth',
  });

  Track copyWith({
    String? name,
    int? color,
    List<bool>? steps,
    double? volume,
    double? pan,
    bool? muted,
    String? sampleFile,
    String? soundType,
  }) {
    return Track(
      id: id,
      name: name ?? this.name,
      color: color ?? this.color,
      steps: steps ?? this.steps,
      volume: volume ?? this.volume,
      pan: pan ?? this.pan,
      muted: muted ?? this.muted,
      sampleFile: sampleFile ?? this.sampleFile,
      soundType: soundType ?? this.soundType,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'color': color,
    'steps': steps,
    'volume': volume,
    'pan': pan,
    'muted': muted,
    'sampleFile': sampleFile,
    'soundType': soundType,
  };

  factory Track.fromJson(Map<String, dynamic> json) => Track(
    id: json['id'] as String,
    name: json['name'] as String,
    color: json['color'] as int,
    steps: List<bool>.from(json['steps'] as List),
    volume: (json['volume'] as num).toDouble(),
    pan: (json['pan'] as num).toDouble(),
    muted: json['muted'] as bool,
    sampleFile: json['sampleFile'] as String? ?? '',
    soundType: json['soundType'] as String? ?? 'synth',
  );
}

class SequencerState {
  final List<Track> tracks;
  final int bpm;
  final bool isPlaying;
  final int currentStep;
  final int stepsPerTrack;
  final double masterVolume;
  final double reverbMix;
  final double delayMix;
  final double delayTime;
  final double eqLow;
  final double eqMid;
  final double eqHigh;
  final double distortion;
  final double chorus;
  final double filterCutoff;
  final bool isRecording;
  final String? recordingPath;

  const SequencerState({
    required this.tracks,
    this.bpm = 120,
    this.isPlaying = false,
    this.currentStep = 0,
    this.stepsPerTrack = 16,
    this.masterVolume = 0.8,
    this.reverbMix = 0.0,
    this.delayMix = 0.0,
    this.delayTime = 0.25,
    this.eqLow = 0.5,
    this.eqMid = 0.5,
    this.eqHigh = 0.5,
    this.distortion = 0.0,
    this.chorus = 0.0,
    this.filterCutoff = 1.0,
    this.isRecording = false,
    this.recordingPath,
  });

  SequencerState copyWith({
    List<Track>? tracks,
    int? bpm,
    bool? isPlaying,
    int? currentStep,
    double? masterVolume,
    double? reverbMix,
    double? delayMix,
    double? delayTime,
    double? eqLow,
    double? eqMid,
    double? eqHigh,
    double? distortion,
    double? chorus,
    double? filterCutoff,
    bool? isRecording,
    String? recordingPath,
  }) {
    return SequencerState(
      tracks: tracks ?? this.tracks,
      bpm: bpm ?? this.bpm,
      isPlaying: isPlaying ?? this.isPlaying,
      currentStep: currentStep ?? this.currentStep,
      stepsPerTrack: stepsPerTrack,
      masterVolume: masterVolume ?? this.masterVolume,
      reverbMix: reverbMix ?? this.reverbMix,
      delayMix: delayMix ?? this.delayMix,
      delayTime: delayTime ?? this.delayTime,
      eqLow: eqLow ?? this.eqLow,
      eqMid: eqMid ?? this.eqMid,
      eqHigh: eqHigh ?? this.eqHigh,
      distortion: distortion ?? this.distortion,
      chorus: chorus ?? this.chorus,
      filterCutoff: filterCutoff ?? this.filterCutoff,
      isRecording: isRecording ?? this.isRecording,
      recordingPath: recordingPath ?? this.recordingPath,
    );
  }

  Map<String, dynamic> toJson() => {
    'tracks': tracks.map((t) => t.toJson()).toList(),
    'bpm': bpm,
    'masterVolume': masterVolume,
    'reverbMix': reverbMix,
    'delayMix': delayMix,
    'delayTime': delayTime,
    'eqLow': eqLow,
    'eqMid': eqMid,
    'eqHigh': eqHigh,
    'distortion': distortion,
    'chorus': chorus,
    'filterCutoff': filterCutoff,
  };

  factory SequencerState.fromJson(Map<String, dynamic> json) => SequencerState(
    tracks: (json['tracks'] as List).map((t) => Track.fromJson(t as Map<String, dynamic>)).toList(),
    bpm: json['bpm'] as int,
    masterVolume: (json['masterVolume'] as num).toDouble(),
    reverbMix: (json['reverbMix'] as num).toDouble(),
    delayMix: (json['delayMix'] as num).toDouble(),
    delayTime: (json['delayTime'] as num).toDouble(),
    eqLow: (json['eqLow'] as num?)?.toDouble() ?? 0.5,
    eqMid: (json['eqMid'] as num?)?.toDouble() ?? 0.5,
    eqHigh: (json['eqHigh'] as num?)?.toDouble() ?? 0.5,
    distortion: (json['distortion'] as num?)?.toDouble() ?? 0.0,
    chorus: (json['chorus'] as num?)?.toDouble() ?? 0.0,
    filterCutoff: (json['filterCutoff'] as num?)?.toDouble() ?? 1.0,
  );
}
