import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'modern_panel.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'ABOUT',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Logo
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: AppTheme.modernButtonDecoration(
                color: AppTheme.primaryColor,
                isPrimary: true,
                borderRadius: 24,
              ),
              child: const Center(
                child: Text(
                  'TS',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // App info
          ModernPanel(
            title: 'TEIVRIM SOUND STUDIO',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(label: 'Version', value: '1.1.0'),
                _InfoRow(label: 'Platform', value: 'Flutter'),
                _InfoRow(label: 'Developer', value: 'Teivrim'),
                _InfoRow(label: 'License', value: 'MIT'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Description
          ModernPanel(
            title: 'DESCRIPTION',
            child: const Text(
              'Teivrim Sound Studio (TS Studio) is a mobile music production '
              'application for Android, built with Flutter. It features a step '
              'sequencer, synthesizer, effects, and more.',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Features
          ModernPanel(
            title: 'FEATURES',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FeatureItem(text: 'Step Sequencer with 16 steps'),
                _FeatureItem(text: '8 tracks with real samples'),
                _FeatureItem(text: 'Synthesizer with presets'),
                _FeatureItem(text: 'Effects: Reverb, Delay, Distortion, Chorus, Filter'),
                _FeatureItem(text: 'MIDI Monitor'),
                _FeatureItem(text: 'Waveform Editor'),
                _FeatureItem(text: 'Loop Sequencer'),
                _FeatureItem(text: 'Drum Pads'),
                _FeatureItem(text: 'Chord Progressions'),
                _FeatureItem(text: 'Project Browser'),
                _FeatureItem(text: 'Export to WAV/MIDI'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;

  const _FeatureItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: AppTheme.ledDecoration(isOn: true),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
