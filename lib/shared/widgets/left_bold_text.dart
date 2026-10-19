import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/shared/widgets/left_light_text.dart';

class LeftBoldText extends StatelessWidget {
  const LeftBoldText({super.key, this.content, this.color});

  final String? content;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return LeftLightText(
      content: content,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.uiHeadingSmall,
    );
  }
}
