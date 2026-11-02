import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:lab3_appointment/core/theme/app_colors.dart';
import 'package:lab3_appointment/core/theme/app_text.dart';
import 'package:lab3_appointment/logic/doctors/doctors_cubit.dart';
import 'package:lab3_appointment/logic/doctors/doctors_state.dart';
import 'package:lab3_appointment/presentation/app_navigation.dart';
import 'package:lab3_appointment/presentation/widgets/app_search_field.dart';
import 'package:lab3_appointment/presentation/widgets/doctor_list_status.dart';
import 'package:lab3_appointment/presentation/widgets/doctor_tile.dart';
import 'package:lab3_appointment/presentation/widgets/filter_options.dart';
import 'package:lab3_appointment/presentation/widgets/state_views.dart';

/// „See All” → lista completă „Nearby Doctor” cu căutare, sortare,
/// filtrare după specialitate și favorite.
class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const DoctorsScreen());
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DoctorsCubit>();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocBuilder<DoctorsCubit, DoctorsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const LoadingView(message: 'Loading doctors...');
            }
            if (state.status == DoctorsStatus.error) {
              return ErrorView(
                message: state.errorMessage ?? 'Unknown error',
                onRetry: cubit.load,
              );
            }

            return RefreshIndicator(
              color: AppColors.coralGreen,
              onRefresh: cubit.load,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    sliver: SliverList.list(
                      children: [
                        _TopBar(favorites: state.favoritesCount),
                        const SizedBox(height: 20),
                        AppSearchField(
                          value: state.query,
                          hint: state.home?.searchHint ?? 'Search',
                          onChanged: cubit.search,
                          activeFilters: state.activeFilterCount,
                          onFilterTap: () => FilterSortSheet.show(context),
                        ),
                        const SizedBox(height: 16),
                        SortOptions(
                          value: state.sort,
                          onChanged: cubit.changeSort,
                        ),
                        const SizedBox(height: 8),
                        ServiceOptions(
                          services: state.home?.services ?? const [],
                          selectedId: state.serviceId,
                          onSelected: cubit.selectService,
                          favoritesOnly: state.favoritesOnly,
                          onFavoritesOnlyChanged: cubit.setFavoritesOnly,
                        ),
                        const SizedBox(height: 16),
                        ActiveFiltersBar(
                          state: state,
                          onClear: cubit.clearFilters,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  if (state.status == DoctorsStatus.empty)
                    SliverToBoxAdapter(
                      child: NoDoctorsView(
                        state: state,
                        onClear: cubit.clearFilters,
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                      sliver: SliverList.separated(
                        itemCount: state.visibleDoctors.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final doctor = state.visibleDoctors[index];
                          return DoctorTile(
                            key: ValueKey(doctor.id),
                            doctor: doctor,
                            onTap: () =>
                                openAppointment(context, doctor: doctor),
                            onFavoriteTap: () =>
                                cubit.toggleFavorite(doctor.id),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.favorites});

  final int favorites;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          InkResponse(
            key: const Key('doctors-back-button'),
            onTap: () => Navigator.of(context).maybePop(),
            radius: 24,
            child: SvgPicture.asset(
              'assets/icons/back.svg',
              width: 40,
              height: 40,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Nearby Doctor',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.outfit(size: 20, weight: FontWeight.w600),
            ),
          ),
          const Icon(
            Icons.favorite_rounded,
            size: 18,
            color: AppColors.favorite,
          ),
          const SizedBox(width: 4),
          Text(
            '$favorites',
            style: AppText.outfit(size: 14, weight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
