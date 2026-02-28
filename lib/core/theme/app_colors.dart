import 'package:flutter/material.dart';

/// App color palette for gym tracker.
class AppColors {
  AppColors._();

  // Primary colors
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Secondary/Accent colors
  static const Color secondary = Color(0xFF22C55E); // Green for success/PR
  static const Color secondaryLight = Color(0xFF4ADE80);
  static const Color secondaryDark = Color(0xFF16A34A);

  // Background colors
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color cardDark = Color(0xFF334155);

  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFF1F5F9);

  // Convenience aliases (defaults to dark theme)
  static const Color surface = surfaceDark;
  static const Color card = cardDark;
  static const Color background = backgroundDark;
  static const Color textSecondary = textSecondaryDark;

  // Border colors
  static const Color borderDark = Color(0xFF334155);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Text colors
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textTertiaryDark = Color(0xFF64748B);

  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textTertiaryLight = Color(0xFF94A3B8);

  // Status colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // PR colors (celebratory)
  static const Color prGold = Color(0xFFFFD700);
  static const Color prSilver = Color(0xFFC0C0C0);
  static const Color prBronze = Color(0xFFCD7F32);

  // Muscle group colors
  static const Map<String, Color> muscleGroupColors = {
    'chest': Color(0xFFEF4444),
    'back': Color(0xFF3B82F6),
    'shoulders': Color(0xFFF59E0B),
    'biceps': Color(0xFF8B5CF6),
    'triceps': Color(0xFFEC4899),
    'forearms': Color(0xFF14B8A6),
    'quadriceps': Color(0xFF22C55E),
    'hamstrings': Color(0xFF84CC16),
    'glutes': Color(0xFFF97316),
    'calves': Color(0xFF06B6D4),
    'abs': Color(0xFFEAB308),
    'obliques': Color(0xFFA855F7),
    'lowerBack': Color(0xFF6366F1),
    'traps': Color(0xFF0EA5E9),
    'lats': Color(0xFF2563EB),
    'neck': Color(0xFF78716C),
    'fullBody': Color(0xFF64748B),
    'cardio': Color(0xFFDC2626),
  };
}
