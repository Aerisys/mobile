import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../core/di.dart';
import '../../core/services/auth_service.dart';
import 'common_view_model.dart';

class HomeViewModel extends CommonViewModel {
  final IAuthService _auth = getIt<IAuthService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  LatLng? _currentPosition;
  LatLng? get currentPosition => _currentPosition;

  HomeViewModel() {
    _initLocation();
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

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      _currentPosition = LatLng(position.latitude, position.longitude);

      final user = _auth.currentUser;
      if (user != null) {
        _firestore.collection('users').doc(user.uid).update({
          'position': {
            'lat': position.latitude,
            'lng': position.longitude,
          },
          'lastUpdated': FieldValue.serverTimestamp(),
        }).catchError((e) {
          return;
        });
      }
      
      isLoading = false;
    });
  }
}