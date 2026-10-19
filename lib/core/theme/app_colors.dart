import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const int backgroundValue = 0xFFFEF6F2;
  static const int uiHeadingValue = 0xFF2A0E5D;
  static const int uiHeadingSmallValue = 0xFF6D5D78;
  static const int grad1Value = 0xFF2B0B78;
  static const int containerValue = 0xFF8B7D92;
  static const int borderValue = 0xFFE9DCD7;
  static const int borderStrongValue = 0xFFD8C6D8;
  static const int statusInfoBgValue = 0xFFECEBFA;
  static const int statusInfoFgValue = 0xFF4F4A9E;
  static const int faintValue = 0xffFAF1F8;
  static const int dashboardValue = 0xff211431;
  static const int insightPrimaryBgValue = 0xFFF2ECFF;
  static const int insightPrimaryBorderValue = 0xFFCDBAF4;
  static const int insightPrimaryFgValue = 0xFF3A2384;
  static const int insightWarmBgValue = 0xFFFFF7E8;
  static const int insightWarmBorderValue = 0xFFEBCDA6;
  static const int insightWarmFgValue = 0xFF7A4A00;
  static const int insightSubtleBgValue = 0xFFF6F0F6;
  static const int surfaceHighlightValue = 0xFFFFF3CC;
  static const int successFgValue = 0xFF3F7A5F;
  static const int errorFgValue = 0xFF9F3F63;
  static const int highlightClarityValue = 0xFFFFB600;

  static const Color background = Color(backgroundValue);
  static const Color uiHeading = Color(uiHeadingValue);
  static const Color uiHeadingSmall = Color(uiHeadingSmallValue);
  static const Color grad1 = Color(grad1Value);
  static const Color container = Color(containerValue);
  static const Color border = Color(borderValue);
  static const Color borderStrong = Color(borderStrongValue);
  static const Color statusInfoBg = Color(statusInfoBgValue);
  static const Color statusInfoFg = Color(statusInfoFgValue);
  static const Color faint = Color(faintValue);
  static const Color dashboard = Color(dashboardValue);
  static const Color insightPrimaryBg = Color(insightPrimaryBgValue);
  static const Color insightPrimaryBorder = Color(insightPrimaryBorderValue);
  static const Color insightPrimaryFg = Color(insightPrimaryFgValue);
  static const Color insightWarmBg = Color(insightWarmBgValue);
  static const Color insightWarmBorder = Color(insightWarmBorderValue);
  static const Color insightWarmFg = Color(insightWarmFgValue);
  static const Color insightSubtleBg = Color(insightSubtleBgValue);
  static const Color surfaceHighlight = Color(surfaceHighlightValue);
  static const Color successFg = Color(successFgValue);
  static const Color errorFg = Color(errorFgValue);
  static const Color highlightClarity = Color(highlightClarityValue);

  /// Action/Special Gradient design token.
  static const LinearGradient specialGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF2B0B78), Color(0xFF7F378E), Color(0xFFD35771)],
  );
}
