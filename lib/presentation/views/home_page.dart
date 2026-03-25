import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/drone_model.dart';
import '../../core/routes/app_routes.dart';
import '../../core/themes/app_colors.dart';
import '../components/atoms/aerisys_icon.dart';
import '../components/molecules/aerisys_top_bar.dart';
import '../components/molecules/drone_preview.dart';
import '../components/organisms/aerisys_bottom_nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final activeDrone = DroneModel(
      id: '1',
      name: 'Super drone 30000',
      modelType: 'DJI Mavic',
      batteryLevel: 85,
      status: 'Connecté',
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
              child: Column(
                children: [
                  AerisysTopBar(title: activeDrone.name),
                  const SizedBox(height: 30),
                  DronePreview(drone: activeDrone),
                  const SizedBox(height: 30),
                  
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.battery, extra: activeDrone),
                    child: _buildBatteryCard(activeDrone.batteryLevel.toInt()),
                  ),
                  
                  const SizedBox(height: 16),
                  _buildStatsRow(),
                  const SizedBox(height: 16),
                  _buildRecordingCard(),
                ],
              ),
            ),
          ),
          
          const Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: AerisysBottomNavBar(activeItem: NavItemType.home),
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryCard(int batteryLevel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Batterie',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkSlate,
                ),
              ),
              Text(
                '$batteryLevel%',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: batteryLevel / 100,
              minHeight: 10,
              backgroundColor: const Color(0xFFF3F4F6),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.darkSlate),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            icon: Icons.speed,
            title: 'Vitesse',
            value: '58km/h',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            icon: Icons.location_on_outlined,
            title: 'Distance',
            value: '15km',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            icon: Icons.air,
            title: 'Vent',
            value: '15km/h',
            subtitle: '10pm',
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFF6F7F9),
              shape: BoxShape.circle,
            ),
            child: AerisysIcon(icon, color: AppColors.darkSlate, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.darkSlate,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.darkSlate,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildRecordingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F7F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const AerisysIcon(Icons.videocam_outlined, color: AppColors.darkSlate, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Temps d'enregistrement",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkSlate,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: const [
                    Text(
                      '12:30:21',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: AppColors.darkSlate,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'hrs',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const LinearProgressIndicator(
                    value: 0.7,
                    minHeight: 10,
                    backgroundColor: Color(0xFFF3F4F6),
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.darkSlate),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}