import 'package:flutter/material.dart';
import 'package:futureme/core/data/character_strengths.dart';
import 'package:futureme/core/data/character_strengths_feedback.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

/// The three strengths the user picked out of their five.
///
/// Each card shows the name and the subtitle, with "Vezi din nou" to
/// reopen the same feedback that was already shown on the Top 5 screen —
/// reopened, not rewritten: a second, differently-worded text for the same
/// strength would read as a new and slightly different result.
class StrengthsTopThreeScreen extends StatelessWidget {
  const StrengthsTopThreeScreen({
    super.key,
    required this.topThree,
    required this.onContinue,
    this.continueLabel = "Continuă cu Etapa 2",
  });

  final List<StrengthDimension> topThree;
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
                      strengthsFinalHeading,
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
                      strengthsFinalText,
                      style: TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 14,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    for (final dimension in topThree) ...[
                      _ChosenStrengthCard(dimension: dimension),
                      const SizedBox(height: 16),
                    ],
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.faint,
                        border: Border.all(color: AppColors.borderStrong),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        strengthsFinalClosing,
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

class _ChosenStrengthCard extends StatefulWidget {
  const _ChosenStrengthCard({required this.dimension});

  final StrengthDimension dimension;

  @override
  State<_ChosenStrengthCard> createState() => _ChosenStrengthCardState();
}

class _ChosenStrengthCardState extends State<_ChosenStrengthCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final feedback = strengthFeedbackFor(widget.dimension);

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
            widget.dimension.label,
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
          if (_expanded) ...[
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
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Text(
                  _expanded ? "Ascunde" : "Vezi din nou",
                  style: const TextStyle(
                    color: AppColors.grad1,
                    fontSize: 14,
                    fontFamily: AppFonts.body,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  size: 18,
                  color: AppColors.grad1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
