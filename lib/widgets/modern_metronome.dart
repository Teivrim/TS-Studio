import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ModernMetronome extends StatefulWidget {
  final int currentBeat;
  final bool isPlaying;
  final VoidCallback onToggle;

  const ModernMetronome({
    super.key,
    required this.currentBeat,
    required this.isPlaying,
    required this.onToggle,
  });

  @override
  State<ModernMetronome> createState() => _ModernMetronomeState();
}

class _ModernMetronomeState extends State<ModernMetronome> with SingleTickerProviderStateMixin {
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
  void didUpdateWidget(ModernMetronome oldWidget) {
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderColor.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer_rounded, size: 20, color: AppTheme.textSecondary),
          const SizedBox(width: 12),
          const Text(
            'METRONOME',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(width: 20),
          // Beat indicators
          Row(
            children: List.generate(4, (index) {
              final isActive = widget.isPlaying && widget.currentBeat == index;
              final isFirst = index == 0;
              return AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: AppTheme.ledDecoration(
                      isOn: isActive,
                      color: isFirst ? AppTheme.dangerColor : AppTheme.accentColor,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isActive ? Colors.white : AppTheme.textMuted,
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: AppTheme.modernButtonDecoration(
                color: widget.isPlaying
                    ? AppTheme.dangerColor.withValues(alpha: 0.2)
                    : AppTheme.surfaceLightColor,
                isPrimary: widget.isPlaying,
                borderRadius: 12,
              ),
              child: Text(
                widget.isPlaying ? 'STOP' : 'START',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: widget.isPlaying ? AppTheme.dangerColor : AppTheme.textPrimary,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
