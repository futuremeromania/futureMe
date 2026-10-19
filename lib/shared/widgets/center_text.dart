import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';

class CenterText extends StatelessWidget {
  const CenterText({
    super.key,
    this.content,
    this.width,
    this.color,
    this.fontSize,
    this.fontFamily,
    this.fontWeight,
  });

  final String? content;
  final double? width;
  final Color? color;
  final double? fontSize;
  final String? fontFamily;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 345,
      child: Text(
        content ?? "",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color ?? AppColors.uiHeadingSmall /* ui-text-secondary */,
          fontSize: fontSize ?? 16,
          fontFamily: fontFamily ?? AppFonts.body,
          fontWeight: fontWeight ?? FontWeight.w400,
          height: 1.50,
          letterSpacing: -0.16,
        ),
      ),
    );
  }
}
