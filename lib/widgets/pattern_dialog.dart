import 'package:flutter/material.dart';
import '../models/pattern.dart';
import '../theme/app_theme.dart';

class PatternDialog extends StatefulWidget {
  final Pattern? pattern;
  final ValueChanged<Pattern> onSave;

  const PatternDialog({super.key, this.pattern, required this.onSave});

  @override
  State<PatternDialog> createState() => _PatternDialogState();
}

class _PatternDialogState extends State<PatternDialog> {
  late TextEditingController _nameController;
  late List<List<bool>> _steps;
  late int _bpm;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pattern?.name ?? '');
    _steps = widget.pattern?.steps ?? List.generate(8, (_) => List.filled(16, false));
    _bpm = widget.pattern?.bpm ?? 120;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.pattern == null ? 'Новый паттерн' : 'Редактировать паттерн'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Название паттерна',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('BPM', style: TextStyle(fontSize: 12, color: Colors.white54)),
            Slider(
              value: _bpm.toDouble(),
              min: 60,
              max: 200,
              divisions: 140,
              activeColor: AppTheme.primaryColor,
              inactiveColor: AppTheme.gridColor,
              onChanged: (value) => setState(() => _bpm = value.round()),
            ),
            Text('$_bpm BPM', style: const TextStyle(fontSize: 14, color: AppTheme.accentColor)),
            const SizedBox(height: 16),
            const Text('Сетка', style: TextStyle(fontSize: 12, color: Colors.white54)),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 16,
                  childAspectRatio: 1,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemCount: 128,
                itemBuilder: (context, index) {
                  final row = index ~/ 16;
                  final col = index % 16;
                  final isActive = _steps[row][col];
                  final isBeat = col % 4 == 0;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _steps[row][col] = !isActive;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppTheme.primaryColor
                            : isBeat
                                ? AppTheme.inactiveStepColor
                                : AppTheme.gridColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              widget.onSave(Pattern(
                id: widget.pattern?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                name: _nameController.text,
                steps: _steps,
                bpm: _bpm,
              ));
              Navigator.of(context).pop();
            }
          },
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
