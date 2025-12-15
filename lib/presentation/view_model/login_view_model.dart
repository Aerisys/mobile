import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      _isLoading = false;
      notifyListeners();
      return true;

    } on FirebaseAuthException catch (e) {
      _isLoading = false;

      switch (e.code) {
        case 'user-not-found':
          _errorMessage = "Aucun utilisateur trouvé avec cet email.";
          break;
        case 'wrong-password':
          _errorMessage = "Mot de passe incorrect.";
          break;
        case 'invalid-email':
          _errorMessage = "L'adresse email est mal formatée.";
          break;
        case 'invalid-credential':
          _errorMessage = "L'adresse email ou le mot de passe est incorrect.";
          break;
        case 'channel-error':
          _errorMessage = "Veuillez spécifier un email et un mot de passe.";
          break;
        default:
          _errorMessage = "Erreur de connexion : ${e.message}";
      }
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = "Une erreur inconnue est survenue.";
      notifyListeners();
      return false;
    }
  }
}