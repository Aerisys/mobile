import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ContactViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Stream<QuerySnapshot> getContactsStream() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('contacts')
        .orderBy('displayName')
        .snapshots();
  }

  Future<bool> addContactByEmail(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception("Non connecté");

      if (email.trim() == currentUser.email) {
        throw Exception("Vous ne pouvez pas vous ajouter vous-même.");
      }

      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email.trim())
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("Aucun utilisateur trouvé avec cet email.");
      }

      final userToAdd = querySnapshot.docs.first.data();
      final userToAddId = userToAdd['uid'];

      final existingContact = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('contacts')
          .doc(userToAddId)
          .get();

      if (existingContact.exists) {
        throw Exception("Cette personne est déjà dans vos contacts.");
      }

      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('contacts')
          .doc(userToAddId)
          .set({
        'uid': userToAddId,
        'email': userToAdd['email'],
        'displayName': userToAdd['displayName'] ?? 'Sans nom',
        'photoURL': userToAdd['photoURL'],
        'addedAt': FieldValue.serverTimestamp(),
      });

      _isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> syncContactInfo(String contactUid, Map<String, dynamic> freshData) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('contacts')
          .doc(contactUid)
          .update({
        'displayName': freshData['displayName'],
        'photoURL': freshData['photoURL'],
      });
    } catch (e) {
      return;
    }
  }
}