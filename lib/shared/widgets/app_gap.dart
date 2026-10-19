import 'package:flutter/material.dart';

class AppGap extends StatelessWidget {
  const AppGap({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 20,
      width: width ?? 20,
    );
  }
}
