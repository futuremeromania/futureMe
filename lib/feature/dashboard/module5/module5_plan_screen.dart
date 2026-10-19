import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

/// One card in the "Planul tău în 3 etape" list (Figma frame 419:1939,
/// Module 5 - Plan). Only the first step shows an expanded checklist in
/// the design; the others are collapsed rows with just a period pill.
class PlanStep {
  const PlanStep({
    required this.title,
    required this.periodLabel,
    required this.description,
    this.checklist,
  });

  final String title;
  final String periodLabel;
  final String description;
  final List<String>? checklist;
}

/// "Module 5 - Plan" (Figma frame 419:1939) — a starting-direction card
/// followed by a 3-step plan list.
class Module5PlanScreen extends StatelessWidget {
  const Module5PlanScreen({
    super.key,
    required this.moduleLabel,
    required this.title,
    required this.description,
    required this.directionLabel,
    required this.directionTitle,
    required this.directionDescription,
    required this.firstStepTitle,
    required this.firstStepDescription,
    required this.planSectionLabel,
    required this.steps,
    required this.infoNote,
    required this.continueLabel,
    required this.onContinue,
  });

  final String moduleLabel;
  final String title;
  final String description;
  final String directionLabel;
  final String directionTitle;
  final String directionDescription;
  final String firstStepTitle;
  final String firstStepDescription;
  final String planSectionLabel;
  final List<PlanStep> steps;
  final String infoNote;
  final String continueLabel;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      moduleLabel,
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w500,
                        height: 1.375,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
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
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        letterSpacing: -0.16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.faint,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            directionLabel,
                            style: const TextStyle(
                              color: AppColors.uiHeadingSmall,
                              fontSize: 16,
                              fontFamily: AppFonts.body,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                              letterSpacing: -0.16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _AvatarRow(
                            title: directionTitle,
                            description: directionDescription,
                            headingSize: 20,
                          ),
                          const SizedBox(height: 16),
                          Divider(
                            color: AppColors.border,
                            height: 1,
                            thickness: 1,
                          ),
                          const SizedBox(height: 16),
                          _AvatarRow(
                            title: firstStepTitle,
                            description: firstStepDescription,
                            headingSize: 18,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      planSectionLabel,
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 18,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.56,
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (int i = 0; i < steps.length; i++) ...[
                      _PlanStepCard(step: steps[i]),
                      if (i < steps.length - 1) const SizedBox(height: 8),
                    ],
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

class _AvatarRow extends StatelessWidget {
  const _AvatarRow({
    required this.title,
    required this.description,
    required this.headingSize,
  });

  final String title;
  final String description;
  final double headingSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.borderStrong),
            image: const DecorationImage(
              image: AssetImage(AppAssets.moduleIcon),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.uiHeading,
                  fontSize: headingSize,
                  fontFamily: AppFonts.heading,
                  fontWeight: FontWeight.w500,
                  height: 1.33,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  color: AppColors.uiHeadingSmall,
                  fontSize: 12,
                  fontFamily: AppFonts.body,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanStepCard extends StatelessWidget {
  const _PlanStepCard({required this.step});

  final PlanStep step;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borderStrong),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderStrong),
                  image: const DecorationImage(
                    image: AssetImage(AppAssets.moduleIcon),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          step.title,
                          style: const TextStyle(
                            color: AppColors.uiHeading,
                            fontSize: 16,
                            fontFamily: AppFonts.body,
                            fontWeight: FontWeight.w500,
                            height: 1.375,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.insightPrimaryBg,
                            border: Border.all(
                              color: AppColors.insightPrimaryBorder,
                            ),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            step.periodLabel,
                            style: const TextStyle(
                              color: AppColors.insightPrimaryFg,
                              fontSize: 12,
                              fontFamily: AppFonts.body,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      step.description,
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 12,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.uiHeadingSmall,
              ),
            ],
          ),
          if (step.checklist != null) ...[
            const SizedBox(height: 8),
            for (final item in step.checklist!)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.check, size: 16, color: AppColors.grad1),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          color: AppColors.dashboard,
                          fontSize: 14,
                          fontFamily: AppFonts.body,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}
