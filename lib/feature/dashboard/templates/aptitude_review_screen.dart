import 'package:flutter/material.dart';
import 'package:futureme/core/data/aptitude_test.dart';
import 'package:futureme/core/data/aptitude_test_feedback.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/spatial_figure_view.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

/// All 24 exercises with what the person answered, what the answer was and
/// how it is solved.
///
/// Only reachable once the session is over — including when it ended by
/// itself at 30:00 — because during the test no item may reveal whether it
/// was right. The explanations are fixed FutureMe copy; nothing here is
/// generated or reworded.
class AptitudeReviewScreen extends StatelessWidget {
  const AptitudeReviewScreen({
    super.key,
    required this.result,
    required this.onContinue,
    this.continueLabel = "Continuă",
  });

  final AptitudeResult result;
  final VoidCallback onContinue;
  final String continueLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(context),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                itemCount: result.items.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          aptitudeStageTitle,
                          style: TextStyle(
                            color: AppColors.uiHeadingSmall,
                            fontSize: 16,
                            fontFamily: AppFonts.body,
                            fontWeight: FontWeight.w500,
                            height: 1.375,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          aptitudeReviewHeading,
                          style: TextStyle(
                            color: AppColors.uiHeading,
                            fontSize: 28,
                            fontFamily: AppFonts.heading,
                            fontWeight: FontWeight.w600,
                            height: 1.21,
                          ),
                        ),
                      ],
                    );
                  }
                  return _ReviewCard(index: i, result: result.items[i - 1]);
                },
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

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.index, required this.result});

  final int index;
  final AptitudeItemResult result;

  @override
  Widget build(BuildContext context) {
    final item = result.item;
    final status = result.status;
    final correctLabel =
        "${aptitudeOptionLetters[item.correctIndex]}. ${item.options[item.correctIndex]}";
    final yourLabel = result.answer == null
        ? aptitudeReviewNoAnswer
        : "${aptitudeOptionLetters[result.answer!]}. ${item.options[result.answer!]}";

    final (statusColor, statusIcon, statusText) = switch (status) {
      AptitudeItemStatus.correct => (
        AppColors.successFg,
        Icons.check_circle_outline,
        "Corect",
      ),
      AptitudeItemStatus.incorrect => (
        AppColors.errorFg,
        Icons.cancel_outlined,
        "Greșit",
      ),
      AptitudeItemStatus.unanswered => (
        AppColors.uiHeadingSmall,
        Icons.remove_circle_outline,
        aptitudeReviewNoAnswer,
      ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "$index. ${item.category.label} · ${item.title}",
                  style: const TextStyle(
                    color: AppColors.grad1,
                    fontSize: 13,
                    fontFamily: AppFonts.body,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),
              Icon(statusIcon, size: 16, color: statusColor),
              const SizedBox(width: 4),
              Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 13,
                  fontFamily: AppFonts.body,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.prompt,
            style: const TextStyle(
              color: AppColors.uiHeading,
              fontSize: 15,
              fontFamily: AppFonts.body,
              fontWeight: FontWeight.w500,
              height: 1.45,
            ),
          ),
          if (item.promptFigure != null) ...[
            const SizedBox(height: 12),
            SpatialFigureView(figure: item.promptFigure!, height: 160),
          ],
          if (item.optionFigures != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                for (int i = 0; i < item.optionFigures!.length; i++)
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: i == item.correctIndex
                                  ? AppColors.successFg
                                  : AppColors.border,
                              width: i == item.correctIndex ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SpatialFigureView(
                            figure: item.optionFigures![i],
                            height: 64,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          aptitudeOptionLetters[i],
                          style: TextStyle(
                            color: i == item.correctIndex
                                ? AppColors.successFg
                                : AppColors.uiHeadingSmall,
                            fontSize: 12,
                            fontFamily: AppFonts.body,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          _Line(
            label: aptitudeReviewYourAnswer,
            value: yourLabel,
            color: statusColor,
          ),
          const SizedBox(height: 6),
          _Line(
            label: aptitudeReviewCorrectAnswer,
            value: correctLabel,
            color: AppColors.successFg,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  aptitudeReviewHowTo,
                  style: TextStyle(
                    color: AppColors.uiHeading,
                    fontSize: 13,
                    fontFamily: AppFonts.body,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.explanation,
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

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 118,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.uiHeadingSmall,
              fontSize: 13,
              fontFamily: AppFonts.body,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontFamily: AppFonts.body,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
