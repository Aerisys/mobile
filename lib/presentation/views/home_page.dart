import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/routes/app_routes.dart';
import '../view_models/home_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MapController _mapController = MapController();
  bool _hasCenteredOnce = false;
  final Map<String, Marker> _friendMarkers = {};

  final List<StreamSubscription> _subscriptions = [];
  StreamSubscription? _friendsListSubscription;

  @override
  void initState() {
    super.initState();
    _startListeningToFriends();
  }

  @override
  void dispose() {
    _friendsListSubscription?.cancel();
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }

  void _startListeningToFriends() {
    final viewModel = context.read<HomeViewModel>();

    _friendsListSubscription = viewModel.getTrackingFriendsStream().listen((snapshot) {

      for (var doc in snapshot.docs) {
        final friendData = doc.data() as Map<String, dynamic>;
        final friendUid = friendData['uid'];

        if (_friendMarkers.containsKey(friendUid)) continue;

        final sub = FirebaseFirestore.instance
            .collection('users')
            .doc(friendUid)
            .snapshots()
            .listen((userDoc) {

          if (!userDoc.exists) return;
          final userData = userDoc.data()!;

          if (userData.containsKey('position')) {
            final pos = userData['position'];
            final LatLng position = LatLng(pos['lat'], pos['lng']);

            final marker = _buildFriendMarker(
                friendUid,
                position,
                userData['displayName'] ?? 'Ami',
                userData['photoURL']
            );

            if (mounted) {
              setState(() {
                _friendMarkers[friendUid] = marker;
              });
            }
          }
        });

        _subscriptions.add(sub);
      }
    });
  }

  Marker _buildFriendMarker(String uid, LatLng position, String name, String? photoUrl) {
    return Marker(
      point: position,
      width: 50,
      height: 50,
      child: GestureDetector(
        onTap: () => _showFriendInfo(context, name, photoUrl),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [const BoxShadow(blurRadius: 4, color: Colors.black26)],
              ),
              child: CircleAvatar(
                radius: 18,
                backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                backgroundColor: Colors.green,
                child: photoUrl == null ? Text(name[0]) : null,
              ),
            ),
            ClipPath(
              clipper: _TriangleClipper(),
              child: Container(color: Colors.white, width: 8, height: 6),
            )
          ],
        ),
      ),
    );
  }

  void _showFriendInfo(BuildContext context, String name, String? photoUrl) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                child: photoUrl == null ? Text(name[0], style: const TextStyle(fontSize: 24)) : null,
              ),
              const SizedBox(width: 16),
              Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewModel>();

    if (homeViewModel.currentPosition != null && !_hasCenteredOnce) {
      _mapController.move(homeViewModel.currentPosition!, 15.0);
      _hasCenteredOnce = true;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Accueil"),
        elevation: 0,
        actions: [
          IconButton(onPressed: () => context.push(AppRoutes.contact), icon: const Icon(Icons.people)),
          IconButton(onPressed: () => context.push(AppRoutes.settings), icon: const Icon(Icons.settings)),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(48.8566, 2.3522),
              initialZoom: 13.0,
              interactionOptions: InteractionOptions(flags: InteractiveFlag.all),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.herebro',
              ),

              MarkerLayer(
                markers: [
                  if (homeViewModel.currentPosition != null)
                    Marker(
                      point: homeViewModel.currentPosition!,
                      width: 60, height: 60,
                      child: _buildMyMarker(),
                    ),

                  ..._friendMarkers.values,
                ],
              ),
            ],
          ),

          Positioned(
            bottom: 20,
            right: 0,
            child: SafeArea(
              minimum: const EdgeInsets.only(bottom: 30, right: 20),
              child: FloatingActionButton(
                heroTag: "recenter",
                child: const Icon(Icons.my_location),
                onPressed: () {
                  if (homeViewModel.currentPosition != null) {
                    _mapController.move(homeViewModel.currentPosition!, 16);
                    _mapController.rotate(0.0);
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMyMarker() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(width: 22, height: 22, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(blurRadius: 3)])),
        Container(width: 16, height: 16, decoration: const BoxDecoration(color: Color(0xFF4285F4), shape: BoxShape.circle)),
      ],
    );
  }
}

class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}