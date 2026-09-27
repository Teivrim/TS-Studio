import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/sequencer_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: TSStudioApp()));
}

class TSStudioApp extends StatelessWidget {
  const TSStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TS Studio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SequencerScreen(),
    );
  }
}
