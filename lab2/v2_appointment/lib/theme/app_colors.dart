import 'package:flutter/material.dart';

/// Culorile definite în fișierul Figma „Laboratoare 2026”, pagina V2.
abstract final class AppColors {
  // --- Ecranul „Appointment detailes” ---
  static const Color primary = Color(0xFF0B8FAC);
  static const Color secondary = Color(0xFF7BC1B7);
  static const Color gray = Color(0xFF858585);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  /// rgba(217, 217, 217, 0.3) – fundalul chip-urilor neselectate.
  static const Color chip = Color(0x4DD9D9D9);

  /// Fundal discret pentru fotografia medicului (vizibil doar la pozele rotunde).
  static const Color photoBackground = Color(0x267BC1B7);

  // --- Ecranul „Homescreen” ---
  static const Color black01 = Color(0xFF191D31);
  static const Color black03 = Color(0xFF8C8E98);
  static const Color coralGreen = Color(0xFF2BACBE);
  static const Color grey01 = Color(0xFFA7AEC1);
  static const Color lightGrey02 = Color(0xFFF9F9F9);
  static const Color lightGrey03 = Color(0xFFFBFBFD);

  /// box-shadow: 0 8px 80px rgba(0, 0, 0, 0.11) – cardul medicului de pe Homescreen.
  static const Color cardShadow = Color(0x1C000000);
}
