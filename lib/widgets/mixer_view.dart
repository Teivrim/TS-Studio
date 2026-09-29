import 'package:flutter/material.dart';
import '../services/audio_mixer_service.dart';
import '../theme/app_theme.dart';

class MixerView extends StatefulWidget {
  final AudioMixerService mixerService;

  const MixerView({super.key, required this.mixerService});

  @override
  State<MixerView> createState() => _MixerViewState();
}

class _MixerViewState extends State<MixerView> {
  @override
  void initState() {
    super.initState();
    widget.mixerService.start();
  }

  @override
  void dispose() {
    widget.mixerService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'MIXER',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
      ),
      body: StreamBuilder<List<double>>(
        stream: widget.mixerService.levelStream,
        builder: (context, snapshot) {
          final levels = snapshot.data ?? List.filled(8, 0.0);
          return Column(
            children: [
              Expanded(
                child: Row(
                  children: List.generate(8, (index) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.borderColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  FractionallySizedBox(
                                    heightFactor: levels[index],
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            AppTheme.successColor,
                                            AppTheme.warningColor,
                                            AppTheme.dangerColor,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'CH ${index + 1}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
