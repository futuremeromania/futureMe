import 'package:flutter/material.dart';

class TagButton extends StatelessWidget {
  const TagButton({super.key, this.content, this.onTap});

  final String? content;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8,
        children: [
          Text(
            content ?? "",
            style: const TextStyle(
              color: Color(0xFF2B0B78) /* ui-action-secondaryText */,
              fontSize: 16,
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w500,
              height: 1.25,
            ),
          ),
        ],
      ),
      ),
    );
  }
}
