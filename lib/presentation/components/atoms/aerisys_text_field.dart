import 'package:flutter/material.dart';

import '../../../core/themes/app_colors.dart';

class AerisysTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final String? labelText;
  final Widget? prefixIcon;

  const AerisysTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.labelText,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    Widget textField = TextField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      autofocus: autofocus,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: AppColors.textWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );

    if (labelText != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              labelText!,
              style: const TextStyle(
                color: AppColors.textWhite,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          textField,
        ],
      );
    }

    return textField;
  }
}
