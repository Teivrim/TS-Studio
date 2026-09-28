import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SettingsService {
  static const String _settingsFile = 'settings.json';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<Map<String, dynamic>> loadSettings() async {
    try {
      final path = await _localPath;
      final file = File('$path/$_settingsFile');
      if (!await file.exists()) return _defaultSettings;

      final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      return json;
    } catch (_) {
      return _defaultSettings;
    }
  }

  Future<void> saveSettings(Map<String, dynamic> settings) async {
    try {
      final path = await _localPath;
      final file = File('$path/$_settingsFile');
      await file.writeAsString(jsonEncode(settings));
    } catch (_) {}
  }

  static const Map<String, dynamic> _defaultSettings = {
    'theme': 'dark',
    'accentColor': '#6366F1',
    'defaultBpm': 120,
    'metronomeEnabled': false,
    'countInEnabled': false,
    'swingAmount': 0.0,
    'quantize': '1/16',
    'audioBufferSize': 512,
    'sampleRate': 44100,
    'midiInputEnabled': false,
    'midiOutputEnabled': false,
  };
}
