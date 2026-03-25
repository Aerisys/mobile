import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_routes.dart';
import '../../core/themes/app_assets.dart';
import '../../core/themes/app_colors.dart';
import '../components/atoms/aerisys_button.dart';
import '../components/atoms/aerisys_icon.dart';

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
            Expanded(
              flex: 4,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                              child: const AerisysIcon(
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
                            const AerisysIcon(
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
                            AerisysButton.text(
                              text: 'Aide',
                              icon: const AerisysIcon(Icons.help_outline, color: AppColors.textWhite),
                              foregroundColor: AppColors.textWhite,
                              onPressed: () {
                                // TODO: Handle Help
                              },
                            ),
                            AerisysButton.text(
                              text: 'Passer cette étape',
                              foregroundColor: AppColors.textWhite,
                              trailingIcon: const AerisysIcon(Icons.arrow_forward, color: AppColors.textWhite),
                              onPressed: () {
                                context.go(AppRoutes.droneSearch);
                              },
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
