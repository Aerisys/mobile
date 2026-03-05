import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_routes.dart';
import '../../core/themes/app_colors.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  // Initial states matching the mockup precisely
  bool _notificationsEnabled = true;
  bool _localNetworkEnabled = false;
  bool _bluetoothEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The background color matches the slate blue in the mockup
      backgroundColor: AppColors.darkSlate,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              // Logo & Title
              const Column(
                children: [
                  Icon(
                    Icons.navigation_outlined, // Fallback icon mimicking the drone/arrow shape
                    size: 80,
                    color: AppColors.textWhite,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Autorisations',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textWhite,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 60),

              // Permissions List
              _buildPermissionTile(
                title: 'Notifications',
                subtitle: 'Autoriser les alertes de l\'app',
                value: _notificationsEnabled,
                onChanged: (val) => setState(() => _notificationsEnabled = val),
              ),
              const SizedBox(height: 32),
              
              _buildPermissionTile(
                title: 'Reseaux locaux',
                subtitle: 'Permettre l\'accès aux appareils proches',
                value: _localNetworkEnabled,
                onChanged: (val) => setState(() => _localNetworkEnabled = val),
              ),
              const SizedBox(height: 32),
              
              _buildPermissionTile(
                title: 'Bluetooth',
                subtitle: 'Connecter l\'app aux appareils Bluetooth',
                value: _bluetoothEnabled,
                onChanged: (val) => setState(() => _bluetoothEnabled = val),
              ),

              const Spacer(),

              // Action Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the next loading step 
                    context.go(AppRoutes.droneSearch);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandBlue,
                    foregroundColor: AppColors.textWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continuer',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500, // Slightly lighter font weight than 'Bold'
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textWhite70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        CupertinoSwitch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: AppColors.brandBlue,
          inactiveTrackColor: AppColors.black.withValues(alpha: 0.45),
        ),
      ],
    );
  }
}
