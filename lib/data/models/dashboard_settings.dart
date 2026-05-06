import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardSettingsRepository {
  DashboardSettingsRepository(this._db);

  final FirebaseFirestore _db;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  DocumentReference<Map<String, dynamic>> userDashboardRef() {
    return _db.doc('users/$_uid/settings/dashboard');
  }

  DocumentReference<Map<String, dynamic>> droneDashboardRef(String droneId) {
    return _db.doc('users/$_uid/drones/$droneId/settings/dashboard');
  }

  Stream<Map<String, dynamic>?> watchUserDashboard() {
    return userDashboardRef().snapshots().map((snap) => snap.data());
  }

  Stream<Map<String, dynamic>?> watchDroneDashboard(String droneId) {
    return droneDashboardRef(droneId).snapshots().map((snap) => snap.data());
  }

  Future<void> saveUserDashboard({
    required Map<String, bool> visible,
    required List<String> order,
  }) async {
    await userDashboardRef().set({
      'visible': visible,
      'order': order,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> saveDroneDashboard({
    required String droneId,
    required Map<String, bool> visible,
    required List<String> order,
  }) async {
    await droneDashboardRef(droneId).set({
      'visible': visible,
      'order': order,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
