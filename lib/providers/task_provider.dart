import 'package:flutter/foundation.dart';
import '../models/Task.dart';
import '../services/storage_service.dart';

class TaskProvider extends ChangeNotifier {

  // ===== DONNÉES PRIVÉES =====
  List<Task> _tasks = [];
  TaskStatus? _statusFilter;
  TaskPriority? _priorityFilter;
  bool _isLoading = false;

  // ===== GETTERS =====
  bool get isLoading => _isLoading;

  // Retourne les tâches filtrées
  List<Task> get tasks {
    List<Task> result = _tasks;

    // on Applique le filtre de statut
    if (_statusFilter != null) {
      result = result.where((t) => t.status == _statusFilter).toList();
    }

    // on Appliquer le filtre de priorité
    if (_priorityFilter != null) {
      result = result.where((t) => t.priority == _priorityFilter).toList();
    }

    return result;
  }

  // On Compte les tâches par statut
  Map<TaskStatus, int> get taskCountByStatus {
    return {
      TaskStatus.todo: _tasks.where((t) => t.status == TaskStatus.todo).length,
      TaskStatus.inProgress: _tasks.where((t) => t.status == TaskStatus.inProgress).length,
      TaskStatus.done: _tasks.where((t) => t.status == TaskStatus.done).length,
    };
  }

  // ===== CHARGER LES TÂCHES =====
  Future<void> loadTasks(String projectId) async {
    _isLoading = true;
    notifyListeners();

    final allTasks = await StorageService.instance.getTasks();


    _tasks = allTasks.where((t) => t.projectId == projectId).toList();

    _isLoading = false;
    notifyListeners();
  }

  // ===== CRÉER UNE TÂCHE =====
  Future<void> createTask(Task task) async {
    await StorageService.instance.saveTask(task);
    _tasks.add(task);
    notifyListeners();
  }

  // ===== MODIFIER UNE TÂCHE =====
  Future<void> updateTask(Task task) async {
    await StorageService.instance.updateTask(task);
    _tasks.removeWhere((t) => t.id == task.id);
    _tasks.add(task);
    notifyListeners();
  }

  // ===== SUPPRIMER UNE TÂCHE =====
  Future<void> deleteTask(String taskId) async {
    await StorageService.instance.deleteTask(taskId);
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }

  // ===== CHANGER LE STATUT D'UNE TÂCHE =====
  Future<void> updateTaskStatus(String taskId, TaskStatus status) async {

    final task = _tasks.firstWhere((t) => t.id == taskId);
    final updatedTask = task.copyWith(status: status);
    await updateTask(updatedTask);
  }

  // ===== FILTRES =====
  void setStatusFilter(TaskStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  void setPriorityFilter(TaskPriority? priority) {
    _priorityFilter = priority;
    notifyListeners();
  }

  void clearFilters() {
    _statusFilter = null;
    _priorityFilter = null;
    notifyListeners();
  }
}