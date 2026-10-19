import 'package:flutter/material.dart';
import 'package:futureme/core/data/work_environments.dart';
import 'package:futureme/core/data/work_environments_feedback.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/tts_audio_card.dart';

/// The result of Module 3, Stage 3 ("Medii de lucru") — exactly seven
/// texts, one per dimension, in the fixed order of the specification,
/// followed once by the common closing text.
///
/// Each text follows the frozen visual rule: the full dimension name
/// ("FORMAL ↔ INFORMAL") in a secondary style above, then the title of the
/// selected text, the text itself and whichever of its closing notes the
/// library gives it. Scores are not shown: the specification's example of
/// what the user sees contains only the texts.
class WorkEnvironmentsResultScreen extends StatelessWidget {
  const WorkEnvironmentsResultScreen({
    super.key,
    required this.result,
    required this.onContinue,
    this.continueLabel = "Vezi imaginea de ansamblu",
  });

  final WorkEnvironmentsResult result;
  final VoidCallback onContinue;
  final String continueLabel;

  String get _spokenFeedback {
    final parts = <String>[];
    for (final dimension in result.dimensions) {
      final feedback = workEnvironmentFeedbackFor(dimension);
      parts.add('${feedback.title}.');
      parts.add(feedback.fullText);
    }
    parts.addAll(workEnvironmentsClosingNote);
    return parts.join(' ');
  }

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
                    const Text(
                      "Etapa 3 · Rezultatul tău",
                      style: TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w500,
                        height: 1.375,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "În ce condiții îți place să lucrezi",
                      style: TextStyle(
                        color: AppColors.uiHeading,
                        fontSize: 28,
                        fontFamily: AppFonts.heading,
                        fontWeight: FontWeight.w600,
                        height: 1.21,
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (final dimension in result.dimensions) ...[
                      _DimensionCard(result: dimension),
                      const SizedBox(height: 16),
                    ],
                    const SizedBox(height: 8),
                    TtsAudioCard(
                      title: "Ascultă rezultatul tău",
                      subtitle:
                          "Un rezumat al rezultatului tău, citit cu voce.",
                      spokenText: _spokenFeedback,
                      summaryScope: "module3_stage3",
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.faint,
                        border: Border.all(color: AppColors.borderStrong),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (
                            int i = 0;
                            i < workEnvironmentsClosingNote.length;
                            i++
                          ) ...[
                            if (i > 0) const SizedBox(height: 8),
                            Text(
                              workEnvironmentsClosingNote[i],
                              style: const TextStyle(
                                color: AppColors.uiHeadingSmall,
                                fontSize: 14,
                                fontFamily: AppFonts.body,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                            ),
                          ],
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

class _DimensionCard extends StatelessWidget {
  const _DimensionCard({required this.result});

  final WorkEnvironmentDimensionResult result;

  @override
  Widget build(BuildContext context) {
    final feedback = workEnvironmentFeedbackFor(result);

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
            result.dimension.label,
            style: const TextStyle(
              color: AppColors.uiHeadingSmall,
              fontSize: 12,
              fontFamily: AppFonts.body,
              fontWeight: FontWeight.w500,
              height: 1.5,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            feedback.title,
            style: const TextStyle(
              color: AppColors.uiHeading,
              fontSize: 20,
              fontFamily: AppFonts.heading,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
          for (final paragraph in feedback.body) ...[
            const SizedBox(height: 8),
            Text(
              paragraph,
              style: const TextStyle(
                color: AppColors.uiHeadingSmall,
                fontSize: 14,
                fontFamily: AppFonts.body,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ],
          for (final note in feedback.notes) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.faint,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "${note.label}: ",
                      style: const TextStyle(
                        color: AppColors.uiHeading,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(text: note.text),
                  ],
                ),
                style: const TextStyle(
                  color: AppColors.uiHeadingSmall,
                  fontSize: 13,
                  fontFamily: AppFonts.body,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
