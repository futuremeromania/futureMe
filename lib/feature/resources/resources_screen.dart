import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/feature/chat/chat_flow.dart';
import 'package:futureme/feature/dashboard/dashboard_navigation.dart';
import 'package:futureme/feature/profile/profile_screen.dart';
import 'package:futureme/feature/report/report_screen.dart';
import 'package:futureme/shared/widgets/app_bottom_nav_bar.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/page_title.dart';

/// Bottom-nav "Resurse" tab. A small static library: how to get the most
/// out of FutureMe, where to turn for support, and what to do after the
/// parcurs. There is no resources backend — this content is fixed.
class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  static const List<_ResourceGroup> _groups = [
    _ResourceGroup(
      title: "Cum folosești FutureMe",
      items: [
        _ResourceItem(
          icon: Icons.route_outlined,
          title: "Parcurge modulele în ritmul tău",
          body:
              "Fiecare modul este împărțit în etape scurte. Progresul se salvează automat, așa că poți relua oricând de unde ai rămas.",
        ),
        _ResourceItem(
          icon: Icons.lightbulb_outline,
          title: "Feedbackul este un reper, nu o etichetă",
          body:
              "După fiecare etapă primești o interpretare orientativă a răspunsurilor tale. Nu este un diagnostic și nu te definește.",
        ),
        _ResourceItem(
          icon: Icons.chat_bubble_outline,
          title: "Folosește chat-ul când vrei să clarifici ceva",
          body:
              "Poți relua în chat orice feedback sau răspuns și poți cere explicații suplimentare, în cuvinte simple.",
        ),
      ],
    ),
    _ResourceGroup(
      title: "Dacă ai nevoie de sprijin",
      items: [
        _ResourceItem(
          icon: Icons.volunteer_activism_outlined,
          title: "Vorbește cu un specialist",
          body:
              "FutureMe nu înlocuiește discuția cu un psiholog sau consilier. Dacă treci printr-o perioadă grea, caută sprijin de specialitate.",
        ),
        _ResourceItem(
          icon: Icons.phone_outlined,
          title: "Telefonul Copilului: 116 111",
          body: "Linie gratuită și confidențială pentru copii și tineri, disponibilă non-stop.",
        ),
        _ResourceItem(
          icon: Icons.emergency_outlined,
          title: "Urgențe: 112",
          body: "Dacă tu sau cineva din jur este în pericol imediat, sună la 112.",
        ),
      ],
    ),
    _ResourceGroup(
      title: "După parcurs",
      items: [
        _ResourceItem(
          icon: Icons.science_outlined,
          title: "Testează o direcție înainte să alegi",
          body:
              "Un proiect mic, un curs scurt sau o conversație cu cineva din domeniu îți arată mai clar dacă o direcție ți se potrivește.",
        ),
        _ResourceItem(
          icon: Icons.family_restroom_outlined,
          title: "Vorbește cu părinții despre ce ai descoperit",
          body:
              "Raportul tău poate fi un punct de pornire pentru o discuție despre opțiuni, fără presiunea unei decizii finale.",
        ),
        _ResourceItem(
          icon: Icons.description_outlined,
          title: "Recitește raportul când ai nevoie",
          body: "Reperele tale rămân disponibile în secțiunea Raport și pot fi reluate oricând.",
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: AppBottomNavBar(
        activeIndex: 3,
        onHomeTap: () => goToDashboard(context),
        onChatTap: () => openChat(context),
        onReportTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ReportScreen()),
        ),
        onProfileTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const PageTitle(content: "Resurse", textAlign: TextAlign.left),
                    const SizedBox(height: 8),
                    const Text(
                      "Câteva repere care te ajută să folosești FutureMe și să mergi mai departe.",
                      style: TextStyle(color: AppColors.uiHeadingSmall, fontSize: 16, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    for (final group in _groups) ...[
                      Text(
                        group.title,
                        style: const TextStyle(color: AppColors.uiHeading, fontSize: 18, fontFamily: AppFonts.heading, fontWeight: FontWeight.w600, height: 1.25),
                      ),
                      const SizedBox(height: 12),
                      for (final item in group.items) ...[
                        _ResourceCard(item: item),
                        const SizedBox(height: 12),
                      ],
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResourceGroup {
  const _ResourceGroup({required this.title, required this.items});

  final String title;
  final List<_ResourceItem> items;
}

class _ResourceItem {
  const _ResourceItem({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;
}

class _ResourceCard extends StatelessWidget {
  const _ResourceCard({required this.item});

  final _ResourceItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.borderStrong)),
            child: Icon(item.icon, size: 20, color: AppColors.uiHeading),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(color: AppColors.uiHeading, fontSize: 16, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.375),
                ),
                const SizedBox(height: 4),
                Text(
                  item.body,
                  style: const TextStyle(color: AppColors.uiHeadingSmall, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
