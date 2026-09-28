import '../models/effect_preset.dart';

class EffectService {
  static List<EffectPreset> getPresets() {
    return [
      // Reverb presets
      EffectPreset(
        id: 'reverb_hall',
        name: 'Concert Hall',
        category: 'Reverb',
        reverbMix: 0.5,
        reverbSize: 0.8,
        reverbDamping: 0.3,
      ),
      EffectPreset(
        id: 'reverb_room',
        name: 'Small Room',
        category: 'Reverb',
        reverbMix: 0.3,
        reverbSize: 0.3,
        reverbDamping: 0.6,
      ),
      EffectPreset(
        id: 'reverb_plate',
        name: 'Plate Reverb',
        category: 'Reverb',
        reverbMix: 0.4,
        reverbSize: 0.6,
        reverbDamping: 0.4,
      ),
      EffectPreset(
        id: 'reverb_spring',
        name: 'Spring Reverb',
        category: 'Reverb',
        reverbMix: 0.35,
        reverbSize: 0.4,
        reverbDamping: 0.5,
      ),
      // Delay presets
      EffectPreset(
        id: 'delay_echo',
        name: 'Echo',
        category: 'Delay',
        delayMix: 0.4,
        delayTime: 0.375,
        delayFeedback: 0.4,
      ),
      EffectPreset(
        id: 'delay_pingpong',
        name: 'Ping Pong',
        category: 'Delay',
        delayMix: 0.35,
        delayTime: 0.25,
        delayFeedback: 0.5,
      ),
      EffectPreset(
        id: 'delay_tape',
        name: 'Tape Delay',
        category: 'Delay',
        delayMix: 0.3,
        delayTime: 0.5,
        delayFeedback: 0.6,
      ),
      // Distortion presets
      EffectPreset(
        id: 'distortion_overdrive',
        name: 'Overdrive',
        category: 'Distortion',
        distortionAmount: 0.3,
        distortionTone: 0.6,
      ),
      EffectPreset(
        id: 'distortion_fuzz',
        name: 'Fuzz',
        category: 'Distortion',
        distortionAmount: 0.6,
        distortionTone: 0.4,
      ),
      EffectPreset(
        id: 'distortion_bitcrush',
        name: 'Bitcrusher',
        category: 'Distortion',
        distortionAmount: 0.4,
        distortionTone: 0.3,
      ),
      // Chorus presets
      EffectPreset(
        id: 'chorus_light',
        name: 'Light Chorus',
        category: 'Chorus',
        chorusRate: 0.5,
        chorusDepth: 0.3,
        chorusMix: 0.3,
      ),
      EffectPreset(
        id: 'chorus_heavy',
        name: 'Heavy Chorus',
        category: 'Chorus',
        chorusRate: 1.0,
        chorusDepth: 0.6,
        chorusMix: 0.5,
      ),
      EffectPreset(
        id: 'chorus_flanger',
        name: 'Flanger',
        category: 'Chorus',
        chorusRate: 0.3,
        chorusDepth: 0.8,
        chorusMix: 0.4,
      ),
      // Filter presets
      EffectPreset(
        id: 'filter_lowpass',
        name: 'Low Pass',
        category: 'Filter',
        filterCutoff: 0.3,
        filterResonance: 0.5,
        filterType: 0.0,
      ),
      EffectPreset(
        id: 'filter_highpass',
        name: 'High Pass',
        category: 'Filter',
        filterCutoff: 0.7,
        filterResonance: 0.3,
        filterType: 1.0,
      ),
      EffectPreset(
        id: 'filter_bandpass',
        name: 'Band Pass',
        category: 'Filter',
        filterCutoff: 0.5,
        filterResonance: 0.7,
        filterType: 2.0,
      ),
    ];
  }
}
