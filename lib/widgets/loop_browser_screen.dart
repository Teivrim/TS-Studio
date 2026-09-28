import 'package:flutter/material.dart';
import '../models/loop.dart';
import '../services/loop_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';

class LoopBrowserScreen extends StatefulWidget {
  final ValueChanged<Loop>? onLoopSelected;

  const LoopBrowserScreen({super.key, this.onLoopSelected});

  @override
  State<LoopBrowserScreen> createState() => _LoopBrowserScreenState();
}

class _LoopBrowserScreenState extends State<LoopBrowserScreen> {
  final List<Loop> _loops = LoopService.getBuiltInLoops();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'LOOPS',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
      ),
      body: ListView.builder(
        itemCount: _loops.length,
        itemBuilder: (context, index) {
          final loop = _loops[index];
          return _LoopTile(
            loop: loop,
            onTap: () {
              widget.onLoopSelected?.call(loop);
              Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }
}

class _LoopTile extends StatelessWidget {
  final Loop loop;
  final VoidCallback onTap;

  const _LoopTile({required this.loop, required this.onTap});

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
          child: const Icon(Icons.loop_rounded, color: AppTheme.primaryColor),
        ),
        title: Text(
          loop.name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Text(
          '${loop.bpm} BPM • ${loop.bars} bars',
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
