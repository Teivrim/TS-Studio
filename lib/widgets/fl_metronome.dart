import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FLMetronome extends StatefulWidget {
  final int currentBeat;
  final bool isPlaying;
  final VoidCallback onToggle;

  const FLMetronome({
    super.key,
    required this.currentBeat,
    required this.isPlaying,
    required this.onToggle,
  });

  @override
  State<FLMetronome> createState() => _FLMetronomeState();
}

class _FLMetronomeState extends State<FLMetronome> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(FLMetronome oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentBeat != oldWidget.currentBeat && widget.isPlaying) {
      _pulseController.forward().then((_) => _pulseController.reverse());
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer, size: 20, color: AppTheme.textSecondary),
          const SizedBox(width: 8),
          const Text('METRONOME', style: TextStyle(fontSize: 10, color: AppTheme.textSecondary, letterSpacing: 1)),
          const SizedBox(width: 16),
          // Beat indicators
          Row(
            children: List.generate(4, (index) {
              final isActive = widget.isPlaying && widget.currentBeat == index;
              final isFirst = index == 0;
              return AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: AppTheme.flLedDecoration(
                      isOn: isActive,
                      color: isFirst ? AppTheme.dangerColor : AppTheme.accentColor,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isActive ? Colors.black : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          const Spacer(),
          // Toggle button
          GestureDetector(
            onTap: widget.onToggle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: AppTheme.flButtonDecoration(
                color: widget.isPlaying ? AppTheme.dangerColor.withValues(alpha: 0.3) : AppTheme.buttonColor,
                isPrimary: widget.isPlaying,
              ),
              child: Text(
                widget.isPlaying ? 'STOP' : 'START',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: widget.isPlaying ? AppTheme.dangerColor : AppTheme.textPrimary,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
