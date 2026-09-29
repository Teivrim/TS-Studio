import 'package:flutter/foundation.dart';

@immutable
class SamplePack {
  final String id;
  final String name;
  final String category;
  final String description;
  final List<String> sampleIds;
  final bool isBuiltIn;

  const SamplePack({
    required this.id,
    required this.name,
    this.category = 'Drums',
    this.description = '',
    this.sampleIds = const [],
    this.isBuiltIn = true,
  });

  SamplePack copyWith({
    String? name,
    String? category,
    String? description,
    List<String>? sampleIds,
  }) {
    return SamplePack(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      sampleIds: sampleIds ?? this.sampleIds,
      isBuiltIn: isBuiltIn,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'description': description,
    'sampleIds': sampleIds,
    'isBuiltIn': isBuiltIn,
  };

  factory SamplePack.fromJson(Map<String, dynamic> json) => SamplePack(
    id: json['id'] as String,
    name: json['name'] as String,
    category: json['category'] as String? ?? 'Drums',
    description: json['description'] as String? ?? '',
    sampleIds: List<String>.from(json['sampleIds'] as List? ?? []),
    isBuiltIn: json['isBuiltIn'] as bool? ?? true,
  );
}
