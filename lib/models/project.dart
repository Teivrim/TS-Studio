import 'package:flutter/foundation.dart';

@immutable
class Project {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final int bpm;
  final int trackCount;
  final int stepCount;
  final String? thumbnailPath;

  const Project({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.modifiedAt,
    this.bpm = 120,
    this.trackCount = 8,
    this.stepCount = 16,
    this.thumbnailPath,
  });

  Project copyWith({
    String? name,
    DateTime? createdAt,
    DateTime? modifiedAt,
    int? bpm,
    int? trackCount,
    int? stepCount,
    String? thumbnailPath,
  }) {
    return Project(
      id: id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      bpm: bpm ?? this.bpm,
      trackCount: trackCount ?? this.trackCount,
      stepCount: stepCount ?? this.stepCount,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'createdAt': createdAt.toIso8601String(),
    'modifiedAt': modifiedAt.toIso8601String(),
    'bpm': bpm,
    'trackCount': trackCount,
    'stepCount': stepCount,
    'thumbnailPath': thumbnailPath,
  };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json['id'] as String,
    name: json['name'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    modifiedAt: DateTime.parse(json['modifiedAt'] as String),
    bpm: json['bpm'] as int? ?? 120,
    trackCount: json['trackCount'] as int? ?? 8,
    stepCount: json['stepCount'] as int? ?? 16,
    thumbnailPath: json['thumbnailPath'] as String?,
  );
}
