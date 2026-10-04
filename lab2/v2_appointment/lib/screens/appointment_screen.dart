import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:v2_appointment/data/doctors.dart';
import 'package:v2_appointment/theme/app_colors.dart';
import 'package:v2_appointment/theme/app_text.dart';
import 'package:v2_appointment/widgets/design_scaler.dart';
import 'package:v2_appointment/widgets/selectable_chip.dart';

/// Ecranul „Appointment detailes” din Figma (frame 430 × 932).
class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key, this.doctor = Doctors.upul});

  final Doctor doctor;

  static const double designWidth = 430;

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  static const double _sidePadding = 26;
  static const EdgeInsets _padding =
      EdgeInsets.symmetric(horizontal: _sidePadding);

  static const List<String> _hours = [
    '10.00 AM',
    '11.00 AM',
    '12.00 PM',
    '01.00 PM',
    '02.00 PM',
    '03.00 PM',
    '04.00 PM',
  ];

  static const List<String> _dates = [
    'Sun 4',
    'Mon 5',
    'Tue 6',
    'Wed 7',
    'Thu 8',
    'Fri 9',
    'Sat 10',
  ];

  // Selecția implicită din design: 11.00 AM și Sun 4.
  int _selectedHour = 1;
  int _selectedDate = 0;

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _book() {
    _showMessage(
      'Appointment booked: ${widget.doctor.name} · '
      '${_dates[_selectedDate]} · ${_hours[_selectedHour]}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
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
                        padding: _padding,
                        child: _TopBar(
                          onBack: () => Navigator.of(context).maybePop(),
                        ),
                      ),
                      const SizedBox(height: 28.5),
                      Padding(
                        padding: _padding,
                        child: _DoctorCard(
                          doctor: doctor,
                          onAction: _showMessage,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // În Figma textul are 383 px lățime (26 → 409).
                      Padding(
                        padding: const EdgeInsets.only(
                          left: _sidePadding,
                          right: 21,
                        ),
                        child: _Details(text: doctor.about),
                      ),
                      const SizedBox(height: 44),
                      const Padding(
                        padding: _padding,
                        child: _SectionTitle(title: 'Working Hours'),
                      ),
                      const SizedBox(height: 26),
                      _ChipList(
                        labels: _hours,
                        selected: _selectedHour,
                        onSelected: (i) => setState(() => _selectedHour = i),
                      ),
                      const SizedBox(height: 29),
                      const Padding(
                        padding: _padding,
                        child: _SectionTitle(title: 'Date'),
                      ),
                      const SizedBox(height: 26),
                      _ChipList(
                        labels: _dates,
                        selected: _selectedDate,
                        chipWidth: 122,
                        onSelected: (i) => setState(() => _selectedDate = i),
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
                child: _BookButton(onPressed: _book),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Săgeata „înapoi” + titlul „Appointment” centrat.
class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
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
                onTap: onBack,
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
              'Appointment',
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
        ],
      ),
    );
  }
}

/// Poza 132 × 132 + nume, acțiuni (chat / apel / video), specialitate, preț.
class _DoctorCard extends StatelessWidget {
  const _DoctorCard({required this.doctor, required this.onAction});

  final Doctor doctor;
  final ValueChanged<String> onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 132,
            height: 132,
            color: AppColors.photoBackground,
            child: Image.asset(doctor.photo, fit: BoxFit.cover),
          ),
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
                    const SizedBox(width: 17),
                    _RoundAction(
                      asset: 'assets/icons/ic_chat.svg',
                      onTap: () => onAction('Chat with ${doctor.name}'),
                    ),
                    const SizedBox(width: 17),
                    _RoundAction(
                      asset: 'assets/icons/ic_call.svg',
                      onTap: () => onAction('Calling ${doctor.name}...'),
                    ),
                    const SizedBox(width: 17),
                    _RoundAction(
                      asset: 'assets/icons/ic_video.svg',
                      onTap: () => onAction('Video call with ${doctor.name}'),
                    ),
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
                      'Payment',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.openSans(
                        size: 20,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    doctor.price,
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
  const _Details({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Details',
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
  const _SectionTitle({required this.title});

  final String title;

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
        Text(
          'See All',
          style: AppText.openSans(size: 16, letterSpacingPercent: -2),
        ),
      ],
    );
  }
}

/// Listă orizontală de chip-uri selectabile (orele sau zilele).
class _ChipList extends StatelessWidget {
  const _ChipList({
    required this.labels,
    required this.selected,
    required this.onSelected,
    this.chipWidth,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;
  final double? chipWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: _AppointmentScreenState._sidePadding,
        ),
        itemCount: labels.length,
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        itemBuilder: (context, index) => SelectableChip(
          label: labels[index],
          selected: index == selected,
          width: chipWidth,
          onTap: () => onSelected(index),
        ),
      ),
    );
  }
}

/// Butonul „Book an Appointment” (377 × 60, rază 10).
class _BookButton extends StatelessWidget {
  const _BookButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(10);
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Material(
        color: AppColors.primary,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onPressed,
          child: Center(
            child: Text(
              'Book an Appointment',
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
