import 'package:flutter/material.dart';

import '../../../core/themes/app_colors.dart';

enum _AerisysButtonType {
  primary,
  social,
  text,
  filled,
  fab,
}

class AerisysButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Widget? trailingIcon;
  final _AerisysButtonType _type;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;

  const AerisysButton.primary({
    super.key,
    required this.text,
    this.icon,
    this.trailingIcon,
    this.onPressed,
    this.isLoading = false,
  })  : _type = _AerisysButtonType.primary,
        backgroundColor = AppColors.brandBlue,
        foregroundColor = AppColors.textWhite;

  const AerisysButton.social({
    super.key,
    required this.text,
    required this.icon,
    this.trailingIcon,
    this.onPressed,
    this.isLoading = false,
  })  : _type = _AerisysButtonType.social,
        backgroundColor = AppColors.textWhite,
        foregroundColor = AppColors.black;

  const AerisysButton.text({
    super.key,
    required this.text,
    this.icon,
    this.trailingIcon,
    this.onPressed,
    this.foregroundColor = AppColors.brandBlue,
    this.isLoading = false,
  })  : _type = _AerisysButtonType.text,
        backgroundColor = Colors.transparent;

  const AerisysButton.filled({
    super.key,
    required this.text,
    this.icon,
    this.trailingIcon,
    this.onPressed,
    this.backgroundColor = AppColors.brandBlue,
    this.foregroundColor = AppColors.textWhite,
    this.isLoading = false,
  })  : _type = _AerisysButtonType.filled;

  const AerisysButton.fab({
    super.key,
    required this.text,
    required this.icon,
    this.trailingIcon,
    this.onPressed,
    this.isLoading = false,
  })  : _type = _AerisysButtonType.fab,
        backgroundColor = null,
        foregroundColor = null;

  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case _AerisysButtonType.primary:
        return _buildElevatedButton();
      case _AerisysButtonType.social:
        return _buildSocialButton();
      case _AerisysButtonType.text:
        return _buildTextButton();
      case _AerisysButtonType.filled:
        return _buildFilledButton();
      case _AerisysButtonType.fab:
        return _buildFab();
    }
  }

  Widget _buildChild(Widget textWidget, {bool showLoadingText = false}) {
    if (isLoading) {
      if (showLoadingText) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: foregroundColor, strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            textWidget,
          ],
        );
      }
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(color: foregroundColor, strokeWidth: 2),
      );
    }
    if (icon != null || trailingIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 8),
          ],
          textWidget,
          if (trailingIcon != null) ...[
            const SizedBox(width: 8),
            trailingIcon!,
          ],
        ],
      );
    }
    return textWidget;
  }

  Widget _buildElevatedButton() {
    return SizedBox(
      width: double.infinity,
      height: 56, // Default for primary buttons in welcome/login
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: _buildChild(Text(text)),
      ),
    );
  }

  Widget _buildSocialButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: isLoading ? null : onPressed,
        child: _buildChild(
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: foregroundColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextButton() {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(foregroundColor: foregroundColor),
      child: _buildChild(
        Text(
          text,
          style: TextStyle(
            color: foregroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFilledButton() {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
      child: _buildChild(Text(text), showLoadingText: true),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton.extended(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: AppColors.textWhite, strokeWidth: 2),
            )
          : icon ?? const SizedBox.shrink(),
      label: Text(text),
    );
  }
}
