import 'package:flutter/material.dart';
import '../../data/models/drone_model.dart';

class DroneDetailsPage extends StatelessWidget {
  final DroneModel drone;

  const DroneDetailsPage({super.key, required this.drone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(drone.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue.shade900, Colors.blue.shade400],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Hero(
                  tag: 'drone-icon',
                  child: Icon(Icons.airplanemode_active, size: 120, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  drone.status.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white70,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _buildInfoTile("Drone Model", drone.modelType, Icons.memory),
                _buildInfoTile("Unique ID", drone.id, Icons.fingerprint),
                _buildBatterySection(drone.batteryLevel),
                const SizedBox(height: 40),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                  },
                  child: const Text("START MISSION", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      subtitle: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBatterySection(double level) {
    Color color = level > 20 ? Colors.green : Colors.red;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text("Battery Health", style: TextStyle(color: Colors.grey)),
        ),
        ListTile(
          leading: Icon(Icons.battery_charging_full, color: color),
          title: LinearProgressIndicator(
            value: level / 100,
            backgroundColor: Colors.grey.shade300,
            color: color,
            minHeight: 10,
          ),
          trailing: Text("${level.toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}