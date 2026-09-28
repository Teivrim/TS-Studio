import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ModernStep extends StatefulWidget {
  final bool isActive;
  final bool isCurrentStep;
  final bool isBeat;
  final Color? activeColor;
  final VoidCallback onTap;

  const ModernStep({
    super.key,
    required this.isActive,
    required this.isCurrentStep,
    required this.isBeat,
    this.activeColor,
    required this.onTap,
  });

  @override
  State<ModernStep> createState() => _ModernStepState();
}

class _ModernStepState extends State<ModernStep> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void didUpdateWidget(ModernStep oldWidget) {
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.all(3),
              decoration: AppTheme.modernStepDecoration(
                isActive: widget.isActive,
                isCurrentStep: widget.isCurrentStep,
                isBeat: widget.isBeat,
                activeColor: widget.activeColor,
              ),
              child: widget.isActive
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.5),
                              blurRadius: 8,
                            ),
                          ],
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
