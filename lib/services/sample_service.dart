import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/sample.dart';

class SampleService {
  static const String _samplesDir = 'samples';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> saveSample(Sample sample) async {
    final path = await _localPath;
    final sampleDir = Directory('$path/$_samplesDir');
    if (!await sampleDir.exists()) {
      await sampleDir.create(recursive: true);
    }

    final file = File('${sampleDir.path}/${sample.id}.json');
    final json = jsonEncode(sample.toJson());
    await file.writeAsString(json);
  }

  Future<List<Sample>> listSamples() async {
    final path = await _localPath;
    final sampleDir = Directory('$path/$_samplesDir');
    if (!await sampleDir.exists()) return [];

    final files = await sampleDir.list().toList();
    final samples = <Sample>[];

    for (final file in files) {
      if (file.path.endsWith('.json')) {
        try {
          final json = jsonDecode(await File(file.path).readAsString()) as Map<String, dynamic>;
          samples.add(Sample.fromJson(json));
        } catch (_) {}
      }
    }

    return samples;
  }

  Future<Sample?> loadSample(String id) async {
    final path = await _localPath;
    final file = File('$path/$_samplesDir/$id.json');
    if (!await file.exists()) return null;

    final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    return Sample.fromJson(json);
  }

  Future<void> deleteSample(String id) async {
    final path = await _localPath;
    final file = File('$path/$_samplesDir/$id.json');
    if (await file.exists()) {
      await file.delete();
    }
  }

  List<Sample> getBuiltInSamples() {
    return [
      Sample(id: 'kick', name: 'Kick', filePath: 'assets/samples/kick.wav', category: 'Drums'),
      Sample(id: 'snare', name: 'Snare', filePath: 'assets/samples/snare.wav', category: 'Drums'),
      Sample(id: 'hihat', name: 'Hi-Hat', filePath: 'assets/samples/hihat.wav', category: 'Drums'),
      Sample(id: 'bass', name: 'Bass', filePath: 'assets/samples/bass.wav', category: 'Bass'),
      Sample(id: 'synth', name: 'Synth', filePath: 'assets/samples/synth.wav', category: 'Synth'),
      Sample(id: 'pad', name: 'Pad', filePath: 'assets/samples/pad.wav', category: 'Pad'),
      Sample(id: 'lead', name: 'Lead', filePath: 'assets/samples/lead.wav', category: 'Lead'),
      Sample(id: 'pluck', name: 'Pluck', filePath: 'assets/samples/pluck.wav', category: 'Pluck'),
    ];
  }
}
