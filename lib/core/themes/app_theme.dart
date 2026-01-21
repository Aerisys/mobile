import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      fontFamily: 'NeueHaasDisplay',
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.mainBackground,
      primaryColor: AppColors.mainColor,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.mainColor,
        secondary: AppColors.secondaryColor,
        error: AppColors.error,
        surface: AppColors.mainBackground,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.mainBackground,
        elevation: 0,
        titleTextStyle: TextStyle(
            color: AppColors.mainText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'HansonBold'
        ),
        iconTheme: IconThemeData(color: AppColors.mainText),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.mainText),
        bodyMedium: TextStyle(color: AppColors.secondaryText),
        bodySmall: TextStyle(color: AppColors.secondaryText),
        titleLarge: TextStyle(
            color: AppColors.mainText,
            fontWeight: FontWeight.bold,
            fontFamily: 'HansonBold'
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
            backgroundColor: AppColors.mainColor,
            foregroundColor: AppColors.blanc,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            padding: const EdgeInsets.all(10),
            fixedSize: const Size(331, 40)
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainBackground,
          foregroundColor: AppColors.mainText,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.mainColor,
        foregroundColor: AppColors.noirProfond,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.blanc,
        hintStyle: const TextStyle(color: AppColors.grisAnthracite),
        labelStyle: const TextStyle(color: AppColors.noirProfond),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.mainBackground,
        indicatorColor: AppColors.mainColor,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.noirProfond);
          }
          return const IconThemeData(color: AppColors.secondaryText);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: AppColors.mainText,
              fontWeight: FontWeight.bold,
            );
          }
          return const TextStyle(color: AppColors.secondaryText);
        }),
      ),
    );
  }
}
