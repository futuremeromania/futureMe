import 'package:flutter/material.dart';
import 'package:futureme/shared/widgets/faded_header_image.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

/// The body text of the first break; later breaks pass their own.
const String defaultBreakMessage =
    "Ai trecut de primele întrebări. Unele alegeri pot fi clare, altele mai greu de simțit. E normal. Continuăm când ești gata.";

/// Shared layout for the "Break - After Question N" screens (Figma
/// frames 136:698 and 137:839) — a short mid-quiz rest screen. The frames
/// differ in headline and header illustration, hence [title] and
/// [headerImage]. Opened through `openQuestionBreak` in module_resume.dart,
/// which also makes "Revin mai târziu" safe: the stage resumes at the next
/// question.
class ModuleBreakScreen extends StatelessWidget {
  const ModuleBreakScreen({
    super.key,
    required this.title,
    required this.onContinue,
    required this.onSecondary,
    this.message = defaultBreakMessage,
    this.continueLabel = "Continuă",
    this.secondaryLabel = "Revin mai târziu",
    this.headerImage = AppAssets.fullOnboardingImage,
  });

  final String title;

  /// The illustration across the top (exported at 1179×777, i.e. 393×259).
  final String headerImage;
  final String message;
  final String continueLabel;
  final String secondaryLabel;
  final VoidCallback onContinue;
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
                    FadedHeaderImage(headerImage, height: 259),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.uiHeading,
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
                              color: AppColors.uiHeadingSmall,
                              fontSize: 16,
                              fontFamily: AppFonts.body,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                              letterSpacing: -0.16,
                            ),
                          ),
                          const SizedBox(height: 40),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      const Text(
                        "Progresul tău este salvat.",
                        style: TextStyle(
                          color: AppColors.statusInfoFg,
                          fontSize: 14,
                          fontFamily: AppFonts.body,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(content: continueLabel, onpressed: onContinue),
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
                          color: AppColors.grad1,
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
