import 'package:flutter/material.dart';
import '../models/project.dart';
import '../services/project_browser_service.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';

class ProjectBrowserScreen extends StatefulWidget {
  final ProjectBrowserService projectBrowserService;
  final ValueChanged<Project>? onProjectSelected;

  const ProjectBrowserScreen({
    super.key,
    required this.projectBrowserService,
    this.onProjectSelected,
  });

  @override
  State<ProjectBrowserScreen> createState() => _ProjectBrowserScreenState();
}

class _ProjectBrowserScreenState extends State<ProjectBrowserScreen> {
  List<Project> _projects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() => _isLoading = true);
    final projects = await widget.projectBrowserService.listProjects();
    setState(() {
      _projects = projects;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'PROJECTS',
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
            onPressed: _loadProjects,
            width: 44,
            height: 44,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _projects.isEmpty
              ? const Center(
                  child: Text(
                    'Нет сохранённых проектов',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                )
              : ListView.builder(
                  itemCount: _projects.length,
                  itemBuilder: (context, index) {
                    final project = _projects[index];
                    return _ProjectTile(
                      project: project,
                      onTap: () {
                        widget.onProjectSelected?.call(project);
                        Navigator.of(context).pop();
                      },
                      onDelete: () async {
                        await widget.projectBrowserService.deleteProject(project.id);
                        _loadProjects();
                      },
                      onRename: () => _showRenameDialog(project),
                    );
                  },
                ),
    );
  }

  void _showRenameDialog(Project project) {
    final controller = TextEditingController(text: project.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Переименовать проект'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Название проекта',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await widget.projectBrowserService.renameProject(project.id, controller.text);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  _loadProjects();
                }
              }
            },
            child: const Text('Переименовать'),
          ),
        ],
      ),
    );
  }
}

class _ProjectTile extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onRename;

  const _ProjectTile({
    required this.project,
    required this.onTap,
    required this.onDelete,
    required this.onRename,
  });

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
          child: const Icon(Icons.music_note_rounded, color: AppTheme.primaryColor),
        ),
        title: Text(
          project.name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Text(
          '${project.bpm} BPM • ${project.trackCount} треков • ${_formatDate(project.modifiedAt)}',
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ModernButton(
              icon: Icons.edit_rounded,
              onPressed: onRename,
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 8),
            ModernButton(
              icon: Icons.delete_outline_rounded,
              onPressed: onDelete,
              width: 40,
              height: 40,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
