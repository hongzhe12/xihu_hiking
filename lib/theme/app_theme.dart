import 'package:flutter/material.dart';

abstract class AppColors {
  static const canvas = Color(0xFFF4F0E7);
  static const surface = Color(0xFFFFFCF6);
  static const ink = Color(0xFF17221D);
  static const forest = Color(0xFF173C31);
  static const pine = Color(0xFF285846);
  static const moss = Color(0xFF687966);
  static const muted = Color(0xFF6E766F);
  static const line = Color(0xFFDED8CA);
  static const mist = Color(0xFFE7ECE3);
  static const clay = Color(0xFFB25335);
}

ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.pine,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.forest,
    onPrimary: AppColors.surface,
    secondary: AppColors.moss,
    onSecondary: AppColors.surface,
    surface: AppColors.surface,
    onSurface: AppColors.ink,
    outline: AppColors.line,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.canvas,
  );

  return base.copyWith(
    textTheme: base.textTheme.copyWith(
      displaySmall: const TextStyle(
        color: AppColors.ink,
        fontSize: 34,
        fontWeight: FontWeight.w700,
        height: 1.16,
        letterSpacing: -0.7,
      ),
      headlineMedium: const TextStyle(
        color: AppColors.ink,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.22,
        letterSpacing: -0.3,
      ),
      headlineSmall: const TextStyle(
        color: AppColors.ink,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.3,
      ),
      titleLarge: const TextStyle(
        color: AppColors.ink,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.3,
      ),
      titleMedium: const TextStyle(
        color: AppColors.ink,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      bodyLarge: const TextStyle(
        color: AppColors.ink,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.75,
      ),
      bodyMedium: const TextStyle(
        color: AppColors.muted,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.6,
      ),
      labelLarge: const TextStyle(
        color: AppColors.ink,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
    ),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        minimumSize: MaterialStatePropertyAll(Size(48, 48)),
        tapTargetSize: MaterialTapTargetSize.padded,
        foregroundColor: MaterialStatePropertyAll(AppColors.ink),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.forest,
        foregroundColor: AppColors.surface,
        minimumSize: const Size(48, 54),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.forest,
        minimumSize: const Size(48, 54),
        side: const BorderSide(color: AppColors.line),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.ink,
      contentTextStyle: const TextStyle(
        color: AppColors.surface,
        fontSize: 14,
      ),
      actionTextColor: const Color(0xFFDCEBCF),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.line,
      thickness: 1,
      space: 1,
    ),
  );
}
