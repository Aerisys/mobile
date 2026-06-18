import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; 

import '../../data/models/app_user_model.dart';
import 'user_service.dart';

abstract class IAuthService {
  Stream<User?> get authStateChanges;
  Future<void> signInWithEmail(String email, String password);
  Future<void> signOut();
  Future<void> createUserWithEmailAndPassword(String email, String password);
  Future<UserCredential?> signInWithGoogle();
  User? get currentUser;
}

class AuthService implements IAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final IAppUserService _appUserService;
  
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthService(this._appUserService);

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<void> signInWithEmail(String email, String password) async {
    email = email.trim().toLowerCase();
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password.trim(),
    );
    if (_appUserService.currentAppUser != null) {
      _appUserService.updateUser(_appUserService.currentAppUser!);
    }
  }
  
  @override
  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    
    if (googleUser == null) return null; 

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = 
        await _firebaseAuth.signInWithCredential(credential);

    if (userCredential.additionalUserInfo?.isNewUser ?? false) {
      final user = userCredential.user;
      if (user != null) {
        final newAppUser = AppUser(
          uid: user.uid,
          displayName: user.displayName ?? 'Utilisateur Aerisys',
          email: user.email ?? '',
          photoURL: user.photoURL ?? '',
          position: null,
          createdAt: Timestamp.now(),
          updatedAt: Timestamp.now(),
        );
        await _appUserService.createUser(newAppUser);
      }
    }

    return userCredential;
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut(); 
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    email = email.trim().toLowerCase();
    final UserCredential cred = await _firebaseAuth
        .createUserWithEmailAndPassword(
          email: email,
          password: password.trim(),
        );

    if (cred.user == null) return;
    final user = AppUser(
      uid: cred.user!.uid,
      displayName: cred.user!.displayName ?? '',
      email: email,
      photoURL: cred.user!.photoURL ?? '',
      position: null,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    );
    _appUserService.createUser(user);
  }

  @override
  User? get currentUser => _firebaseAuth.currentUser;
}