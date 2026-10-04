import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:v2_appointment/data/doctors.dart';
import 'package:v2_appointment/screens/appointment_screen.dart';
import 'package:v2_appointment/theme/app_colors.dart';
import 'package:v2_appointment/theme/app_text.dart';
import 'package:v2_appointment/widgets/design_scaler.dart';

/// Ecranul „Homescreen” din Figma (frame 375 × 812).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const double designWidth = 375;

  void _openAppointment(BuildContext context, Doctor doctor) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AppointmentScreen(doctor: doctor),
      ),
    );
  }

  void _showMessage(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final nearby = Doctors.nearby;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: DesignScaler(
            designWidth: designWidth,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Header(),
                  const SizedBox(height: 24),
                  const _SearchField(),
                  const SizedBox(height: 24),
                  _AppointmentCard(
                    doctor: Doctors.richar,
                    onTap: () => _openAppointment(context, Doctors.upul),
                    onMessage: () => _showMessage(
                      context,
                      'Chat with ${Doctors.richar.name}',
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _SectionHeader(title: 'Health Services'),
                  const SizedBox(height: 16),
                  const _HealthServices(),
                  const SizedBox(height: 24),
                  const _SectionHeader(title: 'Nearby Doctor'),
                  const SizedBox(height: 16),
                  for (var i = 0; i < nearby.length; i++) ...[
                    if (i > 0) const SizedBox(height: 16),
                    _NearbyDoctorTile(
                      doctor: nearby[i],
                      onTap: () => _openAppointment(context, nearby[i]),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Avatar + „Hi, Jonathan” + clopoțelul de notificări.
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              'assets/images/avatar_jonathan.png',
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, Jonathan',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.outfit(size: 14, weight: FontWeight.w600),
                ),
                Text(
                  'May you always be healthy',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.outfit(
                    size: 10,
                    color: AppColors.black03,
                    height: 1.8,
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            'assets/icons/notification.svg',
            width: 44,
            height: 44,
          ),
        ],
      ),
    );
  }
}

/// Câmpul „Search something” (327 × 52, rază 15).
class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.lightGrey03,
        border: Border.all(color: AppColors.lightGrey02),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/search.svg', width: 24, height: 24),
          const SizedBox(width: 15),
          Expanded(
            child: TextField(
              cursorColor: AppColors.coralGreen,
              style: AppText.outfit(size: 14, height: 1.8),
              decoration: InputDecoration.collapsed(
                hintText: 'Search something',
                hintStyle: AppText.outfit(
                  size: 14,
                  color: AppColors.grey01,
                  height: 1.8,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset('assets/icons/setting.svg', width: 24, height: 24),
        ],
      ),
    );
  }
}

/// Cardul turcoaz „Appointment” cu cardul alb al medicului suprapus.
class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({
    required this.doctor,
    required this.onTap,
    required this.onMessage,
  });

  final Doctor doctor;
  final VoidCallback onTap;
  final VoidCallback onMessage;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(8);
    return SizedBox(
      height: 198,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 173,
            child: Material(
              color: AppColors.coralGreen,
              borderRadius: radius,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(21, 23, 22, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Appointment',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.outfit(
                                size: 12,
                                weight: FontWeight.w500,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/icons/arrow_right.svg',
                            width: 14,
                            height: 14,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _CardInfoRow(
                                  icon: 'assets/icons/calendar_edit.svg',
                                  text: '22 October, 2023',
                                ),
                                SizedBox(height: 12),
                                _CardInfoRow(
                                  icon: 'assets/icons/clock.svg',
                                  text: '08:00 AM - 10.30 AM',
                                ),
                              ],
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/icons/edit_circle.svg',
                            width: 40,
                            height: 40,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 22,
            right: 22,
            top: 131,
            height: 67,
            child: GestureDetector(
              onTap: onTap,
              child: _UpcomingDoctorCard(doctor: doctor, onMessage: onMessage),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardInfoRow extends StatelessWidget {
  const _CardInfoRow({required this.icon, required this.text});

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(icon, width: 20, height: 20),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.outfit(
              size: 14,
              weight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}

/// Cardul alb „Dr. Richar Kandowen” (283 × 67, umbră 0 8 80 #0000001C).
class _UpcomingDoctorCard extends StatelessWidget {
  const _UpcomingDoctorCard({required this.doctor, required this.onMessage});

  final Doctor doctor;
  final VoidCallback onMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: Offset(0, 8),
            blurRadius: 80,
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              doctor.photo,
              width: 43,
              height: 43,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.outfit(size: 16, weight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.specialty,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.outfit(
                    size: 12,
                    weight: FontWeight.w500,
                    color: AppColors.black03,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkResponse(
            onTap: onMessage,
            radius: 20,
            child: SvgPicture.asset(
              'assets/icons/message_text.svg',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }
}

/// Titlu de secțiune + „See All”.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

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
            style: AppText.outfit(size: 18, weight: FontWeight.w600),
          ),
        ),
        Text(
          'See All',
          style: AppText.outfit(
            size: 12,
            color: AppColors.coralGreen,
            height: 1.8,
          ),
        ),
      ],
    );
  }
}

/// Rândul „Health Services”: Tooth, Eye, Lungs, Ear.
class _HealthServices extends StatelessWidget {
  const _HealthServices();

  static const List<(String, String)> _services = [
    ('Tooth', 'assets/images/service_tooth.png'),
    ('Eye', 'assets/images/service_eye.png'),
    ('Lungs', 'assets/images/service_lungs.png'),
    ('Ear', 'assets/images/service_ear.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (label, image) in _services)
          _ServiceItem(label: label, image: image),
      ],
    );
  }
}

class _ServiceItem extends StatelessWidget {
  const _ServiceItem({required this.label, required this.image});

  final String label;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.lightGrey02,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(image, width: 32, height: 32),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppText.outfit(
            size: 14,
            weight: FontWeight.w500,
            color: AppColors.black03,
          ),
        ),
      ],
    );
  }
}

/// Un rând din lista „Nearby Doctor”.
class _NearbyDoctorTile extends StatelessWidget {
  const _NearbyDoctorTile({required this.doctor, required this.onTap});

  final Doctor doctor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: Image.asset(
              doctor.photo,
              width: 46,
              height: 46,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.outfit(size: 14, weight: FontWeight.w600),
                ),
                Text(
                  doctor.specialty,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.outfit(
                    size: 12,
                    color: AppColors.black03,
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/location.svg',
                      width: 18,
                      height: 18,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        doctor.address ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.outfit(size: 12, height: 1.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset('assets/icons/heart.svg', width: 20, height: 20),
        ],
      ),
    );
  }
}
