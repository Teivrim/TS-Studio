import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RandomizerDialog extends StatelessWidget {
  final VoidCallback onRandomPattern;
  final VoidCallback onRandomKick;
  final VoidCallback onRandomSnare;
  final VoidCallback onRandomHiHat;
  final VoidCallback onRandomBass;
  final VoidCallback onRandomMelodic;
  final VoidCallback onRandomFull;
  final VoidCallback onShuffle;
  final VoidCallback onInvert;
  final VoidCallback onShiftLeft;
  final VoidCallback onShiftRight;

  const RandomizerDialog({
    super.key,
    required this.onRandomPattern,
    required this.onRandomKick,
    required this.onRandomSnare,
    required this.onRandomHiHat,
    required this.onRandomBass,
    required this.onRandomMelodic,
    required this.onRandomFull,
    required this.onShuffle,
    required this.onInvert,
    required this.onShiftLeft,
    required this.onShiftRight,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Рандомайзер'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Генерация', style: TextStyle(fontSize: 12, color: Colors.white54)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _RandomButton(label: 'Full', onTap: onRandomFull, color: AppTheme.accentColor),
                _RandomButton(label: 'Pattern', onTap: onRandomPattern, color: AppTheme.primaryColor),
                _RandomButton(label: 'Kick', onTap: onRandomKick, color: AppTheme.dangerColor),
                _RandomButton(label: 'Snare', onTap: onRandomSnare, color: AppTheme.warningColor),
                _RandomButton(label: 'HiHat', onTap: onRandomHiHat, color: AppTheme.successColor),
                _RandomButton(label: 'Bass', onTap: onRandomBass, color: AppTheme.primaryColor),
                _RandomButton(label: 'Melodic', onTap: onRandomMelodic, color: AppTheme.accentColor),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Трансформации', style: TextStyle(fontSize: 12, color: Colors.white54)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _RandomButton(label: 'Shuffle', onTap: onShuffle, color: AppTheme.primaryColor),
                _RandomButton(label: 'Invert', onTap: onInvert, color: AppTheme.warningColor),
                _RandomButton(label: 'Shift L', onTap: onShiftLeft, color: AppTheme.successColor),
                _RandomButton(label: 'Shift R', onTap: onShiftRight, color: AppTheme.successColor),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Закрыть'),
        ),
      ],
    );
  }
}

class _RandomButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _RandomButton({
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onTap();
        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.2),
        foregroundColor: color,
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: Size.zero,
      ),
      child: Text(label, style: const TextStyle(fontSize: 11)),
    );
  }
}
