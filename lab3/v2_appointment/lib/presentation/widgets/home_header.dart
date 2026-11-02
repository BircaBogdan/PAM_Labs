import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:lab3_appointment/core/theme/app_colors.dart';
import 'package:lab3_appointment/core/theme/app_text.dart';
import 'package:lab3_appointment/data/models/home_data.dart';
import 'package:lab3_appointment/presentation/widgets/app_network_image.dart';

/// Avatar + „Hi, Jonathan” + clopoțelul de notificări.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.user,
    required this.hasUnreadNotifications,
    required this.onNotificationsTap,
  });

  final UserProfile user;
  final bool hasUnreadNotifications;
  final VoidCallback onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          AppNetworkImage(
            url: user.avatarUrl,
            width: 44,
            height: 44,
            circle: true,
            fallbackAsset: 'assets/images/avatar_jonathan.png',
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.greeting,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.outfit(size: 14, weight: FontWeight.w600),
                ),
                Text(
                  user.subtitle,
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
          InkResponse(
            onTap: onNotificationsTap,
            radius: 24,
            child: SvgPicture.asset(
              hasUnreadNotifications
                  ? 'assets/icons/notification.svg'
                  : 'assets/icons/notification_none.svg',
              width: 44,
              height: 44,
            ),
          ),
        ],
      ),
    );
  }
}
