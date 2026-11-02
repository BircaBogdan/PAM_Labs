import 'package:flutter/material.dart';

import 'package:lab3_appointment/core/theme/app_colors.dart';
import 'package:lab3_appointment/core/theme/app_text.dart';

/// Chip-ul pentru oră / dată din ecranul Appointment (înălțime 56, rază 10).
class SelectableChip extends StatelessWidget {
  const SelectableChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.width,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// Lățime fixă; dacă e `null`, chip-ul are padding orizontal de 24.
  final double? width;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(10);
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? AppColors.primary : AppColors.chip,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Container(
            width: width,
            height: 56,
            padding: EdgeInsets.symmetric(horizontal: width == null ? 24 : 0),
            alignment: Alignment.center,
            child: Text(
              label,
              maxLines: 1,
              style: AppText.openSans(
                size: 20,
                color: selected ? AppColors.white : AppColors.black,
                letterSpacingPercent: -2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
