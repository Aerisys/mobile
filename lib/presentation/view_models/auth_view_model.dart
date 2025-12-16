import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../core/di.dart';
import '../../core/enums/auth_exception_code_enum.dart';
import '../../core/enums/firestore_collection_enum.dart';
import '../../core/enums/storage_child_enum.dart';
import '../../core/services/auth_service.dart';
import 'common_view_model.dart';

class AuthViewModel extends CommonViewModel {
  final IAuthService _auth = getIt<IAuthService>();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;

    try {
      await _auth.signInWithEmail(email, password);

      isLoading = false;
      return true;
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      errorMessage = AuthExceptionCode.getMessageFromCode(e.code);
      return false;
    } catch (e) {
      isLoading = false;
      errorMessage = "Une erreur inconnue est survenue.";
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    isLoading = true;
    errorMessage = null;

    try {
      final UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email,
        password,
      );

      if (cred.user != null) {
        await FirebaseFirestore.instance
            .collection(FirestoreCollection.users.value)
            .doc(cred.user!.uid)
            .set({
              'uid': cred.user!.uid,
              'email': email.trim(),
              'displayName': '',
              'photoURL': null,
              'createdAt': FieldValue.serverTimestamp(),
            });
      }

      isLoading = false;
      return true;
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      errorMessage = AuthExceptionCode.getMessageFromCode(e.code);
      return false;
    } catch (e) {
      isLoading = false;
      errorMessage = "Une erreur inconnue est survenue.";
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<bool> updateProfile({
    required String newName,
    File? newImageFile,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("Utilisateur non connecté");

      String? photoUrl;

      if (newImageFile != null) {
        final ref = _storage
            .ref()
            .child(StorageChild.profileImages.value)
            .child('${user.uid}.jpg');
        await ref.putFile(newImageFile);
        photoUrl = await ref.getDownloadURL();
        await user.updatePhotoURL(photoUrl);
      }

      if (newName != user.displayName) {
        await user.updateDisplayName(newName);
      }

      final Map<String, dynamic> firestoreData = {};

      if (newName.isNotEmpty) {
        firestoreData['displayName'] = newName;
      }
      if (photoUrl != null) {
        firestoreData['photoURL'] = photoUrl;
      }

      if (firestoreData.isNotEmpty) {
        await _firestore
            .collection(FirestoreCollection.users.value)
            .doc(user.uid)
            .update(firestoreData);
      }

      await user.reload();

      isLoading = false;
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = "Erreur mise à jour : $e";
      return false;
    }
  }
}
