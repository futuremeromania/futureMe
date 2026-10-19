import 'package:flutter/material.dart';
import 'package:futureme/shared/widgets/faded_header_image.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/data/app_feedback_repository.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

/// The last screen of the app: how likely the person is to recommend
/// FutureMe, why, and the one thing they would change.
///
/// Nothing here is required. Someone who has just finished the whole
/// journey has already given FutureMe a great deal of their attention, and
/// holding the exit hostage for three more answers would sour the ending
/// and fill the data with whatever people type to get past it. The button
/// says "Trimite" once anything has been answered and "Mai târziu"
/// otherwise, so moving on without answering is an ordinary choice rather
/// than an escape hatch someone has to hunt for.
class AppFeedbackScreen extends StatefulWidget {
  const AppFeedbackScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<AppFeedbackScreen> createState() => _AppFeedbackScreenState();
}

class _AppFeedbackScreenState extends State<AppFeedbackScreen> {
  int? _score;
  final TextEditingController _reason = TextEditingController();
  final TextEditingController _change = TextEditingController();
  bool _sent = false;

  bool get _hasAnything =>
      _score != null ||
      _reason.text.trim().isNotEmpty ||
      _change.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    // The button's label depends on whether anything has been written, so
    // it has to follow the fields as they are typed in.
    _reason.addListener(_refresh);
    _change.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _reason.dispose();
    _change.dispose();
    super.dispose();
  }

  void _submit() {
    if (_sent) return;
    _sent = true;
    saveAppFeedback(
      score: _score,
      reason: _reason.text,
      oneChange: _change.text,
    );
    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // The two open questions sit above the keyboard; resizing lets the
      // scroll view reach them instead of hiding them behind it.
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FadedHeaderImage(
                      AppAssets.fullOnboardingImage,
                      height: 160,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Ne dorim să îmbunătățim FutureMe",
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
                            "Răspunsurile tale la aceste 3 întrebări ne sunt de mare ajutor.",
                            style: TextStyle(
                              color: AppColors.uiHeadingSmall,
                              fontSize: 16,
                              fontFamily: AppFonts.body,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                              letterSpacing: -0.16,
                            ),
                          ),
                          const SizedBox(height: 28),
                          const _QuestionLabel(
                            number: 1,
                            text:
                                "Cât de probabil este să recomanzi FutureMe unui prieten?",
                          ),
                          const SizedBox(height: 12),
                          _ScoreRow(
                            selected: _score,
                            onSelect: (value) => setState(() => _score = value),
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Text(
                                "Deloc probabil",
                                style: TextStyle(
                                  color: AppColors.uiHeadingSmall,
                                  fontSize: 12,
                                  fontFamily: AppFonts.body,
                                  height: 1.5,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "Foarte probabil",
                                style: TextStyle(
                                  color: AppColors.uiHeadingSmall,
                                  fontSize: 12,
                                  fontFamily: AppFonts.body,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          const _QuestionLabel(
                            number: 2,
                            text:
                                "Care este principalul motiv pentru care ai ales acest scor?",
                          ),
                          const SizedBox(height: 12),
                          _FeedbackField(
                            controller: _reason,
                            hint: "Scrie aici...",
                          ),
                          const SizedBox(height: 28),
                          const _QuestionLabel(
                            number: 3,
                            text:
                                "Dacă ai putea schimba sau adăuga un singur lucru în FutureMe, care ar fi acela?",
                          ),
                          const SizedBox(height: 12),
                          _FeedbackField(
                            controller: _change,
                            hint: "Scrie aici...",
                          ),
                          const SizedBox(height: 28),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.faint,
                              border: Border.all(color: AppColors.borderStrong),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              "Mulțumim! Echipa FutureMe",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.uiHeading,
                                fontSize: 16,
                                fontFamily: AppFonts.body,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: PrimaryButton(
                content: _hasAnything ? "Trimite" : "Mai târziu",
                onpressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionLabel extends StatelessWidget {
  const _QuestionLabel({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            gradient: AppColors.specialGradient,
            shape: BoxShape.circle,
          ),
          child: Text(
            "$number",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontFamily: AppFonts.body,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.uiHeading,
              fontSize: 17,
              fontFamily: AppFonts.heading,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

/// Zero to ten as a wrapped row of chips rather than a slider: a slider
/// starts at some value whether or not the person meant it, and there
/// would be no way to tell an untouched scale from a deliberate answer.
class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.selected, required this.onSelect});

  final int? selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (int i = 0; i <= 10; i++)
          GestureDetector(
            onTap: () => onSelect(i),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected == i ? null : Colors.white,
                gradient: selected == i ? AppColors.specialGradient : null,
                border: Border.all(
                  color: selected == i ? Colors.transparent : AppColors.border,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "$i",
                style: TextStyle(
                  color: selected == i ? Colors.white : AppColors.uiHeading,
                  fontSize: 15,
                  fontFamily: AppFonts.body,
                  fontWeight: selected == i ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _FeedbackField extends StatelessWidget {
  const _FeedbackField({required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        maxLines: 4,
        minLines: 3,
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(
          color: AppColors.uiHeading,
          fontSize: 15,
          fontFamily: AppFonts.body,
          height: 1.5,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            color: AppColors.uiHeadingSmall,
            fontSize: 15,
            fontFamily: AppFonts.body,
          ),
        ),
      ),
    );
  }
}
