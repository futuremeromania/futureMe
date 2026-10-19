import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

/// Shared layout for the "Scale 1-5" Likert-question screens (Figma frames
/// 148:998, 148:842 selected/unselected, and the per-stage equivalents
/// 151:1411, 175:1594, 180:1716, ...). Each module stage runs this same
/// template across a whole question bank (e.g. "1 din 50" in Figma) rather
/// than having one Figma frame per question.
class ModuleScaleQuestionScreen extends StatefulWidget {
  const ModuleScaleQuestionScreen({
    super.key,
    required this.sectionLabel,
    required this.statement,
    required this.questionNumber,
    required this.totalQuestions,
    required this.onContinue,
    this.subtitle = "Alege cât de adevărată este afirmația pentru tine acum.",
    this.caption = "Gândește-te la cum ești de obicei, nu doar azi.",
    this.options = const [
      "Deloc adevărat",
      "Mai degrabă fals",
      "Neutru",
      "Mai degrabă adevărat",
      "Foarte adevărat",
    ],
    this.initialSelection,
  });

  final String sectionLabel;
  final String statement;
  final String subtitle;
  final String caption;
  final List<String> options;
  final int questionNumber;
  final int totalQuestions;
  final int? initialSelection;
  final ValueChanged<int> onContinue;

  @override
  State<ModuleScaleQuestionScreen> createState() =>
      _ModuleScaleQuestionScreenState();
}

class _ModuleScaleQuestionScreenState extends State<ModuleScaleQuestionScreen> {
  late int? _selected = widget.initialSelection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 24, 0),
              child: Row(
                children: [
                  // The back arrow and the counter are different widths, so
                  // `spaceBetween` would centre the wordmark between them
                  // rather than on the screen — visibly off to the left. Both
                  // sides expand instead, which makes them equal and puts the
                  // wordmark on the true centre line.
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.chevron_left,
                          color: AppColors.dashboard,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                  // The wordmark rides along in the header on every question
                  // screen — with 180-odd of them in a full run, this is where
                  // the brand actually gets seen. It sits in space the row
                  // already had, so nothing below moves down.
                  SvgPicture.asset(AppAssets.splashImage, height: 30),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${widget.questionNumber}",
                          style: const TextStyle(
                            color: AppColors.dashboard /* ui-text-primary */,
                            fontSize: 16,
                            fontFamily: AppFonts.body,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "din ${widget.totalQuestions}",
                          style: const TextStyle(
                            color: AppColors
                                .uiHeadingSmall /* ui-text-secondary */,
                            fontSize: 16,
                            fontFamily: AppFonts.body,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9999),
                child: LinearProgressIndicator(
                  value: widget.questionNumber / widget.totalQuestions,
                  minHeight: 6,
                  backgroundColor: AppColors.faint,
                  valueColor: const AlwaysStoppedAnimation(AppColors.uiHeading),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                child: Column(
                  children: [
                    Text(
                      widget.sectionLabel,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall /* ui-text-secondary */,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w500,
                        height: 1.375,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.statement,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.uiHeading /* ui-text-heading */,
                        fontSize: 24,
                        fontFamily: AppFonts.heading,
                        fontWeight: FontWeight.w600,
                        height: 1.33,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall /* ui-text-secondary */,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        letterSpacing: -0.16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    for (int i = 0; i < widget.options.length; i++) ...[
                      if (i > 0) const SizedBox(height: 16),
                      _OptionRow(
                        label: widget.options[i],
                        selected: _selected == i,
                        onTap: () => setState(() => _selected = i),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Text(
                      widget.caption,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall /* ui-text-secondary */,
                        fontSize: 14,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppColors.statusInfoBg,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            size: 12,
                            color: AppColors.statusInfoFg,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            "Progresul tău se salvează automat.",
                            style: TextStyle(
                              color: AppColors.statusInfoFg,
                              fontSize: 14,
                              fontFamily: AppFonts.body,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Opacity(
                opacity: _selected != null ? 1 : 0.5,
                child: PrimaryButton(
                  content: "Continuă",
                  onpressed: _selected != null
                      ? () => widget.onContinue(_selected!)
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

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.faint /* ui-surface-tint */
              : Colors.white /* ui-surface-card */,
          border: Border.all(
            color: selected ? AppColors.grad1 : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x59CFB2A4),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: AppColors.dashboard /* ui-text-primary */,
                  fontSize: 16,
                  fontFamily: AppFonts.body,
                  fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                  height: 1.375,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.grad1 : null,
                shape: BoxShape.circle,
                border: selected
                    ? null
                    : Border.all(color: AppColors.border, width: 2),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
