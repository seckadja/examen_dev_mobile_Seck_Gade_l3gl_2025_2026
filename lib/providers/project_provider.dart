import 'package:flutter/foundation.dart';
import '../models/Project.dart';
import '../services/storage_service.dart';

class ProjectProvider extends ChangeNotifier {

  // ===== DONNÉES PRIVÉES =====
  List<Project> _projects = [];
  Project? _selectedProject;
  bool _isLoading = false;

  // ===== GETTERS =====
  List<Project> get projects => _projects;
  Project? get selectedProject => _selectedProject;
  int get projectCount => _projects.length;
  bool get isLoading => _isLoading;

  // ===== CHARGER LES PROJETS =====
  Future<void> loadProjects(String userId) async {
    _isLoading = true;
    notifyListeners();

    // Récupérer tous les projets
    final allProjects = await StorageService.instance.getProjects();

    // Garder seulement les projets de cet utilisateur
    _projects = allProjects.where((p) => p.userId == userId).toList();

    _isLoading = false;
    notifyListeners();
  }

  // ===== CRÉER UN PROJET =====
  Future<void> createProject(Project project) async {
    await StorageService.instance.saveProject(project);
    _projects.add(project);
    notifyListeners();
  }

  // ===== MODIFIER UN PROJET =====
  Future<void> updateProject(Project project) async {
    await StorageService.instance.updateProject(project);
    // Supprimer l'ancien et ajouter le nouveau
    _projects.removeWhere((p) => p.id == project.id);
    _projects.add(project);
    notifyListeners();
  }

  // ===== SUPPRIMER UN PROJET =====
  Future<void> deleteProject(String projectId) async {

    await StorageService.instance.deleteProject(projectId);

    await StorageService.instance.deleteTasksByProjectId(projectId);

    _projects.removeWhere((p) => p.id == projectId);
    if (_selectedProject?.id == projectId) {
      _selectedProject = null;
    }
    notifyListeners();
  }

  // ===== SÉLECTIONNER UN PROJET =====
  void selectProject(Project? project) {
    _selectedProject = project;
    notifyListeners();
  }
}