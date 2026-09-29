import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PresetManagerService {
  static const String _presetsDir = 'presets';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> savePreset(String name, Map<String, dynamic> preset) async {
    final path = await _localPath;
    final presetDir = Directory('$path/$_presetsDir');
    if (!await presetDir.exists()) {
      await presetDir.create(recursive: true);
    }

    final file = File('${presetDir.path}/$name.json');
    await file.writeAsString(jsonEncode(preset));
  }

  Future<List<String>> listPresets() async {
    final path = await _localPath;
    final presetDir = Directory('$path/$_presetsDir');
    if (!await presetDir.exists()) return [];

    final files = await presetDir.list().toList();
    return files
        .where((f) => f.path.endsWith('.json'))
        .map((f) => f.path.split('\\').last.replaceAll('.json', ''))
        .toList();
  }

  Future<Map<String, dynamic>?> loadPreset(String name) async {
    final path = await _localPath;
    final file = File('$path/$_presetsDir/$name.json');
    if (!await file.exists()) return null;

    return jsonDecode(await file.readAsString()) as Map<String, dynamic>;
  }

  Future<void> deletePreset(String name) async {
    final path = await _localPath;
    final file = File('$path/$_presetsDir/$name.json');
    if (await file.exists()) {
      await file.delete();
    }
  }
}
