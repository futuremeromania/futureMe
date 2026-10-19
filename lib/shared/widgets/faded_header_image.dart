import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';

/// A full-width header illustration whose bottom [fade] points blend into
/// the page background instead of ending on a hard edge, as in the design.
/// Used by every screen that opens with a header background.
class FadedHeaderImage extends StatelessWidget {
  const FadedHeaderImage(
    this.asset, {
    super.key,
    required this.height,
    this.fade = 30,
    this.alignment = Alignment.center,
  });

  final String asset;
  final double height;
  final double fade;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(asset, fit: BoxFit.cover, alignment: alignment),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: fade,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.background.withValues(alpha: 0), AppColors.background],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
