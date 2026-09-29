import 'package:flutter/material.dart';
import '../services/loop_recorder_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';
import 'modern_panel.dart';
import 'waveform_display.dart';

class LoopRecorderScreen extends StatefulWidget {
  const LoopRecorderScreen({super.key});

  @override
  State<LoopRecorderScreen> createState() => _LoopRecorderScreenState();
}

class _LoopRecorderScreenState extends State<LoopRecorderScreen> {
  final LoopRecorderService _recorderService = LoopRecorderService();
  List<double> _recordedLoop = [];

  @override
  void initState() {
    super.initState();
    _recorderService.loopStream.listen((loop) {
      setState(() {
        _recordedLoop = loop;
      });
    });
  }

  @override
  void dispose() {
    _recorderService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'LOOP RECORDER',
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
            icon: _recorderService.isRecording ? Icons.stop_rounded : Icons.fiber_manual_record,
            onPressed: () {
              if (_recorderService.isRecording) {
                _recorderService.stopRecording();
              } else {
                _recorderService.startRecording();
              }
              setState(() {});
            },
            width: 44,
            height: 44,
            isPrimary: _recorderService.isRecording,
            color: _recorderService.isRecording ? AppTheme.dangerColor : null,
          ),
          const SizedBox(width: 8),
          ModernButton(
            icon: Icons.clear_all_rounded,
            onPressed: () {
              _recorderService.clear();
              setState(() {
                _recordedLoop = [];
              });
            },
            width: 44,
            height: 44,
          ),
        ],
      ),
      body: Column(
        children: [
          // Status
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: AppTheme.ledDecoration(
                    isOn: _recorderService.isRecording,
                    color: _recorderService.isRecording ? AppTheme.dangerColor : AppTheme.accentColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  _recorderService.isRecording ? 'Recording...' : 'Ready',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_recordedLoop.length} samples',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Waveform display
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: ModernPanel(
                title: 'RECORDED LOOP',
                child: _recordedLoop.isEmpty
                    ? const Center(
                        child: Text(
                          'No recorded loop',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      )
                    : WaveformDisplay(
                        samples: _recordedLoop,
                        height: 200,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
