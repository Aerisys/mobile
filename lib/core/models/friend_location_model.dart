import 'package:latlong2/latlong.dart';

class FriendLocationModel {
  final String uid;
  final LatLng position;
  final String displayName;
  final String? photoURL;

  FriendLocationModel({
    required this.uid,
    required this.position,
    required this.displayName,
    this.photoURL,
  });
}