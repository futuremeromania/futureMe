import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.content,
    this.width,
    this.contentPadding,
    this.onpressed,
    this.color,
    this.borderRadius,
    this.fontSize,
    this.textColor,
    this.gradient,
    this.trailingIcon,
  });

  final String? content;
  final double? width;
  final EdgeInsets? contentPadding;
  final VoidCallback? onpressed;
  final Color? color;
  final BorderRadius? borderRadius;
  final double? fontSize;
  final Color? textColor;

  /// Overrides [color] when set. Matches the design system's
  /// "Action/Special Gradient" token (#2b0b78 -> #7f378e -> #d35771).
  final Gradient? gradient;

  /// An optional icon after the label (e.g. an arrow).
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    // Never wider than the space it is given, and the label wraps onto a
    // second line instead of running past the button's edges when it is
    // longer than one line ("Continuă cu Tiparele emoționale").
    return LayoutBuilder(
      builder: (context, constraints) {
        final preferred = width ?? 345;
        final buttonWidth = constraints.hasBoundedWidth && constraints.maxWidth < preferred ? constraints.maxWidth : preferred;
        return GestureDetector(
          onTap: onpressed ?? () {},
          child: Container(
            width: buttonWidth,
            padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: ShapeDecoration(
              color: gradient == null ? (color ?? const Color(0xFF2B0B78) /* ui-action-primary */) : null,
              gradient: gradient,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(100),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    content ?? "",
                    textAlign: TextAlign.center,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor ?? Colors.white /* ui-text-inverse */,
                      fontSize: fontSize ?? 16,
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                    ),
                  ),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 12),
                  Icon(trailingIcon, size: 22, color: textColor ?? Colors.white),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
