import 'package:career_lens/core/ui/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        brightness: Brightness.light,
      ),
      textTheme: const TextTheme(
        titleMedium: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        bodySmall: TextStyle(color: AppColors.gray),
      ),
      scaffoldBackgroundColor: Colors.transparent,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        brightness: Brightness.dark,
      ),
      textTheme: const TextTheme(
        titleMedium: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        bodySmall: TextStyle(color: AppColors.gray),
      ),
      scaffoldBackgroundColor: Colors.transparent,
    );
  }
}
