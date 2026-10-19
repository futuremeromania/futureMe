import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';

/// Shared layout for Module 5's "Report Loading" screens (478:2399,
/// 487:2349). Figma uses an animated illustration here; this is
/// approximated with a simple spinner since no illustration asset is
/// available in the project. Calls [onTimeout] once after [duration] so
/// callers can advance the flow — mirrors the auto-continue behavior
/// noted in the Figma annotations ("if the report becomes ready,
/// automatically continue to the Report Ready screen").
class ModuleLoadingScreen extends StatefulWidget {
  const ModuleLoadingScreen({
    super.key,
    required this.moduleLabel,
    required this.title,
    required this.description,
    required this.reminderText,
    this.onTimeout,
    this.duration = const Duration(seconds: 2),
    this.secondaryLabel,
    this.onSecondary,
  });

  final String moduleLabel;
  final String title;
  final String description;
  final String reminderText;
  final VoidCallback? onTimeout;
  final Duration duration;

  /// "Revin mai târziu" (Figma frame 487:2349, Report Loading 2 only).
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  State<ModuleLoadingScreen> createState() => _ModuleLoadingScreenState();
}

class _ModuleLoadingScreenState extends State<ModuleLoadingScreen> {
  @override
  void initState() {
    super.initState();
    final onTimeout = widget.onTimeout;
    if (onTimeout != null) {
      Future.delayed(widget.duration, () {
        if (mounted) onTimeout();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.moduleLabel,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w500,
                        height: 1.375,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.uiHeading,
                        fontSize: 28,
                        fontFamily: AppFonts.heading,
                        fontWeight: FontWeight.w600,
                        height: 1.21,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.description,
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
                    const SizedBox(height: 62),
                    Container(
                      width: 96,
                      height: 96,
                      decoration: const BoxDecoration(
                        color: AppColors.faint,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(28),
                      child: const CircularProgressIndicator(
                        strokeWidth: 3,
                        color: AppColors.grad1,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      widget.reminderText,
                      textAlign: TextAlign.center,
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
            ),
            if (widget.secondaryLabel != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: GestureDetector(
                  onTap: widget.onSecondary,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 18,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.secondaryLabel!,
                      style: const TextStyle(
                        color: AppColors.grad1,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
