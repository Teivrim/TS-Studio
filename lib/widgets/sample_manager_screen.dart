import 'package:flutter/material.dart';
import '../models/sample.dart';
import '../services/sample_service.dart';
import '../theme/app_theme.dart';
import 'fl_button.dart';

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
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
        actions: [
          FLButton(
            icon: Icons.refresh,
            onPressed: _loadSamples,
            width: 40,
            height: 40,
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter
          Container(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((category) {
                  final isSelected = category == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCategory = category),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: AppTheme.flButtonDecoration(
                          color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.3) : AppTheme.buttonColor,
                          isPrimary: isSelected,
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
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
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: AppTheme.flPanelDecoration(),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: AppTheme.flButtonDecoration(
            color: AppTheme.buttonColor,
          ),
          child: const Icon(Icons.audiotrack, color: AppTheme.primaryColor),
        ),
        title: Text(
          sample.name,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Text(
          '${sample.category} • ${sample.bpm} BPM',
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FLButton(
              icon: Icons.play_arrow,
              onPressed: onTap,
              width: 36,
              height: 36,
            ),
            const SizedBox(width: 4),
            FLButton(
              icon: Icons.delete,
              onPressed: onDelete,
              width: 36,
              height: 36,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
