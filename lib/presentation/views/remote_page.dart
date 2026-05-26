import 'package:flutter/material.dart';
import '../../data/models/drone_model.dart';
import '../components/molecules/aerisys_top_bar.dart';
import '../components/atoms/aerisys_icon.dart';
import '../../core/themes/app_assets.dart';
import '../../core/themes/app_colors.dart';
import 'package:provider/provider.dart';
import '../view_models/drone_view_model.dart';

class RemotePage extends StatelessWidget {
  const RemotePage({super.key});

  @override
  Widget build(BuildContext context) {
    final droneViewModel = context.watch<DroneViewModel>();
    final activeDrone = droneViewModel.selectedDrone ?? DroneModel(
      id: '0',
      name: 'Aucun appareil',
      modelType: '-',
      batteryLevel: 0,
      status: 'Inconnu',
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
          child: Column(
            children: [
              const AerisysTopBar(title: 'Télécommande'),
              const SizedBox(height: 50),
              Image.asset(
                AppAssets.manetteDji,
                height: 140, // As big as the drone image
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AerisysIcon(Icons.link, color: AppColors.success, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Connectée à ${activeDrone.name}',
                    style: const TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Additional information or controls can be placed here in the future
            ],
          ),
        ),
      ),
    );
  }
}
