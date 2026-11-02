import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lab3_appointment/core/theme/app_colors.dart';
import 'package:lab3_appointment/core/widgets/design_scaler.dart';
import 'package:lab3_appointment/logic/doctors/doctors_cubit.dart';
import 'package:lab3_appointment/logic/doctors/doctors_state.dart';
import 'package:lab3_appointment/presentation/app_navigation.dart';
import 'package:lab3_appointment/presentation/widgets/app_search_field.dart';
import 'package:lab3_appointment/presentation/widgets/appointment_card.dart';
import 'package:lab3_appointment/presentation/widgets/doctor_list_status.dart';
import 'package:lab3_appointment/presentation/widgets/doctor_tile.dart';
import 'package:lab3_appointment/presentation/widgets/filter_options.dart';
import 'package:lab3_appointment/presentation/widgets/health_service_item.dart';
import 'package:lab3_appointment/presentation/widgets/home_header.dart';
import 'package:lab3_appointment/presentation/widgets/section_header.dart';
import 'package:lab3_appointment/presentation/widgets/state_views.dart';

/// Ecranul „Homescreen” din Figma (frame 375 × 812).
///
/// Afișează stările Loading / Error, iar după încărcare conținutul;
/// lista „Nearby Doctor” are și ea starea Empty.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const double designWidth = 375;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocConsumer<DoctorsCubit, DoctorsState>(
          // Eroare la pull-to-refresh: datele rămân, arătăm doar un mesaj.
          listenWhen: (previous, current) =>
              current.status != DoctorsStatus.error &&
              current.errorMessage != null &&
              previous.errorMessage != current.errorMessage,
          listener: (context, state) =>
              showAppMessage(context, state.errorMessage!),
          builder: (context, state) {
            return switch (state.status) {
              DoctorsStatus.initial ||
              DoctorsStatus.loading => const LoadingView(
                message: 'Loading doctors...',
              ),
              DoctorsStatus.error => ErrorView(
                message: state.errorMessage ?? 'Unknown error',
                onRetry: () => context.read<DoctorsCubit>().load(),
              ),
              DoctorsStatus.success ||
              DoctorsStatus.empty => _HomeContent(state: state),
            };
          },
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.state});

  final DoctorsState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DoctorsCubit>();
    final home = state.home!;
    return RefreshIndicator(
      color: AppColors.coralGreen,
      onRefresh: cubit.load,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: DesignScaler(
          designWidth: HomeScreen.designWidth,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HomeHeader(
                  user: home.user,
                  hasUnreadNotifications: home.hasUnreadNotifications,
                  onNotificationsTap: () => showAppMessage(
                    context,
                    home.hasUnreadNotifications
                        ? 'You have unread notifications'
                        : 'No new notifications',
                  ),
                ),
                const SizedBox(height: 24),
                AppSearchField(
                  value: state.query,
                  hint: home.searchHint,
                  onChanged: cubit.search,
                  activeFilters: state.activeFilterCount,
                  onFilterTap: () => FilterSortSheet.show(context),
                ),
                const SizedBox(height: 24),
                AppointmentCard(
                  appointment: home.appointment,
                  onTap: () => openAppointment(context),
                  onMessage: () => showAppMessage(
                    context,
                    'Chat with ${home.appointment.doctor.name}',
                  ),
                ),
                const SizedBox(height: 24),
                SectionHeader(
                  title: 'Health Services',
                  onAction: () => openDoctors(context),
                ),
                const SizedBox(height: 16),
                HealthServicesRow(
                  services: home.services,
                  selectedId: state.serviceId,
                  onSelected: (service) => cubit.toggleService(service.id),
                ),
                const SizedBox(height: 24),
                SectionHeader(
                  title: 'Nearby Doctor',
                  onAction: () => openDoctors(context),
                ),
                if (state.hasActiveFilters) ...[
                  const SizedBox(height: 8),
                  ActiveFiltersBar(state: state, onClear: cubit.clearFilters),
                ],
                const SizedBox(height: 16),
                if (state.status == DoctorsStatus.empty)
                  NoDoctorsView(state: state, onClear: cubit.clearFilters)
                else
                  DoctorList(
                    doctors: state.visibleDoctors,
                    onOpen: (doctor) => openAppointment(context, doctor: doctor),
                    onToggleFavorite: (doctor) =>
                        cubit.toggleFavorite(doctor.id),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
