import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({
    super.key,
    this.width,
    this.content,
    this.textAlign,
    this.color,
    this.fontSize,
    this.fontFamily,
    this.fontWeight,
  });

  final double? width;
  final String? content;
  final TextAlign? textAlign;
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
        textAlign: textAlign ?? TextAlign.center,
        style: TextStyle(
          color: color ?? AppColors.uiHeading /* ui-text-heading */,
          fontSize: fontSize ?? 28,
          fontFamily: fontFamily ?? AppFonts.heading,
          fontWeight: fontWeight ?? FontWeight.w600,
          height: 1.21,
        ),
      ),
    );
  }
}
