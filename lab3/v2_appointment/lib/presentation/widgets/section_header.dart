import 'package:flutter/material.dart';

import 'package:lab3_appointment/core/theme/app_colors.dart';
import 'package:lab3_appointment/core/theme/app_text.dart';

/// Titlu de secțiune + „See All” (Homescreen).
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel = 'See All',
    this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.outfit(size: 18, weight: FontWeight.w600),
          ),
        ),
        InkWell(
          onTap: onAction,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: Text(
              actionLabel,
              style: AppText.outfit(
                size: 12,
                color: AppColors.coralGreen,
                height: 1.8,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
