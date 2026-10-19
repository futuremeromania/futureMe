import 'package:flutter/material.dart';
import 'package:futureme/core/data/character_strengths.dart';
import 'package:futureme/core/data/character_strengths_feedback.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/strength_choice_card.dart';

/// Asks the user to pick the three of their five strengths they recognise
/// themselves in most.
///
/// This is self-selection, not measurement: it does not touch the scores
/// and does not re-rank the five. It is stored separately for exactly that
/// reason — what the instrument found and what the person recognises are
/// two different pieces of information, and the second is not evidence
/// about the first.
class StrengthsPickThreeScreen extends StatefulWidget {
  const StrengthsPickThreeScreen({
    super.key,
    required this.topFive,
    required this.onContinue,
  });

  final List<StrengthDimension> topFive;
  final ValueChanged<List<StrengthDimension>> onContinue;

  @override
  State<StrengthsPickThreeScreen> createState() =>
      _StrengthsPickThreeScreenState();
}

class _StrengthsPickThreeScreenState extends State<StrengthsPickThreeScreen> {
  final List<StrengthDimension> _selected = [];

  bool get _complete => _selected.length == strengthsSelfPickCount;

  void _toggle(StrengthDimension dimension) {
    setState(() {
      if (_selected.contains(dimension)) {
        _selected.remove(dimension);
      } else if (_selected.length < strengthsSelfPickCount) {
        _selected.add(dimension);
      }
    });
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
                      strengthsPickHeading,
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
                      strengthsPickText,
                      style: TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 14,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    for (final dimension in widget.topFive) ...[
                      StrengthChoiceCard(
                        dimension: dimension,
                        description: strengthFeedbackFor(dimension).headline,
                        selected: _selected.contains(dimension),
                        onTap: () => _toggle(dimension),
                      ),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      "Ai ales ${_selected.length} din $strengthsSelfPickCount.",
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 14,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Opacity(
                opacity: _complete ? 1 : 0.5,
                child: PrimaryButton(
                  content: "Continuă",
                  onpressed: _complete
                      ? () => widget.onContinue(List.of(_selected))
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
