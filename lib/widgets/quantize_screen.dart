import 'package:flutter/material.dart';
import '../services/quantize_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';
import 'modern_panel.dart';

class QuantizeScreen extends StatefulWidget {
  final String initialGrid;
  final ValueChanged<String> onGridChanged;

  const QuantizeScreen({
    super.key,
    required this.initialGrid,
    required this.onGridChanged,
  });

  @override
  State<QuantizeScreen> createState() => _QuantizeScreenState();
}

class _QuantizeScreenState extends State<QuantizeScreen> {
  late String _selectedGrid;

  final List<String> _grids = [
    '1/4',
    '1/8',
    '1/16',
    '1/32',
    '1/4T',
    '1/8T',
    '1/16T',
  ];

  @override
  void initState() {
    super.initState();
    _selectedGrid = widget.initialGrid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'QUANTIZE',
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
              widget.onGridChanged(_selectedGrid);
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
          // Grid selector
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _grids.map((grid) {
                  final isSelected = grid == _selectedGrid;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedGrid = grid),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: AppTheme.modernButtonDecoration(
                          color: isSelected
                              ? AppTheme.primaryColor.withValues(alpha: 0.2)
                              : AppTheme.surfaceLightColor,
                          isPrimary: isSelected,
                          borderRadius: 12,
                        ),
                        child: Text(
                          grid,
                          style: TextStyle(
                            fontSize: 14,
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
          // Visual representation
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: ModernPanel(
                title: 'GRID',
                child: _buildGrid(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final gridLines = QuantizeService.getGridLines(_selectedGrid);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(16, (index) {
            final isGridLine = gridLines.contains(index);

            return Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isGridLine
                    ? AppTheme.primaryColor.withValues(alpha: 0.3)
                    : AppTheme.gridColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isGridLine
                      ? AppTheme.primaryColor.withValues(alpha: 0.5)
                      : Colors.transparent,
                ),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 8,
                    color: isGridLine ? AppTheme.primaryColor : AppTheme.textMuted,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        Text(
          'Grid: $_selectedGrid',
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
