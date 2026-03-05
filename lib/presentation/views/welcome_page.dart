import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/app_router.dart';
import '../../core/routes/app_routes.dart';
import '../../core/themes/app_assets.dart';
import '../../core/themes/app_colors.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                // Using a placeholder image that matches the "aerial coastal road" vibe
                image: NetworkImage(AppAssets.onlineBackground),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  AppColors.black26, // Adds a slight dark tint
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          // Gradient Overlay to ensure text readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.black.withOpacity(0.0),
                  AppColors.black.withOpacity(0.4),
                  AppColors.black.withOpacity(0.8),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  // Logo Placeholder
                  // If you have the asset, replace this Icon with Image.asset('assets/logo.png')
                  Image.asset(
                    AppAssets.logoAERISYS,
                    color: AppColors.brandBlue,
                    height: 80,
                  ),
                  const SizedBox(height: 16),
                  
                  // Main Title
                  const Text(
                    'Bienvenue',
                    style: TextStyle(
                      fontFamily: 'Hanson', // Using system font effectively
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textWhite,
                      letterSpacing: 1.0,
                    ),
                  ),
                  
                  const Spacer(flex: 2), // Pushes text down as seen in design

                  // Subtitle
                  const Text(
                    'Prêt à voir le monde\nsous un nouvel angle?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textWhite,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Description
                  const Text(
                    'Aerisys t\'accompagne pour piloter tes drones en toute sécurité et capturer des images aériennes spectaculaires.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textWhite70,
                      height: 1.4,
                    ),
                  ),
                  
                  const Spacer(flex: 1),
                  
                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        await authNotifier.completeOnboarding();
                        if (context.mounted) {
                          context.go(AppRoutes.login);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandBlue, // Matches the blue from the image
                        foregroundColor: AppColors.textWhite,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      child: const Text('Commencer'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
