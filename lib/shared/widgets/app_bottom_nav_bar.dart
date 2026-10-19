import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';

/// Figma "Action Buttons" (dashboard bottom bar, e.g. frame 61:271, also
/// reused on the Chat screens) — a custom icon+label row, not a standard
/// Material BottomNavigationBar. A tab with no handler passed is rendered
/// but inert.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    this.activeIndex = 0,
    this.onHomeTap,
    this.onChatTap,
    this.onReportTap,
    this.onResourcesTap,
    this.onProfileTap,
  });

  /// Which item is highlighted (0 = Acasă, 1 = Chat, 2 = Raport, 3 = Resurse, 4 = Profil).
  final int activeIndex;
  final VoidCallback? onHomeTap;
  final VoidCallback? onChatTap;
  final VoidCallback? onReportTap;
  final VoidCallback? onResourcesTap;
  final VoidCallback? onProfileTap;

  static const _items = [
    (icon: Icons.home_outlined, label: "Acasă"),
    (icon: Icons.chat_bubble_outline, label: "Chat"),
    (icon: Icons.description_outlined, label: "Raport"),
    (icon: Icons.menu_book_outlined, label: "Resurse"),
    (icon: Icons.person_outline, label: "Profil"),
  ];

  @override
  Widget build(BuildContext context) {
    final taps = [onHomeTap, onChatTap, onReportTap, onResourcesTap, onProfileTap];
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Color(0x0D251006), blurRadius: 12, offset: Offset(0, -6))],
      ),
      /// Keeps the row clear of the home indicator, and of the rounded
      /// screen corners that were clipping the first and last labels.
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Row(
            children: [
              for (int i = 0; i < _items.length; i++)
                /// Equal-width slots rather than spaceBetween: the outer two
                /// items no longer sit against the screen edge, and a longer
                /// label can't shift the others out of line.
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: taps[i],
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_items[i].icon, size: 24, color: i == activeIndex ? AppColors.grad1 : AppColors.uiHeadingSmall),
                        const SizedBox(height: 4),
                        Text(
                          _items[i].label,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: i == activeIndex ? AppColors.grad1 : AppColors.uiHeadingSmall,
                            fontSize: 13,
                            fontFamily: AppFonts.body,
                            fontWeight: FontWeight.w500,
                            height: 1.23,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}