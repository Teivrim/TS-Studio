import 'package:flutter/material.dart';
import '../models/pattern.dart';
import '../services/preset_service.dart';
import '../theme/app_theme.dart';

class PresetDialog extends StatelessWidget {
  final ValueChanged<Preset> onSelect;

  const PresetDialog({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final presets = PresetService.getPresets();
    final categories = presets.map((p) => p.category).toSet().toList();

    return AlertDialog(
      title: const Text('Пресеты'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, categoryIndex) {
            final category = categories[categoryIndex];
            final categoryPresets = presets.where((p) => p.category == category).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentColor,
                    ),
                  ),
                ),
                ...categoryPresets.map((preset) => ListTile(
                  title: Text(preset.name),
                  subtitle: Text('${preset.bpm} BPM'),
                  trailing: const Icon(Icons.play_arrow, color: AppTheme.primaryColor),
                  onTap: () {
                    onSelect(preset);
                    Navigator.of(context).pop();
                  },
                )),
                const Divider(),
              ],
            );
          },
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
