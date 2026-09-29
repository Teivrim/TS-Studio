import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';
import 'modern_panel.dart';

class SwingEditorScreen extends StatefulWidget {
  final double initialSwing;
  final ValueChanged<double> onSwingChanged;

  const SwingEditorScreen({
    super.key,
    required this.initialSwing,
    required this.onSwingChanged,
  });

  @override
  State<SwingEditorScreen> createState() => _SwingEditorScreenState();
}

class _SwingEditorScreenState extends State<SwingEditorScreen> {
  late double _swing;

  @override
  void initState() {
    super.initState();
    _swing = widget.initialSwing;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'SWING EDITOR',
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
            icon: Icons.check_rounded,
            onPressed: () {
              widget.onSwingChanged(_swing);
              Navigator.of(context).pop();
            },
            width: 44,
            height: 44,
            isPrimary: true,
          ),
        ],
      ),
      body: Column(
        children: [
          // Swing value display
          Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Text(
                  '${(_swing * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const Text(
                  'SWING',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
          ),
          // Swing slider
          Container(
            padding: const EdgeInsets.all(16),
            child: ModernPanel(
              title: 'AMOUNT',
              child: Slider(
                value: _swing,
                min: 0,
                max: 1,
                divisions: 100,
                activeColor: AppTheme.primaryColor,
                inactiveColor: AppTheme.gridColor,
                onChanged: (v) => setState(() => _swing = v),
              ),
            ),
          ),
          // Visual representation
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: ModernPanel(
                title: 'PATTERN',
                child: _buildSwingGrid(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwingGrid() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(16, (index) {
            final isBeat = index % 4 == 0;

            return Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isBeat
                    ? AppTheme.primaryColor.withValues(alpha: 0.3)
                    : AppTheme.gridColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isBeat
                      ? AppTheme.primaryColor.withValues(alpha: 0.5)
                      : Colors.transparent,
                ),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 8,
                    color: isBeat ? AppTheme.primaryColor : AppTheme.textMuted,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        Text(
          'Offset: ${(_swing * 50).round()}%',
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
