import 'package:flutter/material.dart';
import '../models/mixer_channel.dart';
import '../theme/app_theme.dart';

class MixerScreen extends StatelessWidget {
  final List<MixerChannel> channels;
  final void Function(String channelId, double volume) onVolumeChanged;
  final void Function(String channelId, double pan) onPanChanged;
  final VoidCallback Function(String channelId) onMuteToggle;
  final VoidCallback Function(String channelId) onSoloToggle;
  final void Function(String channelId, double low, double mid, double high) onEqChanged;
  final void Function(String channelId, double send) onReverbSendChanged;
  final void Function(String channelId, double send) onDelaySendChanged;
  final void Function(String channelId, double value) onDistortionChanged;
  final void Function(String channelId, double value) onChorusChanged;
  final void Function(String channelId, double cutoff, double resonance) onFilterChanged;
  final void Function(String channelId, double rate, double depth, String target) onLfoChanged;

  const MixerScreen({
    super.key,
    required this.channels,
    required this.onVolumeChanged,
    required this.onPanChanged,
    required this.onMuteToggle,
    required this.onSoloToggle,
    required this.onEqChanged,
    required this.onReverbSendChanged,
    required this.onDelaySendChanged,
    required this.onDistortionChanged,
    required this.onChorusChanged,
    required this.onFilterChanged,
    required this.onLfoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Микшер',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.accentColor,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: channels.length,
        itemBuilder: (context, index) {
          final channel = channels[index];
          return _MixerChannelWidget(
            channel: channel,
            onVolumeChanged: (v) => onVolumeChanged(channel.id, v),
            onPanChanged: (p) => onPanChanged(channel.id, p),
            onMuteToggle: () => onMuteToggle(channel.id),
            onSoloToggle: () => onSoloToggle(channel.id),
            onEqChanged: (l, m, h) => onEqChanged(channel.id, l, m, h),
            onReverbSendChanged: (s) => onReverbSendChanged(channel.id, s),
            onDelaySendChanged: (s) => onDelaySendChanged(channel.id, s),
            onDistortionChanged: (v) => onDistortionChanged(channel.id, v),
            onChorusChanged: (v) => onChorusChanged(channel.id, v),
            onFilterChanged: (c, r) => onFilterChanged(channel.id, c, r),
            onLfoChanged: (r, d, t) => onLfoChanged(channel.id, r, d, t),
          );
        },
      ),
    );
  }
}

class _MixerChannelWidget extends StatelessWidget {
  final MixerChannel channel;
  final ValueChanged<double> onVolumeChanged;
  final ValueChanged<double> onPanChanged;
  final VoidCallback onMuteToggle;
  final VoidCallback onSoloToggle;
  final void Function(double low, double mid, double high) onEqChanged;
  final ValueChanged<double> onReverbSendChanged;
  final ValueChanged<double> onDelaySendChanged;
  final ValueChanged<double> onDistortionChanged;
  final ValueChanged<double> onChorusChanged;
  final void Function(double cutoff, double resonance) onFilterChanged;
  final void Function(double rate, double depth, String target) onLfoChanged;

  const _MixerChannelWidget({
    required this.channel,
    required this.onVolumeChanged,
    required this.onPanChanged,
    required this.onMuteToggle,
    required this.onSoloToggle,
    required this.onEqChanged,
    required this.onReverbSendChanged,
    required this.onDelaySendChanged,
    required this.onDistortionChanged,
    required this.onChorusChanged,
    required this.onFilterChanged,
    required this.onLfoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.gridColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(int.parse('0xFF${channel.id}')),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  channel.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // Mute/Solo buttons
              Row(
                children: [
                  _MuteSoloButton(
                    label: 'M',
                    isActive: channel.muted,
                    activeColor: AppTheme.dangerColor,
                    onTap: onMuteToggle,
                  ),
                  const SizedBox(width: 4),
                  _MuteSoloButton(
                    label: 'S',
                    isActive: channel.solo,
                    activeColor: AppTheme.warningColor,
                    onTap: onSoloToggle,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Volume & Pan
          Row(
            children: [
              Expanded(
                child: _SliderControl(
                  label: 'Vol',
                  value: channel.volume,
                  onChanged: onVolumeChanged,
                  color: AppTheme.accentColor,
                ),
              ),
              Expanded(
                child: _SliderControl(
                  label: 'Pan',
                  value: (channel.pan + 1) / 2,
                  onChanged: (v) => onPanChanged(v * 2 - 1),
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          // EQ
          const SizedBox(height: 8),
          const Text('EQ', style: TextStyle(fontSize: 10, color: Colors.white54)),
          Row(
            children: [
              Expanded(
                child: _SliderControl(
                  label: 'L',
                  value: channel.eqLow,
                  onChanged: (v) => onEqChanged(v, channel.eqMid, channel.eqHigh),
                  color: AppTheme.primaryColor,
                ),
              ),
              Expanded(
                child: _SliderControl(
                  label: 'M',
                  value: channel.eqMid,
                  onChanged: (v) => onEqChanged(channel.eqLow, v, channel.eqHigh),
                  color: AppTheme.primaryColor,
                ),
              ),
              Expanded(
                child: _SliderControl(
                  label: 'H',
                  value: channel.eqHigh,
                  onChanged: (v) => onEqChanged(channel.eqLow, channel.eqMid, v),
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          // FX Sends
          const SizedBox(height: 8),
          const Text('Sends', style: TextStyle(fontSize: 10, color: Colors.white54)),
          Row(
            children: [
              Expanded(
                child: _SliderControl(
                  label: 'Rev',
                  value: channel.reverbSend,
                  onChanged: onReverbSendChanged,
                  color: AppTheme.primaryColor,
                ),
              ),
              Expanded(
                child: _SliderControl(
                  label: 'Dly',
                  value: channel.delaySend,
                  onChanged: onDelaySendChanged,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          // FX
          const SizedBox(height: 8),
          const Text('FX', style: TextStyle(fontSize: 10, color: Colors.white54)),
          Row(
            children: [
              Expanded(
                child: _SliderControl(
                  label: 'Dist',
                  value: channel.distortion,
                  onChanged: onDistortionChanged,
                  color: AppTheme.dangerColor,
                ),
              ),
              Expanded(
                child: _SliderControl(
                  label: 'Chor',
                  value: channel.chorus,
                  onChanged: onChorusChanged,
                  color: AppTheme.successColor,
                ),
              ),
            ],
          ),
          // Filter
          const SizedBox(height: 8),
          const Text('Filter', style: TextStyle(fontSize: 10, color: Colors.white54)),
          Row(
            children: [
              Expanded(
                child: _SliderControl(
                  label: 'Cut',
                  value: channel.filterCutoff,
                  onChanged: (v) => onFilterChanged(v, channel.filterResonance),
                  color: AppTheme.warningColor,
                ),
              ),
              Expanded(
                child: _SliderControl(
                  label: 'Res',
                  value: channel.filterResonance,
                  onChanged: (v) => onFilterChanged(channel.filterCutoff, v),
                  color: AppTheme.warningColor,
                ),
              ),
            ],
          ),
          // LFO
          const SizedBox(height: 8),
          const Text('LFO', style: TextStyle(fontSize: 10, color: Colors.white54)),
          Row(
            children: [
              Expanded(
                child: _SliderControl(
                  label: 'Rate',
                  value: channel.lfoRate,
                  onChanged: (v) => onLfoChanged(v, channel.lfoDepth, channel.lfoTarget),
                  color: AppTheme.accentColor,
                ),
              ),
              Expanded(
                child: _SliderControl(
                  label: 'Depth',
                  value: channel.lfoDepth,
                  onChanged: (v) => onLfoChanged(channel.lfoRate, v, channel.lfoTarget),
                  color: AppTheme.accentColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MuteSoloButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _MuteSoloButton({
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isActive ? activeColor.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isActive ? activeColor : AppTheme.gridColor,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isActive ? activeColor : Colors.white54,
            ),
          ),
        ),
      ),
    );
  }
}

class _SliderControl extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final Color color;

  const _SliderControl({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(label, style: const TextStyle(fontSize: 9, color: Colors.white54)),
              const Spacer(),
              Text('${(value * 100).round()}%', style: const TextStyle(fontSize: 8, color: Colors.white38)),
            ],
          ),
          Slider(
            value: value,
            min: 0,
            max: 1,
            activeColor: color,
            inactiveColor: AppTheme.gridColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
