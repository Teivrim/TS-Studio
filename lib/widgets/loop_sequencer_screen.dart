import 'package:flutter/material.dart';
import '../models/loop.dart';
import '../services/loop_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';

class LoopSequencerScreen extends StatefulWidget {
  final Loop? initialLoop;
  final ValueChanged<Loop>? onLoopChanged;

  const LoopSequencerScreen({
    super.key,
    this.initialLoop,
    this.onLoopChanged,
  });

  @override
  State<LoopSequencerScreen> createState() => _LoopSequencerScreenState();
}

class _LoopSequencerScreenState extends State<LoopSequencerScreen> {
  late Loop _loop;
  final int _currentStep = 0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loop = widget.initialLoop ?? LoopService.getBuiltInLoops().first;
  }

  void _toggleStep(int trackIndex, int stepIndex) {
    setState(() {
      final newSteps = _loop.steps.map((row) => List<bool>.from(row)).toList();
      newSteps[trackIndex][stepIndex] = !newSteps[trackIndex][stepIndex];
      _loop = _loop.copyWith(steps: newSteps);
      widget.onLoopChanged?.call(_loop);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'LOOP SEQUENCER',
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
            icon: _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            onPressed: () => setState(() => _isPlaying = !_isPlaying),
            width: 44,
            height: 44,
            isPrimary: _isPlaying,
          ),
        ],
      ),
      body: Column(
        children: [
          // Loop info
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _loop.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                Text(
                  '${_loop.bpm} BPM',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentColor,
                  ),
                ),
              ],
            ),
          ),
          // Step grid
          Expanded(
            child: ListView.builder(
              itemCount: _loop.steps.length,
              itemBuilder: (context, trackIndex) {
                return Container(
                  height: 64,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: AppTheme.modernPanelDecoration(),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Center(
                          child: Text(
                            'Track ${trackIndex + 1}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: List.generate(16, (stepIndex) {
                            final isActive = _loop.steps[trackIndex][stepIndex];
                            final isCurrentStep = stepIndex == _currentStep && _isPlaying;
                            final isBeat = stepIndex % 4 == 0;

                            return Expanded(
                              child: GestureDetector(
                                onTap: () => _toggleStep(trackIndex, stepIndex),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 100),
                                  margin: const EdgeInsets.all(2),
                                  decoration: AppTheme.modernStepDecoration(
                                    isActive: isActive,
                                    isCurrentStep: isCurrentStep,
                                    isBeat: isBeat,
                                    activeColor: AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
