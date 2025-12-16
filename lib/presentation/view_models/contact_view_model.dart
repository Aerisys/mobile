import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/di.dart';
import '../../core/services/auth_service.dart';
import 'common_view_model.dart';

class ContactViewModel extends CommonViewModel {
  final IAuthService _auth = getIt<IAuthService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    isLoading = true;
    errorMessage = null;

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

      isLoading = false;
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceAll("Exception: ", "");
      isLoading = false;
      return false;
    }
  }

  Future<void> syncContactInfo(
    String contactUid,
    Map<String, dynamic> freshData,
  ) async {
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
