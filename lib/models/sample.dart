import 'package:flutter/foundation.dart';

@immutable
class Sample {
  final String id;
  final String name;
  final String filePath;
  final String category;
  final int bpm;
  final int key;
  final double duration;
  final bool isBuiltIn;

  const Sample({
    required this.id,
    required this.name,
    required this.filePath,
    this.category = 'Drums',
    this.bpm = 120,
    this.key = 0,
    this.duration = 0.0,
    this.isBuiltIn = true,
  });

  Sample copyWith({
    String? name,
    String? filePath,
    String? category,
    int? bpm,
    int? key,
    double? duration,
  }) {
    return Sample(
      id: id,
      name: name ?? this.name,
      filePath: filePath ?? this.filePath,
      category: category ?? this.category,
      bpm: bpm ?? this.bpm,
      key: key ?? this.key,
      duration: duration ?? this.duration,
      isBuiltIn: isBuiltIn,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'filePath': filePath,
    'category': category,
    'bpm': bpm,
    'key': key,
    'duration': duration,
    'isBuiltIn': isBuiltIn,
  };

  factory Sample.fromJson(Map<String, dynamic> json) => Sample(
    id: json['id'] as String,
    name: json['name'] as String,
    filePath: json['filePath'] as String,
    category: json['category'] as String? ?? 'Drums',
    bpm: json['bpm'] as int? ?? 120,
    key: json['key'] as int? ?? 0,
    duration: (json['duration'] as num?)?.toDouble() ?? 0.0,
    isBuiltIn: json['isBuiltIn'] as bool? ?? true,
  );
}
