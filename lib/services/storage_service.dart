import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/Project.dart';
import '../models/Task.dart';
import '../models/User.dart';
/**
 * Pattern Singleton:
 * Pour avoir une seule instance
 */


class StorageService {
  //===== Singleton ==========
  /// Instance Unique (privee)
  static StorageService? _instance;

  /// Getter pour acceder a l'instance
  static StorageService get instance {
    _instance ??= StorageService._();
    return _instance!;
  }

  /// Constructeur prive
  StorageService._();

  //===== SharedPreferences ==========
  /**
   * SharedPreferences utilise des opérations asynchrones
   * car il lit/ecrtit sur le disque
   *
   * Le mot-cle await attend que l'operation se termine
   * La fonction doit etre marque async et retourner un Future
   * Les variables doivent être marqué par late
   */
  late SharedPreferences _prefs;

  /// Indicateur d'initialisation
  bool _initialized = false;

  Future<void> init() async {
    if(_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  // ======== Cles de Stockage =========
  static const String _keyOnboardingConmplete = 'onboarding_complete';


  bool get isOnboardingComplete {
    return _prefs.getBool(_keyOnboardingConmplete) ?? false;
  }

  Future<void> setOnboardingComplete(bool value) async {
    await _prefs.setBool(_keyOnboardingConmplete, value);
  }
  static const String _keyUsers = 'users';
  static const String _keyCurrentUser = 'current_user';

  Future<List<User>> getUsers() async {
    final String? usersJson = _prefs.getString(_keyUsers);
    if (usersJson == null) return [];
    final List<dynamic> decoded = jsonDecode(usersJson);
    return decoded.map((item) => User.fromMap(item)).toList();
  }
  Future<void> saveUser(User user) async {
    final users = await getUsers();
    users.add(user);
    await _prefs.setString(_keyUsers, jsonEncode(users.map((u) => u.toMap()).toList()));
  }
  Future<void> saveCurrentUser(User user) async {
    await _prefs.setString(_keyCurrentUser, jsonEncode(user.toMap()));
  }
  User? getCurrentUser() {
    final String? userJson = _prefs.getString(_keyCurrentUser);
    if (userJson == null) return null;
    return User.fromMap(jsonDecode(userJson));
  }

  Future<void> clearCurrentUser() async {
    await _prefs.remove(_keyCurrentUser);
  }
  static const String _keyProjects = 'projects';
  static const String _keyTasks = 'tasks';
//Project
  Future<List<Project>> getProjects() async {
    final String? projectsJson = _prefs.getString(_keyProjects);
    if (projectsJson == null) return [];
    final List<dynamic> decoded = jsonDecode(projectsJson);
    return decoded.map((item) => Project.fromMap(item)).toList();
  }

  Future<void> saveProject(Project project) async {
    final projects = await getProjects();
    projects.add(project);
    await _prefs.setString(_keyProjects, jsonEncode(projects.map((p) => p.toMap()).toList()));
  }

  Future<void> deleteProject(String projectId) async {
    final projects = await getProjects();
    projects.removeWhere((p) => p.id == projectId);
    await _prefs.setString(_keyProjects, jsonEncode(projects.map((p) => p.toMap()).toList()));
  }
  Future<void> updateProject(Project project) async {
    final projects = await getProjects();
    projects.removeWhere((p) => p.id == project.id);
    projects.add(project);
    await _prefs.setString(_keyProjects, jsonEncode(projects.map((p) => p.toMap()).toList()));
  }
 //Tasks
  Future<List<Task>> getTasks() async {
    final String? tasksJson = _prefs.getString(_keyTasks);
    if (tasksJson == null) return [];
    final List<dynamic> decoded = jsonDecode(tasksJson);
    return decoded.map((item) => Task.fromMap(item)).toList();
  }
  Future<void> saveTask(Task task) async {
    final tasks = await getTasks();
    tasks.add(task);
    await _prefs.setString(_keyTasks, jsonEncode(tasks.map((t) => t.toMap()).toList()));
  }
  Future<void> updateTask(Task task) async {
    final tasks = await getTasks();
    tasks.removeWhere((t) => t.id == task.id);
    tasks.add(task);
    await _prefs.setString(_keyTasks, jsonEncode(tasks.map((t) => t.toMap()).toList()));
  }
  Future<void> deleteTask(String taskId) async {
    final tasks = await getTasks();
    tasks.removeWhere((t) => t.id == taskId);
    await _prefs.setString(_keyTasks, jsonEncode(tasks.map((t) => t.toMap()).toList()));
  }
  Future<void> deleteTasksByProjectId(String projectId) async {
    final tasks = await getTasks();
    tasks.removeWhere((t) => t.projectId == projectId);
    await _prefs.setString(_keyTasks, jsonEncode(tasks.map((t) => t.toMap()).toList()));
  }
}