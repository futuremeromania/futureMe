import 'package:flutter/material.dart';
import 'package:futureme/core/data/aptitude_test.dart';
import 'package:futureme/core/data/aptitude_test_feedback.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

/// The four block scores, each as "X din 6" plus a sentence saying what
/// those six exercises asked for.
///
/// No total, no labels, no comparison. The total across the four blocks is
/// computed and stored for the pilot, but showing it would invite a
/// general-ability reading that four sets of six items cannot support.
class AptitudeResultScreen extends StatelessWidget {
  const AptitudeResultScreen({
    super.key,
    required this.result,
    required this.onReview,
    required this.onContinue,
    this.continueLabel = "Vezi imaginea de ansamblu",
  });

  final AptitudeResult result;
  final VoidCallback onReview;
  final VoidCallback onContinue;
  final String continueLabel;

  @override
  Widget build(BuildContext context) {
    final timeExpired = result.finish == AptitudeFinish.timeExpired;

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
                    const Text(
                      aptitudeStageTitle,
                      style: TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w500,
                        height: 1.375,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeExpired
                          ? aptitudeTimeUpHeading
                          : aptitudeResultHeading,
                      style: const TextStyle(
                        color: AppColors.uiHeading,
                        fontSize: 28,
                        fontFamily: AppFonts.heading,
                        fontWeight: FontWeight.w600,
                        height: 1.21,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      timeExpired ? aptitudeTimeUpText : aptitudeResultText,
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 14,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    for (final category in AptitudeCategory.values) ...[
                      _CategoryCard(
                        category: category,
                        score: result.scoreOf(category),
                      ),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.faint,
                        border: Border.all(color: AppColors.borderStrong),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            aptitudeResultClosingOne,
                            style: TextStyle(
                              color: AppColors.uiHeadingSmall,
                              fontSize: 14,
                              fontFamily: AppFonts.body,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            aptitudeResultClosingTwo,
                            style: TextStyle(
                              color: AppColors.uiHeadingSmall,
                              fontSize: 14,
                              fontFamily: AppFonts.body,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  PrimaryButton(
                    content: aptitudeReviewButton,
                    onpressed: onReview,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: onContinue,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grad1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        continueLabel,
                        textAlign: TextAlign.center,
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

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, required this.score});

  final AptitudeCategory category;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
            category.label,
            style: const TextStyle(
              color: AppColors.uiHeading,
              fontSize: 18,
              fontFamily: AppFonts.heading,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            aptitudeScoreLine(score),
            style: const TextStyle(
              color: AppColors.grad1,
              fontSize: 14,
              fontFamily: AppFonts.body,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: LinearProgressIndicator(
              value: score / aptitudeItemsPerCategory,
              minHeight: 6,
              backgroundColor: AppColors.faint,
              valueColor: const AlwaysStoppedAnimation(AppColors.grad1),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            aptitudeCategorySentence(category, score),
            style: const TextStyle(
              color: AppColors.uiHeadingSmall,
              fontSize: 14,
              fontFamily: AppFonts.body,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
