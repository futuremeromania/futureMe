import 'package:flutter/material.dart';
import 'package:futureme/shared/widgets/module_header_banner.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/tts_audio_card.dart';

/// Shared layout for the "Module N - Complete" screens (Figma frame 86:485
/// and its per-module equivalents). The audio card speaks [message] aloud
/// via on-device text-to-speech, or plays [audioAssetPath] when a module
/// has a recorded message instead (see [TtsAudioCard]).
class ModuleCompleteScreen extends StatelessWidget {
  const ModuleCompleteScreen({
    super.key,
    required this.title,
    required this.message,
    required this.encouragementNote,
    required this.onContinue,
    required this.onHome,
    this.continueLabel = "Continuă către feedback",
    this.homeLabel = "Înapoi Acasă",
    this.nextModuleLabel,
    this.nextModuleTitle,
    this.nextModuleDescription,
    this.audioAssetPath,
    this.headerImage = AppAssets.fullOnboardingImage,
  });

  final String title;

  /// The illustration across the top (exported at 1179×597, i.e. 393×199).
  final String headerImage;
  final String message;
  final String encouragementNote;
  final String continueLabel;
  final String homeLabel;

  /// Optional "next module" preview card (Figma frame 191:1371) — shown
  /// between the audio message and the info note, when this Complete
  /// screen is a module-level one rather than a stage-level one.
  final String? nextModuleLabel;
  final String? nextModuleTitle;
  final String? nextModuleDescription;

  /// Optional recorded message for this module, e.g.
  /// `assets/audio/module1_complete.m4a`. Falls back to text-to-speech of
  /// [message] when absent.
  final String? audioAssetPath;

  final VoidCallback onContinue;
  final VoidCallback onHome;

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
                    // Same wordmark and tagline as the Introduction screens,
                    // over this module's own image. No back arrow: this screen
                    // replaced the last one, so there is nothing to go back to.
                    ModuleHeaderBanner(
                      image: headerImage,
                      imageAlignment: Alignment.center,
                      height: 199,
                      showBackButton: false,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
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
                          TtsAudioCard(
                            title: "Mesaj pentru tine",
                            subtitle:
                                "Un scurt mesaj de încurajare înainte să mergi mai departe.",
                            spokenText: message,
                            assetPath: audioAssetPath,
                          ),
                          if (nextModuleTitle != null) ...[
                            const SizedBox(height: 24),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.faint /* ui-surface-tint */,
                                border: Border.all(
                                  color: AppColors.borderStrong,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nextModuleLabel ?? "",
                                    style: const TextStyle(
                                      color: AppColors
                                          .uiHeadingSmall /* ui-text-secondary */,
                                      fontSize: 12,
                                      fontFamily: AppFonts.body,
                                      fontWeight: FontWeight.w500,
                                      height: 1.33,
                                    ),
                                  ),
                                  Text(
                                    nextModuleTitle!,
                                    style: const TextStyle(
                                      color: AppColors
                                          .uiHeading /* ui-text-heading */,
                                      fontSize: 20,
                                      fontFamily: AppFonts.heading,
                                      fontWeight: FontWeight.w500,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    nextModuleDescription ?? "",
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
                          const SizedBox(height: 32),
                          Text(
                            encouragementNote,
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
                  PrimaryButton(content: continueLabel, onpressed: onContinue),
                  GestureDetector(
                    onTap: onHome,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 18,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        homeLabel,
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
