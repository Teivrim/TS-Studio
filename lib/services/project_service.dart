import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/track.dart';

class ProjectService {
  static const String _projectsDir = 'projects';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> saveProject(SequencerState state, String name) async {
    final path = await _localPath;
    final projectDir = Directory('$path/$_projectsDir');
    if (!await projectDir.exists()) {
      await projectDir.create(recursive: true);
    }

    final file = File('${projectDir.path}/$name.json');
    final json = jsonEncode({
      'name': name,
      'createdAt': DateTime.now().toIso8601String(),
      ...state.toJson(),
    });
    await file.writeAsString(json);
  }

  Future<List<String>> listProjects() async {
    final path = await _localPath;
    final projectDir = Directory('$path/$_projectsDir');
    if (!await projectDir.exists()) return [];

    final files = await projectDir.list().toList();
    return files
        .where((f) => f.path.endsWith('.json'))
        .map((f) => f.path.split('\\').last.replaceAll('.json', ''))
        .toList();
  }

  Future<SequencerState?> loadProject(String name) async {
    final path = await _localPath;
    final file = File('$path/$_projectsDir/$name.json');
    if (!await file.exists()) return null;

    final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    return SequencerState.fromJson(json);
  }

  Future<void> deleteProject(String name) async {
    final path = await _localPath;
    final file = File('$path/$_projectsDir/$name.json');
    if (await file.exists()) {
      await file.delete();
    }
  }
}
