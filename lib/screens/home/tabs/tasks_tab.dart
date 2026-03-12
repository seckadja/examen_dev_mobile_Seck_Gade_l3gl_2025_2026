import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/Task.dart';
import '../../../providers/task_provider.dart';
import '../../../widgets/cards/task_card.dart';
import '../../../widgets/common/loading_indicator.dart';

class TasksTab extends StatefulWidget {
  const TasksTab({super.key});

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  TaskStatus?   _statusFilter;
  TaskPriority? _priorityFilter;

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    return ListenableBuilder(
      listenable: taskProvider,
      builder: (context, _) {

        if (taskProvider.isLoading) {
          return const LoadingIndicator();
        }
        final List<Task> tasks = taskProvider.tasks;

        return Column(
          children: [
            //Filtres par STATUT
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
                  FilterChip(
                    label: const Text('A faire'),
                    selected: _statusFilter == TaskStatus.todo,
                    selectedColor: Colors.orange.withOpacity(0.3),
                    onSelected: (_) {
                      setState(() => _statusFilter = TaskStatus.todo);
                      taskProvider.setStatusFilter(TaskStatus.todo);
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('En cours'),
                    selected: _statusFilter == TaskStatus.inProgress,
                    selectedColor: Colors.purple.withOpacity(0.3),
                    onSelected: (_) {
                      setState(() => _statusFilter = TaskStatus.inProgress);
                      taskProvider.setStatusFilter(TaskStatus.inProgress);
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Terminees'),
                    selected: _statusFilter == TaskStatus.done,
                    selectedColor: Colors.green.withOpacity(0.3),
                    onSelected: (_) {
                      setState(() => _statusFilter = TaskStatus.done);
                      taskProvider.setStatusFilter(TaskStatus.done);
                    },
                  ),

                ],
              ),
            ),

            //Filtres par PRIORITE
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
                  FilterChip(
                    label: const Text('Haute'),
                    selected: _priorityFilter == TaskPriority.high,
                    selectedColor: Colors.red.withOpacity(0.3),
                    onSelected: (_) {
                      setState(() => _priorityFilter = TaskPriority.high);
                      taskProvider.setPriorityFilter(TaskPriority.high);
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Moyenne'),
                    selected: _priorityFilter == TaskPriority.medium,
                    selectedColor: Colors.orange.withOpacity(0.3),
                    onSelected: (_) {
                      setState(() => _priorityFilter = TaskPriority.medium);
                      taskProvider.setPriorityFilter(TaskPriority.medium);
                    },
                  ),
                  const SizedBox(width: 8),


                  FilterChip(
                    label: const Text('Basse'),
                    selected: _priorityFilter == TaskPriority.low,
                    selectedColor: Colors.grey.withOpacity(0.3),
                    onSelected: (_) {
                      setState(() => _priorityFilter = TaskPriority.low);
                      taskProvider.setPriorityFilter(TaskPriority.low);
                    },
                  ),

                ],
              ),
            ),

            const SizedBox(height: 4),
            Visibility(
              visible: tasks.isEmpty,
              child: const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.checklist, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Aucune tache pour le moment',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            // Liste des taches
            Visibility(
              visible: tasks.isNotEmpty,
              child: Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final Task t = tasks[index];
                    return TaskCard(
                      titre:       t.title,
                      description: t.description ?? '',

                      statut: t.status == TaskStatus.inProgress ? 'inProgress'
                          : t.status == TaskStatus.done       ? 'done'
                          : 'todo',

                      priorite: t.priority == TaskPriority.high   ? 'high'
                          : t.priority == TaskPriority.medium ? 'medium'
                          : 'low',
                      dateEcheance: t.dueDate,
                      onTap: () {
                        // TODO:On naviguer vers TaskDetailScreen
                      },
                    );
                  },
                ),
              ),
            ),

          ],
        );
      },
    );
  }
}