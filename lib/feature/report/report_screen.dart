import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:futureme/core/auth/auth_service.dart';
import 'package:futureme/core/data/ai_content_repository.dart';
import 'package:futureme/core/data/user_repository.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/core/report/report_pdf_actions.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/feature/chat/chat_flow.dart';
import 'package:futureme/feature/dashboard/dashboard_navigation.dart';
import 'package:futureme/feature/dashboard/module_progress.dart';
import 'package:futureme/feature/dashboard/module5/module5_report_preview_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_audio_message_screen.dart';
import 'package:futureme/feature/profile/profile_screen.dart';
import 'package:futureme/feature/resources/resources_screen.dart';
import 'package:futureme/shared/widgets/app_bottom_nav_bar.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

/// Bottom-nav "Raport" tab. A hub for the FutureMe final report: locked
/// until all 5 modules are done, then the report, its PDF and the guided
/// audio. The report document is watched live, so one still being generated
/// on the server appears here as soon as it is ready; one that failed (or
/// was never generated) can be requested again from here.
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool _loading = true;
  String? _reportStatus;
  DateTime? _startedAt;
  GeneratedReport? _report;
  bool _requesting = false;
  StreamSubscription<Map<String, dynamic>?>? _subscription;

  /// The report's section titles, shown while the report itself isn't ready.
  static const _fallbackSectionTitles = [
    "Introducere",
    "Sinteză rapidă",
    "Profil psihologic și decizional",
    "Interese și vocație",
    "Aptitudini și puncte forte",
    "5 lucruri importante de reținut despre tine",
    "Direcții profesionale recomandate",
    "Impactul AI asupra direcțiilor tale",
    "Opțiuni academice și de formare",
    "Planul tău de pași",
    "Mesaj final",
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    await ModuleProgress.hydrate();
    final uid = getIt<AuthService>().currentUser?.uid;
    if (uid == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    _subscription = getIt<UserRepository>().watchFinalReport(uid).listen(
      (doc) {
        if (!mounted) return;
        final status = doc?['status'] as String?;
        final startedAt = doc?['startedAt'];
        setState(() {
          _reportStatus = status;
          _startedAt = startedAt is Timestamp ? startedAt.toDate() : null;
          _report = status == 'ready' && doc != null ? GeneratedReport.fromMap(doc) : null;
          _loading = false;
        });
      },
      onError: (_) {
        if (mounted) setState(() => _loading = false);
      },
    );
  }

  /// A run the server abandoned (crashed or timed out) stays `generating`;
  /// after 10 minutes it may be requested again.
  bool get _isGenerating =>
      _requesting ||
      (_reportStatus == 'generating' && (_startedAt == null || DateTime.now().difference(_startedAt!) < const Duration(minutes: 10)));

  Future<void> _requestReport() async {
    setState(() => _requesting = true);
    // The watched document reports the outcome; this only starts the run.
    await getIt<AiContentRepository>().requestFinalReport();
    if (mounted) setState(() => _requesting = false);
  }

  String get _userName {
    final user = getIt<AuthService>().currentUser;
    return (user?.displayName?.trim().isNotEmpty ?? false) ? user!.displayName!.trim() : "Contul tău";
  }

  void _openPreview() {
    final report = _report;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Module5ReportPreviewScreen(
          titleLabel: "Raportul tău",
          primaryLabel: "Ascultă audio-ul ghidat",
          chatLabel: "Discută raportul în Chat",
          summary: report?.summary,
          sections: report?.sectionMaps,
          onDownload: report == null ? null : () => downloadReportPdf(userName: _userName, report: report),
          onShare: report == null ? null : () => shareReportPdf(userName: _userName, report: report),
          onPrimary: () {
            Navigator.pop(context);
            _openGuidedAudio();
          },
          onChat: () => openChat(context),
        ),
      ),
    );
  }

  void _openGuidedAudio() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModuleAudioMessageScreen(
          moduleLabel: "Raport · Audio ghidat",
          title: "Un audio pentru final de drum",
          description:
              "Acesta este audio-ul ghidat care încheie parcursul FutureMe, pentru mai multă claritate și încredere în pașii următori.",
          messageTitle: "Încredere în propriul ritm",
          messageSubtitle: "Un audio ghidat de sub un minut, despre claritate și încredere în propriul ritm.",
          audioAssetPath: "assets/audio/module5_guided.m4a",
          infoNote: "Îl poți asculta oricând. Rămâne disponibil aici, în secțiunea Raport.",
          continueLabel: "Înapoi la raport",
          onContinue: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completed = ModuleProgress.completedModules.clamp(0, 5);
    final ready = ModuleProgress.isAllComplete;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: AppBottomNavBar(
        activeIndex: 2,
        onHomeTap: () => goToDashboard(context),
        onChatTap: () => openChat(context),
        onResourcesTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ResourcesScreen()),
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
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const PageTitle(content: "Raportul tău", textAlign: TextAlign.left),
                          const SizedBox(height: 16),
                          if (!ready)
                            _LockedState(completed: completed)
                          else
                            _ReadyState(
                              sectionTitles: _report != null ? [for (final s in _report!.sections) s.title] : _fallbackSectionTitles,
                              state: _report != null
                                  ? _ReportState.ready
                                  : _isGenerating
                                      ? _ReportState.generating
                                      : _ReportState.missing,
                              onGenerate: _requestReport,
                              onOpenPreview: _openPreview,
                              onOpenAudio: _openGuidedAudio,
                              onChat: () => openChat(context),
                            ),
                          const SizedBox(height: 24),
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

class _LockedState extends StatelessWidget {
  const _LockedState({required this.completed});

  final int completed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.faint,
            border: Border.all(color: AppColors.borderStrong),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lock_outline, size: 28, color: AppColors.uiHeadingSmall),
              const SizedBox(height: 12),
              const Text(
                "Raportul se deblochează la final",
                style: TextStyle(color: AppColors.uiHeading, fontSize: 18, fontFamily: AppFonts.heading, fontWeight: FontWeight.w600, height: 1.25),
              ),
              const SizedBox(height: 8),
              const Text(
                "Raportul tău personalizat adună tot ce descoperi în cele 5 module. Îl poți vedea după ce termini Modulul 5.",
                style: TextStyle(color: AppColors.uiHeadingSmall, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
              ),
              const SizedBox(height: 16),
              Text(
                "$completed din 5 module finalizate",
                style: const TextStyle(color: AppColors.dashboard, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.5),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(9999),
                child: LinearProgressIndicator(
                  value: completed / 5,
                  minHeight: 8,
                  backgroundColor: AppColors.border,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.statusInfoFg),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          content: "Continuă parcursul",
          onpressed: () => goToDashboard(context),
        ),
      ],
    );
  }
}

enum _ReportState { ready, generating, missing }

class _ReadyState extends StatelessWidget {
  const _ReadyState({
    required this.sectionTitles,
    required this.state,
    required this.onGenerate,
    required this.onOpenPreview,
    required this.onOpenAudio,
    required this.onChat,
  });

  final List<String> sectionTitles;
  final _ReportState state;
  final VoidCallback onGenerate;
  final VoidCallback onOpenPreview;
  final VoidCallback onOpenAudio;
  final VoidCallback onChat;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.specialGradient,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(999)),
                child: const Text(
                  "Raport personalizat",
                  style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.4),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Raportul tău FutureMe",
                style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: AppFonts.heading, fontWeight: FontWeight.w600, height: 1.2),
              ),
              const SizedBox(height: 8),
              const Text(
                "Dezvoltă mai pe larg rezultatele din aplicație, cu explicații, recomandări și un plan la care poți reveni oricând.",
                style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ce conține",
                style: TextStyle(color: AppColors.uiHeading, fontSize: 16, fontFamily: AppFonts.heading, fontWeight: FontWeight.w500, height: 1.25),
              ),
              const SizedBox(height: 12),
              for (final title in sectionTitles) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.grad1)),
                        child: const Icon(Icons.check, size: 10, color: AppColors.grad1),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(color: AppColors.dashboard, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
            ],
          ),
        ),
        if (state != _ReportState.ready) ...[
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: AppColors.statusInfoBg, shape: BoxShape.circle),
                child: state == _ReportState.generating
                    ? const SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.statusInfoFg))
                    : const Icon(Icons.info_outline, size: 12, color: AppColors.statusInfoFg),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  state == _ReportState.generating
                      ? "Raportul tău se generează. Poate dura câteva minute; apare aici automat când este gata."
                      : "Raportul tău nu a fost generat încă. Îl poți genera acum.",
                  style: const TextStyle(color: AppColors.statusInfoFg, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 24),
        if (state == _ReportState.missing)
          PrimaryButton(content: "Generează raportul", onpressed: onGenerate)
        else
          PrimaryButton(content: "Vezi raportul", onpressed: onOpenPreview),
        const SizedBox(height: 8),
        _SecondaryButton(icon: Icons.headphones_outlined, label: "Ascultă audio-ul ghidat", onTap: onOpenAudio),
        const SizedBox(height: 8),
        _SecondaryButton(icon: Icons.chat_bubble_outline, label: "Discută raportul în Chat", onTap: onChat),
      ],
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(border: Border.all(color: AppColors.grad1), borderRadius: BorderRadius.circular(100)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: AppColors.grad1),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: AppColors.grad1, fontSize: 16, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.25),
            ),
          ],
        ),
      ),
    );
  }
}
