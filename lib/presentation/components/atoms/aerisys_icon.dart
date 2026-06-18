import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/themes/app_colors.dart';

class AerisysIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double? size;

  const AerisysIcon(
    this.icon, {
    super.key,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the icon is a FontAwesome icon
    if (icon.fontPackage == 'font_awesome_flutter') {
      return FaIcon(
        icon,
        color: color ?? AppColors.textWhite,
        size: size,
      );
    }
    
    return Icon(
      icon,
      color: color ?? AppColors.textWhite,
      size: size,
    );
  }
}
