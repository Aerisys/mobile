import 'package:flutter/material.dart';
import '../components/molecules/aerisys_top_bar.dart';
import '../../core/themes/app_colors.dart';
import '../components/atoms/aerisys_icon.dart';

class CameraPage extends StatelessWidget {
  // Defaulting to false to show the "out of reach" state as requested
  final bool isConnected;

  const CameraPage({super.key, this.isConnected = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: AerisysTopBar(title: 'Caméra'),
            ),
            Expanded(
              child: isConnected
                  ? const Center(
                      child: Text(
                        'Flux vidéo de la caméra ici',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.darkSlate,
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const AerisysIcon(
                              Icons.videocam_off_outlined,
                              color: AppColors.error,
                              size: 48,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'drone out of reach',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkSlate,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Vérifiez la connexion avec votre appareil.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
