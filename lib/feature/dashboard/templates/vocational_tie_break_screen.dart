import 'package:flutter/material.dart';
import 'package:futureme/core/data/vocational_interests.dart';
import 'package:futureme/core/data/vocational_interests_feedback.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/module_header_banner.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

/// Asks the user to separate two or more interest areas that tied, when the
/// tie decides who enters the top three or the order inside the RIASEC code.
///
/// The choice orders the profile and nothing else: no point is added or
/// removed, and the scores shown on the result screen stay exactly as they
/// were earned. That is why the note at the bottom says so outright — a
/// screen that asks you to pick between two results invites the suspicion
/// that the picking changes them.
class VocationalTieBreakScreen extends StatefulWidget {
  const VocationalTieBreakScreen({
    super.key,
    required this.tied,
    required this.onChoice,
  });

  /// The dimensions still tied, in their provisional order.
  final List<VocationalDimension> tied;

  final ValueChanged<VocationalDimension> onChoice;

  @override
  State<VocationalTieBreakScreen> createState() =>
      _VocationalTieBreakScreenState();
}

class _VocationalTieBreakScreenState extends State<VocationalTieBreakScreen> {
  VocationalDimension? _selected;

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
                      vocationalTieBreakTitle,
                      style: TextStyle(
                        color: AppColors.uiHeading,
                        fontSize: 24,
                        fontFamily: AppFonts.heading,
                        fontWeight: FontWeight.w600,
                        height: 1.33,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      vocationalTieBreakQuestion,
                      style: TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        letterSpacing: -0.16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    for (final dimension in widget.tied) ...[
                      _TieOption(
                        dimension: dimension,
                        selected: _selected == dimension,
                        onTap: () => setState(() => _selected = dimension),
                      ),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 8),
                    const Text(
                      vocationalTieBreakHint,
                      style: TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 14,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                            vocationalTieBreakNote,
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
                      ? () => widget.onChoice(_selected!)
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

class _TieOption extends StatelessWidget {
  const _TieOption({
    required this.dimension,
    required this.selected,
    required this.onTap,
  });

  final VocationalDimension dimension;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.faint : Colors.white,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dimension.label,
                    style: TextStyle(
                      color: AppColors.uiHeading,
                      fontSize: 18,
                      fontFamily: AppFonts.heading,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    vocationalTieBreakActivities[dimension]!,
                    style: const TextStyle(
                      color: AppColors.uiHeadingSmall,
                      fontSize: 14,
                      fontFamily: AppFonts.body,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
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
