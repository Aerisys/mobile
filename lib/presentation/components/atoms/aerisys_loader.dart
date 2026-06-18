import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';

class AerisysLoader extends StatelessWidget {
  const AerisysLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.darkSlate,
        strokeWidth: 3,
      ),
    );
  }
}