import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:lab3_appointment/core/theme/app_colors.dart';
import 'package:lab3_appointment/core/theme/app_text.dart';
import 'package:lab3_appointment/data/models/doctor.dart';
import 'package:lab3_appointment/data/models/home_data.dart';
import 'package:lab3_appointment/presentation/widgets/app_network_image.dart';

/// Cardul turcoaz „Appointment” cu cardul alb al medicului suprapus.
class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onTap,
    required this.onMessage,
  });

  final UpcomingAppointment appointment;
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
                key: const Key('appointment-card'),
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
                              appointment.title,
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _CardInfoRow(
                                  icon: 'assets/icons/calendar_edit.svg',
                                  text: appointment.date,
                                ),
                                const SizedBox(height: 12),
                                _CardInfoRow(
                                  icon: 'assets/icons/clock.svg',
                                  text: appointment.time,
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
              child: _UpcomingDoctorCard(
                doctor: appointment.doctor,
                onMessage: onMessage,
              ),
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

/// Cardul alb al medicului (283 × 67, umbră 0 8 80 #0000001C).
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
          AppNetworkImage(
            url: doctor.avatarUrl,
            width: 43,
            height: 43,
            borderRadius: BorderRadius.circular(8),
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
