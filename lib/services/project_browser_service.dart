import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/project.dart';

class ProjectBrowserService {
  static const String _projectsDir = 'projects';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> saveProject(Project project) async {
    final path = await _localPath;
    final projectDir = Directory('$path/$_projectsDir');
    if (!await projectDir.exists()) {
      await projectDir.create(recursive: true);
    }

    final file = File('${projectDir.path}/${project.id}.json');
    final json = jsonEncode(project.toJson());
    await file.writeAsString(json);
  }

  Future<List<Project>> listProjects() async {
    final path = await _localPath;
    final projectDir = Directory('$path/$_projectsDir');
    if (!await projectDir.exists()) return [];

    final files = await projectDir.list().toList();
    final projects = <Project>[];

    for (final file in files) {
      if (file.path.endsWith('.json')) {
        try {
          final json = jsonDecode(await File(file.path).readAsString()) as Map<String, dynamic>;
          projects.add(Project.fromJson(json));
        } catch (_) {}
      }
    }

    projects.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
    return projects;
  }

  Future<Project?> loadProject(String id) async {
    final path = await _localPath;
    final file = File('$path/$_projectsDir/$id.json');
    if (!await file.exists()) return null;

    final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    return Project.fromJson(json);
  }

  Future<void> deleteProject(String id) async {
    final path = await _localPath;
    final file = File('$path/$_projectsDir/$id.json');
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> renameProject(String id, String newName) async {
    final project = await loadProject(id);
    if (project != null) {
      await saveProject(project.copyWith(
        name: newName,
        modifiedAt: DateTime.now(),
      ));
    }
  }
}
