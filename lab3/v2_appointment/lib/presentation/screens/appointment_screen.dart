import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:lab3_appointment/core/theme/app_colors.dart';
import 'package:lab3_appointment/core/theme/app_text.dart';
import 'package:lab3_appointment/core/widgets/design_scaler.dart';
import 'package:lab3_appointment/core/widgets/selectable_chip.dart';
import 'package:lab3_appointment/data/models/appointment_details.dart';
import 'package:lab3_appointment/data/models/doctor.dart';
import 'package:lab3_appointment/data/repositories/clinic_repository.dart';
import 'package:lab3_appointment/logic/appointment/appointment_cubit.dart';
import 'package:lab3_appointment/logic/appointment/appointment_state.dart';
import 'package:lab3_appointment/logic/doctors/doctors_cubit.dart';
import 'package:lab3_appointment/presentation/app_navigation.dart';
import 'package:lab3_appointment/presentation/widgets/app_network_image.dart';
import 'package:lab3_appointment/presentation/widgets/favorite_button.dart';
import 'package:lab3_appointment/presentation/widgets/state_views.dart';

/// Ecranul „Appointment detailes” din Figma (frame 430 × 932) – pagina de
/// detalii a medicului ales.
class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  static const double designWidth = 430;
  static const double _sidePadding = 26;
  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: _sidePadding,
  );

  /// Fiecare deschidere a ecranului are propriul [AppointmentCubit].
  /// Dacă [doctor] e `null`, se afișează medicul din JSON (Dr.Upul).
  static Route<void> route({Doctor? doctor}) {
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => AppointmentCubit(
          context.read<ClinicRepository>(),
          doctor: doctor,
        )..load(),
        child: const AppointmentScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocConsumer<AppointmentCubit, AppointmentState>(
          listenWhen: (previous, current) =>
              previous.bookingStatus != current.bookingStatus &&
              (current.bookingStatus == BookingStatus.success ||
                  current.bookingStatus == BookingStatus.failure),
          listener: (context, state) {
            final message = state.message;
            if (message != null) showAppMessage(context, message);
          },
          builder: (context, state) {
            final details = state.details;
            final doctor = state.displayedDoctor;
            if (state.status == AppointmentStatus.success &&
                details != null &&
                doctor != null) {
              return _AppointmentContent(
                state: state,
                details: details,
                doctor: doctor,
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DesignScaler(
                  designWidth: designWidth,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      _sidePadding,
                      24,
                      _sidePadding,
                      0,
                    ),
                    child: _TopBar(
                      title: details?.title ?? 'Appointment',
                      doctor: state.doctor,
                    ),
                  ),
                ),
                Expanded(
                  child: state.status == AppointmentStatus.error
                      ? ErrorView(
                          message: state.message ?? 'Unknown error',
                          onRetry: context.read<AppointmentCubit>().load,
                        )
                      : const LoadingView(message: 'Loading details...'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AppointmentContent extends StatelessWidget {
  const _AppointmentContent({
    required this.state,
    required this.details,
    required this.doctor,
  });

  final AppointmentState state;
  final AppointmentDetails details;
  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppointmentCubit>();
    const padding = AppointmentScreen._padding;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: DesignScaler(
              designWidth: AppointmentScreen.designWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Padding(
                    padding: padding,
                    child: _TopBar(title: details.title, doctor: state.doctor),
                  ),
                  const SizedBox(height: 28.5),
                  Padding(
                    padding: padding,
                    child: _DoctorCard(
                      doctor: doctor,
                      actions: details.actions,
                      payment: details.payment,
                      onAction: (text) => showAppMessage(context, text),
                    ),
                  ),
                  const SizedBox(height: 44),
                  // În Figma textul are 383 px lățime (26 → 409).
                  Padding(
                    padding: const EdgeInsets.only(
                      left: AppointmentScreen._sidePadding,
                      right: 21,
                    ),
                    child: _Details(
                      title: details.detailsTitle,
                      text: details.description,
                    ),
                  ),
                  const SizedBox(height: 44),
                  Padding(
                    padding: padding,
                    child: _SectionTitle(
                      title: details.workingHours.title,
                      showAll: details.workingHours.showAll,
                    ),
                  ),
                  const SizedBox(height: 26),
                  _ChipList(
                    slots: details.workingHours.slots,
                    selectedId: state.selectedHourId,
                    onSelected: cubit.selectHour,
                  ),
                  const SizedBox(height: 29),
                  Padding(
                    padding: padding,
                    child: _SectionTitle(
                      title: details.dates.title,
                      showAll: details.dates.showAll,
                    ),
                  ),
                  const SizedBox(height: 26),
                  _ChipList(
                    slots: details.dates.slots,
                    selectedId: state.selectedDateId,
                    chipWidth: 122,
                    onSelected: cubit.selectDate,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
        DesignScaler(
          designWidth: AppointmentScreen.designWidth,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26.7, 16, 26.7, 24),
            child: _BookButton(
              label: details.bookLabel,
              loading: state.bookingStatus == BookingStatus.inProgress,
              onPressed: state.canBook ? cubit.book : null,
            ),
          ),
        ),
      ],
    );
  }
}

/// Săgeata „înapoi” + titlul centrat + inima (doar pentru medicii din listă).
class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.doctor});

  final String title;

  /// Medicul deschis din listă; pentru el se afișează butonul de favorit.
  final Doctor? doctor;

  @override
  Widget build(BuildContext context) {
    final doctorId = doctor?.id;
    return SizedBox(
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Semantics(
              label: 'Back',
              button: true,
              child: InkResponse(
                key: const Key('back-button'),
                onTap: () => Navigator.of(context).maybePop(),
                radius: 24,
                child: SvgPicture.asset(
                  'assets/icons/back.svg',
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppText.openSans(
                size: 26,
                weight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacingPercent: -2,
              ),
            ),
          ),
          if (doctorId != null)
            Align(
              alignment: Alignment.centerRight,
              child: _FavoriteToggle(doctorId: doctorId),
            ),
        ],
      ),
    );
  }
}

/// Inima de pe pagina de detalii – citește și schimbă starea din
/// [DoctorsCubit], deci rămâne sincronizată cu lista de pe Homescreen.
class _FavoriteToggle extends StatelessWidget {
  const _FavoriteToggle({required this.doctorId});

  final String doctorId;

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<DoctorsCubit, bool?>(
      (cubit) => cubit.state.doctorById(doctorId)?.isFavorite,
    );
    if (isFavorite == null) return const SizedBox.shrink();
    return FavoriteButton(
      key: const Key('details-favorite'),
      isFavorite: isFavorite,
      size: 28,
      onTap: () => context.read<DoctorsCubit>().toggleFavorite(doctorId),
    );
  }
}

/// Poza 132 × 132 + nume, acțiuni (chat / apel / video), specialitate, preț.
class _DoctorCard extends StatelessWidget {
  const _DoctorCard({
    required this.doctor,
    required this.actions,
    required this.payment,
    required this.onAction,
  });

  final Doctor doctor;
  final DoctorActions actions;
  final Payment payment;
  final ValueChanged<String> onAction;

  @override
  Widget build(BuildContext context) {
    final buttons = <Widget>[
      if (actions.message)
        _RoundAction(
          asset: 'assets/icons/ic_chat.svg',
          onTap: () => onAction('Chat with ${doctor.name}'),
        ),
      if (actions.call)
        _RoundAction(
          asset: 'assets/icons/ic_call.svg',
          onTap: () => onAction('Calling ${doctor.name}...'),
        ),
      if (actions.videoCall)
        _RoundAction(
          asset: 'assets/icons/ic_video.svg',
          onTap: () => onAction('Video call with ${doctor.name}'),
        ),
    ];

    return Row(
      children: [
        AppNetworkImage(
          url: doctor.avatarUrl,
          width: 132,
          height: 132,
          borderRadius: BorderRadius.circular(10),
        ),
        const SizedBox(width: 21),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        doctor.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.openSans(
                          size: 22,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ),
                    for (final button in buttons) ...[
                      const SizedBox(width: 17),
                      button,
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                doctor.specialty,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.openSans(
                  size: 16,
                  weight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: Text(
                      payment.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.openSans(
                        size: 20,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    payment.formatted,
                    style: AppText.openSans(
                      size: 20,
                      weight: FontWeight.w700,
                      color: AppColors.secondary,
                      height: null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Butonul rotund 30 × 30 (cerc #7BC1B7 30% + iconiță).
class _RoundAction extends StatelessWidget {
  const _RoundAction({required this.asset, required this.onTap});

  final String asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 20,
      child: SvgPicture.asset(asset, width: 30, height: 30),
    );
  }
}

/// „Details” + textul descriptiv.
class _Details extends StatelessWidget {
  const _Details({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppText.openSans(
            size: 22,
            weight: FontWeight.w600,
            letterSpacingPercent: -2,
          ),
        ),
        const SizedBox(height: 17),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 120),
          child: Text(
            text,
            style: AppText.openSans(
              size: 13,
              color: AppColors.gray,
              height: 1.32,
            ),
          ),
        ),
      ],
    );
  }
}

/// „Working Hours” / „Date” + „See All”.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.showAll});

  final String title;
  final bool showAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.openSans(
              size: 22,
              weight: FontWeight.w600,
              letterSpacingPercent: -2,
            ),
          ),
        ),
        if (showAll)
          Text(
            'See All',
            style: AppText.openSans(size: 16, letterSpacingPercent: -2),
          ),
      ],
    );
  }
}

/// Listă orizontală de chip-uri selectabile (orele sau zilele din JSON).
class _ChipList extends StatelessWidget {
  const _ChipList({
    required this.slots,
    required this.selectedId,
    required this.onSelected,
    this.chipWidth,
  });

  final List<TimeSlot> slots;
  final String? selectedId;
  final ValueChanged<String> onSelected;
  final double? chipWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: AppointmentScreen._padding,
        itemCount: slots.length,
        separatorBuilder: (_, _) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final slot = slots[index];
          return SelectableChip(
            key: Key('slot-${slot.id}'),
            label: slot.label,
            selected: slot.id == selectedId,
            width: chipWidth,
            onTap: () => onSelected(slot.id),
          );
        },
      ),
    );
  }
}

/// Butonul „Book an Appointment” (377 × 60, rază 10).
class _BookButton extends StatelessWidget {
  const _BookButton({
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  final String label;
  final bool loading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(10);
    final enabled = onPressed != null || loading;
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Material(
        color: enabled ? AppColors.primary : AppColors.grey01,
        borderRadius: radius,
        child: InkWell(
          key: const Key('book-button'),
          borderRadius: radius,
          onTap: onPressed,
          child: Center(
            child: loading
                ? const SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppColors.white,
                    ),
                  )
                : Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.openSans(
                      size: 22,
                      weight: FontWeight.w700,
                      color: AppColors.white,
                      letterSpacingPercent: -2,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
