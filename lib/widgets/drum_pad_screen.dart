import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DrumPadScreen extends StatefulWidget {
  final ValueChanged<String>? onPadHit;

  const DrumPadScreen({super.key, this.onPadHit});

  @override
  State<DrumPadScreen> createState() => _DrumPadScreenState();
}

class _DrumPadScreenState extends State<DrumPadScreen> {
  final List<_DrumPad> _pads = [
    _DrumPad(id: '1', name: 'Kick', color: 0xFFE91E63),
    _DrumPad(id: '2', name: 'Snare', color: 0xFF9C27B0),
    _DrumPad(id: '3', name: 'Hi-Hat', color: 0xFF3F51B5),
    _DrumPad(id: '4', name: 'Clap', color: 0xFF009688),
    _DrumPad(id: '5', name: 'Tom', color: 0xFFFF9800),
    _DrumPad(id: '6', name: 'Rim', color: 0xFF4CAF50),
    _DrumPad(id: '7', name: 'Crash', color: 0xFFE53935),
    _DrumPad(id: '8', name: 'Perc', color: 0xFF8BC34A),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'DRUM PADS',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _pads.length,
        itemBuilder: (context, index) {
          final pad = _pads[index];
          return _DrumPadWidget(
            pad: pad,
            onTap: () {
              widget.onPadHit?.call(pad.name);
            },
          );
        },
      ),
    );
  }
}

class _DrumPad {
  final String id;
  final String name;
  final int color;

  const _DrumPad({required this.id, required this.name, required this.color});
}

class _DrumPadWidget extends StatefulWidget {
  final _DrumPad pad;
  final VoidCallback onTap;

  const _DrumPadWidget({required this.pad, required this.onTap});

  @override
  State<_DrumPadWidget> createState() => _DrumPadWidgetState();
}

class _DrumPadWidgetState extends State<_DrumPadWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: _isPressed
              ? Color(widget.pad.color)
              : AppTheme.surfaceLightColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isPressed
                ? Color(widget.pad.color)
                : AppTheme.borderColor.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: Color(widget.pad.color).withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            widget.pad.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _isPressed ? Colors.white : AppTheme.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
