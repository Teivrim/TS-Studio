import 'package:flutter/foundation.dart';

@immutable
class Loop {
  final String id;
  final String name;
  final int bpm;
  final int bars;
  final List<List<bool>> steps;
  final bool isBuiltIn;

  const Loop({
    required this.id,
    required this.name,
    this.bpm = 120,
    this.bars = 1,
    required this.steps,
    this.isBuiltIn = true,
  });

  Loop copyWith({
    String? name,
    int? bpm,
    int? bars,
    List<List<bool>>? steps,
  }) {
    return Loop(
      id: id,
      name: name ?? this.name,
      bpm: bpm ?? this.bpm,
      bars: bars ?? this.bars,
      steps: steps ?? this.steps,
      isBuiltIn: isBuiltIn,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'bpm': bpm,
    'bars': bars,
    'steps': steps,
    'isBuiltIn': isBuiltIn,
  };

  factory Loop.fromJson(Map<String, dynamic> json) => Loop(
    id: json['id'] as String,
    name: json['name'] as String,
    bpm: json['bpm'] as int? ?? 120,
    bars: json['bars'] as int? ?? 1,
    steps: (json['steps'] as List).map((row) => List<bool>.from(row as List)).toList(),
    isBuiltIn: json['isBuiltIn'] as bool? ?? true,
  );
}
