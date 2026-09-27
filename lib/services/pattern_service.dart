import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/pattern.dart';

class PatternService {
  static const String _patternsDir = 'patterns';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> savePattern(Pattern pattern) async {
    final path = await _localPath;
    final patternDir = Directory('$path/$_patternsDir');
    if (!await patternDir.exists()) {
      await patternDir.create(recursive: true);
    }

    final file = File('${patternDir.path}/${pattern.id}.json');
    final json = jsonEncode(pattern.toJson());
    await file.writeAsString(json);
  }

  Future<List<Pattern>> listPatterns() async {
    final path = await _localPath;
    final patternDir = Directory('$path/$_patternsDir');
    if (!await patternDir.exists()) return [];

    final files = await patternDir.list().toList();
    final patterns = <Pattern>[];

    for (final file in files) {
      if (file.path.endsWith('.json')) {
        try {
          final json = jsonDecode(await File(file.path).readAsString()) as Map<String, dynamic>;
          patterns.add(Pattern.fromJson(json));
        } catch (_) {}
      }
    }

    return patterns;
  }

  Future<Pattern?> loadPattern(String id) async {
    final path = await _localPath;
    final file = File('$path/$_patternsDir/$id.json');
    if (!await file.exists()) return null;

    final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    return Pattern.fromJson(json);
  }

  Future<void> deletePattern(String id) async {
    final path = await _localPath;
    final file = File('$path/$_patternsDir/$id.json');
    if (await file.exists()) {
      await file.delete();
    }
  }
}
