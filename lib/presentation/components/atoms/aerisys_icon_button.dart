import 'package:flutter/material.dart';

import '../../../core/themes/app_colors.dart';

enum _AerisysIconButtonType {
  standard,
  filled,
  filledTonal,
  outlined,
}

class AerisysIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final _AerisysIconButtonType _type;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AerisysIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  }) : _type = _AerisysIconButtonType.standard;

  const AerisysIconButton.filled({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor = AppColors.success,
    this.foregroundColor = AppColors.textWhite,
  }) : _type = _AerisysIconButtonType.filled;

  AerisysIconButton.filledTonal({
    super.key,
    required this.icon,
    this.onPressed,
    Color? baseColor,
  })  : _type = _AerisysIconButtonType.filledTonal,
        backgroundColor = (baseColor ?? AppColors.error).withValues(alpha: 0.1),
        foregroundColor = baseColor ?? AppColors.error;

  const AerisysIconButton.outlined({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor = AppColors.darkSlate,
    this.foregroundColor = AppColors.white,
  }) : _type = _AerisysIconButtonType.outlined;

  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case _AerisysIconButtonType.standard:
        return _buildStandard();
      case _AerisysIconButtonType.filled:
        return _buildFilled();
      case _AerisysIconButtonType.filledTonal:
        return _buildFilledTonal();
      case _AerisysIconButtonType.outlined:
        return _buildOutlined();
    }
  }

  Widget _buildStandard() {
    return IconButton(
      icon: icon,
      color: foregroundColor,
      onPressed: onPressed,
    );
  }

  Widget _buildFilled() {
    return IconButton.filled(
      icon: icon,
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildFilledTonal() {
    return IconButton.filledTonal(
      icon: icon,
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildOutlined() {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: icon,
      ),
    );
  }
}
