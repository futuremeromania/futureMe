import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';

class LeftLightText extends StatelessWidget {
  const LeftLightText({
    super.key,
    this.content,
    this.width,
    this.color,
    this.fontSize,
    this.fontFamily,
    this.fontWeight,
    this.textAlign,
    this.shrinkWrap = false,
  });

  final String? content;
  final double? width;
  final Color? color;
  final double? fontSize;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  /// When true, sizes to the text itself instead of the default fixed
  /// 345px-wide box. Use this when embedding the text as one item in a
  /// Row alongside other siblings (e.g. an icon) — the fixed-width box
  /// would otherwise force the Row to overflow / throw off centering.
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      content ?? "",
      textAlign: textAlign ?? TextAlign.left,
      style: TextStyle(
        color: color ?? AppColors.uiHeadingSmall /* ui-text-secondary */,
        fontSize: fontSize ?? 16,
        fontFamily: fontFamily ?? AppFonts.body,
        fontWeight: fontWeight ?? FontWeight.w400,
        height: 1.50,
        letterSpacing: -0.16,
      ),
    );
    if (shrinkWrap) return text;
    return SizedBox(width: width ?? 345, child: text);
  }
}
