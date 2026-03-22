import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/drone_model.dart';
import '../view_models/drone_view_model.dart'; 
import '../../core/routes/app_routes.dart';
import '../../core/themes/app_assets.dart';
import '../../core/themes/app_colors.dart';
import '../components/atoms/aerisys_button.dart';
import '../components/atoms/aerisys_icon_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Local mock of the drone data to ensure the UI renders without errors
    final activeDrone = DroneModel(
      id: '1',
      name: 'Alpha-X',
      modelType: 'DJI Mavic',
      batteryLevel: 85,
      status: 'Connecté',
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildDroneCard(context, activeDrone),
                ],
              ),
            ),
          ),
          
          // Floating Bottom Navigation Bar
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: _buildFloatingNavBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Accueil',
          style: TextStyle(
            fontFamily: 'Hanson',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.darkSlate,
          ),
        ),
        Row(
          children: [
            _buildIconButton(
              icon: Icons.settings_outlined,
              onTap: () => context.push(AppRoutes.settings),
            ),
            const SizedBox(width: 12),
            _buildIconButton(
              icon: Icons.notifications_outlined,
              onTap: () {}, 
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.darkSlate,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.white, size: 24),
      ),
    );
  }

  Widget _buildDroneCard(BuildContext context, DroneModel drone) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            drone.name,
            style: const TextStyle(
              fontFamily: 'Hanson',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkSlate,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Image.asset(
              AppAssets.droneDji,
              height: 140,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi, color: AppColors.success, size: 20),
              const SizedBox(width: 8),
              Text(
                drone.status,
                style: const TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.8,
            children: [
              _buildStatCard(
                icon: Icons.swap_horiz,
                title: 'Distance',
                value: '2km',
              ),
              _buildStatCard(
                icon: Icons.timer_outlined,
                title: 'Temps de vol',
                value: '20min',
              ),
              _buildStatCard(
                icon: Icons.battery_charging_full,
                iconColor: AppColors.success,
                title: 'Batterie',
                value: '${drone.batteryLevel.toInt()}%',
              ),
              _buildStatCard(
                icon: Icons.signal_cellular_alt,
                iconColor: AppColors.warning,
                title: 'Signal GPS',
                value: 'Moyen',
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          SizedBox(
            width: double.infinity,
            height: 50,
            child: AerisysButton.filled(
              text: 'Voir',
              backgroundColor: AppColors.darkSlate,
              onPressed: () => context.push(AppRoutes.droneList),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    Color iconColor = AppColors.white,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.darkSlate,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.darkSlate,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.darkSlate,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingNavBar(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: AppColors.darkSlate,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(icon: Icons.camera_alt_outlined, onTap: () {}),
          _buildActiveNavItem(icon: Icons.home_outlined, label: 'Accueil'),
          _buildNavItem(
            icon: Icons.airplanemode_active,
            onTap: () => context.push(AppRoutes.droneList),
          ),
          _buildNavItem(
            icon: Icons.person_outline,
            onTap: () => context.push(AppRoutes.contact),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required VoidCallback onTap}) {
    return AerisysIconButton(
      icon: Icon(icon, color: AppColors.white, size: 28),
      onPressed: onTap,
    );
  }

  Widget _buildActiveNavItem({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.white, size: 28),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}