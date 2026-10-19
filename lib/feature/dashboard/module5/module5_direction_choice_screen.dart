import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

/// One direction the user can pick to build the plan for.
class DirectionOption {
  const DirectionOption({required this.title, required this.description});

  final String title;
  final String description;
}

/// "Cu ce direcție vrei să începi?" — the user picks one of the five
/// directions; the plan is then built for that one.
class Module5DirectionChoiceScreen extends StatefulWidget {
  const Module5DirectionChoiceScreen({
    super.key,
    required this.options,
    required this.onChoose,
    this.initialTitle,
  });

  final List<DirectionOption> options;
  final void Function(DirectionOption option) onChoose;

  /// Preselected when the user comes back to change the choice.
  final String? initialTitle;

  @override
  State<Module5DirectionChoiceScreen> createState() => _Module5DirectionChoiceScreenState();
}

class _Module5DirectionChoiceScreenState extends State<Module5DirectionChoiceScreen> {
  int? _selected;

  @override
  void initState() {
    super.initState();
    final i = widget.options.indexWhere((o) => o.title == widget.initialTitle);
    _selected = i >= 0 ? i : null;
  }

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
                    const Text(
                      "Modulul 5 • Plan",
                      style: TextStyle(color: AppColors.uiHeadingSmall, fontSize: 16, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.375),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Cu ce direcție vrei să începi?",
                      style: TextStyle(color: AppColors.uiHeading, fontSize: 28, fontFamily: AppFonts.heading, fontWeight: FontWeight.w600, height: 1.21),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Alege una dintre direcțiile de mai jos. Pentru ea construim un plan concret, în trei etape. Celelalte rămân în raportul tău și le poți explora oricând.",
                      style: TextStyle(color: AppColors.uiHeadingSmall, fontSize: 16, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5, letterSpacing: -0.16),
                    ),
                    const SizedBox(height: 24),
                    for (int i = 0; i < widget.options.length; i++) ...[
                      _OptionTile(
                        option: widget.options[i],
                        selected: _selected == i,
                        onTap: () => setState(() => _selected = i),
                      ),
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
                content: "Construiește planul",
                color: _selected == null ? AppColors.borderStrong : null,
                onpressed: _selected == null ? null : () => widget.onChoose(widget.options[_selected!]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.option, required this.selected, required this.onTap});

  final DirectionOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.faint : Colors.white,
          border: Border.all(color: selected ? AppColors.grad1 : AppColors.border, width: selected ? 1.5 : 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 22,
              height: 22,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.grad1, width: 1.5),
              ),
              alignment: Alignment.center,
              child: selected
                  ? Container(width: 12, height: 12, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.grad1))
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: const TextStyle(color: AppColors.uiHeading, fontSize: 18, fontFamily: AppFonts.heading, fontWeight: FontWeight.w500, height: 1.3),
                  ),
                  if (option.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      option.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.uiHeadingSmall, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
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
