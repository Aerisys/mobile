import 'package:flutter/material.dart';
import '../../core/themes/app_assets.dart';
import '../../core/themes/app_colors.dart';
import '../../data/models/drone_model.dart';
import '../components/atoms/aerisys_button.dart';
import '../components/atoms/aerisys_icon.dart';

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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.darkSlate, AppColors.brandBlue],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'drone-icon',
                  child: Image.asset(AppAssets.droneDji, height: 120, fit: BoxFit.contain),
                ),
                const SizedBox(height: 10),
                Text(
                  drone.status.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.textWhite70,
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

                AerisysButton.primary(
                  text: "START MISSION",
                  onPressed: () {},
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
      leading: AerisysIcon(icon, color: AppColors.brandBlue),
      title: Text(label, style: const TextStyle(color: AppColors.textWhite70, fontSize: 14)),
      subtitle: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBatterySection(double level) {
    Color color = level > 20 ? AppColors.success : AppColors.error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text("Battery Health", style: TextStyle(color: AppColors.textWhite70)),
        ),
        ListTile(
          leading: AerisysIcon(Icons.battery_charging_full, color: color),
          title: LinearProgressIndicator(
            value: level / 100,
            backgroundColor: AppColors.black,
            color: color,
            minHeight: 10,
          ),
          trailing: Text("${level.toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}