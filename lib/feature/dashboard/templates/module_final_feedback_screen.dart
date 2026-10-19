import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

class ConnectionItem {
  const ConnectionItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

/// Shared layout for the "Module N - Final Feedback" screens (Figma frame
/// 190:1271 and its per-module equivalents) — a synthesis screen shown
/// after all of a module's stages are complete, before the module's own
/// "Complete" screen.
class ModuleFinalFeedbackScreen extends StatelessWidget {
  const ModuleFinalFeedbackScreen({
    super.key,
    required this.moduleLabel,
    required this.title,
    required this.description,
    required this.connectionsTitle,
    required this.connections,
    required this.infoNote,
    required this.continueLabel,
    required this.onContinue,
    this.chatLabel,
    this.onChat,
    this.synthesisTitle,
    this.synthesisDescription,
    this.explorationTitle,
    this.explorationItems,
    this.secondConnectionsTitle,
    this.secondConnections,
  });

  final String moduleLabel;
  final String title;
  final String description;
  final String connectionsTitle;
  final List<ConnectionItem> connections;
  final String infoNote;
  final String continueLabel;
  final String? chatLabel;
  final VoidCallback onContinue;

  /// When null, the Chat button is omitted (Figma frame 315:1785, Module 5
  /// Personal Profile — a single Primary Button, no secondary Chat action).
  final VoidCallback? onChat;

  /// Optional tinted synthesis box (Figma frame 190:1271, Modules 2/3) —
  /// omitted on modules whose Final Feedback goes straight from the
  /// description into the cards section (e.g. Module 4).
  final String? synthesisTitle;
  final String? synthesisDescription;

  /// Optional "Arii care merită explorate" checklist (Figma frame 229:2289,
  /// Module 3 only) — a tinted card with a simple checkmark list.
  final String? explorationTitle;
  final List<String>? explorationItems;

  /// Optional second white card in the same icon/title/description row
  /// style as [connections] (Figma frame 258:1872 "O zonă care merită
  /// dezvoltată", Module 4 only).
  final String? secondConnectionsTitle;
  final List<ConnectionItem>? secondConnections;

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
                    Text(
                      moduleLabel,
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall /* ui-text-secondary */,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w500,
                        height: 1.375,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.uiHeading /* ui-text-heading */,
                        fontSize: 28,
                        fontFamily: AppFonts.heading,
                        fontWeight: FontWeight.w600,
                        height: 1.21,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      description,
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall /* ui-text-secondary */,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        letterSpacing: -0.16,
                      ),
                    ),
                    if (synthesisTitle != null) ...[
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.faint /* ui-surface-tint */,
                          border: Border.all(color: AppColors.borderStrong),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              synthesisTitle!,
                              style: const TextStyle(
                                color:
                                    AppColors.uiHeading /* ui-text-heading */,
                                fontSize: 20,
                                fontFamily: AppFonts.heading,
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              synthesisDescription ?? "",
                              style: const TextStyle(
                                color: AppColors
                                    .uiHeadingSmall /* ui-text-secondary */,
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
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            connectionsTitle,
                            style: const TextStyle(
                              color: AppColors.uiHeading /* ui-text-heading */,
                              fontSize: 20,
                              fontFamily: AppFonts.heading,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          for (int i = 0; i < connections.length; i++) ...[
                            if (i > 0) ...[
                              const SizedBox(height: 16),
                              Divider(
                                color: AppColors.border,
                                height: 1,
                                thickness: 1,
                              ),
                              const SizedBox(height: 16),
                            ],
                            _ConnectionRow(item: connections[i]),
                          ],
                        ],
                      ),
                    ),
                    if (secondConnections != null) ...[
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              secondConnectionsTitle ?? "",
                              style: const TextStyle(
                                color:
                                    AppColors.uiHeading /* ui-text-heading */,
                                fontSize: 20,
                                fontFamily: AppFonts.heading,
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 16),
                            for (
                              int i = 0;
                              i < secondConnections!.length;
                              i++
                            ) ...[
                              if (i > 0) ...[
                                const SizedBox(height: 16),
                                Divider(
                                  color: AppColors.border,
                                  height: 1,
                                  thickness: 1,
                                ),
                                const SizedBox(height: 16),
                              ],
                              _ConnectionRow(item: secondConnections![i]),
                            ],
                          ],
                        ),
                      ),
                    ],
                    if (explorationItems != null) ...[
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.faint /* ui-surface-tint */,
                          border: Border.all(color: AppColors.borderStrong),
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
                              explorationTitle ?? "",
                              style: const TextStyle(
                                color:
                                    AppColors.uiHeading /* ui-text-heading */,
                                fontSize: 20,
                                fontFamily: AppFonts.heading,
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 16),
                            for (
                              int i = 0;
                              i < explorationItems!.length;
                              i++
                            ) ...[
                              if (i > 0) ...[
                                const SizedBox(height: 16),
                                Divider(
                                  color: AppColors.border,
                                  height: 1,
                                  thickness: 1,
                                ),
                                const SizedBox(height: 16),
                              ],
                              Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      size: 12,
                                      color: AppColors.uiHeading,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      explorationItems![i],
                                      style: const TextStyle(
                                        color: AppColors
                                            .dashboard /* ui-text-primary */,
                                        fontSize: 16,
                                        fontFamily: AppFonts.body,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5,
                                        letterSpacing: -0.16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
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
                        Expanded(
                          child: Text(
                            infoNote,
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
              child: Column(
                children: [
                  PrimaryButton(content: continueLabel, onpressed: onContinue),
                  if (onChat != null) ...[
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: onChat,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grad1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.chat_bubble_outline,
                              size: 24,
                              color: AppColors.grad1,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              chatLabel ?? "",
                              style: const TextStyle(
                                color: AppColors.grad1 /* ui-action-primary */,
                                fontSize: 16,
                                fontFamily: AppFonts.body,
                                fontWeight: FontWeight.w500,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectionRow extends StatelessWidget {
  const _ConnectionRow({required this.item});

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
