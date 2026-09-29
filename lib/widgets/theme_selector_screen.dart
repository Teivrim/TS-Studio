import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';
import 'modern_panel.dart';

class ThemeSelectorScreen extends StatefulWidget {
  final String currentAccent;
  final ValueChanged<String> onAccentChanged;

  const ThemeSelectorScreen({
    super.key,
    required this.currentAccent,
    required this.onAccentChanged,
  });

  @override
  State<ThemeSelectorScreen> createState() => _ThemeSelectorScreenState();
}

class _ThemeSelectorScreenState extends State<ThemeSelectorScreen> {
  late String _selectedAccent;

  @override
  void initState() {
    super.initState();
    _selectedAccent = widget.currentAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'THEME SELECTOR',
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
            icon: Icons.check_rounded,
            onPressed: () {
              widget.onAccentChanged(_selectedAccent);
              Navigator.of(context).pop();
            },
            width: 44,
            height: 44,
            isPrimary: true,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ModernPanel(
            title: 'ACCENT COLOR',
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: ThemeService.getAccentColorNames().map((name) {
                final color = ThemeService.getAccentColor(name);
                final isSelected = name == _selectedAccent;

                return GestureDetector(
                  onTap: () => setState(() => _selectedAccent = name),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: isSelected ? 0.3 : 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? color : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? color : AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
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
