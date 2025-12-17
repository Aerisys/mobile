import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../view_models/map_view_model.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  void initState() {
    super.initState();
    // Initialize GPS tracking when the page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapViewModel>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Drone & Friends Map")),
      body: Consumer<MapViewModel>(
        builder: (context, model, child) {
          if (model.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (model.errorMessage != null) {
            return Center(child: Text(model.errorMessage!));
          }

          return FlutterMap(
            options: MapOptions(
              initialCenter: model.currentPosition ?? const LatLng(0, 0),
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.aerisys.mobile',
              ),
              MarkerLayer(
                markers: [
                  // Your current position
                  if (model.currentPosition != null)
                    Marker(
                      point: model.currentPosition!,
                      width: 50,
                      height: 50,
                      child: const Icon(Icons.my_location, color: Colors.blue, size: 30),
                    ),

                  // Friend/Drone markers from your ViewModel logic
                  ...model.friends.map((friend) => Marker(
                    point: friend.position,
                    width: 50,
                    height: 50,
                    child: const Icon(Icons.location_on, color: Colors.red, size: 30),
                  )),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}