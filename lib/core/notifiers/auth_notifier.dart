import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/services/auth_service.dart';
import '../services/preferences_service.dart';

class AuthNotifier extends ChangeNotifier {
  final IAuthService _authService;
  final PreferencesService _preferencesService;
  User? _user;

  AuthNotifier(this._authService, this._preferencesService) {
    _authService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  bool get isAuthenticated => _user != null;
  bool get hasSeenWelcome => _preferencesService.hasSeenWelcome;

  Future<void> completeOnboarding() async {
    await _preferencesService.setHasSeenWelcome(true);
    notifyListeners();
  }

  bool get hasCompletedSetup {
    return _preferencesService.getBool('setup_done') ?? false;
  }

  void completeSetup() {
    _preferencesService.setBool('setup_done', true);
    notifyListeners();
  }
}
