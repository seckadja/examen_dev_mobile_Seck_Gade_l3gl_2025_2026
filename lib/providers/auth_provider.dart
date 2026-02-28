import 'package:flutter/material.dart';
class AuthProvider extends ChangeNotifier {
// Propriétés privées
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
// Getters publics
  User? get currentUser => ;
  bool get isAuthenticated => ; // true si _currentUser != null
  bool get isLoading => ;
  String? get error => ;
// Méthodes à implémenter
  Future<void> init(); // Charge l'utilisateur depuis le stockage

  Future<bool> login(String email, String password); // Connexion

  Future<bool> register(String name, String email, String pas
  sword); // Inscription
  Future<void> logout(); // Déconnexion
  Future<void> updateProfile({String? name, String? email});
// Mise à jour profil
  void clearError(); // Efface le message d'erreur
}
