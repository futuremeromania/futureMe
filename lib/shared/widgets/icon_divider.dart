import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';

/// Renders a heart icon in the middle by default (Figma "Divider With
/// Icon", used on the consent screens). Pass [centerText] to render text
/// instead (Figma "Or Divider Container", e.g. "sau" on Create Account).
class IconDivider extends StatelessWidget {
  const IconDivider({super.key, this.centerText});

  final String? centerText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16,
        children: [
          Expanded(
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: const Color(0xFFE9DCD7) /* ui-border-default */,
                  ),
                ),
              ),
            ),
          ),
          if (centerText != null)
            Text(
              centerText!,
              style: const TextStyle(color: AppColors.uiHeadingSmall, fontSize: 12, fontFamily: 'Rubik', fontWeight: FontWeight.w400, height: 1.5),
            )
          else
            Container(
              width: 16,
              height: 16,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(),
              child: Stack(
                children: [
                  Image.asset(AppAssets.loveIcon),
                ],
              ),
            ),
          Expanded(
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: const Color(0xFFE9DCD7) /* ui-border-default */,
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
