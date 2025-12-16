import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
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
        title: const Text("Carte"),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: "Contacts",
            onPressed: () {
              context.push(AppRoutes.contact);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: "Paramètres",
            onPressed: () {
              context.push(AppRoutes.settings);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(48.8566, 2.3522),
              initialZoom: 13.0,
              minZoom: 4.0,
              maxZoom: 20.0,
              interactionOptions: InteractionOptions(
                flags: InteractiveFlag.all,
              ),
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
                      width: 60,
                      height: 60,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // (Plus tard, on ajoutera ici les marqueurs des amis)
                ],
              ),
            ],
          ),

          if (homeViewModel.isLoading)
            Positioned(
              top: 16,
              left: 16,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      const BoxShadow(blurRadius: 4, color: Colors.black12)
                    ],
                  ),
                  child: const Row(
                    children: [
                      SizedBox(width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 2)),
                      SizedBox(width: 8),
                      Text("Recherche GPS...", style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),

          if (homeViewModel.errorMessage != null)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: SafeArea(
                child: Card(
                  color: Colors.red.withValues(alpha: 0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      homeViewModel.errorMessage!,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),

          Positioned(
            bottom: 30,
            right: 20,
            child: SafeArea(
              child: FloatingActionButton(
                heroTag: "recenter_fab",
                onPressed: () {
                  if (homeViewModel.currentPosition != null) {
                    _mapController.move(homeViewModel.currentPosition!, 16.0);
                    _mapController.rotate(0.0);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Position inconnue pour le moment"))
                    );
                  }
                },
                child: const Icon(Icons.my_location),
              ),
            ),
          ),
        ],
      ),
    );
  }
}