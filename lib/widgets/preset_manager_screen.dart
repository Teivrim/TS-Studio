import 'package:flutter/material.dart';
import '../services/preset_manager_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';

class PresetManagerScreen extends StatefulWidget {
  final String presetType;
  final Map<String, dynamic> currentPreset;
  final ValueChanged<Map<String, dynamic>>? onPresetLoaded;

  const PresetManagerScreen({
    super.key,
    required this.presetType,
    required this.currentPreset,
    this.onPresetLoaded,
  });

  @override
  State<PresetManagerScreen> createState() => _PresetManagerScreenState();
}

class _PresetManagerScreenState extends State<PresetManagerScreen> {
  final PresetManagerService _presetService = PresetManagerService();
  List<String> _presets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPresets();
  }

  Future<void> _loadPresets() async {
    setState(() => _isLoading = true);
    final presets = await _presetService.listPresets();
    setState(() {
      _presets = presets;
      _isLoading = false;
    });
  }

  Future<void> _savePreset() async {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Preset'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Preset name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await _presetService.savePreset(controller.text, widget.currentPreset);
                if (!context.mounted) return;
                Navigator.of(context).pop();
                _loadPresets();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          '${widget.presetType.toUpperCase()} PRESETS',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
        actions: [
          ModernButton(
            icon: Icons.save_rounded,
            onPressed: _savePreset,
            width: 44,
            height: 44,
          ),
          const SizedBox(width: 8),
          ModernButton(
            icon: Icons.refresh_rounded,
            onPressed: _loadPresets,
            width: 44,
            height: 44,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _presets.isEmpty
              ? const Center(
                  child: Text(
                    'No saved presets',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                )
              : ListView.builder(
                  itemCount: _presets.length,
                  itemBuilder: (context, index) {
                    final preset = _presets[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: AppTheme.modernPanelDecoration(),
                      child: ListTile(
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: AppTheme.modernButtonDecoration(
                            color: AppTheme.surfaceLightColor,
                            borderRadius: 12,
                          ),
                          child: const Icon(Icons.save_rounded, color: AppTheme.primaryColor),
                        ),
                        title: Text(
                          preset,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          widget.presetType,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ModernButton(
                              icon: Icons.upload_rounded,
                              onPressed: () async {
                                final presetData = await _presetService.loadPreset(preset);
                                if (!context.mounted) return;
                                if (presetData != null) {
                                  widget.onPresetLoaded?.call(presetData);
                                  Navigator.of(context).pop();
                                }
                              },
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(width: 8),
                            ModernButton(
                              icon: Icons.delete_outline_rounded,
                              onPressed: () async {
                                await _presetService.deletePreset(preset);
                                _loadPresets();
                              },
                              width: 40,
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
