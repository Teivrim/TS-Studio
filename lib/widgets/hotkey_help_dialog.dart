import 'package:flutter/material.dart';
import '../services/platform_service.dart';
import '../theme/app_theme.dart';

class HotkeyHelpDialog extends StatelessWidget {
  const HotkeyHelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    if (!PlatformService.supportsHotkeys) {
      return const SizedBox.shrink();
    }

    return AlertDialog(
      title: const Text('Горячие клавиши'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HotkeyRow(keys: 'Space', description: 'Play / Pause'),
            _HotkeyRow(keys: 'Ctrl + Z', description: 'Отменить'),
            _HotkeyRow(keys: 'Ctrl + Y', description: 'Повторить'),
            _HotkeyRow(keys: 'Ctrl + S', description: 'Сохранить'),
            _HotkeyRow(keys: 'Ctrl + O', description: 'Загрузить'),
            _HotkeyRow(keys: 'Ctrl + E', description: 'Экспорт'),
            _HotkeyRow(keys: 'M', description: 'Метроном'),
            _HotkeyRow(keys: 'C', description: 'Очистить'),
            _HotkeyRow(keys: '1-8', description: 'Mute трек'),
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

class _HotkeyRow extends StatelessWidget {
  final String keys;
  final String description;

  const _HotkeyRow({required this.keys, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.gridColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.5)),
            ),
            child: Text(
              keys,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.accentColor,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(description, style: const TextStyle(fontSize: 12, color: Colors.white70)),
        ],
      ),
    );
  }
}
