import 'package:flutter/material.dart';
import 'package:futureme/core/data/character_strengths.dart';
import 'package:futureme/core/data/character_strengths_feedback.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/tts_audio_card.dart';

/// The five strengths that stood out, each with its full fixed feedback.
///
/// No scores, no numbers, no places. The cards follow the ranking, but
/// nothing on screen says so: the five are a comparison inside one
/// person's own profile, and a visible "1 to 5" would read as a league
/// table — both against the other five strengths and against other people,
/// neither of which this instrument measures.
class StrengthsTopFiveScreen extends StatelessWidget {
  const StrengthsTopFiveScreen({
    super.key,
    required this.topFive,
    required this.onContinue,
    this.continueLabel = strengthsTopButton,
  });

  final List<StrengthDimension> topFive;
  final VoidCallback onContinue;
  final String continueLabel;

  String get _spokenFeedback {
    final parts = <String>[strengthsTopHeading, strengthsTopText];
    for (final dimension in topFive) {
      final feedback = strengthFeedbackFor(dimension);
      parts.add('${dimension.label}. ${feedback.headline}');
      parts.addAll(feedback.body);
      parts.add('${feedback.howToUseHeading}: ${feedback.howToUse}');
    }
    parts.add(strengthsTopClosing);
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
                      strengthsScreenTitle,
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
                      strengthsTopHeading,
                      style: TextStyle(
                        color: AppColors.uiHeading,
                        fontSize: 28,
                        fontFamily: AppFonts.heading,
                        fontWeight: FontWeight.w600,
                        height: 1.21,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      strengthsTopText,
                      style: TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 14,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    for (final dimension in topFive) ...[
                      StrengthFeedbackCard(dimension: dimension),
                      const SizedBox(height: 16),
                    ],
                    const SizedBox(height: 8),
                    TtsAudioCard(
                      title: "Ascultă rezultatul tău",
                      subtitle:
                          "Un rezumat al rezultatului tău, citit cu voce.",
                      spokenText: _spokenFeedback,
                      summaryScope: "module4_stage1",
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
                      child: const Text(
                        strengthsTopClosing,
                        style: TextStyle(
                          color: AppColors.uiHeadingSmall,
                          fontSize: 14,
                          fontFamily: AppFonts.body,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
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

/// One strength's full fixed feedback: name, subtitle, both paragraphs and
/// the "how to use it" note.
class StrengthFeedbackCard extends StatelessWidget {
  const StrengthFeedbackCard({super.key, required this.dimension});

  final StrengthDimension dimension;

  @override
  Widget build(BuildContext context) {
    final feedback = strengthFeedbackFor(dimension);

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
            dimension.label,
            style: const TextStyle(
              color: AppColors.uiHeading,
              fontSize: 20,
              fontFamily: AppFonts.heading,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            feedback.headline,
            style: const TextStyle(
              color: AppColors.grad1,
              fontSize: 14,
              fontFamily: AppFonts.body,
              fontWeight: FontWeight.w500,
              height: 1.5,
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
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.faint,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feedback.howToUseHeading,
                  style: const TextStyle(
                    color: AppColors.uiHeading,
                    fontSize: 13,
                    fontFamily: AppFonts.body,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  feedback.howToUse,
                  style: const TextStyle(
                    color: AppColors.uiHeadingSmall,
                    fontSize: 13,
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
    );
  }
}
