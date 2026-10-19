import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

/// Shared layout for the free-text "Module N - Question X" screens (Figma
/// frames 80:408/591, 80:510/617, 80:550, 81:838, ...). The "Answered"
/// variant in Figma is just this screen with text typed into the field —
/// there's no separate widget for it, the Continue button simply enables.
class ModuleQuestionScreen extends StatefulWidget {
  const ModuleQuestionScreen({
    super.key,
    required this.questionNumber,
    required this.totalQuestions,
    required this.question,
    required this.subtitle,
    required this.placeholder,
    required this.onContinue,
    this.hint = "Nu trebuie să scrii perfect. Spune doar ce simți.",
    this.initialAnswer,
    this.continueLabel = "Continuă",
    this.textFieldHeight = 170,
    this.tipsTitle,
    this.tips,
    this.buttonPinned = true,
    this.onAutosave,
  });

  final int questionNumber;
  final int totalQuestions;
  final String question;
  final String subtitle;
  final String placeholder;
  final String hint;
  final String? initialAnswer;
  final String continueLabel;
  final double textFieldHeight;

  /// Optional "Te poți gândi la:" tip card shown above the text field
  /// (Figma frame 80:550 / Question 3 only).
  final String? tipsTitle;
  final List<String>? tips;

  /// Q1/Q2 pin the Continue button to the screen bottom; Q3 has it flow
  /// in-line after the tip card instead (Figma frame 80:550).
  final bool buttonPinned;

  final ValueChanged<String> onContinue;

  /// Debounced (~600ms after typing stops) autosave hook for the in-progress
  /// answer, matching the "Răspunsul tău se salvează automat" copy below.
  final ValueChanged<String>? onAutosave;

  @override
  State<ModuleQuestionScreen> createState() => _ModuleQuestionScreenState();
}

class _ModuleQuestionScreenState extends State<ModuleQuestionScreen> {
  late final TextEditingController _controller;
  Timer? _autosaveTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialAnswer);
  }

  @override
  void dispose() {
    _autosaveTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _scheduleAutosave() {
    if (widget.onAutosave == null) return;
    _autosaveTimer?.cancel();
    _autosaveTimer = Timer(const Duration(milliseconds: 600), () {
      final text = _controller.text.trim();
      if (text.isNotEmpty) widget.onAutosave!(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasAnswer = _controller.text.trim().isNotEmpty;
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
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
                child: Column(
                  children: [
                    Text(
                      widget.question,
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
                    const SizedBox(height: 40),
                    if (widget.tips != null) ...[
                      _TipsCard(title: widget.tipsTitle!, tips: widget.tips!),
                      const SizedBox(height: 32),
                    ],
                    Container(
                      width: double.infinity,
                      height: widget.textFieldHeight,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white /* ui-surface-card */,
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
                      child: TextField(
                        controller: _controller,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        onChanged: (_) {
                          setState(() {});
                          _scheduleAutosave();
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: widget.placeholder,
                          hintStyle: const TextStyle(
                            color: Color(0xFF8B7D92) /* ui-text-muted */,
                            fontSize: 16,
                            fontFamily: AppFonts.body,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.16,
                          ),
                        ),
                        style: const TextStyle(
                          color: AppColors.dashboard /* ui-text-primary */,
                          fontSize: 16,
                          fontFamily: AppFonts.body,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.hint,
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
                            "Răspunsul tău se salvează automat",
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
                    if (!widget.buttonPinned) ...[
                      _continueButton(hasAnswer),
                      const SizedBox(height: 24),
                    ],
                  ],
                ),
              ),
            ),
            if (widget.buttonPinned)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: _continueButton(hasAnswer),
              ),
          ],
        ),
      ),
    );
  }

  Widget _continueButton(bool hasAnswer) {
    return Opacity(
      opacity: hasAnswer ? 1 : 0.5,
      child: PrimaryButton(
        content: widget.continueLabel,
        onpressed: hasAnswer ? () => widget.onContinue(_controller.text) : null,
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard({required this.title, required this.tips});

  final String title;
  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.faint /* ui-surface-tint */,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.uiHeading /* ui-text-heading */,
              fontSize: 16,
              fontFamily: AppFonts.body,
              fontWeight: FontWeight.w500,
              height: 1.375,
            ),
          ),
          const SizedBox(height: 12),

          /// A bullet rather than a checkmark: these are prompts to think
          /// about, not a list of things to tick off. Longer prompts also
          /// need more room to breathe between them.
          for (final tip in tips)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Icon(
                      Icons.circle,
                      size: 6,
                      color: AppColors.uiHeading,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      tip,
                      style: const TextStyle(
                        color: AppColors.dashboard /* ui-text-primary */,
                        fontSize: 14,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
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
