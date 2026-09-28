import 'package:flutter/material.dart';
import '../services/automation_service.dart';
import '../theme/app_theme.dart';
import 'fl_button.dart';

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
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
        actions: [
          FLButton(
            icon: Icons.add,
            onPressed: _showAddLaneDialog,
            width: 40,
            height: 40,
          ),
        ],
      ),
      body: Column(
        children: [
          // Transport
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                FLButton(
                  icon: widget.automationService.isPlaying ? Icons.pause : Icons.play_arrow,
                  onPressed: () {
                    if (widget.automationService.isPlaying) {
                      widget.automationService.pause();
                    } else {
                      widget.automationService.play();
                    }
                    setState(() {});
                  },
                  width: 48,
                  height: 48,
                  isPrimary: true,
                ),
                const SizedBox(width: 8),
                FLButton(
                  icon: Icons.stop,
                  onPressed: () {
                    widget.automationService.stop();
                    setState(() {});
                  },
                  width: 48,
                  height: 48,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Time: ${widget.automationService.currentTime.toStringAsFixed(2)}s',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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
                          widget.automationService.addPoint(lane.id, AutomationPoint(time, value));
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
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: AppTheme.flPanelDecoration(),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppTheme.buttonColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    lane.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                Text(
                  lane.parameter,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                FLButton(
                  icon: Icons.delete,
                  onPressed: onDelete,
                  width: 28,
                  height: 28,
                ),
              ],
            ),
          ),
          // Automation curve
          SizedBox(
            height: 100,
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
      ..color = AppTheme.primaryColor.withValues(alpha: 0.2)
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
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
