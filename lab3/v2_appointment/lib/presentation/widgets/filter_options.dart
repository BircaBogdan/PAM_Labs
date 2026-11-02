import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lab3_appointment/core/theme/app_colors.dart';
import 'package:lab3_appointment/core/theme/app_text.dart';
import 'package:lab3_appointment/data/models/home_data.dart';
import 'package:lab3_appointment/logic/doctors/doctor_filters.dart';
import 'package:lab3_appointment/logic/doctors/doctors_cubit.dart';
import 'package:lab3_appointment/logic/doctors/doctors_state.dart';

/// O „pastilă” selectabilă (sortare / specialitate / favorite).
class OptionChip extends StatelessWidget {
  const OptionChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20);
    final foreground = selected ? AppColors.white : AppColors.black01;
    final chipIcon = icon;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? AppColors.coralGreen : AppColors.lightGrey02,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (chipIcon != null) ...[
                  Icon(
                    chipIcon,
                    size: 16,
                    color: selected ? AppColors.white : AppColors.favorite,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: AppText.outfit(
                    size: 13,
                    weight: FontWeight.w500,
                    color: foreground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Opțiunile de sortare.
class SortOptions extends StatelessWidget {
  const SortOptions({super.key, required this.value, required this.onChanged});

  final DoctorSort value;
  final ValueChanged<DoctorSort> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final sort in DoctorSort.values)
          OptionChip(
            key: Key('sort-${sort.name}'),
            label: sort.label,
            selected: sort == value,
            onTap: () => onChanged(sort),
          ),
      ],
    );
  }
}

/// Filtrul după serviciu („All” + serviciile din JSON) și „Favorites”.
class ServiceOptions extends StatelessWidget {
  const ServiceOptions({
    super.key,
    required this.services,
    required this.selectedId,
    required this.onSelected,
    required this.favoritesOnly,
    required this.onFavoritesOnlyChanged,
  });

  final List<HealthService> services;
  final String? selectedId;
  final ValueChanged<String?> onSelected;
  final bool favoritesOnly;
  final ValueChanged<bool> onFavoritesOnlyChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        OptionChip(
          label: 'All',
          selected: selectedId == null,
          onTap: () => onSelected(null),
        ),
        for (final service in services)
          OptionChip(
            label: service.name,
            selected: service.id == selectedId,
            onTap: () => onSelected(service.id),
          ),
        OptionChip(
          key: const Key('favorites-only'),
          label: 'Favorites',
          icon: favoritesOnly
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          selected: favoritesOnly,
          onTap: () => onFavoritesOnlyChanged(!favoritesOnly),
        ),
      ],
    );
  }
}

/// Foaia de jos „Filter & Sort”, deschisă din iconița de lângă căutare.
class FilterSortSheet extends StatelessWidget {
  const FilterSortSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const FilterSortSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DoctorsCubit>();
    return BlocBuilder<DoctorsCubit, DoctorsState>(
      builder: (context, state) {
        final count = state.visibleDoctors.length;
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Filter & Sort',
                        style: AppText.outfit(
                          size: 18,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: state.hasActiveFilters
                          ? cubit.clearFilters
                          : null,
                      child: Text(
                        'Reset',
                        style: AppText.outfit(
                          size: 14,
                          weight: FontWeight.w500,
                          color: state.hasActiveFilters
                              ? AppColors.coralGreen
                              : AppColors.grey01,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const _SheetLabel('Sort by'),
                const SizedBox(height: 10),
                SortOptions(value: state.sort, onChanged: cubit.changeSort),
                const SizedBox(height: 20),
                const _SheetLabel('Specialty'),
                const SizedBox(height: 10),
                ServiceOptions(
                  services: state.home?.services ?? const [],
                  selectedId: state.serviceId,
                  onSelected: cubit.selectService,
                  favoritesOnly: state.favoritesOnly,
                  onFavoritesOnlyChanged: cubit.setFavoritesOnly,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.coralGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      count == 1 ? 'Show 1 doctor' : 'Show $count doctors',
                      style: AppText.outfit(
                        size: 16,
                        weight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SheetLabel extends StatelessWidget {
  const _SheetLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppText.outfit(
        size: 13,
        weight: FontWeight.w500,
        color: AppColors.black03,
      ),
    );
  }
}
