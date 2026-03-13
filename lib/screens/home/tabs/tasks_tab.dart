import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../models/Task.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/task_provider.dart';
import '../../../widgets/cards/task_card.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../tasks/task_form_screen.dart';
import '../../tasks/task_detail_screen.dart';

class TasksTab extends StatefulWidget {
  const TasksTab({super.key});

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  TaskStatus? _statusFilter;
  TaskPriority? _priorityFilter;

  @override
  void initState() {
    super.initState();
    // Charger les taches de l'utilisateur
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId =
          Provider.of<AuthProvider>(context, listen: false).currentUser?.id ?? '';
      Provider.of<TaskProvider>(context, listen: false).loadAllTasks(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.background,

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskFormScreen(),
            ),
          );

          final userId =
              Provider.of<AuthProvider>(context, listen: false).currentUser?.id ?? '';
          taskProvider.loadAllTasks(userId);
        },
        child: const Icon(Icons.add, color: AppColors.white),
      ),

      body: ListenableBuilder(
        listenable: taskProvider,
        builder: (context, _) {
          if (taskProvider.isLoading) {
            return const LoadingIndicator();
          }
          final List<Task> tasks = taskProvider.tasks;

          return Column(
            children: [
              // Filtres de Statut
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('Tous'),
                      selected: _statusFilter == null,
                      onSelected: (_) {
                        setState(() => _statusFilter = null);
                        taskProvider.setStatusFilter(null);
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildStatusChip(taskProvider, TaskStatus.todo, AppStrings.statusTodo, AppColors.warning),
                    const SizedBox(width: 8),
                    _buildStatusChip(taskProvider, TaskStatus.inProgress, AppStrings.statusInProgress, AppColors.info),
                    const SizedBox(width: 8),
                    _buildStatusChip(taskProvider, TaskStatus.done, AppStrings.statusDone, AppColors.success),
                  ],
                ),
              ),

              // Filtres de Priorité
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('Toutes'),
                      selected: _priorityFilter == null,
                      onSelected: (_) {
                        setState(() => _priorityFilter = null);
                        taskProvider.setPriorityFilter(null);
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildPriorityChip(taskProvider, TaskPriority.high, AppStrings.priorityHigh, AppColors.priorityHigh),
                    const SizedBox(width: 8),
                    _buildPriorityChip(taskProvider, TaskPriority.medium, AppStrings.priorityMedium, AppColors.priorityMedium),
                    const SizedBox(width: 8),
                    _buildPriorityChip(taskProvider, TaskPriority.low, AppStrings.priorityLow, AppColors.priorityLow),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              if (tasks.isEmpty)
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.checklist, size: 80, color: AppColors.textDisable),
                      SizedBox(height: 16),
                      Text(
                        AppStrings.noTasks,
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                      ),
                    ],
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final Task t = tasks[index];
                      return TaskCard(
                        titre: t.title,
                        description: t.description ?? '',
                        statut: t.status.name,
                        priorite: t.priority.name,
                        dateEcheance: t.dueDate,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailScreen(task: t),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(TaskProvider p, TaskStatus s, String label, Color color) {
    return FilterChip(
      label: Text(label),
      selected: _statusFilter == s,
      selectedColor: color.withOpacity(0.3),
      onSelected: (_) {
        setState(() => _statusFilter = s);
        p.setStatusFilter(s);
      },
    );
  }

  Widget _buildPriorityChip(TaskProvider p, TaskPriority pr, String label, Color color) {
    return FilterChip(
      label: Text(label),
      selected: _priorityFilter == pr,
      selectedColor: color.withOpacity(0.3),
      onSelected: (_) {
        setState(() => _priorityFilter = pr);
        p.setPriorityFilter(pr);
      },
    );
  }
}