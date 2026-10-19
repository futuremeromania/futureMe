import 'package:flutter/material.dart';
import 'package:futureme/core/data/work_preferences.dart';
import 'package:futureme/core/data/work_preferences_feedback.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/tts_audio_card.dart';

/// The result of Module 3, Stage 2 — four blocks in the fixed order the
/// specification sets, each showing both pole scores and exactly one of
/// the four texts for that dimension.
///
/// Both scores stay on screen even when neither is a preference: the two
/// poles are independent, so showing only the "winner" would suggest a
/// comparison the instrument does not make.
class WorkPreferencesResultScreen extends StatelessWidget {
  const WorkPreferencesResultScreen({
    super.key,
    required this.result,
    required this.onContinue,
    this.onChat,
    this.continueLabel = "Continuă cu Etapa 3",
    this.chatLabel = "Discută rezultatul în Chat",
  });

  final WorkPreferencesResult result;
  final VoidCallback onContinue;
  final VoidCallback? onChat;
  final String continueLabel;
  final String chatLabel;

  String get _spokenFeedback {
    final parts = <String>[];
    for (final dimension in result.dimensions) {
      final feedback = workPreferenceFeedbackFor(dimension);
      parts.add('${dimension.dimension.label}. ${feedback.headline}');
      parts.addAll(feedback.body);
      parts.add(feedback.advice);
    }
    parts.add(workPreferencesClosingNote);
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
                      "Etapa 2 · Rezultatul tău",
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
                      "Preferințele tale de lucru",
                      style: TextStyle(
                        color: AppColors.uiHeading,
                        fontSize: 28,
                        fontFamily: AppFonts.heading,
                        fontWeight: FontWeight.w600,
                        height: 1.21,
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (int i = 0; i < result.dimensions.length; i++) ...[
                      _DimensionCard(
                        index: i + 1,
                        result: result.dimensions[i],
                      ),
                      const SizedBox(height: 16),
                    ],
                    const SizedBox(height: 8),
                    TtsAudioCard(
                      title: "Ascultă rezultatul tău",
                      subtitle:
                          "Un rezumat al rezultatului tău, citit cu voce.",
                      spokenText: _spokenFeedback,
                      summaryScope: "module3_stage2",
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
                        workPreferencesClosingNote,
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
              child: Column(
                children: [
                  PrimaryButton(content: continueLabel, onpressed: onContinue),
                  if (onChat != null) const SizedBox(height: 8),
                  if (onChat != null)
                    GestureDetector(
                      onTap: onChat,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.chat_bubble_outline,
                              size: 24,
                              color: AppColors.grad1,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                chatLabel,
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
                          ],
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

class _DimensionCard extends StatelessWidget {
  const _DimensionCard({required this.index, required this.result});

  final int index;
  final WorkPreferenceDimensionResult result;

  @override
  Widget build(BuildContext context) {
    final feedback = workPreferenceFeedbackFor(result);

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
            "$index. ${result.dimension.label}",
            style: const TextStyle(
              color: AppColors.uiHeading,
              fontSize: 20,
              fontFamily: AppFonts.heading,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          _PoleRow(result: result.first),
          const SizedBox(height: 8),
          _PoleRow(result: result.second),
          const SizedBox(height: 16),
          Text(
            feedback.headline,
            style: const TextStyle(
              color: AppColors.uiHeading,
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
            child: Text(
              feedback.advice,
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
      ),
    );
  }
}

/// One pole: its name, its raw score out of 10, its band, and a bar. The
/// bar starts at the instrument's floor of 2, so a minimum score reads as
/// empty rather than as a fifth of the way along.
class _PoleRow extends StatelessWidget {
  const _PoleRow({required this.result});

  final WorkPreferencePoleResult result;

  @override
  Widget build(BuildContext context) {
    final preference = result.isPreference;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (preference) ...[
              const Icon(Icons.star_rounded, size: 16, color: AppColors.grad1),
              const SizedBox(width: 4),
            ],
            Expanded(
              child: Text(
                result.pole.label,
                style: TextStyle(
                  color: preference
                      ? AppColors.uiHeading
                      : AppColors.uiHeadingSmall,
                  fontSize: 14,
                  fontFamily: AppFonts.body,
                  fontWeight: preference ? FontWeight.w600 : FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ),
            Text(
              "${result.score}/10 · ${result.level.label}",
              style: TextStyle(
                color: preference
                    ? AppColors.uiHeading
                    : AppColors.uiHeadingSmall,
                fontSize: 13,
                fontFamily: AppFonts.body,
                fontWeight: preference ? FontWeight.w600 : FontWeight.w400,
                height: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(9999),
          child: LinearProgressIndicator(
            value: (result.score - 2) / 8,
            minHeight: 6,
            backgroundColor: AppColors.faint,
            valueColor: AlwaysStoppedAnimation(
              preference ? AppColors.grad1 : AppColors.border,
            ),
          ),
        ),
      ],
    );
  }
}
