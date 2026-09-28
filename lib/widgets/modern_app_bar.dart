import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';
import 'platform_indicator.dart';

class ModernAppBar extends StatelessWidget implements PreferredSizeWidget {
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

  const ModernAppBar({
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
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderColor.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Row(
            children: [
              const SizedBox(width: 20),
              // Logo
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: AppTheme.modernButtonDecoration(
                      color: AppTheme.primaryColor,
                      isPrimary: true,
                      borderRadius: 12,
                    ),
                    child: const Center(
                      child: Text(
                        'TS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'TS STUDIO',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              const PlatformIndicator(),
              const Spacer(),
              // Action buttons
              ModernButton(
                icon: Icons.undo_rounded,
                onPressed: canUndo ? onUndo : null,
                width: 44,
                height: 44,
                borderRadius: 12,
              ),
              const SizedBox(width: 6),
              ModernButton(
                icon: Icons.redo_rounded,
                onPressed: canRedo ? onRedo : null,
                width: 44,
                height: 44,
                borderRadius: 12,
              ),
              const SizedBox(width: 12),
              ModernButton(
                icon: Icons.save_rounded,
                onPressed: onSave,
                width: 44,
                height: 44,
                borderRadius: 12,
              ),
              const SizedBox(width: 6),
              ModernButton(
                icon: Icons.folder_open_rounded,
                onPressed: onLoad,
                width: 44,
                height: 44,
                borderRadius: 12,
              ),
              const SizedBox(width: 6),
              ModernButton(
                icon: Icons.download_rounded,
                onPressed: onExport,
                width: 44,
                height: 44,
                borderRadius: 12,
              ),
              const SizedBox(width: 12),
              ModernButton(
                icon: Icons.library_music_rounded,
                onPressed: onPresets,
                width: 44,
                height: 44,
                borderRadius: 12,
              ),
              const SizedBox(width: 6),
              ModernButton(
                icon: Icons.queue_music_rounded,
                onPressed: onPatterns,
                width: 44,
                height: 44,
                borderRadius: 12,
              ),
              const SizedBox(width: 6),
              ModernButton(
                icon: Icons.shuffle_rounded,
                onPressed: onRandomizer,
                width: 44,
                height: 44,
                borderRadius: 12,
              ),
              const SizedBox(width: 6),
              ModernButton(
                icon: Icons.tune_rounded,
                onPressed: onMixer,
                width: 44,
                height: 44,
                borderRadius: 12,
              ),
              const SizedBox(width: 6),
              ModernButton(
                icon: Icons.delete_outline_rounded,
                onPressed: onClear,
                width: 44,
                height: 44,
                borderRadius: 12,
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}
