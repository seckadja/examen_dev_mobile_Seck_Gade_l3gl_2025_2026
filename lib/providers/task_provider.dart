import 'package:flutter/material.dart';
class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  TaskStatus? _statusFilter;
  TaskPriority? _priorityFilter;
  bool _isLoading = false;
// Getters
  List<Task> get tasks => ; // Retourne les tâches filtrée
  s et triées
  Map<TaskStatus, int> get taskCountByStatus => ; // Compt
  eur par statut
// Méthodes CRUD
  Future<void> loadTasks(String projectId);
  Future<void> createTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
  Future<void> updateTaskStatus(String taskId, TaskStatus status);

// Filtres
  void setStatusFilter(TaskStatus? status);
  void setPriorityFilter(TaskPriority? priority);
  void clearFilters();
}