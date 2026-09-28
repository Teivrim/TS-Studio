import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedStep extends StatefulWidget {
  final bool isActive;
  final bool isCurrentStep;
  final bool isBeat;
  final Color color;
  final VoidCallback onTap;

  const AnimatedStep({
    super.key,
    required this.isActive,
    required this.isCurrentStep,
    required this.isBeat,
    required this.color,
    required this.onTap,
  });

  @override
  State<AnimatedStep> createState() => _AnimatedStepState();
}

class _AnimatedStepState extends State<AnimatedStep> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(AnimatedStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.forward();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: widget.isActive
                    ? widget.color
                    : widget.isCurrentStep
                        ? AppTheme.playheadColor.withValues(alpha: 0.15)
                        : widget.isBeat
                            ? AppTheme.inactiveStepColor
                            : AppTheme.gridColor,
                borderRadius: BorderRadius.circular(4),
                border: widget.isCurrentStep
                    ? Border.all(
                        color: AppTheme.playheadColor,
                        width: 2,
                      )
                    : null,
                boxShadow: widget.isActive
                    ? [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.5 * _glowAnimation.value),
                          blurRadius: 8 * _glowAnimation.value,
                          spreadRadius: 2 * _glowAnimation.value,
                        ),
                      ]
                    : null,
              ),
              child: widget.isActive
                  ? Center(
                      child: Icon(
                        Icons.circle,
                        size: 8,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
