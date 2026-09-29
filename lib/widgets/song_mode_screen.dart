import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';
import 'modern_panel.dart';

class SongModeScreen extends StatefulWidget {
  final ValueChanged<List<int>>? onArrangementSelected;

  const SongModeScreen({super.key, this.onArrangementSelected});

  @override
  State<SongModeScreen> createState() => _SongModeScreenState();
}

class _SongModeScreenState extends State<SongModeScreen> {
  final List<String> _arrangement = [];
  final List<String> _sections = ['Intro', 'Verse', 'Chorus', 'Bridge', 'Outro'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'SONG MODE',
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
            icon: Icons.clear_all_rounded,
            onPressed: () => setState(() => _arrangement.clear()),
            width: 44,
            height: 44,
          ),
          ModernButton(
            icon: Icons.check_rounded,
            onPressed: () {
              widget.onArrangementSelected?.call(_arrangement.map((s) => _sections.indexOf(s)).toList());
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
          // Current arrangement
          Container(
            padding: const EdgeInsets.all(16),
            child: ModernPanel(
              title: 'ARRANGEMENT',
              child: _arrangement.isEmpty
                  ? const Text(
                      'Добавьте секции песни',
                      style: TextStyle(color: AppTheme.textSecondary),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _arrangement.asMap().entries.map((entry) {
                        final index = entry.key;
                        final section = entry.value;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: AppTheme.modernButtonDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.2),
                            borderRadius: 12,
                          ),
                          child: Text(
                            '${index + 1}. $section',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ),
          // Section buttons
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: _sections.map((section) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ModernButton(
                    text: section,
                    onPressed: () {
                      setState(() {
                        _arrangement.add(section);
                      });
                    },
                    width: double.infinity,
                    height: 56,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
