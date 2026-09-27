import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/track.dart';
import '../services/audio_service.dart';
import '../services/project_service.dart';
import '../services/export_service.dart';
import '../theme/app_theme.dart';
import '../widgets/step_sequencer.dart';
import '../widgets/transport_controls.dart';
import '../widgets/effects_panel.dart';
import '../widgets/project_dialog.dart';

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(() => service.dispose());
  return service;
});

final projectServiceProvider = Provider<ProjectService>((ref) => ProjectService());

final exportServiceProvider = Provider<ExportService>((ref) {
  final audioService = ref.watch(audioServiceProvider);
  return ExportService(audioService);
});

final sequencerProvider = StateNotifierProvider<SequencerNotifier, SequencerState>((ref) {
  final audioService = ref.watch(audioServiceProvider);
  return SequencerNotifier(audioService);
});

class SequencerNotifier extends StateNotifier<SequencerState> {
  final AudioService _audioService;

  SequencerNotifier(this._audioService) : super(_initialState()) {
    _audioService.updateTracks(state.tracks);
    _audioService.stepStream.listen((step) {
      state = state.copyWith(currentStep: step);
    });
  }

  static SequencerState _initialState() {
    final tracks = [
      Track(id: '1', name: 'Kick', color: 0xFFE91E63, steps: List.filled(16, false), soundType: 'kick'),
      Track(id: '2', name: 'Snare', color: 0xFF9C27B0, steps: List.filled(16, false), soundType: 'snare'),
      Track(id: '3', name: 'Hi-Hat', color: 0xFF3F51B5, steps: List.filled(16, false), soundType: 'hihat'),
      Track(id: '4', name: 'Bass', color: 0xFF009688, steps: List.filled(16, false), soundType: 'bass'),
      Track(id: '5', name: 'Synth', color: 0xFFFF9800, steps: List.filled(16, false), soundType: 'synth'),
      Track(id: '6', name: 'Pad', color: 0xFF4CAF50, steps: List.filled(16, false), soundType: 'pad'),
      Track(id: '7', name: 'Lead', color: 0xFFE53935, steps: List.filled(16, false), soundType: 'lead'),
      Track(id: '8', name: 'Pluck', color: 0xFF8BC34A, steps: List.filled(16, false), soundType: 'pluck'),
    ];

    tracks[0].steps[0] = true;
    tracks[0].steps[4] = true;
    tracks[0].steps[8] = true;
    tracks[0].steps[12] = true;

    tracks[1].steps[4] = true;
    tracks[1].steps[12] = true;

    tracks[2].steps[0] = true;
    tracks[2].steps[2] = true;
    tracks[2].steps[4] = true;
    tracks[2].steps[6] = true;
    tracks[2].steps[8] = true;
    tracks[2].steps[10] = true;
    tracks[2].steps[12] = true;
    tracks[2].steps[14] = true;

    tracks[3].steps[0] = true;
    tracks[3].steps[3] = true;
    tracks[3].steps[6] = true;
    tracks[3].steps[10] = true;

    return SequencerState(tracks: tracks);
  }

  void toggleStep(int trackIndex, int stepIndex) {
    final newTracks = List<Track>.from(state.tracks);
    final track = newTracks[trackIndex];
    final newSteps = List<bool>.from(track.steps);
    newSteps[stepIndex] = !newSteps[stepIndex];
    newTracks[trackIndex] = track.copyWith(steps: newSteps);
    state = state.copyWith(tracks: newTracks);
    _audioService.updateTracks(newTracks);
  }

  void togglePlay() {
    _audioService.togglePlay();
    state = state.copyWith(isPlaying: _audioService.isPlaying);
  }

  void stop() {
    _audioService.stop();
    state = state.copyWith(isPlaying: false, currentStep: 0);
  }

  void setBpm(int bpm) {
    _audioService.updateBpm(bpm);
    state = state.copyWith(bpm: bpm);
  }

  void toggleMute(int trackIndex) {
    final newTracks = List<Track>.from(state.tracks);
    final track = newTracks[trackIndex];
    newTracks[trackIndex] = track.copyWith(muted: !track.muted);
    state = state.copyWith(tracks: newTracks);
    _audioService.updateTracks(newTracks);
  }

  void setTrackVolume(int trackIndex, double volume) {
    final newTracks = List<Track>.from(state.tracks);
    final track = newTracks[trackIndex];
    newTracks[trackIndex] = track.copyWith(volume: volume);
    state = state.copyWith(tracks: newTracks);
    _audioService.updateTracks(newTracks);
  }

  void setTrackPan(int trackIndex, double pan) {
    final newTracks = List<Track>.from(state.tracks);
    final track = newTracks[trackIndex];
    newTracks[trackIndex] = track.copyWith(pan: pan);
    state = state.copyWith(tracks: newTracks);
  }

  void setMasterVolume(double volume) {
    _audioService.updateMasterVolume(volume);
    state = state.copyWith(masterVolume: volume);
  }

  void setReverbMix(double mix) {
    state = state.copyWith(reverbMix: mix);
  }

  void setDelayMix(double mix) {
    state = state.copyWith(delayMix: mix);
  }

  void setDelayTime(double time) {
    state = state.copyWith(delayTime: time);
  }

  void clearAll() {
    final newTracks = state.tracks.map((track) {
      return track.copyWith(steps: List.filled(16, false));
    }).toList();
    state = state.copyWith(tracks: newTracks);
    _audioService.updateTracks(newTracks);
  }

  void loadState(SequencerState newState) {
    state = newState;
    _audioService.updateTracks(newState.tracks);
    _audioService.updateBpm(newState.bpm);
    _audioService.updateMasterVolume(newState.masterVolume);
  }
}

class SequencerScreen extends ConsumerWidget {
  const SequencerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sequencerProvider);
    final notifier = ref.read(sequencerProvider.notifier);
    final projectService = ref.read(projectServiceProvider);
    final exportService = ref.read(exportServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TS Studio',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.accentColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _showSaveDialog(context, ref, state),
            tooltip: 'Сохранить',
          ),
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: () => _showLoadDialog(context, ref, projectService, notifier),
            tooltip: 'Загрузить',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportProject(context, exportService, state),
            tooltip: 'Экспорт',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => notifier.clearAll(),
            tooltip: 'Очистить',
          ),
        ],
      ),
      body: Column(
        children: [
          TransportControls(
            isPlaying: state.isPlaying,
            bpm: state.bpm,
            onPlayPause: () => notifier.togglePlay(),
            onStop: () => notifier.stop(),
            onBpmChanged: (bpm) => notifier.setBpm(bpm),
          ),
          Expanded(
            child: StepSequencer(
              tracks: state.tracks,
              currentStep: state.currentStep,
              onStepToggle: (trackIndex, stepIndex) =>
                  notifier.toggleStep(trackIndex, stepIndex),
              onTrackMute: (trackIndex) => notifier.toggleMute(trackIndex),
              onTrackVolume: (trackIndex, volume) =>
                  notifier.setTrackVolume(trackIndex, volume),
              onTrackPan: (trackIndex, pan) =>
                  notifier.setTrackPan(trackIndex, pan),
            ),
          ),
          EffectsPanel(
            masterVolume: state.masterVolume,
            reverbMix: state.reverbMix,
            delayMix: state.delayMix,
            delayTime: state.delayTime,
            onMasterVolumeChanged: (v) => notifier.setMasterVolume(v),
            onReverbMixChanged: (v) => notifier.setReverbMix(v),
            onDelayMixChanged: (v) => notifier.setDelayMix(v),
            onDelayTimeChanged: (v) => notifier.setDelayTime(v),
          ),
        ],
      ),
    );
  }

  void _showSaveDialog(BuildContext context, WidgetRef ref, SequencerState state) {
    showDialog(
      context: context,
      builder: (context) => ProjectDialog(
        onSave: (name) async {
          final projectService = ref.read(projectServiceProvider);
          await projectService.saveProject(state, name);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Проект "$name" сохранён')),
            );
          }
        },
      ),
    );
  }

  void _showLoadDialog(
    BuildContext context,
    WidgetRef ref,
    ProjectService projectService,
    SequencerNotifier notifier,
  ) async {
    final projects = await projectService.listProjects();
    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Загрузить проект'),
        content: projects.isEmpty
            ? const Text('Нет сохранённых проектов')
            : SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(projects[index]),
                      onTap: () async {
                        final state = await projectService.loadProject(projects[index]);
                        if (state != null) {
                          notifier.loadState(state);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Проект "${projects[index]}" загружен')),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _exportProject(BuildContext context, ExportService exportService, SequencerState state) async {
    final path = await exportService.exportWav(
      state.tracks,
      state.bpm,
      masterVolume: state.masterVolume,
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(path != null ? 'Экспортировано: $path' : 'Ошибка экспорта'),
        ),
      );
    }
  }
}
