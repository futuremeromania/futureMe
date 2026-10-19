import 'package:flutter/material.dart';
import 'package:futureme/shared/widgets/left_bold_text.dart';

class CheckIconRow extends StatelessWidget {
  const CheckIconRow({super.key, this.icon, this.text, this.color});

  final IconData? icon;
  final String? text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon ?? Icons.check_circle_outline_outlined,
            color: color ?? const Color(0xFF6D5D78),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: LeftBoldText(content: text),
          ),
        ],
      ),
    );
  }
}
