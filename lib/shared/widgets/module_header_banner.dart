import 'package:flutter/material.dart';
import 'package:futureme/shared/widgets/faded_header_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';

/// The full-bleed header of the module/stage Introduction and Complete
/// screens: a landscape (the sunrise by default, or the module's own
/// [image]) with the FutureMe wordmark on the left and the tagline on the
/// right.
///
/// Composed from the assets the app already ships rather than baked into a
/// single PNG: the wordmark stays vector-crisp on a tablet, and the tagline
/// remains real text, so it can be changed or translated without anyone
/// having to re-export an image.
///
/// The back arrow is drawn on top of the image, matching the design — the
/// screens using this banner therefore drop their own [CustomAppBar].
class ModuleHeaderBanner extends StatelessWidget {
  const ModuleHeaderBanner({
    super.key,
    this.height = 180,
    this.tagline = "Mai multă\nclaritate\npentru\nmâine.",
    this.showBackButton = true,
    this.image = AppAssets.fullOnboardingImage,
    this.imageAlignment = Alignment.bottomCenter,
  });

  final String image;
  final Alignment imageAlignment;
  final double height;
  final String tagline;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FadedHeaderImage(image, height: height, alignment: imageAlignment),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 20, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showBackButton)
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 4, top: 2, bottom: 8),
                      child: Icon(Icons.arrow_back, color: AppColors.grad1, size: 24),
                    ),
                  ),
                SvgPicture.asset(AppAssets.splashImage, height: 44),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tagline,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: AppColors.grad1,
                        fontSize: 13,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 48,
                      height: 2,
                      decoration: const BoxDecoration(
                        gradient: AppColors.specialGradient,
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
