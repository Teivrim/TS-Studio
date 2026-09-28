import 'package:flutter/material.dart';
import '../models/sample.dart';
import '../services/sample_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';

class SampleManagerScreen extends StatefulWidget {
  final SampleService sampleService;
  final ValueChanged<Sample>? onSampleSelected;

  const SampleManagerScreen({
    super.key,
    required this.sampleService,
    this.onSampleSelected,
  });

  @override
  State<SampleManagerScreen> createState() => _SampleManagerScreenState();
}

class _SampleManagerScreenState extends State<SampleManagerScreen> {
  List<Sample> _samples = [];
  String _selectedCategory = 'All';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSamples();
  }

  Future<void> _loadSamples() async {
    setState(() => _isLoading = true);
    final samples = await widget.sampleService.listSamples();
    setState(() {
      _samples = samples;
      _isLoading = false;
    });
  }

  List<String> get _categories {
    final categories = _samples.map((s) => s.category).toSet().toList();
    return ['All', ...categories];
  }

  List<Sample> get _filteredSamples {
    if (_selectedCategory == 'All') return _samples;
    return _samples.where((s) => s.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'SAMPLE MANAGER',
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
            icon: Icons.refresh_rounded,
            onPressed: _loadSamples,
            width: 44,
            height: 44,
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((category) {
                  final isSelected = category == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCategory = category),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: AppTheme.modernButtonDecoration(
                          color: isSelected
                              ? AppTheme.primaryColor.withValues(alpha: 0.2)
                              : AppTheme.surfaceLightColor,
                          isPrimary: isSelected,
                          borderRadius: 12,
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 12,
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
          // Sample list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredSamples.isEmpty
                    ? const Center(
                        child: Text(
                          'Нет сэмплов',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredSamples.length,
                        itemBuilder: (context, index) {
                          final sample = _filteredSamples[index];
                          return _SampleTile(
                            sample: sample,
                            onTap: () {
                              widget.onSampleSelected?.call(sample);
                              Navigator.of(context).pop();
                            },
                            onDelete: () async {
                              await widget.sampleService.deleteSample(sample.id);
                              _loadSamples();
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _SampleTile extends StatelessWidget {
  final Sample sample;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _SampleTile({
    required this.sample,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: AppTheme.modernPanelDecoration(),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: AppTheme.modernButtonDecoration(
            color: AppTheme.surfaceLightColor,
            borderRadius: 12,
          ),
          child: const Icon(Icons.audiotrack_rounded, color: AppTheme.primaryColor),
        ),
        title: Text(
          sample.name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Text(
          '${sample.category} • ${sample.bpm} BPM',
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ModernButton(
              icon: Icons.play_arrow_rounded,
              onPressed: onTap,
              width: 44,
              height: 44,
            ),
            const SizedBox(width: 8),
            ModernButton(
              icon: Icons.delete_outline_rounded,
              onPressed: onDelete,
              width: 44,
              height: 44,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
