import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:lab3_appointment/core/theme/app_colors.dart';
import 'package:lab3_appointment/core/theme/app_text.dart';
import 'package:lab3_appointment/data/models/home_data.dart';

/// Un pătrat din „Health Services”. Apăsarea filtrează medicii după serviciu.
class HealthServiceItem extends StatelessWidget {
  const HealthServiceItem({
    super.key,
    required this.service,
    required this.selected,
    required this.onTap,
  });

  final HealthService service;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(10);
    return Semantics(
      button: true,
      selected: selected,
      label: 'Filter by ${service.name}',
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.coralGreenSoft
                    : AppColors.lightGrey02,
                borderRadius: radius,
                border: Border.all(
                  color: selected ? AppColors.coralGreen : AppColors.lightGrey02,
                  width: 1.5,
                ),
              ),
              // Iconița din Figma; pentru servicii noi – cea din JSON (iconUrl).
              child: Image.asset(
                service.localIcon,
                width: 32,
                height: 32,
                errorBuilder: (_, _, _) => service.iconUrl.isEmpty
                    ? const Icon(
                        Icons.medical_services_outlined,
                        color: AppColors.coralGreen,
                      )
                    : SvgPicture.network(
                        service.iconUrl,
                        width: 32,
                        height: 32,
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              service.name,
              style: AppText.outfit(
                size: 14,
                weight: FontWeight.w500,
                color: selected ? AppColors.coralGreen : AppColors.black03,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Rândul „Health Services”.
class HealthServicesRow extends StatelessWidget {
  const HealthServicesRow({
    super.key,
    required this.services,
    required this.selectedId,
    required this.onSelected,
  });

  final List<HealthService> services;
  final String? selectedId;
  final ValueChanged<HealthService> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final service in services)
          HealthServiceItem(
            key: Key('service-${service.id}'),
            service: service,
            selected: service.id == selectedId,
            onTap: () => onSelected(service),
          ),
      ],
    );
  }
}
