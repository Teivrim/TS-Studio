import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';
import 'modern_panel.dart';

class SettingsScreen extends StatefulWidget {
  final SettingsService settingsService;
  final VoidCallback onSettingsChanged;

  const SettingsScreen({
    super.key,
    required this.settingsService,
    required this.onSettingsChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, dynamic> _settings = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await widget.settingsService.loadSettings();
    setState(() {
      _settings = settings;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    await widget.settingsService.saveSettings(_settings);
    widget.onSettingsChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'SETTINGS',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
        actions: [
          ModernButton(
            icon: Icons.save_rounded,
            onPressed: _saveSettings,
            width: 44,
            height: 44,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Audio Settings
                ModernPanel(
                  title: 'AUDIO',
                  child: Column(
                    children: [
                      _SettingSlider(
                        label: 'Sample Rate',
                        value: (_settings['sampleRate'] as num).toDouble(),
                        min: 22050,
                        max: 96000,
                        divisions: 3,
                        onChanged: (v) {
                          _settings['sampleRate'] = v.round();
                          setState(() {});
                        },
                        displayValue: '${(_settings['sampleRate'] as num).round()} Hz',
                      ),
                      _SettingSlider(
                        label: 'Buffer Size',
                        value: (_settings['audioBufferSize'] as num).toDouble(),
                        min: 128,
                        max: 2048,
                        divisions: 7,
                        onChanged: (v) {
                          _settings['audioBufferSize'] = v.round();
                          setState(() {});
                        },
                        displayValue: '${(_settings['audioBufferSize'] as num).round()} samples',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Sequencer Settings
                ModernPanel(
                  title: 'SEQUENCER',
                  child: Column(
                    children: [
                      _SettingSlider(
                        label: 'Default BPM',
                        value: (_settings['defaultBpm'] as num).toDouble(),
                        min: 60,
                        max: 200,
                        divisions: 140,
                        onChanged: (v) {
                          _settings['defaultBpm'] = v.round();
                          setState(() {});
                        },
                        displayValue: '${(_settings['defaultBpm'] as num).round()} BPM',
                      ),
                      _SettingSlider(
                        label: 'Swing',
                        value: (_settings['swingAmount'] as num).toDouble(),
                        min: 0,
                        max: 1,
                        divisions: 20,
                        onChanged: (v) {
                          _settings['swingAmount'] = v;
                          setState(() {});
                        },
                        displayValue: '${((_settings['swingAmount'] as num).toDouble() * 100).round()}%',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Metronome Settings
                ModernPanel(
                  title: 'METRONOME',
                  child: Column(
                    children: [
                      _SettingSwitch(
                        label: 'Enabled',
                        value: _settings['metronomeEnabled'] as bool,
                        onChanged: (v) {
                          _settings['metronomeEnabled'] = v;
                          setState(() {});
                        },
                      ),
                      _SettingSwitch(
                        label: 'Count-in',
                        value: _settings['countInEnabled'] as bool,
                        onChanged: (v) {
                          _settings['countInEnabled'] = v;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // MIDI Settings
                ModernPanel(
                  title: 'MIDI',
                  child: Column(
                    children: [
                      _SettingSwitch(
                        label: 'MIDI Input',
                        value: _settings['midiInputEnabled'] as bool,
                        onChanged: (v) {
                          _settings['midiInputEnabled'] = v;
                          setState(() {});
                        },
                      ),
                      _SettingSwitch(
                        label: 'MIDI Output',
                        value: _settings['midiOutputEnabled'] as bool,
                        onChanged: (v) {
                          _settings['midiOutputEnabled'] = v;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _SettingSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;
  final String displayValue;

  const _SettingSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    required this.displayValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              activeColor: AppTheme.primaryColor,
              inactiveColor: AppTheme.gridColor,
              onChanged: onChanged,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              displayValue,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.accentColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingSwitch({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }
}
