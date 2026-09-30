import 'package:flutter/material.dart';
import '../services/spectrum_analyzer_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';

class SpectrumAnalyzerScreen extends StatefulWidget {
  const SpectrumAnalyzerScreen({super.key});

  @override
  State<SpectrumAnalyzerScreen> createState() => _SpectrumAnalyzerScreenState();
}

class _SpectrumAnalyzerScreenState extends State<SpectrumAnalyzerScreen> {
  final SpectrumAnalyzerService _spectrumService = SpectrumAnalyzerService();
  List<double> _spectrum = [];

  @override
  void initState() {
    super.initState();
    _spectrumService.spectrumStream.listen((spectrum) {
      setState(() => _spectrum = spectrum);
    });
    _spectrumService.start();
  }

  @override
  void dispose() {
    _spectrumService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'SPECTRUM ANALYZER',
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
            icon: _spectrumService.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
            onPressed: () {
              if (_spectrumService.isRunning) {
                _spectrumService.stop();
              } else {
                _spectrumService.start();
              }
              setState(() {});
            },
            width: 44,
            height: 44,
            isPrimary: _spectrumService.isRunning,
          ),
        ],
      ),
      body: Column(
        children: [
          // Spectrum display
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: _spectrum.isEmpty
                  ? const Center(
                      child: Text(
                        'No spectrum data',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: _spectrum.map((value) {
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  AppTheme.primaryColor,
                                  AppTheme.secondaryColor,
                                  AppTheme.accentColor,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ),
          // Frequency labels
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('20Hz', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                Text('1kHz', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                Text('20kHz', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
