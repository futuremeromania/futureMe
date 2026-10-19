import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

/// Shared layout for the "MBTI" point-allocation screens (Figma frames
/// 147:1239/1407 selected/unselected, 147:1492, 147:1584, and the per-stage
/// question banks, e.g. Module 2 Stage 1's "32 de perechi de afirmații").
/// The user splits 5 points across two statements (A5·B0 ... A0·B5); unlike
/// the free-text/scale screens, a split is always active so Continue is
/// never disabled.
class ModuleMbtiQuestionScreen extends StatefulWidget {
  const ModuleMbtiQuestionScreen({
    super.key,
    required this.sectionLabel,
    required this.statementA,
    required this.statementB,
    required this.questionNumber,
    required this.totalQuestions,
    required this.onContinue,
    this.prompt = "Cum preferi să împarți cele 5 puncte?",
    this.subtitle =
        "Distribuie punctele între cele două variante, în funcție de cât de mult te regăsești în fiecare.",
    this.caption = "Dacă ambele ți se potrivesc, alege o variantă de mijloc.",
    this.initialPointsForA = 2,
  });

  final String sectionLabel;
  final String prompt;
  final String subtitle;
  final String statementA;
  final String statementB;
  final String caption;
  final int questionNumber;
  final int totalQuestions;
  final int initialPointsForA;

  /// Called with (pointsForA, pointsForB), which always sum to 5.
  final void Function(int pointsForA, int pointsForB) onContinue;

  @override
  State<ModuleMbtiQuestionScreen> createState() =>
      _ModuleMbtiQuestionScreenState();
}

class _ModuleMbtiQuestionScreenState extends State<ModuleMbtiQuestionScreen> {
  late int _pointsForA = widget.initialPointsForA;

  @override
  Widget build(BuildContext context) {
    final pointsForB = 5 - _pointsForA;
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
                            color: AppColors.dashboard,
                            fontSize: 16,
                            fontFamily: AppFonts.body,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "din ${widget.totalQuestions}",
                          style: const TextStyle(
                            color: AppColors.uiHeadingSmall,
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
                        color: AppColors.uiHeadingSmall,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w500,
                        height: 1.375,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.prompt,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.uiHeading,
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
                        color: AppColors.uiHeadingSmall,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        letterSpacing: -0.16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _AfirmationCard(
                      label: "Varianta A",
                      statement: widget.statementA,
                      points: _pointsForA,
                      winning: _pointsForA > pointsForB,
                    ),
                    const SizedBox(height: 16),
                    _AfirmationCard(
                      label: "Varianta B",
                      statement: widget.statementB,
                      points: pointsForB,
                      winning: pointsForB > _pointsForA,
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Alege proporția care se simte cea mai apropiată:",
                        style: const TextStyle(
                          color: AppColors.uiHeadingSmall,
                          fontSize: 14,
                          fontFamily: AppFonts.body,
                          fontWeight: FontWeight.w500,
                          height: 1.29,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    for (int row = 0; row < 2; row++) ...[
                      if (row > 0) const SizedBox(height: 12),
                      Row(
                        children: [
                          for (int col = 0; col < 3; col++) ...[
                            if (col > 0) const SizedBox(width: 16),
                            Expanded(child: _buildSplitButton(row * 3 + col)),
                          ],
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text(
                      widget.caption,
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall,
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
                            "Poți reveni oricând. Răspunsurile tale se salvează automat.",
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
              child: PrimaryButton(
                content: "Continuă",
                onpressed: () => widget.onContinue(_pointsForA, pointsForB),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSplitButton(int index) {
    final pointsForA = 5 - index;
    final selected = _pointsForA == pointsForA;
    return GestureDetector(
      onTap: () => setState(() => _pointsForA = pointsForA),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.grad1 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: selected ? null : Border.all(color: AppColors.border),
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
        child: Text(
          "A$pointsForA · B${5 - pointsForA}",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.dashboard,
            fontSize: 16,
            fontFamily: AppFonts.body,
            fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
            height: 1.375,
          ),
        ),
      ),
    );
  }
}

class _AfirmationCard extends StatelessWidget {
  const _AfirmationCard({
    required this.label,
    required this.statement,
    required this.points,
    required this.winning,
  });

  final String label;
  final String statement;
  final int points;
  final bool winning;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: winning ? AppColors.faint : Colors.white,
        border: Border.all(color: winning ? AppColors.grad1 : AppColors.border),
        borderRadius: BorderRadius.circular(16),
        boxShadow: winning
            ? const [
                BoxShadow(
                  color: Color(0x59CFB2A4),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.uiHeadingSmall,
                  fontSize: 12,
                  fontFamily: AppFonts.body,
                  fontWeight: FontWeight.w500,
                  height: 1.33,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: winning ? AppColors.grad1 : AppColors.faint,
                  borderRadius: BorderRadius.circular(99999),
                  border: winning ? null : Border.all(color: AppColors.border),
                ),
                child: Text(
                  "$points puncte",
                  style: TextStyle(
                    color: winning ? Colors.white : AppColors.uiHeading,
                    fontSize: 12,
                    fontFamily: AppFonts.body,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            statement,
            style: TextStyle(
              color: AppColors.dashboard,
              fontSize: 16,
              fontFamily: AppFonts.body,
              fontWeight: winning ? FontWeight.w500 : FontWeight.w400,
              height: 1.375,
            ),
          ),
        ],
      ),
    );
  }
}
