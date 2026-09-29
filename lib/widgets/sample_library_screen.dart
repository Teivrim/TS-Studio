import 'package:flutter/material.dart';
import '../services/sample_library_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';

class SampleLibraryScreen extends StatefulWidget {
  const SampleLibraryScreen({super.key});

  @override
  State<SampleLibraryScreen> createState() => _SampleLibraryScreenState();
}

class _SampleLibraryScreenState extends State<SampleLibraryScreen> {
  final SampleLibraryService _sampleService = SampleLibraryService();

  @override
  void initState() {
    super.initState();
    _sampleService.sampleStream.listen((event) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _sampleService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'SAMPLE LIBRARY',
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
            icon: _sampleService.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            onPressed: () {
              if (_sampleService.isPlaying) {
                _sampleService.stop();
              } else {
                _sampleService.start();
              }
              setState(() {});
            },
            width: 44,
            height: 44,
            isPrimary: _sampleService.isPlaying,
          ),
        ],
      ),
      body: Column(
        children: [
          // Controls
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'VOLUME',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textSecondary,
                              letterSpacing: 1,
                            ),
                          ),
                          Slider(
                            value: _sampleService.volume,
                            min: 0,
                            max: 1,
                            activeColor: AppTheme.primaryColor,
                            inactiveColor: AppTheme.gridColor,
                            onChanged: (value) {
                              _sampleService.setVolume(value);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PITCH',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textSecondary,
                              letterSpacing: 1,
                            ),
                          ),
                          Slider(
                            value: _sampleService.pitch,
                            min: 0.5,
                            max: 2.0,
                            activeColor: AppTheme.primaryColor,
                            inactiveColor: AppTheme.gridColor,
                            onChanged: (value) {
                              _sampleService.setPitch(value);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PLAYBACK RATE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textSecondary,
                              letterSpacing: 1,
                            ),
                          ),
                          Slider(
                            value: _sampleService.playbackRate,
                            min: 0.25,
                            max: 4.0,
                            activeColor: AppTheme.primaryColor,
                            inactiveColor: AppTheme.gridColor,
                            onChanged: (value) {
                              _sampleService.setPlaybackRate(value);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Sample grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 8,
              itemBuilder: (context, index) {
                final sampleNames = ['Kick', 'Snare', 'Hi-Hat', 'Clap', 'Tom', 'Rim', 'Crash', 'Perc'];
                final sampleColors = [
                  AppTheme.dangerColor,
                  AppTheme.warningColor,
                  AppTheme.accentColor,
                  AppTheme.successColor,
                  AppTheme.primaryColor,
                  AppTheme.secondaryColor,
                  AppTheme.textSecondary,
                  AppTheme.borderColor,
                ];

                return GestureDetector(
                  onTap: () {
                    _sampleService.start();
                    setState(() {});
                  },
                  child: Container(
                    decoration: AppTheme.modernButtonDecoration(
                      color: sampleColors[index].withValues(alpha: 0.1),
                      borderRadius: 16,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.music_note_rounded,
                          size: 32,
                          color: sampleColors[index],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          sampleNames[index],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: sampleColors[index],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
