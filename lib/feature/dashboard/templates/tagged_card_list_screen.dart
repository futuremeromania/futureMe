import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

enum CardPillTone { primary, warm, subtle }

/// One "Ce poți explora" / "Ce rămâne valoros" / "Exemple" card (Figma
/// frames 317:1908, 323:1807, 330:1934, Module 5 only). [pillLabel] is
/// omitted on cards that don't carry a match/impact indicator (e.g.
/// Training).
class TaggedCard {
  const TaggedCard({
    required this.title,
    required this.description,
    required this.tags,
    this.pillLabel,
    this.pillTone,
  });

  final String? pillLabel;
  final CardPillTone? pillTone;
  final String title;
  final String description;
  final List<String> tags;
}

/// Shared layout for Module 5's "tagged card list" screens — Directions,
/// AI Impact and Training. Each shows a module header, then a stack of
/// bordered cards with an optional tone pill, title, description and a
/// wrapped list of tag chips under a shared [tagsLabel].
class TaggedCardListScreen extends StatelessWidget {
  const TaggedCardListScreen({
    super.key,
    required this.moduleLabel,
    required this.title,
    required this.description,
    required this.cards,
    required this.tagsLabel,
    required this.infoNote,
    required this.continueLabel,
    required this.onContinue,
  });

  final String moduleLabel;
  final String title;
  final String description;
  final List<TaggedCard> cards;
  final String tagsLabel;
  final String infoNote;
  final String continueLabel;
  final VoidCallback onContinue;

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
                        color: AppColors.uiHeadingSmall,
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
                        color: AppColors.uiHeading,
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
                        color: AppColors.uiHeadingSmall,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        letterSpacing: -0.16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    for (final card in cards) ...[
                      _TaggedCardTile(card: card, tagsLabel: tagsLabel),
                      const SizedBox(height: 16),
                    ],
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
              child: PrimaryButton(
                content: continueLabel,
                onpressed: onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaggedCardTile extends StatelessWidget {
  const _TaggedCardTile({required this.card, required this.tagsLabel});

  final TaggedCard card;
  final String tagsLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borderStrong),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (card.pillLabel != null) ...[
            _Pill(
              label: card.pillLabel!,
              tone: card.pillTone ?? CardPillTone.subtle,
            ),
            const SizedBox(height: 16),
          ],
          Text(
            card.title,
            style: const TextStyle(
              color: AppColors.uiHeading,
              fontSize: 20,
              fontFamily: AppFonts.heading,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            card.description,
            style: const TextStyle(
              color: AppColors.uiHeadingSmall,
              fontSize: 14,
              fontFamily: AppFonts.body,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          // No examples, no "Exemple:" label left hanging on its own.
          if (card.tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              tagsLabel,
              style: const TextStyle(
                color: AppColors.uiHeading,
                fontSize: 14,
                fontFamily: AppFonts.body,
                fontWeight: FontWeight.w500,
                height: 1.29,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final tag in card.tags)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: AppColors.container,
                        fontSize: 12,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.tone});

  final String label;
  final CardPillTone tone;

  @override
  Widget build(BuildContext context) {
    final (bg, border, fg) = switch (tone) {
      CardPillTone.primary => (
        AppColors.insightPrimaryBg,
        AppColors.insightPrimaryBorder,
        AppColors.insightPrimaryFg,
      ),
      CardPillTone.warm => (
        AppColors.insightWarmBg,
        AppColors.insightWarmBorder,
        AppColors.insightWarmFg,
      ),
      CardPillTone.subtle => (
        AppColors.insightSubtleBg,
        AppColors.borderStrong,
        AppColors.uiHeadingSmall,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontFamily: AppFonts.body,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
      ),
    );
  }
}
