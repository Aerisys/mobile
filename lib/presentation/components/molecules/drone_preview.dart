import 'package:flutter/material.dart';

import '../../../core/themes/app_assets.dart';
import '../../../core/themes/app_colors.dart';
import '../../../data/models/drone_model.dart';
import '../atoms/aerisys_icon.dart';

class DronePreview extends StatelessWidget {
  final DroneModel drone;

  const DronePreview({
    super.key,
    required this.drone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          AppAssets.droneDji,
          height: 110,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AerisysIcon(Icons.wifi, color: AppColors.success, size: 20),
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
      ],
    );
  }
}
