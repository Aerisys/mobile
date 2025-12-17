import 'package:flutter/material.dart';
import '../../data/models/drone_model.dart';

class DroneDetailsPage extends StatelessWidget {
  final DroneModel drone;

  const DroneDetailsPage({super.key, required this.drone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(drone.name)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.airplanemode_active, size: 100, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            Text("Model: ${drone.modelType}", style: const TextStyle(fontSize: 20)),
            const Divider(),
            Text("Status: ${drone.status}",
                style: TextStyle(fontSize: 18, color: drone.status == "Flying" ? Colors.green : Colors.orange)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.battery_charging_full),
                const SizedBox(width: 10),
                Text("Battery: ${drone.batteryLevel.toInt()}%"),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Action to connect to drone
                },
                child: const Text("CONNECT TO DRONE"),
              ),
            )
          ],
        ),
      ),
    );
  }
}