import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';

/// The 100x100 "sunny day" illustration with a small status badge
/// overlapping its bottom-right edge (Figma "Icon Badge" — envelope, clock,
/// check-circle or warning-circle depending on the screen).
class SunBadgeIcon extends StatelessWidget {
  const SunBadgeIcon({super.key, this.badgeIcon, this.badgeColor, this.size = 100});

  final IconData? badgeIcon;
  final Color? badgeColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size + 16,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(size / 2),
            child: Image.asset(AppAssets.sunnyDay, width: size, height: size, fit: BoxFit.cover),
          ),
          if (badgeIcon != null)
            Positioned(
              right: -4,
              bottom: -4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white /* ui-surface-card */,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Color(0x59CFB2A4), blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Icon(badgeIcon, size: 24, color: badgeColor),
              ),
            ),
        ],
      ),
    );
  }
}
