import 'package:flutter/material.dart';
import 'package:futureme/core/data/decision_style.dart';
import 'package:futureme/core/data/decision_style_feedback.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/tts_audio_card.dart';

/// The result of Module 2, Stage 4 — the five decision styles, showing only
/// the ones scoring 3/4 or 4/4, plus a combination/"profil multiplu"/"nicio
/// strategie predominantă" block as dictated by [resolveDecisionStyleDisplay].
///
/// Nothing is generated here: the score decides which fixed texts appear,
/// and they're shown in full, unchanged.
class DecisionStyleResultScreen extends StatelessWidget {
  const DecisionStyleResultScreen({
    super.key,
    required this.result,
    required this.onContinue,
    this.onChat,
    this.continueLabel = "Continuă cu Tiparele emoționale",
    this.chatLabel = "Discută rezultatul în Chat",
  });

  final DecisionStyleResult result;
  final VoidCallback onContinue;
  final VoidCallback? onChat;
  final String continueLabel;
  final String chatLabel;

  String get _spokenFeedback {
    final display = resolveDecisionStyleDisplay(result);
    final parts = <String>[];
    for (final d in display.relevant) {
      parts.add(
        '${d.style.label}. ${decisionStyleScoreLabels[d.score]}. ${decisionStyleFeedbackBodies[d.style]![d.score]!}',
      );
    }
    switch (display.type) {
      case DecisionStyleResultType.none:
        parts.add(decisionStyleNoDominantBody);
        break;
      case DecisionStyleResultType.pair:
        if (display.combo != null) parts.add(display.combo!.body);
        break;
      case DecisionStyleResultType.multiple:
        parts.add(decisionStyleMultipleProfileBody);
        break;
      case DecisionStyleResultType.single:
        break;
    }
    parts.add(decisionStyleFinalMessageBody);
    return parts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final display = resolveDecisionStyleDisplay(result);

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
                      "Etapa 4 · Rezultatul tău",
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
                      "Stilul tău decizional",
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
                      "Acest rezultat arată ce te ajută sau te încurcă atunci când trebuie să alegi. Nu este o etichetă. Este o hartă a felului tău de a decide.",
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
                    for (int i = 0; i < display.relevant.length; i++) ...[
                      _StyleCard(index: i + 1, result: display.relevant[i]),
                      const SizedBox(height: 16),
                    ],
                    if (display.type == DecisionStyleResultType.none) ...[
                      _NoteCard(
                        title: decisionStyleNoDominantTitle,
                        body: decisionStyleNoDominantBody,
                        question: decisionStyleNoDominantQuestion,
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (display.type == DecisionStyleResultType.pair &&
                        display.combo != null) ...[
                      _NoteCard(
                        title:
                            "${display.combo!.styleA.label} + ${display.combo!.styleB.label}",
                        body: display.combo!.body,
                        question: display.combo!.question,
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (display.type == DecisionStyleResultType.multiple) ...[
                      _NoteCard(
                        title: decisionStyleMultipleProfileTitle,
                        body: decisionStyleMultipleProfileBody,
                        question: decisionStyleMultipleProfileQuestion,
                      ),
                      const SizedBox(height: 16),
                    ],
                    const SizedBox(height: 8),
                    TtsAudioCard(
                      title: "Ascultă rezultatul tău",
                      subtitle:
                          "Un rezumat al rezultatului tău, citit cu voce.",
                      spokenText: _spokenFeedback,
                      summaryScope: "module2_stage4",
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
                        decisionStyleFinalMessageBody,
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

class _StyleCard extends StatelessWidget {
  const _StyleCard({required this.index, required this.result});

  final int index;
  final DecisionStyleDimensionResult result;

  @override
  Widget build(BuildContext context) {
    final heading = decisionStyleScoreLabels[result.score]!;
    final body = decisionStyleFeedbackBodies[result.style]![result.score]!;

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
          Row(
            children: [
              Expanded(
                child: Text(
                  "$index. ${result.style.label}",
                  style: const TextStyle(
                    color: AppColors.uiHeading,
                    fontSize: 20,
                    fontFamily: AppFonts.heading,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ),
              Text(
                "${result.score} / 4",
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

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.title, required this.body, this.question});

  final String title;
  final String body;
  final String? question;

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
            title,
            style: const TextStyle(
              color: AppColors.uiHeading,
              fontSize: 20,
              fontFamily: AppFonts.heading,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
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
          if (question != null) ...[
            const SizedBox(height: 12),
            const Text(
              "Întrebarea care te poate ajuta:",
              style: TextStyle(
                color: AppColors.uiHeading,
                fontSize: 14,
                fontFamily: AppFonts.body,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '„$question”',
              style: const TextStyle(
                color: AppColors.uiHeadingSmall,
                fontSize: 14,
                fontFamily: AppFonts.body,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
