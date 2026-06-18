import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/themes/app_colors.dart';
import '../atoms/aerisys_icon.dart';

class AerisysTopBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onMore;

  const AerisysTopBar({
    super.key,
    required this.title,
    this.onBack,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const AerisysIcon(Icons.arrow_back, color: AppColors.darkSlate, size: 28),
          onPressed: onBack ?? () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.darkSlate,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        PopupMenuButton<String>(
          icon: const AerisysIcon(Icons.more_vert, color: AppColors.darkSlate, size: 28),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          elevation: 4,
          offset: const Offset(0, 48),
          onSelected: (value) {
            if (value == 'edit') {
              context.push(AppRoutes.editWidgets);
            } else if (value == 'settings') {
              context.push(AppRoutes.settings);
            } else if (value == 'locate') {
              context.push(AppRoutes.location);
            } else if (onMore != null) {
              onMore!();
            }
          },
          itemBuilder: (context) => [
            _buildMenuItem(
              value: 'edit',
              icon: Icons.edit_outlined,
              text: 'Editer les widgets',
            ),
            _buildMenuItem(
              value: 'settings',
              icon: Icons.settings_outlined,
              text: 'Parametres',
            ),
            _buildMenuItem(
              value: 'locate',
              icon: Icons.my_location,
              text: 'Localiser l\'appareil',
            ),
            _buildMenuItem(
              value: 'disconnect',
              icon: Icons.logout,
              text: 'Dissocier l\'appareil',
              isDestructive: true,
            ),
          ],
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem({
    required String value,
    required IconData icon,
    required String text,
    bool isGray = false,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? const Color(0xFFC62828) : AppColors.darkSlate;
    
    return PopupMenuItem<String>(
      value: value,
      padding: EdgeInsets.zero,
      height: 48,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isGray ? const Color(0xFFF3F4F6) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
