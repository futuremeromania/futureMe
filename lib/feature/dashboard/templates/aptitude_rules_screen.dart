import 'package:flutter/material.dart';
import 'package:futureme/core/data/aptitude_test_feedback.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/module_header_banner.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

/// The rules screen, shown between the stage introduction and the clock.
///
/// It is a separate screen on purpose: this is the last moment before a
/// 30-minute session that cannot be paused, resumed or restarted, and
/// every rule here is one the person cannot be told again once the timer
/// is running.
class AptitudeRulesScreen extends StatelessWidget {
  const AptitudeRulesScreen({super.key, required this.onStart});

  final VoidCallback onStart;

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
                      "Etapa 2 din 2 • $aptitudeStageTitle",
                      style: TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 14,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      aptitudeRulesHeading,
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
                      aptitudeRulesLead,
                      style: TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        letterSpacing: -0.16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    for (int i = 0; i < aptitudeRules.length; i++) ...[
                      _RuleCard(rule: aptitudeRules[i], icon: _ruleIcons[i]),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: PrimaryButton(
                content: aptitudeStartButton,
                onpressed: onStart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const List<IconData> _ruleIcons = [
  Icons.schedule_outlined,
  Icons.play_circle_outline,
  Icons.format_list_bulleted,
  Icons.edit_outlined,
  Icons.calculate_outlined,
  Icons.stop_circle_outlined,
];

class _RuleCard extends StatelessWidget {
  const _RuleCard({required this.rule, required this.icon});

  final AptitudeRule rule;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.faint,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: AppColors.grad1),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule.title,
                  style: const TextStyle(
                    color: AppColors.uiHeading,
                    fontSize: 16,
                    fontFamily: AppFonts.heading,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rule.description,
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
        ],
      ),
    );
  }
}
