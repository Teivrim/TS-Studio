import '../models/sample_pack.dart';

class SamplePackService {
  static List<SamplePack> getBuiltInPacks() {
    return [
      SamplePack(
        id: 'pack_essentials',
        name: 'Essentials',
        category: 'Drums',
        description: 'Basic drum kit with kick, snare, hi-hat',
        sampleIds: ['kick', 'snare', 'hihat'],
      ),
      SamplePack(
        id: 'pack_percussion',
        name: 'Percussion',
        category: 'Percussion',
        description: 'Percussion instruments',
        sampleIds: ['clap', 'rim', 'perc'],
      ),
      SamplePack(
        id: 'pack_synth',
        name: 'Synth Collection',
        category: 'Synth',
        description: 'Synthesizer presets',
        sampleIds: ['synth', 'pad', 'lead', 'pluck'],
      ),
      SamplePack(
        id: 'pack_bass',
        name: 'Bass Pack',
        category: 'Bass',
        description: 'Bass sounds',
        sampleIds: ['bass'],
      ),
    ];
  }
}
