import 'package:flutter/foundation.dart';

@immutable
class MixerChannel {
  final String id;
  final String name;
  final double volume;
  final double pan;
  final bool muted;
  final bool solo;
  final double eqLow;
  final double eqMid;
  final double eqHigh;
  final double reverbSend;
  final double delaySend;
  final double distortion;
  final double chorus;
  final double filterCutoff;
  final double filterResonance;
  final double lfoRate;
  final double lfoDepth;
  final String lfoTarget;

  const MixerChannel({
    required this.id,
    required this.name,
    this.volume = 0.8,
    this.pan = 0.0,
    this.muted = false,
    this.solo = false,
    this.eqLow = 0.5,
    this.eqMid = 0.5,
    this.eqHigh = 0.5,
    this.reverbSend = 0.0,
    this.delaySend = 0.0,
    this.distortion = 0.0,
    this.chorus = 0.0,
    this.filterCutoff = 1.0,
    this.filterResonance = 0.0,
    this.lfoRate = 0.0,
    this.lfoDepth = 0.0,
    this.lfoTarget = 'volume',
  });

  MixerChannel copyWith({
    String? name,
    double? volume,
    double? pan,
    bool? muted,
    bool? solo,
    double? eqLow,
    double? eqMid,
    double? eqHigh,
    double? reverbSend,
    double? delaySend,
    double? distortion,
    double? chorus,
    double? filterCutoff,
    double? filterResonance,
    double? lfoRate,
    double? lfoDepth,
    String? lfoTarget,
  }) {
    return MixerChannel(
      id: id,
      name: name ?? this.name,
      volume: volume ?? this.volume,
      pan: pan ?? this.pan,
      muted: muted ?? this.muted,
      solo: solo ?? this.solo,
      eqLow: eqLow ?? this.eqLow,
      eqMid: eqMid ?? this.eqMid,
      eqHigh: eqHigh ?? this.eqHigh,
      reverbSend: reverbSend ?? this.reverbSend,
      delaySend: delaySend ?? this.delaySend,
      distortion: distortion ?? this.distortion,
      chorus: chorus ?? this.chorus,
      filterCutoff: filterCutoff ?? this.filterCutoff,
      filterResonance: filterResonance ?? this.filterResonance,
      lfoRate: lfoRate ?? this.lfoRate,
      lfoDepth: lfoDepth ?? this.lfoDepth,
      lfoTarget: lfoTarget ?? this.lfoTarget,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'volume': volume,
    'pan': pan,
    'muted': muted,
    'solo': solo,
    'eqLow': eqLow,
    'eqMid': eqMid,
    'eqHigh': eqHigh,
    'reverbSend': reverbSend,
    'delaySend': delaySend,
    'distortion': distortion,
    'chorus': chorus,
    'filterCutoff': filterCutoff,
    'filterResonance': filterResonance,
    'lfoRate': lfoRate,
    'lfoDepth': lfoDepth,
    'lfoTarget': lfoTarget,
  };

  factory MixerChannel.fromJson(Map<String, dynamic> json) => MixerChannel(
    id: json['id'] as String,
    name: json['name'] as String,
    volume: (json['volume'] as num).toDouble(),
    pan: (json['pan'] as num).toDouble(),
    muted: json['muted'] as bool,
    solo: json['solo'] as bool? ?? false,
    eqLow: (json['eqLow'] as num?)?.toDouble() ?? 0.5,
    eqMid: (json['eqMid'] as num?)?.toDouble() ?? 0.5,
    eqHigh: (json['eqHigh'] as num?)?.toDouble() ?? 0.5,
    reverbSend: (json['reverbSend'] as num?)?.toDouble() ?? 0.0,
    delaySend: (json['delaySend'] as num?)?.toDouble() ?? 0.0,
    distortion: (json['distortion'] as num?)?.toDouble() ?? 0.0,
    chorus: (json['chorus'] as num?)?.toDouble() ?? 0.0,
    filterCutoff: (json['filterCutoff'] as num?)?.toDouble() ?? 1.0,
    filterResonance: (json['filterResonance'] as num?)?.toDouble() ?? 0.0,
    lfoRate: (json['lfoRate'] as num?)?.toDouble() ?? 0.0,
    lfoDepth: (json['lfoDepth'] as num?)?.toDouble() ?? 0.0,
    lfoTarget: json['lfoTarget'] as String? ?? 'volume',
  );
}
