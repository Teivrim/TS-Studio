import 'package:flutter/material.dart';
import '../services/effect_rack_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';

class EffectRackScreen extends StatefulWidget {
  const EffectRackScreen({super.key});

  @override
  State<EffectRackScreen> createState() => _EffectRackScreenState();
}

class _EffectRackScreenState extends State<EffectRackScreen> {
  final EffectRackService _effectService = EffectRackService();
  Map<String, double> _values = {};

  @override
  void initState() {
    super.initState();
    _effectService.effectStream.listen((event) {
      setState(() => _values = event.values);
    });
    _effectService.start();
  }

  @override
  void dispose() {
    _effectService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'EFFECT RACK',
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
            icon: _effectService.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
            onPressed: () {
              if (_effectService.isRunning) {
                _effectService.stop();
              } else {
                _effectService.start();
              }
              setState(() {});
            },
            width: 44,
            height: 44,
            isPrimary: _effectService.isRunning,
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _effectService.effectValues.length,
        itemBuilder: (context, index) {
          final entry = _effectService.effectValues.entries.elementAt(index);
          final name = entry.key;
          final value = _values[name] ?? entry.value;

          return Container(
            decoration: AppTheme.modernPanelDecoration(),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLightColor.withValues(alpha: 0.3),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: AppTheme.borderColor.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          name.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Text(
                        '${(value * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // Slider
                Expanded(
                  child: Center(
                    child: Slider(
                      value: value,
                      min: 0,
                      max: 1,
                      activeColor: AppTheme.primaryColor,
                      inactiveColor: AppTheme.gridColor,
                      onChanged: (newValue) {
                        _effectService.setEffect(name, newValue);
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
