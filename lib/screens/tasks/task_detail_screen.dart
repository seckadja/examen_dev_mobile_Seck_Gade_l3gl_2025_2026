import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../models/Task.dart';
import '../../providers/task_provider.dart';
import 'task_form_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {

    final taskProvider = Provider.of<TaskProvider>(context);


    final currentTask = taskProvider.tasks.firstWhere(
            (t) => t.id == task.id,
        orElse: () => task
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Détails de la tâche"),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskFormScreen(
                    projectId: currentTask.projectId,
                    task: currentTask,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.errorLight),
            onPressed: () => _confirmerSuppression(context, currentTask),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TITRE ET DESCRIPTION
            _buildSection(
              title: currentTask.title,
              content: currentTask.description ?? "Aucune description",
              isTitle: true,
            ),

            const SizedBox(height: 25),
            const Divider(),
            const SizedBox(height: 20),

            // STATUT
            const Text(
              AppStrings.taskStatus,
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _statusOption(context, currentTask, TaskStatus.todo, AppStrings.statusTodo),
                _statusOption(context, currentTask, TaskStatus.inProgress, AppStrings.statusInProgress),
                _statusOption(context, currentTask, TaskStatus.done, AppStrings.statusDone),
              ],
            ),

            const SizedBox(height: 30),

            // PRIORITÉ ET DATE
            Row(
              children: [
                Expanded(
                  child: _infoCard(
                    label: AppStrings.taskPriority,
                    value: _getPriorityLabel(currentTask.priority),
                    icon: Icons.flag,
                    color: _getPriorityColor(currentTask.priority),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _infoCard(
                    label: AppStrings.taskDueDate,
                    value: currentTask.dueDate != null
                        ? "${currentTask.dueDate!.day}/${currentTask.dueDate!.month}/${currentTask.dueDate!.year}"
                        : "Non définie",
                    icon: Icons.calendar_today,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour afficher les blocs d'information
  Widget _buildSection({required String title, required String content, bool isTitle = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTitle ? 22 : 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  // Bouton pour le changement rapide de statut
  Widget _statusOption(BuildContext context, Task task, TaskStatus status, String label) {
    bool isSelected = task.status == status;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Provider.of<TaskProvider>(context, listen: false)
              .updateTaskStatus(task.id, status);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.primary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // carte d'info pour la priorité et la date
  Widget _infoCard({required String label, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textDisable)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  // Fonctions utilitaires pour la priorité
  String _getPriorityLabel(TaskPriority p) {
    if (p == TaskPriority.high) return AppStrings.priorityHigh;
    if (p == TaskPriority.medium) return AppStrings.priorityMedium;
    return AppStrings.priorityLow;
  }

  Color _getPriorityColor(TaskPriority p) {
    if (p == TaskPriority.high) return AppColors.priorityHigh;
    if (p == TaskPriority.medium) return AppColors.priorityMedium;
    return AppColors.priorityLow;
  }

  void _confirmerSuppression(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.deleteTask),
        content: const Text(AppStrings.confirmDelete),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text(AppStrings.cancel)),
          TextButton(
            onPressed: () async {
              await Provider.of<TaskProvider>(context, listen: false).deleteTask(task.id);
              if (context.mounted) {
                Navigator.pop(ctx);
                Navigator.pop(context);
              }
            },
            child: const Text(AppStrings.delete, style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}