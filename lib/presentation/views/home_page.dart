import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/app_routes.dart';
import '../../core/themes/app_assets.dart';
import '../../core/themes/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aerisys Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _buildMenuButton(
              context,
              title: 'Drone Control',
              iconWidget: Image.asset(AppAssets.droneDji, height: 50, fit: BoxFit.contain),
              color: AppColors.brandBlue,
              onTap: () => context.push(AppRoutes.droneList),
            ),
            _buildMenuButton(
              context,
              title: 'Location / Map',
              iconWidget: const Icon(Icons.map, size: 50, color: AppColors.success),
              color: AppColors.success,
              onTap: () => context.push(AppRoutes.location),
            ),
            _buildMenuButton(
              context,
              title: 'Settings',
              iconWidget: const Icon(Icons.settings, size: 50, color: AppColors.textWhite70),
              color: AppColors.textWhite70,
              onTap: () => context.push(AppRoutes.settings),
            ),
            _buildMenuButton(
              context,
              title: 'Contacts',
              iconWidget: const Icon(Icons.contacts, size: 50, color: AppColors.warning),
              color: AppColors.warning,
              onTap: () => context.push(AppRoutes.contact),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
      BuildContext context, {
        required String title,
        required Widget iconWidget,
        required Color color,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}