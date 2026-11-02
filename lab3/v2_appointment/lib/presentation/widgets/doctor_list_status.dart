import 'package:flutter/material.dart';

import 'package:lab3_appointment/core/theme/app_colors.dart';
import 'package:lab3_appointment/core/theme/app_text.dart';
import 'package:lab3_appointment/logic/doctors/doctors_state.dart';
import 'package:lab3_appointment/presentation/widgets/state_views.dart';

/// „2 doctors · Dental · Favorites   Clear” – rezumatul filtrelor active.
class ActiveFiltersBar extends StatelessWidget {
  const ActiveFiltersBar({
    super.key,
    required this.state,
    required this.onClear,
  });

  final DoctorsState state;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final count = state.visibleDoctors.length;
    final parts = <String>[
      count == 1 ? '1 doctor' : '$count doctors',
      if (state.selectedService != null) state.selectedService!.name,
      if (state.favoritesOnly) 'Favorites',
      state.sort.label,
    ];
    return Row(
      children: [
        Expanded(
          child: Text(
            parts.join(' · '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.outfit(size: 12, color: AppColors.black03),
          ),
        ),
        InkWell(
          key: const Key('clear-filters'),
          onTap: onClear,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Text(
              'Clear',
              style: AppText.outfit(
                size: 12,
                weight: FontWeight.w600,
                color: AppColors.coralGreen,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Starea „Empty” pentru lista de medici.
class NoDoctorsView extends StatelessWidget {
  const NoDoctorsView({super.key, required this.state, required this.onClear});

  final DoctorsState state;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    if (state.doctors.isEmpty) {
      return const EmptyView(
        title: 'No doctors yet',
        message: 'There are no doctors near you at the moment.',
      );
    }
    return EmptyView(
      title: 'No doctors found',
      message: state.favoritesOnly && state.favoritesCount == 0
          ? 'You have no favorite doctors yet. Tap the heart to add one.'
          : 'Try another search or remove some filters.',
      actionLabel: 'Clear filters',
      onAction: onClear,
    );
  }
}
