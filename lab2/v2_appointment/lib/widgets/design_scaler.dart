import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Așază conținutul la lățimea frame-ului din Figma ([designWidth]) și îl
/// scalează proporțional la lățimea telefonului.
///
/// Astfel toate mărimile din Figma (padding-uri, fonturi, raze) pot fi
/// scrise exact ca în design, iar ecranul arată la fel pe orice telefon.
/// [maxScale] oprește mărirea excesivă pe tabletă sau în landscape.
class DesignScaler extends StatelessWidget {
  const DesignScaler({
    super.key,
    required this.designWidth,
    required this.child,
    this.maxScale = 1.3,
  });

  final double designWidth;
  final double maxScale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = math.min(constraints.maxWidth / designWidth, maxScale);
        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: designWidth * scale,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
              child: SizedBox(width: designWidth, child: child),
            ),
          ),
        );
      },
    );
  }
}
