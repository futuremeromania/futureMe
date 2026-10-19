import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:futureme/feature/chat/chat_flow.dart';
import 'package:futureme/feature/dashboard/module1_flow.dart';
import 'package:futureme/feature/dashboard/module2_flow.dart';
import 'package:futureme/feature/dashboard/module3_flow.dart';
import 'package:futureme/feature/dashboard/module4_flow.dart';
import 'package:futureme/feature/dashboard/module5_flow.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';

/// A debug-only shortcut into any stage, so a screen can be checked
/// without answering every question that leads to it.
///
/// Guarded by [kDebugMode], which the Dart compiler treats as a constant:
/// in a release build the whole widget and everything it reaches is
/// removed, so the shortcut cannot ship by accident.
class DevJumpButton extends StatelessWidget {
  const DevJumpButton({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();

    return FloatingActionButton.small(
      heroTag: 'dev-jump',
      backgroundColor: AppColors.uiHeading,
      onPressed: () => _open(context),
      child: const Icon(Icons.bolt, color: Colors.white),
    );
  }

  void _open(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Sari direct la…",
                style: TextStyle(
                  color: AppColors.uiHeading,
                  fontSize: 20,
                  fontFamily: AppFonts.heading,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Scurtătură doar în debug. Nu apare în versiunea publicată.",
                style: TextStyle(
                  color: AppColors.uiHeadingSmall,
                  fontSize: 13,
                  fontFamily: AppFonts.body,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              for (final (title, jumps) in _sections) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.uiHeadingSmall,
                      fontSize: 13,
                      fontFamily: AppFonts.body,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                for (final jump in jumps)
                  _JumpRow(
                    label: jump.label,
                    onTap: () {
                      Navigator.pop(sheetContext);
                      jump.go(context);
                    },
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Jump {
  const _Jump(this.label, this.go);

  final String label;
  final void Function(BuildContext context) go;
}

/// Opens the chat without waiting for all five modules, which is the only
/// way to reach it in a fresh test account.
void _debugChat(BuildContext context) =>
    openChat(context, ignoreCompletionGate: true);

/// Every module, with each stage at its start, plus a few screens that
/// are otherwise only reached after a long run.
const List<(String, List<_Jump>)> _sections = [
  ("General", [
    _Jump("Chat — deschide direct, fără module completate", _debugChat),
    _Jump("Feedback final despre aplicație", debugAppFeedback),
  ]),
  ("Modulul 1", [
    _Jump("M1 — începutul modulului", debugModule1Start),
  ]),
  ("Modulul 2", [
    _Jump("M2 — începutul modulului", debugModule2Start),
    _Jump("M2 · Etapa 1 — Cum preferi să funcționezi", debugModule2Stage1),
    _Jump("M2 · Etapa 2 — Care este personalitatea ta", debugModule2Stage2),
    _Jump("M2 · Etapa 3 — Cum gândești", debugModule2Stage3),
    _Jump("M2 · Etapa 4 — Cum iei decizii", debugModule2Stage4),
    _Jump("M2 · Etapa 5 — Cum reacționezi sub presiune", debugModule2Stage5),
    _Jump("M2 · Etapa 6 — Cât control simți că ai", debugModule2Stage6),
  ]),
  ("Modulul 3", [
    _Jump("M3 — începutul modulului", debugModule3Start),
    _Jump("M3 · Etapa 1 — Interese vocaționale", debugModule3Stage1),
    _Jump("M3 · Etapa 2 — Preferințe profesionale", debugModule3Stage2),
    _Jump("M3 · Etapa 3 — Medii de lucru", debugModule3Stage3),
  ]),
  ("Modulul 4", [
    _Jump("M4 — începutul modulului", debugModule4Start),
    _Jump("M4 · Etapa 1 — Puncte forte", debugModule4Stage1),
    _Jump("M4 · Etapa 2 — Aptitudinile tale (intro)", debugModule4Stage2),
    _Jump("M4 · Etapa 2 — direct în test (30 min)", debugModule4Stage2Test),
    _Jump("M4 · Etapa 2 — rezultat cu scoruri de probă", debugModule4Stage2Result),
  ]),
  ("Modulul 5", [
    _Jump("M5 — începutul modulului", debugModule5Start),
    _Jump("M5 — Imaginea de ansamblu", debugModule5Profile),
    _Jump("M5 — Direcții (generează planul)", debugModule5Directions),
    _Jump("M5 — Raport (generează raportul)", debugModule5Report),
  ]),
];

class _JumpRow extends StatelessWidget {
  const _JumpRow({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.faint,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.uiHeading,
                  fontSize: 14,
                  fontFamily: AppFonts.body,
                  height: 1.4,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.uiHeadingSmall,
            ),
          ],
        ),
      ),
    );
  }
}
