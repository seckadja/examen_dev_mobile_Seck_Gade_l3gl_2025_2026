import 'package:flutter/material.dart';
class ProjectProvider extends ChangeNotifier {
  List<Project> _projects = [];
  Project? _selectedProject;
  bool _isLoading = false;
// Getters
  List<Project> get projects => ;
  Project? get selectedProject => ;
  int get projectCount => ;
// Méthodes CRUD
  Future<void> loadProjects(String userId);
  Future<void> createProject(Project project);
  Future<void> updateProject(Project project);
  Future<void> deleteProject(String projectId);
  void selectProject(Project? project);
}