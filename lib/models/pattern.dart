import 'package:flutter/foundation.dart';

@immutable
class Pattern {
  final String id;
  final String name;
  final List<List<bool>> steps;
  final int bpm;

  const Pattern({
    required this.id,
    required this.name,
    required this.steps,
    this.bpm = 120,
  });

  Pattern copyWith({
    String? name,
    List<List<bool>>? steps,
    int? bpm,
  }) {
    return Pattern(
      id: id,
      name: name ?? this.name,
      steps: steps ?? this.steps,
      bpm: bpm ?? this.bpm,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'steps': steps,
    'bpm': bpm,
  };

  factory Pattern.fromJson(Map<String, dynamic> json) => Pattern(
    id: json['id'] as String,
    name: json['name'] as String,
    steps: (json['steps'] as List).map((row) => List<bool>.from(row as List)).toList(),
    bpm: json['bpm'] as int,
  );
}

class Preset {
  final String id;
  final String name;
  final String category;
  final List<List<bool>> steps;
  final int bpm;

  const Preset({
    required this.id,
    required this.name,
    required this.category,
    required this.steps,
    this.bpm = 120,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'steps': steps,
    'bpm': bpm,
  };

  factory Preset.fromJson(Map<String, dynamic> json) => Preset(
    id: json['id'] as String,
    name: json['name'] as String,
    category: json['category'] as String,
    steps: (json['steps'] as List).map((row) => List<bool>.from(row as List)).toList(),
    bpm: json['bpm'] as int,
  );
}
