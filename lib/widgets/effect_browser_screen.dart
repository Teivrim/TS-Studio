import 'package:flutter/material.dart';
import '../models/effect_preset.dart';
import '../services/effect_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';

class EffectBrowserScreen extends StatefulWidget {
  final EffectPreset? initialPreset;
  final ValueChanged<EffectPreset>? onPresetSelected;

  const EffectBrowserScreen({
    super.key,
    this.initialPreset,
    this.onPresetSelected,
  });

  @override
  State<EffectBrowserScreen> createState() => _EffectBrowserScreenState();
}

class _EffectBrowserScreenState extends State<EffectBrowserScreen> {
  final List<EffectPreset> _presets = EffectService.getPresets();
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    if (widget.initialPreset != null) {
      _selectedCategory = widget.initialPreset!.category;
    }
  }

  List<String> get _categories {
    final categories = _presets.map((p) => p.category).toSet().toList();
    return ['All', ...categories];
  }

  List<EffectPreset> get _filteredPresets {
    if (_selectedCategory == 'All') return _presets;
    return _presets.where((p) => p.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'EFFECTS',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
      ),
      body: Column(
        children: [
          // Category filter
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((category) {
                  final isSelected = category == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCategory = category),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: AppTheme.modernButtonDecoration(
                          color: isSelected
                              ? AppTheme.primaryColor.withValues(alpha: 0.2)
                              : AppTheme.surfaceLightColor,
                          isPrimary: isSelected,
                          borderRadius: 12,
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Preset list
          Expanded(
            child: ListView.builder(
              itemCount: _filteredPresets.length,
              itemBuilder: (context, index) {
                final preset = _filteredPresets[index];
                return _EffectPresetTile(
                  preset: preset,
                  onTap: () {
                    widget.onPresetSelected?.call(preset);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EffectPresetTile extends StatelessWidget {
  final EffectPreset preset;
  final VoidCallback onTap;

  const _EffectPresetTile({
    required this.preset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: AppTheme.modernPanelDecoration(),
      child: ListTile(
        leading: Container(
          width: 56,
          height: 56,
          decoration: AppTheme.modernButtonDecoration(
            color: AppTheme.surfaceLightColor,
            borderRadius: 12,
          ),
          child: Icon(
            _getCategoryIcon(preset.category),
            color: AppTheme.primaryColor,
          ),
        ),
        title: Text(
          preset.name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Text(
          preset.category,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: ModernButton(
          icon: Icons.play_arrow_rounded,
          onPressed: onTap,
          width: 44,
          height: 44,
        ),
        onTap: onTap,
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Reverb':
        return Icons.water_rounded;
      case 'Delay':
        return Icons.timer_rounded;
      case 'Distortion':
        return Icons.broken_image_rounded;
      case 'Chorus':
        return Icons.auto_awesome_rounded;
      case 'Filter':
        return Icons.filter_alt_rounded;
      default:
        return Icons.tune_rounded;
    }
  }
}
