import 'package:flutter/material.dart';
import 'package:futureme/core/data/character_strengths.dart';
import 'package:futureme/core/data/character_strengths_feedback.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/module_header_banner.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/strength_choice_card.dart';

/// Asks the user to separate strengths that tied for the last places in the
/// Top 5.
///
/// It appears only when the tie actually decides who is shown: several
/// strengths sharing a score wholly inside or wholly outside the five
/// change nothing, and asking about them would invent a decision. The
/// screen never shows scores and never says which place is being decided —
/// the person is choosing which of two true things describes them better,
/// not breaking a draw for fifth.
class StrengthsTieBreakScreen extends StatefulWidget {
  const StrengthsTieBreakScreen({
    super.key,
    required this.tie,
    required this.onChoice,
  });

  final StrengthsTie tie;

  /// The chosen strengths, in the order the user picked them.
  final ValueChanged<List<StrengthDimension>> onChoice;

  @override
  State<StrengthsTieBreakScreen> createState() =>
      _StrengthsTieBreakScreenState();
}

class _StrengthsTieBreakScreenState extends State<StrengthsTieBreakScreen> {
  final List<StrengthDimension> _selected = [];

  bool get _isPair => widget.tie.tied.length == 2;
  int get _needed => widget.tie.slots;
  bool get _complete => _selected.length == _needed;

  String get _text => _isPair ? strengthsTiePairText : strengthsTieManyText;
  String get _question => _isPair
      ? strengthsTiePairQuestion
      : "Alege $_needed pe care simți că te reprezintă mai bine.";
  String get _hint => _isPair
      ? strengthsTiePairHint
      : "Alege $_needed. Nu există răspunsuri corecte.";

  void _toggle(StrengthDimension dimension) {
    setState(() {
      if (_selected.contains(dimension)) {
        _selected.remove(dimension);
      } else if (_needed == 1) {
        // A single slot behaves like a radio group: tapping another card
        // moves the choice rather than refusing the tap.
        _selected
          ..clear()
          ..add(dimension);
      } else if (_selected.length < _needed) {
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
            const ModuleHeaderBanner(height: 140),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
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
                      strengthsTieHeading,
                      style: TextStyle(
                        color: AppColors.uiHeading,
                        fontSize: 24,
                        fontFamily: AppFonts.heading,
                        fontWeight: FontWeight.w600,
                        height: 1.33,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _text,
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        letterSpacing: -0.16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _question,
                      style: const TextStyle(
                        color: AppColors.uiHeading,
                        fontSize: 18,
                        fontFamily: AppFonts.heading,
                        fontWeight: FontWeight.w500,
                        height: 1.33,
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (final dimension in widget.tie.tied) ...[
                      StrengthChoiceCard(
                        dimension: dimension,
                        description: strengthsTieBreakTexts[dimension]!,
                        selected: _selected.contains(dimension),
                        onTap: () => _toggle(dimension),
                      ),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      _hint,
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
                      ? () => widget.onChoice(List.of(_selected))
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
