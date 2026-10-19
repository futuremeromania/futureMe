import 'package:flutter/material.dart';
import 'package:futureme/shared/widgets/link_text.dart';
import 'package:futureme/shared/widgets/rounded_card.dart';

/// Extracted from the duplicated Google/Apple blocks in login.dart.
class SocialSignInButton extends StatelessWidget {
  const SocialSignInButton({super.key, required this.icon, required this.label, this.onPressed, this.isLoading = false});

  final String icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Opacity(
        opacity: onPressed == null && !isLoading ? 0.5 : 1,
        child: RoundedCard(
          contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          contents: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                else
                  Image.asset(icon, width: 24, height: 24),
                const SizedBox(width: 8),
                LinkText(content: label, shrinkWrap: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
