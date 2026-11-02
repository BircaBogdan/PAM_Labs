import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:lab3_appointment/core/theme/app_colors.dart';
import 'package:lab3_appointment/core/theme/app_text.dart';
import 'package:lab3_appointment/data/models/doctor.dart';
import 'package:lab3_appointment/presentation/widgets/app_network_image.dart';
import 'package:lab3_appointment/presentation/widgets/favorite_button.dart';

/// Un rând din lista „Nearby Doctor”: poză, nume, specialitate, adresă, inimă.
class DoctorTile extends StatelessWidget {
  const DoctorTile({
    super.key,
    required this.doctor,
    required this.onTap,
    required this.onFavoriteTap,
  });

  final Doctor doctor;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final location = doctor.location;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppNetworkImage(
            url: doctor.avatarUrl,
            width: 46,
            height: 46,
            circle: true,
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
                if (location != null) ...[
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
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.outfit(size: 12, height: 1.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 4),
          FavoriteButton(
            key: Key('favorite-${doctor.id}'),
            isFavorite: doctor.isFavorite,
            onTap: onFavoriteTap,
          ),
        ],
      ),
    );
  }
}

/// Lista verticală de medici (componentă reutilizată pe Homescreen și în
/// ecranul „Nearby Doctor”).
class DoctorList extends StatelessWidget {
  const DoctorList({
    super.key,
    required this.doctors,
    required this.onOpen,
    required this.onToggleFavorite,
  });

  final List<Doctor> doctors;
  final ValueChanged<Doctor> onOpen;
  final ValueChanged<Doctor> onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < doctors.length; i++) ...[
          if (i > 0) const SizedBox(height: 16),
          DoctorTile(
            key: ValueKey(doctors[i].id),
            doctor: doctors[i],
            onTap: () => onOpen(doctors[i]),
            onFavoriteTap: () => onToggleFavorite(doctors[i]),
          ),
        ],
      ],
    );
  }
}
