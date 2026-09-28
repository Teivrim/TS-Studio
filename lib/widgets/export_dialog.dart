import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';

class ExportDialog extends StatefulWidget {
  final void Function(String format) onExport;

  const ExportDialog({super.key, required this.onExport});

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  String _selectedFormat = 'WAV';
  double _quality = 0.8;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.surfaceColor,
      title: const Text(
        'Экспорт проекта',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Формат',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _FormatButton(
                label: 'WAV',
                isSelected: _selectedFormat == 'WAV',
                onTap: () => setState(() => _selectedFormat = 'WAV'),
              ),
              const SizedBox(width: 8),
              _FormatButton(
                label: 'MP3',
                isSelected: _selectedFormat == 'MP3',
                onTap: () => setState(() => _selectedFormat = 'MP3'),
              ),
              const SizedBox(width: 8),
              _FormatButton(
                label: 'MIDI',
                isSelected: _selectedFormat == 'MIDI',
                onTap: () => setState(() => _selectedFormat = 'MIDI'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Качество',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Slider(
            value: _quality,
            min: 0,
            max: 1,
            divisions: 10,
            activeColor: AppTheme.primaryColor,
            inactiveColor: AppTheme.gridColor,
            onChanged: (v) => setState(() => _quality = v),
          ),
          Text(
            '${(_quality * 100).round()}%',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.accentColor,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ModernButton(
          text: 'Экспорт',
          onPressed: () {
            widget.onExport(_selectedFormat);
            Navigator.of(context).pop();
          },
          isPrimary: true,
          width: 100,
          height: 40,
        ),
      ],
    );
  }
}

class _FormatButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FormatButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: AppTheme.modernButtonDecoration(
          color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.2) : AppTheme.surfaceLightColor,
          isPrimary: isSelected,
          borderRadius: 8,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}
