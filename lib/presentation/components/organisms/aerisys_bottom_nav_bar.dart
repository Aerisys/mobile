import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_assets.dart';
import '../atoms/aerisys_icon_button.dart';
import '../atoms/aerisys_icon.dart';

enum NavItemType {
  camera,
  accueil, // The House Icon
  droneList, // The Drone Icon (Appareils)
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
            onTap: () => context.go(AppRoutes.camera), // USE GO!
          ),
          _buildItem(
            context,
            type: NavItemType.accueil,
            icon: Icons.home_outlined,
            label: 'Accueil',
            onTap: () => context.go(AppRoutes.appareils), // USE GO!
          ),
          _buildItem(
            context,
            type: NavItemType.droneList,
            imagePath: AppAssets.droneLogoNavbar,
            label: 'Appareils',
            onTap: () => context.go(AppRoutes.droneList), // USE GO!
          ),
          _buildItem(
            context,
            type: NavItemType.contact,
            icon: Icons.person_outline,
            label: 'Profil',
            onTap: () => context.go(AppRoutes.contact), // USE GO!
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, {
    required NavItemType type,
    IconData? icon,
    String? imagePath,
    required String label,
    required VoidCallback onTap,
  }) {
    final isSelected = activeItem == type;

    final Color elementColor = isSelected ? AppColors.darkSlate : AppColors.white;

    Widget buildIcon() {
      if (imagePath != null) {
        return ColorFiltered(
          colorFilter: ColorFilter.mode(elementColor, BlendMode.srcIn),
          child: Image.asset(
            imagePath,
            width: 24, 
            height: 24,
          ),
        );
      }
      return AerisysIcon(icon!, color: elementColor, size: 24);
    }

    if (isSelected) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.textWhite70,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildIcon(),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: elementColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: buildIcon(),
      ),
    );
  }
}