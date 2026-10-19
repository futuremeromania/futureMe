import 'package:flutter/material.dart';
import 'package:futureme/shared/widgets/module_header_banner.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

/// "Module 5 - Complete" (Figma frame 537:2275) — the final screen of the
/// whole FutureMe journey. Simpler than [ModuleCompleteScreen]: a header
/// banner, title, description and a single Continue button (no audio
/// message, no Home action).
class Module5CompleteScreen extends StatelessWidget {
  const Module5CompleteScreen({
    super.key,
    required this.title,
    required this.description,
    required this.continueLabel,
    required this.onContinue,
  });

  final String title;
  final String description;
  final String continueLabel;
  final VoidCallback onContinue;

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
                    const ModuleHeaderBanner(
                      imageAlignment: Alignment.center,
                      height: 260,
                      showBackButton: false,
                    ),
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
                            description,
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
              child: PrimaryButton(
                content: continueLabel,
                onpressed: onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
