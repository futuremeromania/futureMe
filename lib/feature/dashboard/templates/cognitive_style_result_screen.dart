import 'package:flutter/material.dart';
import 'package:futureme/core/data/cognitive_style.dart';
import 'package:futureme/core/data/cognitive_style_feedback.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/tts_audio_card.dart';

/// The result of Module 2, Stage 3 — the five cognitive dimensions, each
/// with both pole scores, their levels, and the fixed feedback text that
/// the pair of levels selected.
///
/// Both poles of a dimension are always shown: neither is dropped, and a
/// high score on one does not lower the other. Nothing is generated here —
/// [CognitiveStyleResult] decides which of the forty-five texts appear,
/// and they're shown in full.
class CognitiveStyleResultScreen extends StatelessWidget {
  const CognitiveStyleResultScreen({
    super.key,
    required this.result,
    required this.onContinue,
    this.onChat,
    this.continueLabel = "Continuă cu Stilul decizional",
    this.chatLabel = "Discută rezultatul în Chat",
  });

  final CognitiveStyleResult result;
  final VoidCallback onContinue;
  final VoidCallback? onChat;
  final String continueLabel;
  final String chatLabel;

  /// Reads the whole profile aloud, in the order it appears on screen.
  ///
  /// Deliberately not the on-screen labels: those carry "+" between the two
  /// poles and "7 / 15" for the scores, and the voice reads such symbols as
  /// English, which drags the surrounding Romanian words into an English
  /// pronunciation with them. Spoken, the same information is plain prose.
  String get _spokenFeedback {
    final parts = <String>[];
    for (final d in result.dimensions) {
      final feedback = cognitiveFeedbackFor(d);
      parts.add(
        '${d.dimension.first.label}: ${d.firstScore} din 15, nivel ${d.firstLevel.label.toLowerCase()}. '
        '${d.dimension.second.label}: ${d.secondScore} din 15, nivel ${d.secondLevel.label.toLowerCase()}. '
        '${feedback.title} ${feedback.body}',
      );
    }
    parts.add(cognitiveStyleClosingNote);
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
                      "Cum gândești și procesezi informația",
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
                      "Cele cinci dimensiuni de mai jos arată preferințele tale cognitive. Cei doi poli ai unei dimensiuni nu sunt opuși: poți avea scor ridicat la amândoi. Nu este o măsură a inteligenței, ci a felului în care îți vine natural să gândești.",
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
                      summaryScope: "module2_stage3",
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
                        cognitiveStyleClosingNote,
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
  final CognitiveDimensionResult result;

  @override
  Widget build(BuildContext context) {
    final feedback = cognitiveFeedbackFor(result);

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
          _PoleRow(
            pole: result.dimension.first,
            score: result.firstScore,
            level: result.firstLevel,
          ),
          const SizedBox(height: 8),
          _PoleRow(
            pole: result.dimension.second,
            score: result.secondScore,
            level: result.secondLevel,
          ),
          const SizedBox(height: 16),
          Text(
            feedback.title,
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
        ],
      ),
    );
  }
}

class _PoleRow extends StatelessWidget {
  const _PoleRow({
    required this.pole,
    required this.score,
    required this.level,
  });

  final CognitivePole pole;
  final int score;
  final CognitiveLevel level;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            pole.label,
            style: const TextStyle(
              color: AppColors.dashboard,
              fontSize: 14,
              fontFamily: AppFonts.body,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ),
        Text(
          "$score / 15",
          style: const TextStyle(
            color: AppColors.uiHeadingSmall,
            fontSize: 12,
            fontFamily: AppFonts.body,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
        const SizedBox(width: 8),
        _LevelPill(level: level),
      ],
    );
  }
}

class _LevelPill extends StatelessWidget {
  const _LevelPill({required this.level});

  final CognitiveLevel level;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color border, Color fg) = switch (level) {
      CognitiveLevel.low => (
        const Color(0xFFF6F0F6),
        AppColors.borderStrong,
        AppColors.uiHeadingSmall,
      ),
      CognitiveLevel.moderate => (
        const Color(0xFFFFF7E8),
        const Color(0xFFEBCDA6),
        const Color(0xFF7A4A00),
      ),
      CognitiveLevel.high => (
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
