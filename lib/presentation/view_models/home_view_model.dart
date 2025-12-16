import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'common_view_model.dart';

class HomeViewModel extends CommonViewModel {
  LatLng? _currentPosition;
  LatLng? get currentPosition => _currentPosition;

  HomeViewModel() {
    _initLocation();
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
      isLoading = false;
    });
  }
}