import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Inima din design: goală (gri) sau plină (favorit), cu o mică animație.
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onTap,
    this.size = 20,
  });

  final bool isFavorite;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isFavorite,
      label: isFavorite ? 'Remove from favorites' : 'Add to favorites',
      child: InkResponse(
        onTap: onTap,
        radius: size,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: SvgPicture.asset(
              isFavorite
                  ? 'assets/icons/heart_filled.svg'
                  : 'assets/icons/heart.svg',
              key: ValueKey(isFavorite),
              width: size,
              height: size,
            ),
          ),
        ),
      ),
    );
  }
}
