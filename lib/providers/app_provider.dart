import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

class AppProvider extends ChangeNotifier {

  // Les données privées
  bool _isOnboardingComplete = false;
  bool _isInitialized = false;
  bool _isLoading = false;

  // Les getters pour lire depuis l'extérieur
  bool get isOnboardingComplete => _isOnboardingComplete;
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;


  Future<void> init() async {
    _isLoading = true;
    notifyListeners();


    _isOnboardingComplete = StorageService.instance.isOnboardingComplete;

    _isLoading = false;
    _isInitialized = true;
    notifyListeners();
  }


  Future<void> completeOnboarding() async {
    await StorageService.instance.setOnboardingComplete(true);
    _isOnboardingComplete = true;
    notifyListeners();
  }


  Future<void> resetOnboarding() async {
    await StorageService.instance.setOnboardingComplete(false);
    _isOnboardingComplete = false;
    notifyListeners();
  }
}