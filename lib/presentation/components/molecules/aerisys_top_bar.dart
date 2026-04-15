import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/themes/app_colors.dart';
import '../atoms/aerisys_icon.dart';

class AerisysTopBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onMore;

  const AerisysTopBar({
    super.key,
    required this.title,
    this.onBack,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const AerisysIcon(Icons.arrow_back, color: AppColors.darkSlate, size: 28),
          onPressed: onBack ?? () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.darkSlate,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: const AerisysIcon(Icons.more_vert, color: AppColors.darkSlate, size: 28),
          onPressed: onMore ?? () {},
        ),
      ],
    );
  }
}
