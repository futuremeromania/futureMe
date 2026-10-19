import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/feature/dashboard/templates/module_final_feedback_screen.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/module_header_banner.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/rounded_card.dart';

/// The accent of [ModuleIntroductionScreen.labelAccent]: the middle stop of
/// the brand gradient.
const Color _accentColor = Color(0xFF7F378E);

/// Shared layout for the "Module N - Introduction" screens (Figma frames
/// 74:335, 94:600, 217:1335, 258:1677, 315:1620) — identical structure,
/// only the copy and checklist differ per module.
class ModuleIntroductionScreen extends StatelessWidget {
  const ModuleIntroductionScreen({
    super.key,
    required this.moduleLabel,
    required this.moduleTitle,
    required this.description,
    required this.continueLabel,
    required this.onContinue,
    this.nextSteps = const [],
    this.richNextSteps,
    this.icon = AppAssets.moduleIcon,
    this.labelAccent,
    this.titleAccent,
    this.progressNoteBoldLead = false,
    this.progressNote =
        "Progresul tău este salvat, așa că poți reveni oricând la acest modul.",
  }) : assert(
         nextSteps.length > 0 || richNextSteps != null,
         "Provide either nextSteps or richNextSteps",
       );

  final String moduleLabel;
  final String moduleTitle;
  final String description;
  final List<String> nextSteps;

  /// Alternate "Ce urmează" card layout (Figma frame 315:1620, Module 5
  /// Introduction only) — icon/title/description rows instead of a plain
  /// checkmark list. Takes priority over [nextSteps] when set.
  final List<ConnectionItem>? richNextSteps;

  /// Asset path of the round icon shown above the title.
  final String icon;

  /// Optional second part of [moduleLabel], shown after a "•" in capitals
  /// and in the accent colour ("Etapa 3 din 3 • MEDII DE LUCRU").
  final String? labelAccent;

  /// Optional end of the title drawn in the brand gradient, after
  /// [moduleTitle] ("Cum iei" + "decizii").
  final String? titleAccent;

  /// Sets the first sentence of [progressNote] in bold, as in the designs
  /// ("**Nu trebuie să alegi perfect.** Doar observăm…").
  final bool progressNoteBoldLead;

  static const TextStyle _titleStyle = TextStyle(
    color: AppColors.uiHeading,
    fontSize: 28,
    fontFamily: AppFonts.heading,
    fontWeight: FontWeight.w600,
    height: 1.21,
  );

  TextSpan _progressNoteSpan() {
    final end = progressNote.indexOf('. ');
    if (!progressNoteBoldLead || end < 0) return TextSpan(text: progressNote);
    return TextSpan(
      children: [
        TextSpan(
          text: progressNote.substring(0, end + 1),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        TextSpan(text: progressNote.substring(end + 1)),
      ],
    );
  }

  final String continueLabel;
  final String progressNote;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // The circle straddles the banner's bottom edge, as in the
            // design: the stack reserves half its height below the image so
            // the overlap costs no layout space anywhere else.
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: ModuleHeaderBanner(),
                ),
                Container(
                  width: 80,
                  height: 80,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.background,
                    border: Border.all(color: AppColors.borderStrong),
                  ),
                  child: Image.asset(icon, fit: BoxFit.cover),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text.rich(
                      TextSpan(
                        text: moduleLabel,
                        children: [
                          if (labelAccent != null)
                            TextSpan(
                              text: " • ${labelAccent!.toUpperCase()}",
                              style: const TextStyle(
                                color: _accentColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall /* ui-text-secondary */,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w500,
                        height: 1.375,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (titleAccent == null)
                      PageTitle(content: moduleTitle)
                    else
                      SizedBox(
                        width: 345,
                        child: Text.rich(
                          TextSpan(
                            text: "$moduleTitle ",
                            children: [
                              // The accent stays one unit: on the title's line
                              // when it fits ("Cum iei decizii"), on the next
                              // one when it does not ("Cum reacționezi /
                              // sub presiune").
                              WidgetSpan(
                                alignment: PlaceholderAlignment.baseline,
                                baseline: TextBaseline.alphabetic,
                                child: ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (bounds) => AppColors
                                      .specialGradient
                                      .createShader(bounds),
                                  child: Text(
                                    titleAccent!,
                                    textAlign: TextAlign.center,
                                    style: _titleStyle.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: _titleStyle,
                        ),
                      ),
                    const SizedBox(height: 16),
                    CenterText(content: description),
                    const SizedBox(height: 24),
                    RoundedCard(
                      borderRadius: BorderRadius.circular(16),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      contents: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Ce urmează",
                            style: TextStyle(
                              color: AppColors.uiHeading /* ui-text-heading */,
                              fontSize: 20,
                              fontFamily: AppFonts.heading,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (richNextSteps != null)
                          for (int i = 0; i < richNextSteps!.length; i++) ...[
                            if (i > 0) ...[
                              const SizedBox(height: 16),
                              Divider(
                                color: AppColors.border,
                                height: 1,
                                thickness: 1,
                              ),
                              const SizedBox(height: 16),
                            ],
                            _RichStepRow(item: richNextSteps![i]),
                          ]
                        else
                          for (int i = 0; i < nextSteps.length; i++) ...[
                            if (i > 0) ...[
                              const SizedBox(height: 16),
                              Divider(
                                color: AppColors.border,
                                height: 1,
                                thickness: 1,
                              ),
                              const SizedBox(height: 16),
                            ],
                            _NextStepRow(text: nextSteps[i]),
                          ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        Expanded(
                          child: Text.rich(
                            _progressNoteSpan(),
                            style: const TextStyle(
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
                content: continueLabel,
                gradient: AppColors.specialGradient,
                onpressed: onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RichStepRow extends StatelessWidget {
  const _RichStepRow({required this.item});

  final ConnectionItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 43,
          height: 43,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.borderStrong),
          ),
          child: Icon(item.icon, color: AppColors.uiHeading),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  color: AppColors.uiHeading /* ui-text-heading */,
                  fontSize: 16,
                  fontFamily: AppFonts.body,
                  fontWeight: FontWeight.w500,
                  height: 1.375,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                style: const TextStyle(
                  color: AppColors.uiHeadingSmall /* ui-text-secondary */,
                  fontSize: 12,
                  fontFamily: AppFonts.body,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NextStepRow extends StatelessWidget {
  const _NextStepRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.faint /* ui-surface-tint */,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 12, color: AppColors.uiHeading),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.dashboard /* ui-text-primary */,
              fontSize: 16,
              fontFamily: AppFonts.body,
              fontWeight: FontWeight.w400,
              height: 1.5,
              letterSpacing: -0.16,
            ),
          ),
        ),
      ],
    );
  }
}
