import 'package:flutter/material.dart';
import 'package:futureme/core/data/big_five.dart';
import 'package:futureme/core/data/big_five_feedback.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/tts_audio_card.dart';

/// The result of Module 2, Stage 2 — the five Big Five dimensions, each with
/// the fixed feedback text its score selected.
///
/// The texts run to six sections per dimension, far more than the shared
/// summary screen was built for, so this screen lays them out as its own
/// card per dimension. Nothing is generated here: [BigFiveResult] decides
/// which of the fifteen texts appear, and they're shown in full.
class BigFiveResultScreen extends StatelessWidget {
  const BigFiveResultScreen({
    super.key,
    required this.result,
    required this.onContinue,
    this.onChat,
    this.continueLabel = "Continuă cu Stilul cognitiv",
    this.chatLabel = "Discută rezultatul în Chat",
  });

  final BigFiveResult result;
  final VoidCallback onContinue;
  final VoidCallback? onChat;
  final String continueLabel;
  final String chatLabel;

  /// Reads the whole profile aloud, in the order it appears on screen.
  String get _spokenFeedback {
    final parts = <String>[];
    for (final d in result.dimensions) {
      final feedback = bigFiveFeedback[d.dimension]![d.level]!;
      // The dimension names are display labels: "Deschidere / Intelect"
      // spoken as a slash turns the line English mid-sentence.
      final spokenLabel = d.dimension.label.replaceAll(' / ', ' sau ');
      parts.add(
        '$spokenLabel. Nivelul tău: ${d.level.label}. ${feedback.whatItSays}',
      );
    }
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
                      "Profilul tău de personalitate",
                      style: TextStyle(
                        color: AppColors.uiHeading,
                        fontSize: 28,
                        fontFamily: AppFonts.heading,
                        fontWeight: FontWeight.w600,
                        height: 1.21,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Acest profil îți oferă o imagine asupra modului în care gândești, reacționezi, lucrezi și relaționezi cu lumea. Nu este o etichetă. Este o hartă care te ajută să iei decizii mai bune pentru viitorul tău profesional.",
                      style: TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        letterSpacing: -0.16,
                      ),
                    ),
                    const SizedBox(height: 24),
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
                      subtitle: "Un rezumat audio al celor cinci dimensiuni.",
                      spokenText: _spokenFeedback,
                      summaryScope: "module2_stage2",
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
                        bigFiveClosingNote,
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
  final BigFiveDimensionResult result;

  @override
  Widget build(BuildContext context) {
    final feedback = bigFiveFeedback[result.dimension]![result.level]!;

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
          const SizedBox(height: 2),
          Text(
            bigFiveDimensionSubtitles[result.dimension]!,
            style: const TextStyle(
              color: AppColors.uiHeadingSmall,
              fontSize: 12,
              fontFamily: AppFonts.body,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _LevelPill(level: result.level),
              const SizedBox(width: 8),
              Text(
                "${result.rawScore} / 50",
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
          const SizedBox(height: 16),
          _Section(
            heading: bigFiveWhatItSaysHeading,
            body: feedback.whatItSays,
          ),
          _Section(heading: bigFiveStrengthsHeading, body: feedback.strengths),
          _Section(heading: bigFiveWatchOutHeading, body: feedback.watchOut),
          _Section(
            heading: bigFiveHowYouWorkHeading,
            body: feedback.howYouWork,
          ),
          _Section(
            heading: bigFiveEnvironmentHeading,
            body: feedback.environment,
          ),
          _Section(
            heading: bigFiveCareerMeaningHeading,
            body: feedback.careerMeaning,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.heading,
    required this.body,
    this.isLast = false,
  });

  final String heading;
  final String body;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: const TextStyle(
              color: AppColors.uiHeading,
              fontSize: 14,
              fontFamily: AppFonts.body,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            body,
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

class _LevelPill extends StatelessWidget {
  const _LevelPill({required this.level});

  final BigFiveLevel level;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color border, Color fg) = switch (level) {
      BigFiveLevel.low => (
        const Color(0xFFF6F0F6),
        AppColors.borderStrong,
        AppColors.uiHeadingSmall,
      ),
      BigFiveLevel.moderate => (
        const Color(0xFFFFF7E8),
        const Color(0xFFEBCDA6),
        const Color(0xFF7A4A00),
      ),
      BigFiveLevel.high => (
        const Color(0xFFF2ECFF),
        const Color(0xFFCDBAF4),
        const Color(0xFF3A2384),
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(99999),
      ),
      child: Text(
        level.label,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontFamily: AppFonts.body,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
      ),
    );
  }
}
