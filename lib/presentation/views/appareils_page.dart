import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/app_routes.dart';
import '../../core/themes/app_assets.dart';
import '../../core/themes/app_colors.dart';
import '../../data/models/drone_model.dart';
import '../components/atoms/aerisys_icon.dart';
import '../components/atoms/aerisys_icon.dart';

class AppareilsPage extends StatelessWidget {
  const AppareilsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Shared drone model for consistency
    final activeDrone = DroneModel(
      id: '1',
      name: 'Super drone 30000',
      modelType: 'DJI Mavic',
      batteryLevel: 85,
      status: 'Connecté',
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildHeader(context),
              const SizedBox(height: 40),
              
              const Text(
                'Choisissez un appareil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkSlate,
                ),
              ),
              const SizedBox(height: 20),

              // Drone Selection Card
              _buildDeviceCard(
                context: context,
                title: 'Drone',
                subtitle: activeDrone.name,
                imagePath: AppAssets.droneDji,
                onTap: () => context.push(AppRoutes.home),
              ),
              
              const SizedBox(height: 16),

              // Remote Selection Card
              _buildDeviceCard(
                context: context,
                title: 'Télécommande',
                subtitle: 'Télécommande pour drone',
                imagePath: AppAssets.manetteDji,
                onTap: () => context.push(AppRoutes.remote),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Appareils',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.darkSlate,
          ),
        ),
        const Spacer(),
        _buildCircleButton(
          icon: Icons.settings,
          onPressed: () => context.push(AppRoutes.settings),
        ),
        const SizedBox(width: 12),
        _buildCircleButton(
          icon: Icons.notifications_outlined,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildCircleButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      height: 48,
      width: 48,
      decoration: const BoxDecoration(
        color: Color(0xFF2E6FF2),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 24),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildDeviceCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    IconData? icon,
    String? imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          children: [
            Container(
              padding: const EdgeInsets.all(12), // Slightly reduced padding to allow larger image
              decoration: const BoxDecoration(
                color: Color(0xFFF6F7F9),
                shape: BoxShape.circle,
              ),
              child: imagePath != null 
                ? Image.asset(imagePath, width: 45, height: 45, fit: BoxFit.contain)
                : AerisysIcon(icon ?? Icons.devices, color: AppColors.darkSlate, size: 45),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.darkSlate,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}