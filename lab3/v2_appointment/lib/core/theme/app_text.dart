import 'package:flutter/material.dart';

import 'package:lab3_appointment/core/theme/app_colors.dart';

/// Stilurile de text din Figma.
///
/// * Homescreen folosește fontul **Outfit**.
/// * Appointment folosește fontul **Open Sans**.
///
/// `leadingDistribution: even` împarte spațiul dintre rânduri sus/jos
/// la fel ca în Figma (line-height din CSS).
abstract final class AppText {
  static const String openSansFamily = 'OpenSans';
  static const String outfitFamily = 'Outfit';

  /// [letterSpacingPercent] e în procente din mărimea fontului
  /// (în Figma: -2% → -0.44px la 22px).
  static TextStyle openSans({
    required double size,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.black,
    double? height = 1,
    double letterSpacingPercent = 0,
  }) {
    return TextStyle(
      fontFamily: openSansFamily,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: size * letterSpacingPercent / 100,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  static TextStyle outfit({
    required double size,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.black01,
    double height = 1.3,
  }) {
    return TextStyle(
      fontFamily: outfitFamily,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }
}
