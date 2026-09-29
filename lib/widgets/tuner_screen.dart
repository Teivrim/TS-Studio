import 'package:flutter/material.dart';
import '../services/tuner_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';

class TunerScreen extends StatefulWidget {
  const TunerScreen({super.key});

  @override
  State<TunerScreen> createState() => _TunerScreenState();
}

class _TunerScreenState extends State<TunerScreen> {
  final TunerService _tunerService = TunerService();
  TunerResult? _lastResult;

  @override
  void initState() {
    super.initState();
    _tunerService.tunerStream.listen((result) {
      setState(() => _lastResult = result);
    });
    _tunerService.start();
  }

  @override
  void dispose() {
    _tunerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'TUNER',
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
            icon: _tunerService.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
            onPressed: () {
              if (_tunerService.isRunning) {
                _tunerService.stop();
              } else {
                _tunerService.start();
              }
              setState(() {});
            },
            width: 44,
            height: 44,
            isPrimary: _tunerService.isRunning,
          ),
        ],
      ),
      body: Column(
        children: [
          // Note display
          Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Text(
                  '${_lastResult?.noteName ?? '--'}${_lastResult?.octave ?? '-'}',
                  style: const TextStyle(
                    fontSize: 120,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const Text(
                  'NOTE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
          ),
          // Frequency display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Frequency: ${_lastResult?.frequency.toStringAsFixed(1) ?? '--'} Hz',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Tuner display
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Cents display
                  Text(
                    '${_lastResult?.cents.toStringAsFixed(1) ?? '--'} cents',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: _lastResult?.isInTune == true
                          ? AppTheme.successColor
                          : AppTheme.warningColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Tuner bar
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.borderColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Center marker
                        Center(
                          child: Container(
                            width: 4,
                            height: 60,
                            color: AppTheme.successColor,
                          ),
                        ),
                        // Cents indicator
                        Positioned(
                          left: ((_lastResult?.cents ?? 0) / 50 * 0.5 + 0.5) *
                              (MediaQuery.of(context).size.width - 32 - 24),
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 8,
                            decoration: BoxDecoration(
                              color: _lastResult?.isInTune == true
                                  ? AppTheme.successColor
                                  : AppTheme.warningColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Status
                  Text(
                    _lastResult?.isInTune == true ? 'IN TUNE' : 'OUT OF TUNE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _lastResult?.isInTune == true
                          ? AppTheme.successColor
                          : AppTheme.warningColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
