import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_routes.dart';
import '../../core/themes/app_assets.dart';
import '../../core/themes/app_colors.dart';

class DroneSearchPage extends StatefulWidget {
  const DroneSearchPage({super.key});

  @override
  State<DroneSearchPage> createState() => _DroneSearchPageState();
}

class _DroneSearchPageState extends State<DroneSearchPage> {
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _simulateConnection();
  }

  Future<void> _simulateConnection() async {
    // Wait for 3 seconds simulating the search
    await Future.delayed(const Duration(seconds: 3));
    
    // Safety check because widget could be disposed if user navigated away
    if (!mounted) return;
    
    setState(() {
      _isConnected = true;
    });

    // Wait 1 second to show the "Connected" state briefly
    await Future.delayed(const Duration(seconds: 1));
    
    if (!mounted) return;

    // Navigate to Home
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        bottom: false, // Let the black bottom container go to the absolute bottom if needed
        child: Column(
          children: [
            // Top section with logo perfectly centered
            Expanded(
              flex: 5,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // AERYSIS Logo
                    Image.asset(
                      AppAssets.logoAERISYS,
                      color: AppColors.brandBlue,
                      height: 80,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'AERYSIS',
                      style: TextStyle(
                        fontFamily: 'Hanson',
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: AppColors.brandBlue,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom black container acting as a bottom sheet
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.darkSlate,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                    child: Column(
                      children: [
                        // Header Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.help_outline,
                              color: AppColors.textWhite,
                              size: 26,
                            ),
                            Text(
                              _isConnected ? 'Connecté avec succès!' : 'Recherche en cours....',
                              style: TextStyle(
                                color: _isConnected ? AppColors.success : AppColors.textWhite,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Close/cancel navigation
                                context.go(AppRoutes.home);
                              },
                              child: const Icon(
                                Icons.close,
                                color: AppColors.textWhite,
                                size: 26,
                              ),
                            ),
                          ],
                        ),
                        
                        const Spacer(),
                        
                        // 3D Illustration Placeholder
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              AppAssets.droneDji,
                              height: 120,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                        const Spacer(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
