import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/track.dart';
import '../services/audio_service.dart';
import '../theme/app_theme.dart';
import '../widgets/step_sequencer.dart';
import '../widgets/transport_controls.dart';
import '../widgets/track_header.dart';

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(() => service.dispose());
  return service;
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
      Track(id: '1', name: 'Kick', color: 0xFFE91E63, steps: List.filled(16, false)),
      Track(id: '2', name: 'Snare', color: 0xFF9C27B0, steps: List.filled(16, false)),
      Track(id: '3', name: 'Hi-Hat', color: 0xFF3F51B5, steps: List.filled(16, false)),
      Track(id: '4', name: 'Bass', color: 0xFF009688, steps: List.filled(16, false)),
      Track(id: '5', name: 'Synth', color: 0xFFFF9800, steps: List.filled(16, false)),
      Track(id: '6', name: 'Pad', color: 0xFF4CAF50, steps: List.filled(16, false)),
    ];

    // Pre-fill some steps for a demo pattern
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

  void clearAll() {
    final newTracks = state.tracks.map((track) {
      return track.copyWith(steps: List.filled(16, false));
    }).toList();
    state = state.copyWith(tracks: newTracks);
    _audioService.updateTracks(newTracks);
  }
}

class SequencerScreen extends ConsumerWidget {
  const SequencerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sequencerProvider);
    final notifier = ref.read(sequencerProvider.notifier);

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
            ),
          ),
        ],
      ),
    );
  }
}
