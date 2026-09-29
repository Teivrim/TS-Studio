import 'package:flutter/material.dart';
import '../services/arrangement_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';
import 'modern_panel.dart';

class ArrangementScreen extends StatefulWidget {
  const ArrangementScreen({super.key});

  @override
  State<ArrangementScreen> createState() => _ArrangementScreenState();
}

class _ArrangementScreenState extends State<ArrangementScreen> {
  final ArrangementService _arrangementService = ArrangementService();
  int _currentPosition = 0;

  @override
  void initState() {
    super.initState();
    _arrangementService.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  @override
  void dispose() {
    _arrangementService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'ARRANGEMENT',
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
            icon: _arrangementService.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            onPressed: () {
              if (_arrangementService.isPlaying) {
                _arrangementService.pause();
              } else {
                _arrangementService.play();
              }
              setState(() {});
            },
            width: 44,
            height: 44,
            isPrimary: _arrangementService.isPlaying,
          ),
          const SizedBox(width: 8),
          ModernButton(
            icon: Icons.stop_rounded,
            onPressed: () {
              _arrangementService.stop();
              setState(() {});
            },
            width: 44,
            height: 44,
          ),
        ],
      ),
      body: Column(
        children: [
          // Position display
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Position: $_currentPosition / ${_arrangementService.totalSteps}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                Text(
                  _arrangementService.isPlaying ? 'Playing' : 'Stopped',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _arrangementService.isPlaying
                        ? AppTheme.successColor
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Timeline
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: ModernPanel(
                title: 'TIMELINE',
                child: _buildTimeline(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Column(
      children: [
        // Progress bar
        Container(
          height: 24,
          decoration: BoxDecoration(
            color: AppTheme.gridColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: _currentPosition / _arrangementService.totalSteps,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Step indicators
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: List.generate(_arrangementService.totalSteps, (index) {
            final isCurrent = index == _currentPosition;
            final isBeat = index % 4 == 0;

            return Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: isCurrent
                    ? AppTheme.primaryColor
                    : isBeat
                        ? AppTheme.gridColor
                        : AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isCurrent
                      ? AppTheme.primaryColor
                      : Colors.transparent,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
