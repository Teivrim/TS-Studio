import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FLStep extends StatefulWidget {
  final bool isActive;
  final bool isCurrentStep;
  final bool isBeat;
  final Color? activeColor;
  final VoidCallback onTap;

  const FLStep({
    super.key,
    required this.isActive,
    required this.isCurrentStep,
    required this.isBeat,
    this.activeColor,
    required this.onTap,
  });

  @override
  State<FLStep> createState() => _FLStepState();
}

class _FLStepState extends State<FLStep> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

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
  }

  @override
  void didUpdateWidget(FLStep oldWidget) {
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
              decoration: AppTheme.flStepDecoration(
                isActive: widget.isActive,
                isCurrentStep: widget.isCurrentStep,
                isBeat: widget.isBeat,
                activeColor: widget.activeColor,
              ),
              child: widget.isActive
                  ? Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
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
