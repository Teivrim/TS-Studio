import 'package:flutter/foundation.dart';

@immutable
class EffectPreset {
  final String id;
  final String name;
  final String category;
  final double reverbMix;
  final double reverbSize;
  final double reverbDamping;
  final double delayMix;
  final double delayTime;
  final double delayFeedback;
  final double distortionAmount;
  final double distortionTone;
  final double chorusRate;
  final double chorusDepth;
  final double chorusMix;
  final double filterCutoff;
  final double filterResonance;
  final double filterType;

  const EffectPreset({
    required this.id,
    required this.name,
    this.category = 'Reverb',
    this.reverbMix = 0.3,
    this.reverbSize = 0.5,
    this.reverbDamping = 0.5,
    this.delayMix = 0.0,
    this.delayTime = 0.25,
    this.delayFeedback = 0.3,
    this.distortionAmount = 0.0,
    this.distortionTone = 0.5,
    this.chorusRate = 0.0,
    this.chorusDepth = 0.0,
    this.chorusMix = 0.0,
    this.filterCutoff = 1.0,
    this.filterResonance = 0.0,
    this.filterType = 0.0,
  });

  EffectPreset copyWith({
    String? name,
    String? category,
    double? reverbMix,
    double? reverbSize,
    double? reverbDamping,
    double? delayMix,
    double? delayTime,
    double? delayFeedback,
    double? distortionAmount,
    double? distortionTone,
    double? chorusRate,
    double? chorusDepth,
    double? chorusMix,
    double? filterCutoff,
    double? filterResonance,
    double? filterType,
  }) {
    return EffectPreset(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      reverbMix: reverbMix ?? this.reverbMix,
      reverbSize: reverbSize ?? this.reverbSize,
      reverbDamping: reverbDamping ?? this.reverbDamping,
      delayMix: delayMix ?? this.delayMix,
      delayTime: delayTime ?? this.delayTime,
      delayFeedback: delayFeedback ?? this.delayFeedback,
      distortionAmount: distortionAmount ?? this.distortionAmount,
      distortionTone: distortionTone ?? this.distortionTone,
      chorusRate: chorusRate ?? this.chorusRate,
      chorusDepth: chorusDepth ?? this.chorusDepth,
      chorusMix: chorusMix ?? this.chorusMix,
      filterCutoff: filterCutoff ?? this.filterCutoff,
      filterResonance: filterResonance ?? this.filterResonance,
      filterType: filterType ?? this.filterType,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'reverbMix': reverbMix,
    'reverbSize': reverbSize,
    'reverbDamping': reverbDamping,
    'delayMix': delayMix,
    'delayTime': delayTime,
    'delayFeedback': delayFeedback,
    'distortionAmount': distortionAmount,
    'distortionTone': distortionTone,
    'chorusRate': chorusRate,
    'chorusDepth': chorusDepth,
    'chorusMix': chorusMix,
    'filterCutoff': filterCutoff,
    'filterResonance': filterResonance,
    'filterType': filterType,
  };

  factory EffectPreset.fromJson(Map<String, dynamic> json) => EffectPreset(
    id: json['id'] as String,
    name: json['name'] as String,
    category: json['category'] as String? ?? 'Reverb',
    reverbMix: (json['reverbMix'] as num?)?.toDouble() ?? 0.3,
    reverbSize: (json['reverbSize'] as num?)?.toDouble() ?? 0.5,
    reverbDamping: (json['reverbDamping'] as num?)?.toDouble() ?? 0.5,
    delayMix: (json['delayMix'] as num?)?.toDouble() ?? 0.0,
    delayTime: (json['delayTime'] as num?)?.toDouble() ?? 0.25,
    delayFeedback: (json['delayFeedback'] as num?)?.toDouble() ?? 0.3,
    distortionAmount: (json['distortionAmount'] as num?)?.toDouble() ?? 0.0,
    distortionTone: (json['distortionTone'] as num?)?.toDouble() ?? 0.5,
    chorusRate: (json['chorusRate'] as num?)?.toDouble() ?? 0.0,
    chorusDepth: (json['chorusDepth'] as num?)?.toDouble() ?? 0.0,
    chorusMix: (json['chorusMix'] as num?)?.toDouble() ?? 0.0,
    filterCutoff: (json['filterCutoff'] as num?)?.toDouble() ?? 1.0,
    filterResonance: (json['filterResonance'] as num?)?.toDouble() ?? 0.0,
    filterType: (json['filterType'] as num?)?.toDouble() ?? 0.0,
  );
}
