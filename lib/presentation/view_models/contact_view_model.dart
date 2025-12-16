import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ContactViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Stream<QuerySnapshot> getContactsStream() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('contacts')
        .snapshots();
  }

  Stream<QuerySnapshot> getRequestsStream() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('friend_requests')
        .snapshots();
  }

  Future<bool> sendFriendRequest(String email) async {
    _errorMessage = null;
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception("Non connecté");
      if (email.trim() == currentUser.email) throw Exception("Impossible de s'ajouter soi-même");

      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email.trim())
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) throw Exception("Aucun utilisateur trouvé.");

      final targetUser = querySnapshot.docs.first;
      final targetUid = targetUser['uid'];

      final alreadyFriend = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('contacts')
          .doc(targetUid)
          .get();

      if (alreadyFriend.exists) throw Exception("Vous êtes déjà amis.");

      final pendingRequest = await _firestore
          .collection('users')
          .doc(targetUid)
          .collection('friend_requests')
          .doc(currentUser.uid)
          .get();

      if (pendingRequest.exists) throw Exception("Demande déjà envoyée.");

      await _firestore
          .collection('users')
          .doc(targetUid)
          .collection('friend_requests')
          .doc(currentUser.uid)
          .set({
        'uid': currentUser.uid,
        'displayName': currentUser.displayName ?? 'Inconnu',
        'photoURL': currentUser.photoURL,
        'email': currentUser.email,
        'timestamp': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      notifyListeners();
      return false;
    }
  }

  Future<void> acceptRequest(String senderUid, Map<String, dynamic> senderData) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final batch = _firestore.batch();

    final senderRef = _firestore
        .collection('users')
        .doc(senderUid)
        .collection('contacts')
        .doc(currentUser.uid);

    batch.set(senderRef, {
      'uid': currentUser.uid,
      'displayName': currentUser.displayName,
      'photoURL': currentUser.photoURL,
      'addedAt': FieldValue.serverTimestamp(),
    });

    final myContactRef = _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('contacts')
        .doc(senderUid);

    batch.set(myContactRef, {
      'uid': senderUid,
      'displayName': senderData['displayName'],
      'photoURL': senderData['photoURL'],
      'addedAt': FieldValue.serverTimestamp(),
    });

    final requestRef = _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('friend_requests')
        .doc(senderUid);

    batch.delete(requestRef);

    await batch.commit();
  }

  Future<void> refuseRequest(String senderUid) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('friend_requests')
        .doc(senderUid)
        .delete();
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