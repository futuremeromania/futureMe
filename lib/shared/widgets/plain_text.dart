import 'package:flutter/material.dart';

class PlainText extends StatelessWidget {
  const PlainText(this.content, {super.key});

  final String? content;

  @override
  Widget build(BuildContext context) {
    return Text(
      content!,
      style: const TextStyle(
        color: Color(0xFF211431) /* ui-text-primary */,
        fontSize: 16,
        fontFamily: 'Rubik',
        fontWeight: FontWeight.w400,
        height: 1.38,
      ),
    );
  }
}
