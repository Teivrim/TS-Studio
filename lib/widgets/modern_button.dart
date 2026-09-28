import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ModernButton extends StatefulWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? color;
  final bool isPrimary;
  final double width;
  final double height;
  final bool isActive;
  final double borderRadius;

  const ModernButton({
    super.key,
    this.text,
    this.icon,
    this.onPressed,
    this.color,
    this.isPrimary = false,
    this.width = 48,
    this.height = 48,
    this.isActive = false,
    this.borderRadius = 12,
  });

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.width,
        height: widget.height,
        decoration: AppTheme.modernButtonDecoration(
          color: widget.color,
          isPressed: _isPressed,
          isPrimary: widget.isPrimary,
          borderRadius: widget.borderRadius,
        ),
        child: Center(
          child: widget.icon != null
              ? Icon(
                  widget.icon,
                  color: widget.isActive
                      ? AppTheme.accentColor
                      : widget.isPrimary
                          ? Colors.white
                          : AppTheme.textPrimary,
                  size: widget.height * 0.45,
                )
              : Text(
                  widget.text ?? '',
                  style: TextStyle(
                    color: widget.isPrimary ? Colors.white : AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
        ),
      ),
    );
  }
}
