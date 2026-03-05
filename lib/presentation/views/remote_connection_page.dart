import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_routes.dart';
import '../../core/themes/app_colors.dart';

class RemoteConnectionPage extends StatelessWidget {
  const RemoteConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Section (White)
            const Expanded(
              flex: 4,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.navigation_outlined, // Placeholder for Logo
                      size: 100,
                      color: AppColors.brandBlue,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'AERYSIS',
                      style: TextStyle(
                        fontFamily: 'Inter',
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

            // Bottom Section (Dark Slate)
            Expanded(
              flex: 6,
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
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Télécommande déconnectée',
                              style: TextStyle(
                                color: AppColors.textWhite,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.go(AppRoutes.home),
                              child: const Icon(
                                Icons.close,
                                color: AppColors.textWhite,
                                size: 24,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // Center Graphic (Rings + Plug)
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer Ring
                            Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.brandBlue.withValues(alpha: 0.8),
                              ),
                            ),
                            // Inner Ring (Darker)
                            Container(
                              width: 140,
                              height: 140,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.darkSlate,
                              ),
                            ),
                            // Plug Icon
                            const Icon(
                              Icons.power_outlined,
                              color: AppColors.textWhite,
                              size: 60,
                            ),
                          ],
                        ),

                        const Spacer(),

                        // Subtitle
                        const Text(
                          "Connectez la télécommande à l'aide du cable USB.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textWhite,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Footer Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                // TODO: Handle Help
                              },
                              icon: const Icon(
                                Icons.help_outline,
                                color: AppColors.textWhite,
                              ),
                              label: const Text(
                                'Aide',
                                style: TextStyle(
                                  color: AppColors.textWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.go(AppRoutes.droneSearch);
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Passer cette étape',
                                    style: TextStyle(
                                      color: AppColors.textWhite,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: AppColors.textWhite,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
