import 'package:flutter/material.dart';
import 'package:futureme/core/data/vocational_interests.dart';
import 'package:futureme/core/data/vocational_interests_feedback.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/tts_audio_card.dart';

/// The result of Module 3, Stage 1 — the six interest areas with their
/// scores, the three that came out highest, the RIASEC code, and the fixed
/// text for each of those three.
///
/// All six scores stay visible: the lower three earn no feedback, but
/// hiding them would make the profile look like a verdict rather than a
/// comparison of the person's own six numbers. Nothing here is generated —
/// the ordering decides which three of the six texts appear.
class VocationalInterestsResultScreen extends StatelessWidget {
  const VocationalInterestsResultScreen({
    super.key,
    required this.result,
    required this.onContinue,
    this.onChat,
    this.continueLabel = "Continuă cu Etapa 2",
    this.chatLabel = "Discută rezultatul în Chat",
  });

  final VocationalInterestsResult result;
  final VoidCallback onContinue;
  final VoidCallback? onChat;
  final String continueLabel;
  final String chatLabel;

  String get _topThreeSentence =>
      result.topThree.map((d) => d.label).join(" – ");

  String get _spokenFeedback {
    final parts = <String>[
      'Interesele care ies cel mai mult în evidență: $_topThreeSentence.',
    ];
    for (final dimension in result.topThree) {
      final feedback = vocationalFeedbackFor(dimension);
      parts.add(
        '${dimension.label}. ${feedback.headline} ${feedback.body} ${feedback.examples}',
      );
    }
    parts.add(vocationalInterestsClosingNote);
    return parts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final ranked = result.ranked;
    final topThree = result.topThree;

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
                      "Etapa 1 · Rezultatul tău",
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
                      "Profilul tău de interese",
                      style: TextStyle(
                        color: AppColors.uiHeading,
                        fontSize: 28,
                        fontFamily: AppFonts.heading,
                        fontWeight: FontWeight.w600,
                        height: 1.21,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                          const Text(
                            "Interesele care ies cel mai mult în evidență:",
                            style: TextStyle(
                              color: AppColors.uiHeadingSmall,
                              fontSize: 14,
                              fontFamily: AppFonts.body,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _topThreeSentence,
                            style: const TextStyle(
                              color: AppColors.uiHeading,
                              fontSize: 20,
                              fontFamily: AppFonts.heading,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Codul tău de interese: ${result.code}",
                            style: const TextStyle(
                              color: AppColors.grad1,
                              fontSize: 16,
                              fontFamily: AppFonts.body,
                              fontWeight: FontWeight.w500,
                              height: 1.375,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Toate cele șase zone",
                      style: TextStyle(
                        color: AppColors.uiHeading,
                        fontSize: 20,
                        fontFamily: AppFonts.heading,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (final entry in ranked)
                      _ScoreRow(
                        result: entry,
                        highlighted: topThree.contains(entry.dimension),
                      ),
                    const SizedBox(height: 24),
                    for (int i = 0; i < topThree.length; i++) ...[
                      _FeedbackCard(index: i + 1, dimension: topThree[i]),
                      const SizedBox(height: 16),
                    ],
                    const SizedBox(height: 8),
                    TtsAudioCard(
                      title: "Ascultă rezultatul tău",
                      subtitle:
                          "Un rezumat al rezultatului tău, citit cu voce.",
                      spokenText: _spokenFeedback,
                      summaryScope: "module3_stage1",
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
                        vocationalInterestsClosingNote,
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

/// One of the six rows: name, score out of 25, and a bar the length of the
/// score, so the comparison between the person's own six is visible at a
/// glance — which is the only comparison this instrument supports.
class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.result, required this.highlighted});

  final VocationalDimensionResult result;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (highlighted) ...[
                const Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: AppColors.grad1,
                ),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  "${result.dimension.code} – ${result.dimension.label}",
                  style: TextStyle(
                    color: highlighted
                        ? AppColors.uiHeading
                        : AppColors.uiHeadingSmall,
                    fontSize: 14,
                    fontFamily: AppFonts.body,
                    fontWeight: highlighted ? FontWeight.w600 : FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ),
              Text(
                "${result.score}/25",
                style: TextStyle(
                  color: highlighted
                      ? AppColors.uiHeading
                      : AppColors.uiHeadingSmall,
                  fontSize: 14,
                  fontFamily: AppFonts.body,
                  fontWeight: highlighted ? FontWeight.w600 : FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: LinearProgressIndicator(
              value: result.score / 25,
              minHeight: 6,
              backgroundColor: AppColors.faint,
              valueColor: AlwaysStoppedAnimation(
                highlighted ? AppColors.grad1 : AppColors.border,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.index, required this.dimension});

  final int index;
  final VocationalDimension dimension;

  @override
  Widget build(BuildContext context) {
    final feedback = vocationalFeedbackFor(dimension);

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
            "$index. ${dimension.label}",
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
            feedback.headline,
            style: const TextStyle(
              color: AppColors.uiHeading,
              fontSize: 14,
              fontFamily: AppFonts.body,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
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
              feedback.examples,
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
