import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'fl_button.dart';
import 'platform_indicator.dart';

class FLAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSave;
  final VoidCallback onLoad;
  final VoidCallback onExport;
  final VoidCallback onPresets;
  final VoidCallback onPatterns;
  final VoidCallback onRandomizer;
  final VoidCallback onMixer;
  final VoidCallback onClear;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final bool canUndo;
  final bool canRedo;

  const FLAppBar({
    super.key,
    required this.onSave,
    required this.onLoad,
    required this.onExport,
    required this.onPresets,
    required this.onPatterns,
    required this.onRandomizer,
    required this.onMixer,
    required this.onClear,
    required this.onUndo,
    required this.onRedo,
    required this.canUndo,
    required this.canRedo,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 2),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          // Logo
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: AppTheme.flButtonDecoration(
                  color: AppTheme.primaryColor,
                  isPrimary: true,
                ),
                child: const Center(
                  child: Text(
                    'TS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'TS STUDIO',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          const PlatformIndicator(),
          const Spacer(),
          // Action buttons
          FLButton(
            icon: Icons.undo,
            onPressed: canUndo ? onUndo : null,
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 4),
          FLButton(
            icon: Icons.redo,
            onPressed: canRedo ? onRedo : null,
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 8),
          FLButton(
            icon: Icons.save,
            onPressed: onSave,
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 4),
          FLButton(
            icon: Icons.folder_open,
            onPressed: onLoad,
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 4),
          FLButton(
            icon: Icons.download,
            onPressed: onExport,
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 8),
          FLButton(
            icon: Icons.library_music,
            onPressed: onPresets,
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 4),
          FLButton(
            icon: Icons.queue_music,
            onPressed: onPatterns,
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 4),
          FLButton(
            icon: Icons.shuffle,
            onPressed: onRandomizer,
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 4),
          FLButton(
            icon: Icons.tune,
            onPressed: onMixer,
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 4),
          FLButton(
            icon: Icons.delete_outline,
            onPressed: onClear,
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
