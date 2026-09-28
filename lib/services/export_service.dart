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

  Future<String?> exportMidi(List<Track> tracks, int bpm) async {
    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) return null;

      final directory = await getExternalStorageDirectory();
      if (directory == null) return null;

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/ts_studio_$timestamp.mid');

      // Simple MIDI file generation
      final midiData = _generateMidiData(tracks, bpm);
      await file.writeAsBytes(midiData);

      return file.path;
    } catch (e) {
      return null;
    }
  }

  List<int> _generateMidiData(List<Track> tracks, int bpm) {
    // Simplified MIDI header
    final header = [
      0x4D, 0x54, 0x68, 0x64, // MThd
      0x00, 0x00, 0x00, 0x06, // Chunk size
      0x00, 0x00, // Format 0
      0x00, 0x01, // One track
      0x00, 0x60, // 96 ticks per quarter note
    ];

    // Track data
    final trackData = <int>[];

    // Tempo meta event
    final tempo = (60000000 / bpm).round();
    trackData.addAll([
      0x00, 0xFF, 0x51, 0x03,
      (tempo >> 16) & 0xFF,
      (tempo >> 8) & 0xFF,
      tempo & 0xFF,
    ]);

    // Note events
    for (int trackIndex = 0; trackIndex < tracks.length; trackIndex++) {
      final track = tracks[trackIndex];
      final channel = trackIndex;
      final note = 36 + trackIndex; // C1, C#1, D1, etc.

      for (int step = 0; step < 16; step++) {
        if (track.steps[step]) {
          // Note on
          trackData.addAll([
            0x00, // Delta time
            0x90 | channel, // Note on, channel
            note,
            100, // Velocity
          ]);

          // Note off (after 16th note)
          trackData.addAll([
            24, // Delta time
            0x80 | channel, // Note off, channel
            note,
            0,
          ]);
        }
      }
    }

    // End of track
    trackData.addAll([0x00, 0xFF, 0x2F, 0x00]);

    // Track chunk
    final trackHeader = [
      0x4D, 0x54, 0x72, 0x6B, // MTrk
      (trackData.length >> 24) & 0xFF,
      (trackData.length >> 16) & 0xFF,
      (trackData.length >> 8) & 0xFF,
      trackData.length & 0xFF,
    ];

    return [...header, ...trackHeader, ...trackData];
  }
}
