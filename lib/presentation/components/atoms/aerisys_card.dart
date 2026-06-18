import 'package:flutter/material.dart';

import '../../../core/themes/app_colors.dart';

class AerisysCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double width;

  const AerisysCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24.0),
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: child,
    );
  }
}
