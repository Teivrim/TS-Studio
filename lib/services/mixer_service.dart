import '../models/mixer_channel.dart';
import '../models/track.dart';

class MixerService {
  List<MixerChannel> _channels = [];

  List<MixerChannel> get channels => _channels;

  void initializeChannels(List<Track> tracks) {
    _channels = tracks.map((track) => MixerChannel(
      id: track.id,
      name: track.name,
      volume: track.volume,
      pan: track.pan,
      muted: track.muted,
    )).toList();
  }

  void updateChannel(String channelId, MixerChannel Function(MixerChannel) update) {
    _channels = _channels.map((ch) {
      if (ch.id == channelId) {
        return update(ch);
      }
      return ch;
    }).toList();
  }

  void setVolume(String channelId, double volume) {
    updateChannel(channelId, (ch) => ch.copyWith(volume: volume));
  }

  void setPan(String channelId, double pan) {
    updateChannel(channelId, (ch) => ch.copyWith(pan: pan));
  }

  void toggleMute(String channelId) {
    updateChannel(channelId, (ch) => ch.copyWith(muted: !ch.muted));
  }

  void toggleSolo(String channelId) {
    updateChannel(channelId, (ch) => ch.copyWith(solo: !ch.solo));
  }

  void setEq(String channelId, {double? low, double? mid, double? high}) {
    updateChannel(channelId, (ch) => ch.copyWith(
      eqLow: low ?? ch.eqLow,
      eqMid: mid ?? ch.eqMid,
      eqHigh: high ?? ch.eqHigh,
    ));
  }

  void setReverbSend(String channelId, double send) {
    updateChannel(channelId, (ch) => ch.copyWith(reverbSend: send));
  }

  void setDelaySend(String channelId, double send) {
    updateChannel(channelId, (ch) => ch.copyWith(delaySend: send));
  }

  void setDistortion(String channelId, double value) {
    updateChannel(channelId, (ch) => ch.copyWith(distortion: value));
  }

  void setChorus(String channelId, double value) {
    updateChannel(channelId, (ch) => ch.copyWith(chorus: value));
  }

  void setFilter(String channelId, {double? cutoff, double? resonance}) {
    updateChannel(channelId, (ch) => ch.copyWith(
      filterCutoff: cutoff ?? ch.filterCutoff,
      filterResonance: resonance ?? ch.filterResonance,
    ));
  }

  void setLfo(String channelId, {double? rate, double? depth, String? target}) {
    updateChannel(channelId, (ch) => ch.copyWith(
      lfoRate: rate ?? ch.lfoRate,
      lfoDepth: depth ?? ch.lfoDepth,
      lfoTarget: target ?? ch.lfoTarget,
    ));
  }

  bool get hasSolo => _channels.any((ch) => ch.solo);

  bool isAudible(String channelId) {
    final channel = _channels.firstWhere((ch) => ch.id == channelId);
    if (hasSolo) {
      return channel.solo && !channel.muted;
    }
    return !channel.muted;
  }

  double getEffectiveVolume(String channelId) {
    final channel = _channels.firstWhere((ch) => ch.id == channelId);
    if (!isAudible(channelId)) return 0.0;
    return channel.volume;
  }

  Map<String, dynamic> toJson() => {
    'channels': _channels.map((ch) => ch.toJson()).toList(),
  };

  void fromJson(Map<String, dynamic> json) {
    _channels = (json['channels'] as List)
        .map((ch) => MixerChannel.fromJson(ch as Map<String, dynamic>))
        .toList();
  }
}
