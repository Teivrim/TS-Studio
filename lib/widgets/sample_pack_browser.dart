import 'package:flutter/material.dart';
import '../models/sample_pack.dart';
import '../services/sample_pack_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';

class SamplePackBrowser extends StatefulWidget {
  final ValueChanged<SamplePack>? onPackSelected;

  const SamplePackBrowser({super.key, this.onPackSelected});

  @override
  State<SamplePackBrowser> createState() => _SamplePackBrowserState();
}

class _SamplePackBrowserState extends State<SamplePackBrowser> {
  final List<SamplePack> _packs = SamplePackService.getBuiltInPacks();
  String _selectedCategory = 'All';

  List<String> get _categories {
    final categories = _packs.map((p) => p.category).toSet().toList();
    return ['All', ...categories];
  }

  List<SamplePack> get _filteredPacks {
    if (_selectedCategory == 'All') return _packs;
    return _packs.where((p) => p.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'SAMPLE PACKS',
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
          // Pack list
          Expanded(
            child: ListView.builder(
              itemCount: _filteredPacks.length,
              itemBuilder: (context, index) {
                final pack = _filteredPacks[index];
                return _SamplePackTile(
                  pack: pack,
                  onTap: () {
                    widget.onPackSelected?.call(pack);
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

class _SamplePackTile extends StatelessWidget {
  final SamplePack pack;
  final VoidCallback onTap;

  const _SamplePackTile({required this.pack, required this.onTap});

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
          child: const Icon(Icons.folder_rounded, color: AppTheme.primaryColor),
        ),
        title: Text(
          pack.name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Text(
          pack.description,
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
}
