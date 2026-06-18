import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/themes/app_colors.dart';

class GoogleAuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const GoogleAuthButton({
    super.key, 
    required this.onPressed,
    this.label = 'Continuer avec Google',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE0E0E0)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
        ),
        onPressed: onPressed,
        icon: _buildGoogleIcon(),
        label: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Hanson',
            color: AppColors.darkSlate,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) => const LinearGradient(
        colors: [
          Color(0xFF4285F4), // Blue
          Color(0xFFEA4335), // Red
          Color(0xFFFBBC05), // Yellow
          Color(0xFF34A853), // Green
        ],
        stops: [0.25, 0.5, 0.75, 1.0],
      ).createShader(bounds),
      child: const Icon(FontAwesomeIcons.google, size: 20),
    );
  }
}