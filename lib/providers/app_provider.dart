import 'package:flutter/material.dart';
class AppProvider extends ChangeNotifier {
// Propriétés privées
  bool _isOnboardingComplete = false;
  bool _isInitialized = false;
  bool _isLoading = false;
// Getters publics
  bool get isOnboardingComplete => ;
  bool get isInitialized => ;
  bool get isLoading => ;
// Méthodes à implémenter
  Future<void> init();              // Charge l'état depuis S
  torageService
  Future<void> completeOnboarding(); // Marque l'onboarding c
  omme terminé
  Future<void> resetOnboarding();    // Réinitialise l'onboar
  ding
}