import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';

class RoundedCard extends StatelessWidget {
  const RoundedCard({
    super.key,
    this.contents,
    this.color,
    this.contentPadding,
    this.borderRadius,
  });

  final List<Widget>? contents;
  final Color? color;
  final EdgeInsets? contentPadding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: ShapeDecoration(
        color: color ?? Colors.white /* ui-surface-card */,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: AppColors.border /* ui-border-default */,
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(14),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x59CFB2A4),
            blurRadius: 8,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(children: contents ?? [const Text("")]),
    );
  }
}
