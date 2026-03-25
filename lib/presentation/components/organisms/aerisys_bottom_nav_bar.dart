import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/themes/app_colors.dart';
import '../atoms/aerisys_icon_button.dart';
import '../atoms/aerisys_icon.dart';

enum NavItemType {
  camera,
  home,
  droneList,
  contact,
}

class AerisysBottomNavBar extends StatelessWidget {
  final NavItemType? activeItem;

  const AerisysBottomNavBar({
    super.key,
    this.activeItem,
  });

  @override
  Widget build(BuildContext context) {
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
          _buildItem(
            context,
            type: NavItemType.camera,
            icon: Icons.camera_alt_outlined,
            label: 'Caméra',
            onTap: () {},
          ),
          _buildItem(
            context,
            type: NavItemType.home,
            icon: Icons.home_outlined,
            label: 'Accueil',
            onTap: () {
              if (activeItem != NavItemType.home) context.push(AppRoutes.home);
            },
          ),
          _buildItem(
            context,
            type: NavItemType.droneList,
            icon: Icons.airplanemode_active,
            label: 'Appareils',
            onTap: () {
              // Usually context.push(AppRoutes.droneList)
              if (activeItem != NavItemType.droneList) context.push(AppRoutes.droneList);
            },
          ),
          _buildItem(
            context,
            type: NavItemType.contact,
            icon: Icons.person_outline,
            label: 'Profil',
            onTap: () {
              if (activeItem != NavItemType.contact) context.push(AppRoutes.contact);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, {
    required NavItemType type,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    if (activeItem == type) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AerisysIcon(icon, color: AppColors.white, size: 28),
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
    
    return AerisysIconButton(
      icon: AerisysIcon(icon, color: AppColors.white, size: 28),
      onPressed: onTap,
    );
  }
}
