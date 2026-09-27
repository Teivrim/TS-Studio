import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/track.dart';
import 'audio_service.dart';

class ExportService {
  final AudioService _audioService;

  ExportService(this._audioService);

  Future<String?> exportWav(List<Track> tracks, int bpm, {double masterVolume = 0.8}) async {
    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) return null;

      final wavData = _audioService.generateWav(tracks, bpm, masterVolume: masterVolume);

      final directory = await getExternalStorageDirectory();
      if (directory == null) return null;

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/ts_studio_$timestamp.wav');
      await file.writeAsBytes(wavData);

      return file.path;
    } catch (e) {
      return null;
    }
  }

  Future<String?> exportMp3(List<Track> tracks, int bpm, {double masterVolume = 0.8}) async {
    return exportWav(tracks, bpm, masterVolume: masterVolume);
  }
}
