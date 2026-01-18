import 'package:flutter/material.dart';

/// Minimal color palette for TybeToGo Driver
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF00C853);
  static const Color primarySurface = Color(0xFFE8F5E9);

  // Light theme
  static const Color lightBg = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF5F5F5);
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color lightText = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF666666);
  static const Color lightTextHint = Color(0xFFAAAAAA);
  static const Color lightTextTertiary = Color(0xFFBBBBBB);

  // Dark theme
  static const Color darkBg = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkBorder = Color(0xFF333333);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF999999);
  static const Color darkTextHint = Color(0xFF666666);
  static const Color darkTextTertiary = Color(0xFF555555);

  // Status
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF00C853);
  static const Color warning = Color(0xFFFFB300);
  static const Color info = Color(0xFF2196F3);
  static const Color online = Color(0xFF00C853);
  static const Color offline = Color(0xFF999999);
}
