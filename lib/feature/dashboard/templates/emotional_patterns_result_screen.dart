import 'package:flutter/material.dart';
import 'package:futureme/core/data/emotional_patterns.dart';
import 'package:futureme/core/data/emotional_patterns_feedback.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/tts_audio_card.dart';

/// The result of Module 2, Stage 5 — the four emotional dimensions, each
/// with its score, the band it fell into, and the fixed feedback text that
/// band selected.
///
/// Nothing is generated here: [EmotionalPatternsResult] decides which four
/// of the twelve texts appear, they are shown in full, and no combination
/// across dimensions is produced.
class EmotionalPatternsResultScreen extends StatelessWidget {
  const EmotionalPatternsResultScreen({
    super.key,
    required this.result,
    required this.onContinue,
    this.onChat,
    this.continueLabel = "Continuă cu Controlul perceput",
    this.chatLabel = "Discută rezultatul în Chat",
  });

  final EmotionalPatternsResult result;
  final VoidCallback onContinue;
  final VoidCallback? onChat;
  final String continueLabel;
  final String chatLabel;

  /// Reads the whole profile aloud, in the order it appears on screen.
  /// Phrased in words rather than reusing the on-screen labels: "4,13 / 5"
  /// spoken as a slash pulls the voice into English mid-sentence.
  String get _spokenFeedback {
    final parts = <String>[];
    for (final d in result.dimensions) {
      final feedback = emotionalFeedbackFor(d);
      parts.add(
        '${d.dimension.shortLabel}: scor ${d.formattedScore} din 5. ${d.level.label}. '
        '${feedback.body} $emotionalHelpHeading: ${feedback.help}',
      );
    }
    parts.add(emotionalPatternsClosingNote);
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
                      "Etapa 5 · Rezultatul tău",
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
                      "Cum reacționezi sub presiune",
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
                      "Rezultatele de mai jos arată cât de mult te afectează patru tipuri de situații solicitante. Nu măsoară cât de puternic(ă) ești și nu sunt un verdict — descriu ce se întâmplă cu tine în momentele dificile.",
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
                      subtitle:
                          "Un rezumat al rezultatului tău, citit cu voce.",
                      spokenText: _spokenFeedback,
                      summaryScope: "module2_stage5",
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
                        emotionalPatternsClosingNote,
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
  final EmotionalDimensionResult result;

  @override
  Widget build(BuildContext context) {
    final feedback = emotionalFeedbackFor(result);

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
            "$index. ${result.dimension.shortLabel}",
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
            result.dimension.label,
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
                "${result.formattedScore} din 5",
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
          Text(
            feedback.body,
            style: const TextStyle(
              color: AppColors.uiHeadingSmall,
              fontSize: 14,
              fontFamily: AppFonts.body,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
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
                Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      size: 16,
                      color: AppColors.uiHeading,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      emotionalHelpHeading,
                      style: TextStyle(
                        color: AppColors.uiHeading,
                        fontSize: 14,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  feedback.help,
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
          ),
        ],
      ),
    );
  }
}

class _LevelPill extends StatelessWidget {
  const _LevelPill({required this.level});

  final EmotionalLevel level;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color border, Color fg) = switch (level) {
      EmotionalLevel.low => (
        const Color(0xFFE9F3EE),
        const Color(0xFFB8D7C8),
        const Color(0xFF3F7A5F),
      ),
      EmotionalLevel.moderate => (
        const Color(0xFFFFF7E8),
        const Color(0xFFEBCDA6),
        const Color(0xFF7A4A00),
      ),
      EmotionalLevel.high => (
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
