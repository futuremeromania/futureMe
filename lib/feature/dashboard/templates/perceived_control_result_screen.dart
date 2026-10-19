import 'package:flutter/material.dart';
import 'package:futureme/core/data/perceived_control.dart';
import 'package:futureme/core/data/perceived_control_feedback.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/tts_audio_card.dart';

/// The result of Module 2, Stage 6 — the four perceived-control dimensions,
/// each with its raw 5-25 score, the band it fell into, and the fixed
/// feedback text that band selected.
///
/// Nothing is generated here: [PerceivedControlResult] decides which four
/// of the twelve texts appear, and they are shown in full.
class PerceivedControlResultScreen extends StatelessWidget {
  const PerceivedControlResultScreen({
    super.key,
    required this.result,
    required this.onContinue,
    this.onChat,
    this.continueLabel = "Vezi ce ai conturat în Modulul 2",
    this.chatLabel = "Discută rezultatul în Chat",
  });

  final PerceivedControlResult result;
  final VoidCallback onContinue;
  final VoidCallback? onChat;
  final String continueLabel;
  final String chatLabel;

  /// Reads the whole profile aloud, in the order it appears on screen.
  /// Phrased in words rather than reusing the on-screen "21 / 25", which a
  /// voice reads as a slash and follows into English.
  String get _spokenFeedback {
    final parts = <String>[];
    for (final d in result.dimensions) {
      final feedback = perceivedControlFeedbackFor(d);
      parts.add(
        '${d.dimension.label}: ${d.score} din 25. ${feedback.levelLabel}. ${feedback.headline}. '
        '${feedback.body} ${feedback.helpHeading}: ${feedback.help}',
      );
    }
    parts.add(perceivedControlClosingNote);
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
                      "Etapa 6 · Rezultatul tău",
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
                      "Cât control simți că ai",
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
                      "Cele patru rezultate de mai jos arată în ce măsură simți că poți influența ceea ce ți se întâmplă profesional. Ele nu spun ce se va întâmpla, ci cum privești tu acum legătura dintre ceea ce faci și ceea ce urmează.",
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
                      summaryScope: "module2_stage6",
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
                        perceivedControlClosingNote,
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
  final PerceivedControlDimensionResult result;

  @override
  Widget build(BuildContext context) {
    final feedback = perceivedControlFeedbackFor(result);

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
          Row(
            children: [
              _LevelPill(level: result.level, label: feedback.levelLabel),
              const SizedBox(width: 8),
              Text(
                "${result.score} din 25",
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
          const SizedBox(height: 12),
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
          const SizedBox(height: 4),
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.lightbulb_outline,
                    size: 16,
                    color: AppColors.uiHeading,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  // The heading and the sentence that continues it stay on
                  // one line, exactly as the source text is written.
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "${feedback.helpHeading}: ",
                          style: const TextStyle(
                            color: AppColors.uiHeading,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(text: feedback.help),
                      ],
                    ),
                    style: const TextStyle(
                      color: AppColors.uiHeadingSmall,
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
      ),
    );
  }
}

class _LevelPill extends StatelessWidget {
  const _LevelPill({required this.level, required this.label});

  final PerceivedControlLevel level;
  final String label;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color border, Color fg) = switch (level) {
      PerceivedControlLevel.low => (
        const Color(0xFFF6F0F6),
        AppColors.borderStrong,
        AppColors.uiHeadingSmall,
      ),
      PerceivedControlLevel.moderate => (
        const Color(0xFFFFF7E8),
        const Color(0xFFEBCDA6),
        const Color(0xFF7A4A00),
      ),
      PerceivedControlLevel.high => (
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
        label,
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
