import 'package:flutter/foundation.dart';

@immutable
class SynthPreset {
  final String id;
  final String name;
  final String category;
  final double oscillator1Freq;
  final double oscillator2Freq;
  final double oscillator1Detune;
  final double oscillator2Detune;
  final double filterCutoff;
  final double filterResonance;
  final double attack;
  final double decay;
  final double sustain;
  final double release;
  final double volume;

  const SynthPreset({
    required this.id,
    required this.name,
    this.category = 'Lead',
    this.oscillator1Freq = 440.0,
    this.oscillator2Freq = 440.0,
    this.oscillator1Detune = 0.0,
    this.oscillator2Detune = 0.0,
    this.filterCutoff = 2000.0,
    this.filterResonance = 0.5,
    this.attack = 0.01,
    this.decay = 0.3,
    this.sustain = 0.5,
    this.release = 0.5,
    this.volume = 0.8,
  });

  SynthPreset copyWith({
    String? name,
    String? category,
    double? oscillator1Freq,
    double? oscillator2Freq,
    double? oscillator1Detune,
    double? oscillator2Detune,
    double? filterCutoff,
    double? filterResonance,
    double? attack,
    double? decay,
    double? sustain,
    double? release,
    double? volume,
  }) {
    return SynthPreset(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      oscillator1Freq: oscillator1Freq ?? this.oscillator1Freq,
      oscillator2Freq: oscillator2Freq ?? this.oscillator2Freq,
      oscillator1Detune: oscillator1Detune ?? this.oscillator1Detune,
      oscillator2Detune: oscillator2Detune ?? this.oscillator2Detune,
      filterCutoff: filterCutoff ?? this.filterCutoff,
      filterResonance: filterResonance ?? this.filterResonance,
      attack: attack ?? this.attack,
      decay: decay ?? this.decay,
      sustain: sustain ?? this.sustain,
      release: release ?? this.release,
      volume: volume ?? this.volume,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'oscillator1Freq': oscillator1Freq,
    'oscillator2Freq': oscillator2Freq,
    'oscillator1Detune': oscillator1Detune,
    'oscillator2Detune': oscillator2Detune,
    'filterCutoff': filterCutoff,
    'filterResonance': filterResonance,
    'attack': attack,
    'decay': decay,
    'sustain': sustain,
    'release': release,
    'volume': volume,
  };

  factory SynthPreset.fromJson(Map<String, dynamic> json) => SynthPreset(
    id: json['id'] as String,
    name: json['name'] as String,
    category: json['category'] as String? ?? 'Lead',
    oscillator1Freq: (json['oscillator1Freq'] as num).toDouble(),
    oscillator2Freq: (json['oscillator2Freq'] as num).toDouble(),
    oscillator1Detune: (json['oscillator1Detune'] as num?)?.toDouble() ?? 0.0,
    oscillator2Detune: (json['oscillator2Detune'] as num?)?.toDouble() ?? 0.0,
    filterCutoff: (json['filterCutoff'] as num?)?.toDouble() ?? 2000.0,
    filterResonance: (json['filterResonance'] as num?)?.toDouble() ?? 0.5,
    attack: (json['attack'] as num?)?.toDouble() ?? 0.01,
    decay: (json['decay'] as num?)?.toDouble() ?? 0.3,
    sustain: (json['sustain'] as num?)?.toDouble() ?? 0.5,
    release: (json['release'] as num?)?.toDouble() ?? 0.5,
    volume: (json['volume'] as num?)?.toDouble() ?? 0.8,
  );
}
