import 'package:flutter/material.dart';
import 'package:futureme/shared/widgets/faded_header_image.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

/// Shared layout for the "Module N - Stage X Complete" screens (Figma frame
/// 138:950 and its per-stage equivalents). Simpler than
/// [ModuleCompleteScreen] — a single achievement card instead of an audio
/// message, and a "Revin mai târziu" secondary action instead of "Acasă".
class StageCompleteScreen extends StatelessWidget {
  const StageCompleteScreen({
    super.key,
    required this.stageLabel,
    required this.title,
    required this.message,
    required this.achievementTitle,
    required this.achievementSubtitle,
    required this.infoNote,
    required this.primaryLabel,
    required this.onPrimary,
    required this.secondaryLabel,
    required this.onSecondary,
    this.headerImage = AppAssets.fullOnboardingImage,
  });

  final String stageLabel;
  final String title;

  /// The illustration across the top (exported at 1179×597, i.e. 393×199).
  final String headerImage;
  final String message;
  final String achievementTitle;
  final String achievementSubtitle;
  final String infoNote;
  final String primaryLabel;
  final String secondaryLabel;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FadedHeaderImage(headerImage, height: 199),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            stageLabel,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors
                                  .uiHeadingSmall /* ui-text-secondary */,
                              fontSize: 16,
                              fontFamily: AppFonts.body,
                              fontWeight: FontWeight.w500,
                              height: 1.375,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.uiHeading /* ui-text-heading */,
                              fontSize: 28,
                              fontFamily: AppFonts.heading,
                              fontWeight: FontWeight.w600,
                              height: 1.21,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors
                                  .uiHeadingSmall /* ui-text-secondary */,
                              fontSize: 16,
                              fontFamily: AppFonts.body,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                              letterSpacing: -0.16,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white /* ui-surface-card */,
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x59CFB2A4),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 47,
                                      height: 47,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.borderStrong,
                                        ),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                            AppAssets.moduleIcon,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: -2,
                                      bottom: -2,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check_circle,
                                          size: 16,
                                          color: AppColors.grad1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        achievementTitle,
                                        style: const TextStyle(
                                          color: AppColors
                                              .uiHeading /* ui-text-heading */,
                                          fontSize: 16,
                                          fontFamily: AppFonts.body,
                                          fontWeight: FontWeight.w500,
                                          height: 1.375,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        achievementSubtitle,
                                        style: const TextStyle(
                                          color: AppColors
                                              .uiHeadingSmall /* ui-text-secondary */,
                                          fontSize: 14,
                                          fontFamily: AppFonts.body,
                                          fontWeight: FontWeight.w400,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: AppColors.statusInfoBg,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.info_outline,
                                  size: 12,
                                  color: AppColors.statusInfoFg,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  infoNote,
                                  style: const TextStyle(
                                    color: AppColors.statusInfoFg,
                                    fontSize: 14,
                                    fontFamily: AppFonts.body,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  PrimaryButton(content: primaryLabel, onpressed: onPrimary),
                  GestureDetector(
                    onTap: onSecondary,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 18,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        secondaryLabel,
                        style: const TextStyle(
                          color: AppColors.grad1 /* ui-action-secondaryText */,
                          fontSize: 16,
                          fontFamily: AppFonts.body,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
