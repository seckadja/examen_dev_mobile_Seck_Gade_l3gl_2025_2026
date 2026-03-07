import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/User.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;


  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialisation
  Future<void> init() async {
    _currentUser = StorageService.instance.getCurrentUser();
    notifyListeners();
  }
  Future<bool> login(String email, String password) async {

    _isLoading = true;
    _error = null;
    notifyListeners();


     final Future<List<User>> users = StorageService.instance.getUsers();


    User? found;
    for (User u in await users) {
      if (u.email == email && u.password == password) {
        found = u;
        break;
      }
    }
    if (found != null) {
      _currentUser = found;
      await StorageService.instance.saveCurrentUser(found);
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = 'Email ou mot de passe incorrect';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();


    final List<User> users = await StorageService.instance.getUsers();
    for (User u in users) {
      if (u.email == email) {
        _error = 'Cet email est déjà utilisé';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    }
    final newUser = User(
      id: const Uuid().v4(),
      name: name,
      email: email,
      password: password,
    );


    await StorageService.instance.saveUser(newUser);


    _currentUser = newUser;
    await StorageService.instance.saveCurrentUser(newUser);

    _isLoading = false;
    notifyListeners();
    return true;
  }
  Future<void> logout() async {
    _currentUser = null;
    await StorageService.instance.clearCurrentUser();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}