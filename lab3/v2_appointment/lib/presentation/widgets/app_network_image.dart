import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:lab3_appointment/core/theme/app_colors.dart';

/// Poză încărcată asincron de la adresa din JSON (`avatarUrl`).
///
/// Cât timp se încarcă se vede un fundal discret; dacă nu există internet
/// sau adresa nu răspunde, se afișează [fallbackAsset] sau o iconiță.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    this.circle = false,
    this.borderRadius = BorderRadius.zero,
    this.fallbackAsset,
  });

  final String url;
  final double width;
  final double height;
  final bool circle;
  final BorderRadius borderRadius;
  final String? fallbackAsset;

  @override
  Widget build(BuildContext context) {
    final Widget image = url.isEmpty
        ? _fallback()
        : Image.network(
            url,
            width: width,
            height: height,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) =>
                progress == null ? child : _placeholder(),
            errorBuilder: (_, _, _) => _fallback(),
          );

    return SizedBox(
      width: width,
      height: height,
      child: circle
          ? ClipOval(child: image)
          : ClipRRect(borderRadius: borderRadius, child: image),
    );
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.photoBackground,
    );
  }

  Widget _fallback() {
    final asset = fallbackAsset;
    if (asset != null) {
      return Image.asset(asset, width: width, height: height, fit: BoxFit.cover);
    }
    return Container(
      width: width,
      height: height,
      color: AppColors.photoBackground,
      alignment: Alignment.center,
      child: Icon(
        Icons.person_rounded,
        color: AppColors.secondary,
        size: math.min(width, height) * 0.6,
      ),
    );
  }
}
