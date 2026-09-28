import 'package:flutter/material.dart';
import '../services/automation_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';

class AutomationScreen extends StatefulWidget {
  final AutomationService automationService;

  const AutomationScreen({super.key, required this.automationService});

  @override
  State<AutomationScreen> createState() => _AutomationScreenState();
}

class _AutomationScreenState extends State<AutomationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'AUTOMATION',
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
            icon: Icons.add_rounded,
            onPressed: _showAddLaneDialog,
            width: 44,
            height: 44,
          ),
        ],
      ),
      body: Column(
        children: [
          // Transport
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ModernButton(
                  icon: widget.automationService.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  onPressed: () {
                    if (widget.automationService.isPlaying) {
                      widget.automationService.pause();
                    } else {
                      widget.automationService.play();
                    }
                    setState(() {});
                  },
                  width: 56,
                  height: 56,
                  isPrimary: true,
                ),
                const SizedBox(width: 12),
                ModernButton(
                  icon: Icons.stop_rounded,
                  onPressed: () {
                    widget.automationService.stop();
                    setState(() {});
                  },
                  width: 56,
                  height: 56,
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Text(
                    'Time: ${widget.automationService.currentTime.toStringAsFixed(2)}s',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Lanes
          Expanded(
            child: widget.automationService.lanes.isEmpty
                ? const Center(
                    child: Text(
                      'Нет автоматизаций',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  )
                : ListView.builder(
                    itemCount: widget.automationService.lanes.length,
                    itemBuilder: (context, index) {
                      final lane = widget.automationService.lanes[index];
                      return _AutomationLaneWidget(
                        lane: lane,
                        currentTime: widget.automationService.currentTime,
                        onDelete: () {
                          widget.automationService.removeLane(lane.id);
                          setState(() {});
                        },
                        onAddPoint: (time, value) {
                          widget.automationService.addPoint(
                            lane.id,
                            AutomationPoint(time, value),
                          );
                          setState(() {});
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showAddLaneDialog() {
    final nameController = TextEditingController();
    final parameterController = TextEditingController(text: 'volume');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Новая автоматизация'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Название',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: parameterController,
              decoration: const InputDecoration(
                hintText: 'Параметр (volume, pan, etc.)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                widget.automationService.addLane(AutomationLane(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  parameter: parameterController.text,
                  points: [],
                ));
                Navigator.of(context).pop();
                setState(() {});
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }
}

class _AutomationLaneWidget extends StatelessWidget {
  final AutomationLane lane;
  final double currentTime;
  final VoidCallback onDelete;
  final void Function(double time, double value) onAddPoint;

  const _AutomationLaneWidget({
    required this.lane,
    required this.currentTime,
    required this.onDelete,
    required this.onAddPoint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    lane.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                Text(
                  lane.parameter,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                ModernButton(
                  icon: Icons.delete_outline_rounded,
                  onPressed: onDelete,
                  width: 36,
                  height: 36,
                ),
              ],
            ),
          ),
          // Automation curve
          SizedBox(
            height: 120,
            child: GestureDetector(
              onTapUp: (details) {
                final box = context.findRenderObject() as RenderBox;
                final localPosition = details.localPosition;
                final time = (localPosition.dx / box.size.width) * 10;
                final value = 1.0 - (localPosition.dy / box.size.height);
                onAddPoint(time, value.clamp(0.0, 1.0));
              },
              child: CustomPaint(
                painter: _AutomationPainter(
                  points: lane.points,
                  currentTime: currentTime,
                ),
                size: Size.infinite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AutomationPainter extends CustomPainter {
  final List<AutomationPoint> points;
  final double currentTime;

  _AutomationPainter({required this.points, required this.currentTime});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = AppTheme.primaryColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    if (points.isEmpty) return;

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < points.length; i++) {
      final x = (points[i].time / 10) * size.width;
      final y = size.height - (points[i].value * size.height);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo((points.last.time / 10) * size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw current time indicator
    final currentTimeX = (currentTime / 10) * size.width;
    final currentTimePaint = Paint()
      ..color = AppTheme.accentColor
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(currentTimeX, 0),
      Offset(currentTimeX, size.height),
      currentTimePaint,
    );

    // Draw points
    final pointPaint = Paint()
      ..color = AppTheme.accentColor
      ..style = PaintingStyle.fill;

    for (final point in points) {
      final x = (point.time / 10) * size.width;
      final y = size.height - (point.value * size.height);
      canvas.drawCircle(Offset(x, y), 5, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
