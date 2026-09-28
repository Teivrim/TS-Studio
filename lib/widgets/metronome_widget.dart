import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MetronomeWidget extends StatefulWidget {
  final int currentBeat;
  final bool isPlaying;
  final VoidCallback onToggle;

  const MetronomeWidget({
    super.key,
    required this.currentBeat,
    required this.isPlaying,
    required this.onToggle,
  });

  @override
  State<MetronomeWidget> createState() => _MetronomeWidgetState();
}

class _MetronomeWidgetState extends State<MetronomeWidget> with SingleTickerProviderStateMixin {
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
  void didUpdateWidget(MetronomeWidget oldWidget) {
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
          bottom: BorderSide(color: AppTheme.gridColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer, size: 20, color: Colors.white54),
          const SizedBox(width: 8),
          const Text('Метроном', style: TextStyle(fontSize: 12, color: Colors.white54)),
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
                    width: 16,
                    height: 16,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? (isFirst ? AppTheme.dangerColor : AppTheme.accentColor)
                          : AppTheme.gridColor,
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: (isFirst ? AppTheme.dangerColor : AppTheme.accentColor)
                                    .withValues(alpha: 0.5 * _pulseController.value),
                                blurRadius: 8 * _pulseController.value,
                              ),
                            ]
                          : null,
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: widget.isPlaying
                    ? AppTheme.dangerColor.withValues(alpha: 0.2)
                    : AppTheme.gridColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.isPlaying ? AppTheme.dangerColor : AppTheme.gridColor,
                ),
              ),
              child: Text(
                widget.isPlaying ? 'Стоп' : 'Старт',
                style: TextStyle(
                  fontSize: 12,
                  color: widget.isPlaying ? AppTheme.dangerColor : Colors.white54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
