import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FLButton extends StatefulWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? color;
  final bool isPrimary;
  final double width;
  final double height;
  final bool isActive;

  const FLButton({
    super.key,
    this.text,
    this.icon,
    this.onPressed,
    this.color,
    this.isPrimary = false,
    this.width = 48,
    this.height = 48,
    this.isActive = false,
  });

  @override
  State<FLButton> createState() => _FLButtonState();
}

class _FLButtonState extends State<FLButton> {
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
        duration: const Duration(milliseconds: 100),
        width: widget.width,
        height: widget.height,
        decoration: AppTheme.flButtonDecoration(
          color: widget.color,
          isPressed: _isPressed,
          isPrimary: widget.isPrimary,
        ),
        child: Center(
          child: widget.icon != null
              ? Icon(
                  widget.icon,
                  color: widget.isActive
                      ? AppTheme.accentColor
                      : widget.isPrimary
                          ? AppTheme.primaryColor
                          : AppTheme.textPrimary,
                  size: widget.height * 0.5,
                )
              : Text(
                  widget.text ?? '',
                  style: TextStyle(
                    color: widget.isPrimary ? AppTheme.primaryColor : AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
        ),
      ),
    );
  }
}
