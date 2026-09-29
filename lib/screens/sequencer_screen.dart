import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/track.dart';
import '../models/pattern.dart';
import '../services/audio_service.dart';
import '../services/project_service.dart';
import '../services/export_service.dart';
import '../services/recording_service.dart';
import '../services/pattern_service.dart';
import '../services/history_service.dart';
import '../services/mixer_service.dart';
import '../services/randomizer_service.dart';
import '../services/metronome_service.dart';
import '../services/sample_service.dart';
import '../services/automation_service.dart';
import '../services/project_browser_service.dart';
import '../services/spectrum_service.dart';
import '../services/settings_service.dart';
import '../services/synth_service.dart';
import '../services/midi_service.dart';
import '../services/effect_service.dart';
import '../services/loop_service.dart';
import '../services/waveform_service.dart';
import '../services/sample_pack_service.dart';
import '../theme/app_theme.dart';
import '../widgets/modern_step_sequencer.dart';
import '../widgets/modern_transport.dart';
import '../widgets/modern_effects_panel.dart';
import '../widgets/modern_metronome.dart';
import '../widgets/modern_app_bar.dart';
import '../widgets/project_dialog.dart';
import '../widgets/pattern_dialog.dart';
import '../widgets/preset_dialog.dart';
import '../widgets/mixer_screen.dart';
import '../widgets/randomizer_dialog.dart';
import '../widgets/sample_manager_screen.dart';
import '../widgets/automation_screen.dart';
import '../widgets/piano_roll_screen.dart';
import '../widgets/tap_tempo_button.dart';
import '../widgets/project_browser_screen.dart';
import '../widgets/settings_screen.dart';
import '../widgets/export_dialog.dart';
import '../widgets/synth_screen.dart';
import '../widgets/midi_monitor_screen.dart';
import '../widgets/effect_browser_screen.dart';
import '../widgets/realtime_spectrum.dart';
import '../widgets/chord_progression_screen.dart';
import '../widgets/drum_pad_screen.dart';
import '../widgets/loop_browser_screen.dart';
import '../widgets/waveform_editor_screen.dart';
import '../widgets/sample_pack_browser.dart';
import '../widgets/master_section_screen.dart';
import '../widgets/tempo_tapper_screen.dart';
import '../widgets/about_screen.dart';

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

final recordingServiceProvider = Provider<RecordingService>((ref) {
  final service = RecordingService();
  ref.onDispose(() => service.dispose());
  return service;
});

final patternServiceProvider = Provider<PatternService>((ref) => PatternService());

final historyServiceProvider = Provider<HistoryService>((ref) => HistoryService());

final mixerServiceProvider = Provider<MixerService>((ref) => MixerService());

final randomizerServiceProvider = Provider<RandomizerService>((ref) => RandomizerService());

final metronomeServiceProvider = Provider<MetronomeService>((ref) {
  final service = MetronomeService();
  ref.onDispose(() => service.dispose());
  return service;
});

final sampleServiceProvider = Provider<SampleService>((ref) => SampleService());

final automationServiceProvider = Provider<AutomationService>((ref) {
  final service = AutomationService();
  ref.onDispose(() => service.dispose());
  return service;
});

final projectBrowserServiceProvider = Provider<ProjectBrowserService>((ref) => ProjectBrowserService());

final spectrumServiceProvider = Provider<SpectrumService>((ref) {
  final service = SpectrumService();
  ref.onDispose(() => service.dispose());
  return service;
});

final settingsServiceProvider = Provider<SettingsService>((ref) => SettingsService());

final synthServiceProvider = Provider<SynthService>((ref) => SynthService());

final midiServiceProvider = Provider<MidiService>((ref) {
  final service = MidiService();
  ref.onDispose(() => service.dispose());
  return service;
});

final effectServiceProvider = Provider<EffectService>((ref) => EffectService());

final loopServiceProvider = Provider<LoopService>((ref) => LoopService());

final waveformServiceProvider = Provider<WaveformService>((ref) => WaveformService());

final samplePackServiceProvider = Provider<SamplePackService>((ref) => SamplePackService());

final sequencerProvider = StateNotifierProvider<SequencerNotifier, SequencerState>((ref) {
  final audioService = ref.watch(audioServiceProvider);
  return SequencerNotifier(audioService);
});

class SequencerNotifier extends StateNotifier<SequencerState> {
  final AudioService _audioService;
  final HistoryService _history = HistoryService();

  SequencerNotifier(this._audioService) : super(_initialState()) {
    _audioService.updateTracks(state.tracks);
    _audioService.stepStream.listen((step) {
      state = state.copyWith(currentStep: step);
    });
    _history.pushState(state);
  }

  static SequencerState _initialState() {
    final tracks = [
      Track(id: '1', name: 'Kick', color: 0xFFE91E63, steps: List.filled(16, false), sampleFile: 'kick.wav', soundType: 'kick'),
      Track(id: '2', name: 'Snare', color: 0xFF9C27B0, steps: List.filled(16, false), sampleFile: 'snare.wav', soundType: 'snare'),
      Track(id: '3', name: 'Hi-Hat', color: 0xFF3F51B5, steps: List.filled(16, false), sampleFile: 'hihat.wav', soundType: 'hihat'),
      Track(id: '4', name: 'Bass', color: 0xFF009688, steps: List.filled(16, false), sampleFile: 'bass.wav', soundType: 'bass'),
      Track(id: '5', name: 'Synth', color: 0xFFFF9800, steps: List.filled(16, false), sampleFile: 'synth.wav', soundType: 'synth'),
      Track(id: '6', name: 'Pad', color: 0xFF4CAF50, steps: List.filled(16, false), sampleFile: 'pad.wav', soundType: 'pad'),
      Track(id: '7', name: 'Lead', color: 0xFFE53935, steps: List.filled(16, false), sampleFile: 'lead.wav', soundType: 'lead'),
      Track(id: '8', name: 'Pluck', color: 0xFF8BC34A, steps: List.filled(16, false), sampleFile: 'pluck.wav', soundType: 'pluck'),
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
    _history.pushState(state);
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
    _history.pushState(state);
  }

  void toggleMute(int trackIndex) {
    final newTracks = List<Track>.from(state.tracks);
    final track = newTracks[trackIndex];
    newTracks[trackIndex] = track.copyWith(muted: !track.muted);
    state = state.copyWith(tracks: newTracks);
    _audioService.updateTracks(newTracks);
    _history.pushState(state);
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

  void setEqLow(double value) {
    state = state.copyWith(eqLow: value);
  }

  void setEqMid(double value) {
    state = state.copyWith(eqMid: value);
  }

  void setEqHigh(double value) {
    state = state.copyWith(eqHigh: value);
  }

  void setDistortion(double value) {
    state = state.copyWith(distortion: value);
  }

  void setChorus(double value) {
    state = state.copyWith(chorus: value);
  }

  void setFilterCutoff(double value) {
    state = state.copyWith(filterCutoff: value);
  }

  void clearAll() {
    final newTracks = state.tracks.map((track) {
      return track.copyWith(steps: List.filled(16, false));
    }).toList();
    state = state.copyWith(tracks: newTracks);
    _audioService.updateTracks(newTracks);
    _history.pushState(state);
  }

  void loadState(SequencerState newState) {
    state = newState;
    _audioService.updateTracks(newState.tracks);
    _audioService.updateBpm(newState.bpm);
    _audioService.updateMasterVolume(newState.masterVolume);
    _history.pushState(state);
  }

  void setRecordingState(bool isRecording, String? path) {
    state = state.copyWith(isRecording: isRecording, recordingPath: path);
  }

  void undo() {
    final previousState = _history.undo();
    if (previousState != null) {
      state = previousState;
      _audioService.updateTracks(state.tracks);
      _audioService.updateBpm(state.bpm);
    }
  }

  void redo() {
    final nextState = _history.redo();
    if (nextState != null) {
      state = nextState;
      _audioService.updateTracks(state.tracks);
      _audioService.updateBpm(state.bpm);
    }
  }

  bool get canUndo => _history.canUndo;
  bool get canRedo => _history.canRedo;

  void applyPreset(Preset preset) {
    final newTracks = List<Track>.from(state.tracks);
    for (int i = 0; i < newTracks.length && i < preset.steps.length; i++) {
      newTracks[i] = newTracks[i].copyWith(steps: List<bool>.from(preset.steps[i]));
    }
    state = state.copyWith(tracks: newTracks, bpm: preset.bpm);
    _audioService.updateTracks(newTracks);
    _audioService.updateBpm(preset.bpm);
    _history.pushState(state);
  }

  void applyPattern(Pattern pattern) {
    final newTracks = List<Track>.from(state.tracks);
    for (int i = 0; i < newTracks.length && i < pattern.steps.length; i++) {
      newTracks[i] = newTracks[i].copyWith(steps: List<bool>.from(pattern.steps[i]));
    }
    state = state.copyWith(tracks: newTracks, bpm: pattern.bpm);
    _audioService.updateTracks(newTracks);
    _audioService.updateBpm(pattern.bpm);
    _history.pushState(state);
  }

  void applyRandomPattern(List<Track> newTracks) {
    state = state.copyWith(tracks: newTracks);
    _audioService.updateTracks(newTracks);
    _history.pushState(state);
  }

  List<Track> getTracks() => state.tracks;
}

class SequencerScreen extends ConsumerStatefulWidget {
  const SequencerScreen({super.key});

  @override
  ConsumerState<SequencerScreen> createState() => _SequencerScreenState();
}

class _SequencerScreenState extends ConsumerState<SequencerScreen> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final notifier = ref.read(sequencerProvider.notifier);
    final state = ref.read(sequencerProvider);

    if (event.logicalKey == LogicalKeyboardKey.space) {
      notifier.togglePlay();
    } else if (event.logicalKey == LogicalKeyboardKey.keyZ && HardwareKeyboard.instance.isControlPressed) {
      notifier.undo();
    } else if (event.logicalKey == LogicalKeyboardKey.keyY && HardwareKeyboard.instance.isControlPressed) {
      notifier.redo();
    } else if (event.logicalKey == LogicalKeyboardKey.keyS && HardwareKeyboard.instance.isControlPressed) {
      _showSaveDialog(context, ref, state);
    } else if (event.logicalKey == LogicalKeyboardKey.keyO && HardwareKeyboard.instance.isControlPressed) {
      _showLoadDialog(context, ref, ref.read(projectServiceProvider), notifier);
    } else if (event.logicalKey == LogicalKeyboardKey.keyE && HardwareKeyboard.instance.isControlPressed) {
      _showExportDialog(context, ref, state);
    } else if (event.logicalKey == LogicalKeyboardKey.keyM) {
      _toggleMetronome(ref);
    } else if (event.logicalKey == LogicalKeyboardKey.keyC) {
      notifier.clearAll();
    } else if (event.logicalKey == LogicalKeyboardKey.digit1) {
      notifier.toggleMute(0);
    } else if (event.logicalKey == LogicalKeyboardKey.digit2) {
      notifier.toggleMute(1);
    } else if (event.logicalKey == LogicalKeyboardKey.digit3) {
      notifier.toggleMute(2);
    } else if (event.logicalKey == LogicalKeyboardKey.digit4) {
      notifier.toggleMute(3);
    } else if (event.logicalKey == LogicalKeyboardKey.digit5) {
      notifier.toggleMute(4);
    } else if (event.logicalKey == LogicalKeyboardKey.digit6) {
      notifier.toggleMute(5);
    } else if (event.logicalKey == LogicalKeyboardKey.digit7) {
      notifier.toggleMute(6);
    } else if (event.logicalKey == LogicalKeyboardKey.digit8) {
      notifier.toggleMute(7);
    }
  }

  void _toggleMetronome(WidgetRef ref) {
    final metronomeService = ref.read(metronomeServiceProvider);
    final state = ref.read(sequencerProvider);
    metronomeService.toggle(bpm: state.bpm);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sequencerProvider);
    final notifier = ref.read(sequencerProvider.notifier);
    final projectService = ref.read(projectServiceProvider);
    final recordingService = ref.read(recordingServiceProvider);
    final patternService = ref.read(patternServiceProvider);
    final mixerService = ref.read(mixerServiceProvider);
    final randomizerService = ref.read(randomizerServiceProvider);
    final metronomeService = ref.watch(metronomeServiceProvider);
    final sampleService = ref.read(sampleServiceProvider);
    final automationService = ref.read(automationServiceProvider);
    final projectBrowserService = ref.read(projectBrowserServiceProvider);
    final spectrumService = ref.watch(spectrumServiceProvider);
    final settingsService = ref.read(settingsServiceProvider);
    final midiService = ref.read(midiServiceProvider);

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: ModernAppBar(
          onSave: () => _showSaveDialog(context, ref, state),
          onLoad: () => _showLoadDialog(context, ref, projectService, notifier),
          onExport: () => _showExportDialog(context, ref, state),
          onPresets: () => _showPresetDialog(context, ref, notifier),
          onPatterns: () => _showPatternDialog(context, ref, patternService, notifier),
          onRandomizer: () => _showRandomizerDialog(context, ref, randomizerService, notifier),
          onMixer: () => _openMixer(context, ref, mixerService, state),
          onClear: () => notifier.clearAll(),
          onUndo: () => notifier.undo(),
          onRedo: () => notifier.redo(),
          canUndo: notifier.canUndo,
          canRedo: notifier.canRedo,
        ),
        body: Column(
          children: [
            ModernTransport(
              isPlaying: state.isPlaying,
              bpm: state.bpm,
              onPlayPause: () => notifier.togglePlay(),
              onStop: () => notifier.stop(),
              onBpmChanged: (bpm) => notifier.setBpm(bpm),
              isRecording: state.isRecording,
              onRecordToggle: () => _toggleRecording(context, ref, recordingService, notifier),
            ),
            ModernMetronome(
              currentBeat: metronomeService.currentBeat,
              isPlaying: metronomeService.isPlaying,
              onToggle: () => _toggleMetronome(ref),
            ),
            // BPM and Spectrum
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  const Text(
                    'BPM:',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textSecondary,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Slider(
                      value: state.bpm.toDouble(),
                      min: 60,
                      max: 200,
                      divisions: 140,
                      activeColor: AppTheme.primaryColor,
                      inactiveColor: AppTheme.gridColor,
                      onChanged: (value) => notifier.setBpm(value.round()),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: AppTheme.modernButtonDecoration(
                      color: AppTheme.surfaceLightColor,
                      borderRadius: 12,
                    ),
                    child: Text(
                      '${state.bpm}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.accentColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TapTempoButton(
                    onBpmChanged: (bpm) => notifier.setBpm(bpm),
                  ),
                ],
              ),
            ),
            // Spectrum
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              height: 60,
              child: RealtimeSpectrum(
                spectrumService: spectrumService,
                height: 60,
              ),
            ),
            Expanded(
              child: ModernStepSequencer(
                tracks: state.tracks,
                currentStep: state.currentStep,
                onStepToggle: (trackIndex, stepIndex) =>
                    notifier.toggleStep(trackIndex, stepIndex),
                onTrackMute: (trackIndex) => notifier.toggleMute(trackIndex),
                onTrackVolume: (trackIndex, volume) =>
                    notifier.setTrackVolume(trackIndex, volume),
              ),
            ),
            ModernEffectsPanel(
              masterVolume: state.masterVolume,
              reverbMix: state.reverbMix,
              delayMix: state.delayMix,
              delayTime: state.delayTime,
              eqLow: state.eqLow,
              eqMid: state.eqMid,
              eqHigh: state.eqHigh,
              distortion: state.distortion,
              chorus: state.chorus,
              filterCutoff: state.filterCutoff,
              onMasterVolumeChanged: (v) => notifier.setMasterVolume(v),
              onReverbMixChanged: (v) => notifier.setReverbMix(v),
              onDelayMixChanged: (v) => notifier.setDelayMix(v),
              onDelayTimeChanged: (v) => notifier.setDelayTime(v),
              onEqLowChanged: (v) => notifier.setEqLow(v),
              onEqMidChanged: (v) => notifier.setEqMid(v),
              onEqHighChanged: (v) => notifier.setEqHigh(v),
              onDistortionChanged: (v) => notifier.setDistortion(v),
              onChorusChanged: (v) => notifier.setChorus(v),
              onFilterCutoffChanged: (v) => notifier.setFilterCutoff(v),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: 'projects',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProjectBrowserScreen(
                    projectBrowserService: projectBrowserService,
                    onProjectSelected: (project) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Проект "${project.name}" выбран')),
                      );
                    },
                  ),
                ),
              ),
              backgroundColor: AppTheme.secondaryColor,
              child: const Icon(Icons.folder_open_rounded, color: Colors.white),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'synth',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SynthScreen(
                    onPresetSelected: (preset) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Пресет "${preset.name}" выбран')),
                      );
                    },
                  ),
                ),
              ),
              backgroundColor: AppTheme.primaryColor,
              child: const Icon(Icons.piano_rounded, color: Colors.white),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'effects',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EffectBrowserScreen(
                    onPresetSelected: (preset) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Эффект "${preset.name}" выбран')),
                      );
                    },
                  ),
                ),
              ),
              backgroundColor: AppTheme.accentColor,
              child: const Icon(Icons.tune_rounded, color: Colors.white),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'drums',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DrumPadScreen(
                    onPadHit: (padName) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Пэд "$padName" нажат')),
                      );
                    },
                  ),
                ),
              ),
              backgroundColor: AppTheme.successColor,
              child: const Icon(Icons.music_note_rounded, color: Colors.white),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'chords',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChordProgressionScreen(
                    onProgressionSelected: (progression) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Прогрессия: ${progression.join(' - ')}')),
                      );
                    },
                  ),
                ),
              ),
              backgroundColor: AppTheme.warningColor,
              child: const Icon(Icons.queue_music_rounded, color: Colors.white),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'loops',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LoopBrowserScreen(
                    onLoopSelected: (loop) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Луп "${loop.name}" выбран')),
                      );
                    },
                  ),
                ),
              ),
              backgroundColor: AppTheme.dangerColor,
              child: const Icon(Icons.loop_rounded, color: Colors.white),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'waveform',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => WaveformEditorScreen(),
                ),
              ),
              backgroundColor: AppTheme.textSecondary,
              child: const Icon(Icons.waves_rounded, color: Colors.white),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'packs',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SamplePackBrowser(
                    onPackSelected: (pack) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Пак "${pack.name}" выбран')),
                      );
                    },
                  ),
                ),
              ),
              backgroundColor: AppTheme.textMuted,
              child: const Icon(Icons.folder_rounded, color: Colors.white),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'master',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MasterSectionScreen(
                    masterVolume: state.masterVolume,
                    reverbMix: state.reverbMix,
                    delayMix: state.delayMix,
                    onMasterVolumeChanged: (v) => notifier.setMasterVolume(v),
                    onReverbMixChanged: (v) => notifier.setReverbMix(v),
                    onDelayMixChanged: (v) => notifier.setDelayMix(v),
                  ),
                ),
              ),
              backgroundColor: AppTheme.borderColor,
              child: const Icon(Icons.volume_up_rounded, color: Colors.white),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'tempo',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TempoTapperScreen(
                    onBpmChanged: (bpm) => notifier.setBpm(bpm),
                  ),
                ),
              ),
              backgroundColor: AppTheme.textSecondary,
              child: const Icon(Icons.timer_rounded, color: Colors.white),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'midi',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MidiMonitorScreen(
                    midiService: midiService,
                  ),
                ),
              ),
              backgroundColor: AppTheme.textMuted,
              child: const Icon(Icons.usb_rounded, color: Colors.white),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'samples',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SampleManagerScreen(
                    sampleService: sampleService,
                    onSampleSelected: (sample) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Сэмпл "${sample.name}" выбран')),
                      );
                    },
                  ),
                ),
              ),
              backgroundColor: AppTheme.borderColor,
              child: const Icon(Icons.library_music_rounded, color: Colors.white),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'automation',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AutomationScreen(
                    automationService: automationService,
                  ),
                ),
              ),
              backgroundColor: AppTheme.textMuted,
              child: const Icon(Icons.trending_up_rounded, color: Colors.white),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'piano',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PianoRollScreen(
                    bpm: state.bpm,
                    onBpmChanged: (bpm) => notifier.setBpm(bpm),
                  ),
                ),
              ),
              backgroundColor: AppTheme.borderColor,
              child: const Icon(Icons.piano_rounded, color: Colors.white),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'settings',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    settingsService: settingsService,
                    onSettingsChanged: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Настройки сохранены')),
                      );
                    },
                  ),
                ),
              ),
              backgroundColor: AppTheme.textSecondary,
              child: const Icon(Icons.settings_rounded, color: Colors.white),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'about',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              ),
              backgroundColor: AppTheme.textMuted,
              child: const Icon(Icons.info_outline_rounded, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _openMixer(BuildContext context, WidgetRef ref, MixerService mixerService, SequencerState state) {
    mixerService.initializeChannels(state.tracks);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MixerScreen(
          channels: mixerService.channels,
          onVolumeChanged: (id, v) => mixerService.setVolume(id, v),
          onPanChanged: (id, p) => mixerService.setPan(id, p),
          onMuteToggle: (id) => () => mixerService.toggleMute(id),
          onSoloToggle: (id) => () => mixerService.toggleSolo(id),
          onEqChanged: (id, l, m, h) => mixerService.setEq(id, low: l, mid: m, high: h),
          onReverbSendChanged: (id, s) => mixerService.setReverbSend(id, s),
          onDelaySendChanged: (id, s) => mixerService.setDelaySend(id, s),
          onDistortionChanged: (id, v) => mixerService.setDistortion(id, v),
          onChorusChanged: (id, v) => mixerService.setChorus(id, v),
          onFilterChanged: (id, c, r) => mixerService.setFilter(id, cutoff: c, resonance: r),
          onLfoChanged: (id, r, d, t) => mixerService.setLfo(id, rate: r, depth: d, target: t),
        ),
      ),
    );
  }

  void _toggleRecording(BuildContext context, WidgetRef ref, RecordingService recordingService, SequencerNotifier notifier) async {
    if (recordingService.isRecording) {
      final path = await recordingService.stopRecording();
      notifier.setRecordingState(false, path);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Запись сохранена: $path')),
        );
      }
    } else {
      final path = await recordingService.startRecording();
      notifier.setRecordingState(true, path);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Запись началась...')),
        );
      }
    }
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

  void _showExportDialog(BuildContext context, WidgetRef ref, SequencerState state) {
    showDialog(
      context: context,
      builder: (context) => ExportDialog(
        onExport: (format) async {
          final exportService = ref.read(exportServiceProvider);
          String? path;
          if (format == 'WAV') {
            path = await exportService.exportWav(
              state.tracks,
              state.bpm,
              masterVolume: state.masterVolume,
            );
          } else if (format == 'MP3') {
            path = await exportService.exportMp3(
              state.tracks,
              state.bpm,
              masterVolume: state.masterVolume,
            );
          } else if (format == 'MIDI') {
            path = await exportService.exportMidi(state.tracks, state.bpm);
          }
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(path != null ? 'Экспортировано: $path' : 'Ошибка экспорта'),
              ),
            );
          }
        },
      ),
    );
  }

  void _showPresetDialog(BuildContext context, WidgetRef ref, SequencerNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => PresetDialog(
        onSelect: (preset) {
          notifier.applyPreset(preset);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Пресет "${preset.name}" применён')),
          );
        },
      ),
    );
  }

  void _showPatternDialog(BuildContext context, WidgetRef ref, PatternService patternService, SequencerNotifier notifier) async {
    final patterns = await patternService.listPatterns();
    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Паттерны'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: patterns.isEmpty
              ? const Text('Нет сохранённых паттернов')
              : ListView.builder(
                  itemCount: patterns.length,
                  itemBuilder: (context, index) {
                    final pattern = patterns[index];
                    return ListTile(
                      title: Text(pattern.name),
                      subtitle: Text('${pattern.bpm} BPM'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.play_arrow_rounded),
                            onPressed: () {
                              notifier.applyPattern(pattern);
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Паттерн "${pattern.name}" применён')),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded),
                            onPressed: () async {
                              await patternService.deletePattern(pattern.id);
                              if (context.mounted) {
                                Navigator.of(context).pop();
                                _showPatternDialog(context, ref, patternService, notifier);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showNewPatternDialog(context, ref, patternService, notifier);
            },
            child: const Text('Новый паттерн'),
          ),
        ],
      ),
    );
  }

  void _showNewPatternDialog(BuildContext context, WidgetRef ref, PatternService patternService, SequencerNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => PatternDialog(
        onSave: (pattern) async {
          await patternService.savePattern(pattern);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Паттерн "${pattern.name}" сохранён')),
            );
          }
        },
      ),
    );
  }

  void _showRandomizerDialog(BuildContext context, WidgetRef ref, RandomizerService randomizerService, SequencerNotifier notifier) {
    final tracks = notifier.getTracks();
    showDialog(
      context: context,
      builder: (context) => RandomizerDialog(
        onRandomPattern: () {
          final newTracks = randomizerService.generateRandomPattern(tracks);
          notifier.applyRandomPattern(newTracks);
        },
        onRandomKick: () {
          final newTracks = randomizerService.generateKickPattern(tracks);
          notifier.applyRandomPattern(newTracks);
        },
        onRandomSnare: () {
          final newTracks = randomizerService.generateSnarePattern(tracks);
          notifier.applyRandomPattern(newTracks);
        },
        onRandomHiHat: () {
          final newTracks = randomizerService.generateHiHatPattern(tracks);
          notifier.applyRandomPattern(newTracks);
        },
        onRandomBass: () {
          final newTracks = randomizerService.generateBassPattern(tracks);
          notifier.applyRandomPattern(newTracks);
        },
        onRandomMelodic: () {
          final newTracks = randomizerService.generateMelodicPattern(tracks);
          notifier.applyRandomPattern(newTracks);
        },
        onRandomFull: () {
          final newTracks = randomizerService.generateFullPattern(tracks);
          notifier.applyRandomPattern(newTracks);
        },
        onShuffle: () {
          final newTracks = randomizerService.shuffleSteps(tracks);
          notifier.applyRandomPattern(newTracks);
        },
        onInvert: () {
          final newTracks = randomizerService.invertSteps(tracks);
          notifier.applyRandomPattern(newTracks);
        },
        onShiftLeft: () {
          final newTracks = randomizerService.shiftSteps(tracks, -1);
          notifier.applyRandomPattern(newTracks);
        },
        onShiftRight: () {
          final newTracks = randomizerService.shiftSteps(tracks, 1);
          notifier.applyRandomPattern(newTracks);
        },
      ),
    );
  }
}
