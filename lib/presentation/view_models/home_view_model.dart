import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../core/di.dart';
import '../../core/services/auth_service.dart';
import '../../data/models/friend_location_model.dart';
import 'common_view_model.dart';

class HomeViewModel extends CommonViewModel {
  final IAuthService _auth = getIt<IAuthService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LatLng? _currentPosition;

  LatLng? get currentPosition => _currentPosition;

  final Map<String, FriendLocation> _friendsData = {};

  List<FriendLocation> get friends => _friendsData.values.toList();

  StreamSubscription<Position>? _gpsSubscription;
  StreamSubscription<QuerySnapshot>? _friendsListSubscription;
  final List<StreamSubscription> _individualSubscriptions = [];

  void init() {
    if (_gpsSubscription != null) return;

    _initLocation();
    _startTrackingFriends();
  }

  Stream<QuerySnapshot> getTrackingFriendsStream() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('tracking')
        .snapshots();
  }

  Future<void> _initLocation() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      errorMessage = "Le GPS est désactivé.";
      isLoading = false;
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        errorMessage = "Permission refusée.";
        isLoading = false;
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      errorMessage = "Permission refusée définitivement.";
      isLoading = false;
      return;
    }

    _gpsSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 20,
          ),
        ).listen((Position position) {
          _currentPosition = LatLng(position.latitude, position.longitude);

          final user = _auth.currentUser;
          if (user != null) {
            _firestore.collection('users').doc(user.uid).update({
              'position': {'lat': position.latitude, 'lng': position.longitude},
              'lastUpdated': FieldValue.serverTimestamp(),
            });
          }
          isLoading = false;
        });
  }

  void _startTrackingFriends() {
    final user = _auth.currentUser;
    if (user == null) return;

    _friendsListSubscription = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('tracking')
        .snapshots()
        .listen((snapshot) {
          for (var doc in snapshot.docs) {
            final friendData = doc.data();
            final friendUid = friendData['uid'];

            if (_friendsData.containsKey(friendUid)) continue;

            final sub = _firestore
                .collection('users')
                .doc(friendUid)
                .snapshots()
                .listen((userDoc) {
                  if (!userDoc.exists) return;
                  final userData = userDoc.data()!;

                  if (userData.containsKey('position')) {
                    final pos = userData['position'];

                    _friendsData[friendUid] = FriendLocation(
                      uid: friendUid,
                      position: LatLng(pos['lat'], pos['lng']),
                      displayName: userData['displayName'] ?? 'Ami',
                      photoURL: userData['photoURL'],
                    );

                    notifyListeners();
                  }
                });

            _individualSubscriptions.add(sub);
          }
        });
  }

  Future<void> stopTracking() async {
    await _gpsSubscription?.cancel();
    await _friendsListSubscription?.cancel();
    for (var sub in _individualSubscriptions) {
      await sub.cancel();
    }
    _individualSubscriptions.clear();
    _friendsData.clear();
    _gpsSubscription = null;
  }

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }
}
