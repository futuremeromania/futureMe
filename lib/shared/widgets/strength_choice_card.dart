import 'package:flutter/material.dart';
import 'package:futureme/core/data/character_strengths.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';

/// A strength the user can tap to select — used both by the tie-break and
/// by the choose-three screen, which ask the same kind of question about
/// the same kind of card.
class StrengthChoiceCard extends StatelessWidget {
  const StrengthChoiceCard({
    super.key,
    required this.dimension,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final StrengthDimension dimension;
  final String description;
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
          border: Border.all(color: selected ? AppColors.grad1 : AppColors.border),
          borderRadius: BorderRadius.circular(16),
          boxShadow: selected ? const [BoxShadow(color: Color(0x59CFB2A4), blurRadius: 4, offset: Offset(0, 4))] : null,
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
                    description,
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
                border: selected ? null : Border.all(color: AppColors.border, width: 2),
              ),
              child: selected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}
