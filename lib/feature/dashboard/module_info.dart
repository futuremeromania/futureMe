import 'package:flutter/material.dart';
import 'package:futureme/core/auth/auth_service.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/data/user_repository.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/core/subscription/subscription_service.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/feature/chat/chat_flow.dart';
import 'package:futureme/feature/dashboard/module1_flow.dart';
import 'package:futureme/feature/dashboard/module2_flow.dart';
import 'package:futureme/feature/dashboard/module3_flow.dart';
import 'package:futureme/feature/dashboard/module4_flow.dart';
import 'package:futureme/feature/dashboard/module5_flow.dart';
import 'package:futureme/feature/dashboard/module_progress.dart';
import 'package:futureme/feature/paywall/pricing_package.dart';
import 'package:futureme/feature/profile/profile_screen.dart';
import 'package:futureme/feature/report/report_screen.dart';
import 'package:futureme/feature/resources/resources_screen.dart';
import 'package:futureme/shared/widgets/app_bottom_nav_bar.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/feature/dashboard/dev_jump_menu.dart';

class _ModuleMeta {
  const _ModuleMeta({
    required this.label,
    required this.icon,
    required this.description,
    required this.startLabel,
    required this.onStart,
    required this.stages,
  });

  /// What a finished module lists under it on the roadmap: each stage's
  /// result and the module's synthesis, all opened read-only. A finished
  /// module can be looked at again, never retaken or edited.
  final List<_StageLink> stages;

  /// Roadmap step label, also used as the dashboard card's headline
  /// (Figma frame 86:1433 uses the same text for both).
  final String label;

  /// Round icon shown on the dashboard card — same as the module's
  /// Introduction screen.
  final String icon;

  /// PLACEHOLDER CONTENT for modules 3-5: Figma only has dedicated
  /// dashboard-card copy for Modules 1 (61:271) and 2 (86:1433). These
  /// are one-sentence paraphrases of each module's own verified
  /// Introduction-screen description, not fabricated new content.
  final String description;
  final String startLabel;
  final void Function(BuildContext) onStart;
}

const List<_ModuleMeta> _modules = [
  _ModuleMeta(
    label: "Cunoaștere & context",
    description:
        "Începem cu câteva întrebări despre tine, ce îți dorești și ce ai vrea să clarifici.",
    icon: AppAssets.m1IntroIcon,
    startLabel: "Începe Modulul 1",
    onStart: startModule1,
    stages: [_StageLink("Reflecțiile tale", openModule1Summary)],
  ),
  _ModuleMeta(
    label: "Profil psihologic & stil decizional",
    description:
        "În acest modul explorezi felul în care gândești, iei decizii și reacționezi în situații diferite.",
    icon: AppAssets.m2IntroIcon,
    startLabel: "Începe Modulul 2",
    onStart: startModule2,
    stages: [
      _StageLink("Etapa 1 · Cum preferi să funcționezi", _m2s1),
      _StageLink("Etapa 2 · Care este personalitatea ta", _m2s2),
      _StageLink("Etapa 3 · Cum gândești", _m2s3),
      _StageLink("Etapa 4 · Cum iei decizii", _m2s4),
      _StageLink("Etapa 5 · Cum reacționezi sub presiune", _m2s5),
      _StageLink("Etapa 6 · Cât control simți că ai", _m2s6),
      _StageLink("Imaginea de ansamblu", openModule2Summary),
    ],
  ),
  _ModuleMeta(
    label: "Interese & vocație",
    description:
        "Descoperi ce activități îți stârnesc curiozitatea și în ce medii te simți mai în largul tău.",
    icon: AppAssets.m3IntroIcon,
    startLabel: "Începe Modulul 3",
    onStart: startModule3,
    stages: [
      _StageLink("Etapa 1 · Ce te atrage", _m3s1),
      _StageLink("Etapa 2 · Preferințe profesionale", _m3s2),
      _StageLink("Etapa 3 · Medii de lucru", _m3s3),
      _StageLink("Imaginea de ansamblu", openModule3Summary),
    ],
  ),
  _ModuleMeta(
    label: "Aptitudini & puncte forte",
    description:
        "Descoperi ce îți vine mai natural și ce puncte forte poți dezvolta mai departe.",
    icon: AppAssets.m4IntroIcon,
    startLabel: "Începe Modulul 4",
    onStart: startModule4,
    stages: [
      _StageLink("Etapa 1 · Puncte forte", _m4s1),
      _StageLink("Etapa 2 · Aptitudini", _m4s2),
      _StageLink("Imaginea de ansamblu", openModule4Summary),
    ],
  ),
  _ModuleMeta(
    label: "Claritate, recomandări & plan",
    description:
        "Punem cap la cap reperele descoperite și conturăm direcții și pași concreți pentru tine.",
    icon: AppAssets.m5IntroIcon,
    startLabel: "Începe Modulul 5",
    onStart: startModule5,
    stages: [
      _StageLink("Imaginea de ansamblu", openModule5Summary),
      _StageLink("Direcții care merită explorate", _m5Directions),
      _StageLink("Impactul AI", _m5AiImpact),
      _StageLink("Recomandări", _m5Recommendations),
      _StageLink("Opțiuni de formare", _m5Training),
      _StageLink("Planul tău", _m5Plan),
      _StageLink("Raportul tău", openModule5Report),
    ],
  ),
];

class _StageLink {
  const _StageLink(this.label, this.open);

  final String label;
  final void Function(BuildContext) open;
}

void _m2s1(BuildContext context) => openModule2StageResult(context, 1);
void _m2s2(BuildContext context) => openModule2StageResult(context, 2);
void _m2s3(BuildContext context) => openModule2StageResult(context, 3);
void _m2s4(BuildContext context) => openModule2StageResult(context, 4);
void _m2s5(BuildContext context) => openModule2StageResult(context, 5);
void _m2s6(BuildContext context) => openModule2StageResult(context, 6);
void _m3s1(BuildContext context) => openModule3StageResult(context, 1);
void _m3s2(BuildContext context) => openModule3StageResult(context, 2);
void _m3s3(BuildContext context) => openModule3StageResult(context, 3);
void _m4s1(BuildContext context) => openModule4StageResult(context, 1);
void _m4s2(BuildContext context) => openModule4StageResult(context, 2);
void _m5Directions(BuildContext context) =>
    openModule5Screen(context, Module5Screen.directions);
void _m5AiImpact(BuildContext context) =>
    openModule5Screen(context, Module5Screen.aiImpact);
void _m5Recommendations(BuildContext context) =>
    openModule5Screen(context, Module5Screen.recommendations);
void _m5Training(BuildContext context) =>
    openModule5Screen(context, Module5Screen.training);
void _m5Plan(BuildContext context) =>
    openModule5Screen(context, Module5Screen.plan);

class ModuleInfo extends StatefulWidget {
  const ModuleInfo({super.key});
  @override
  State<ModuleInfo> createState() => ModuleInfoState();
}

class ModuleInfoState extends State<ModuleInfo> {
  /// null while the entitlement check is in flight — the nudge banner is
  /// only shown once we know for sure the user hasn't paid, to avoid a
  /// flash of it on every dashboard load.
  bool? _hasAccess;

  /// First name for the greeting, from the profile's `displayName` (set at
  /// signup from PendingSignupData.firstName). null while loading, or when
  /// the account has no name on it — the greeting drops the name rather
  /// than showing a placeholder.
  String? _firstName;

  /// The finished module whose stages are open on the roadmap, if any.
  int? _expandedModule;

  @override
  void initState() {
    super.initState();
    ModuleProgress.hydrate().then((_) {
      if (mounted) setState(() {});
    });
    _loadProfile();
  }

  /// One read of `users/{uid}` covering both the greeting and the paywall
  /// gate — these used to be two separate fetches of the same document.
  Future<void> _loadProfile() async {
    final user = getIt<AuthService>().currentUser;
    final uid = user?.uid;
    if (uid == null) return;

    final subscriptionService = getIt<SubscriptionService>();
    await subscriptionService.logIn(uid);

    final profile = await getIt<UserRepository>().fetchProfile(uid);
    final status = (profile?['subscription'] as Map?)?['status'];
    var hasAccess = status == 'active' || status == 'active_unverified';
    if (!hasAccess) {
      hasAccess = await subscriptionService.hasActiveEntitlement();
    }

    // Social sign-in returns a full name; the greeting only wants the
    // first word of it.
    final displayName =
        (profile?['displayName'] as String?) ?? user?.displayName;
    final firstName = displayName?.trim().split(RegExp(r'\s+')).firstOrNull;

    if (mounted) {
      setState(() {
        _hasAccess = hasAccess;
        _firstName = (firstName != null && firstName.isNotEmpty)
            ? firstName
            : null;
      });
    }
  }

  /// A new run is a fresh purchase, so this always goes through the
  /// paywall — the finished journey's results stay readable either way.
  void _startNewAssessment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PricingPackage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completed = ModuleProgress.completedModules;
    final isComplete = ModuleProgress.isAllComplete;
    final currentIndex = isComplete
        ? 4
        : completed; // 0-based index into _modules

    return Scaffold(
      floatingActionButton: const DevJumpButton(),
      bottomNavigationBar: AppBottomNavBar(
        onHomeTap: () {},
        onChatTap: () => openChat(context),
        onReportTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReportScreen()),
        ),
        onResourcesTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ResourcesScreen()),
        ),
        onProfileTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        ),
      ),
      backgroundColor: AppColors.background,
      // The greeting sat directly under the status bar and the Dynamic
      // Island; the bottom bar handles its own inset, so only the top is
      // taken here.
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
            decoration: const BoxDecoration(color: AppColors.background),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageTitle(
                  content: _firstName != null ? "Bună, $_firstName" : "Bună",
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8),
                if (_hasAccess == false) ...[
                  const _SubscriptionNudgeBanner(),
                  const SizedBox(height: 20),
                ],
                Text(
                  isComplete
                      ? "Ai încheiat parcursul FutureMe. Poți reveni oricând la rezultatele și reperele descoperite."
                      : "Mergem pas cu pas. Nu trebuie să ai toate răspunsurile de la început.",
                  style: const TextStyle(
                    color: AppColors.uiHeadingSmall,
                    fontSize: 16,
                    fontFamily: AppFonts.body,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                _ModuleCard(currentIndex: currentIndex, isComplete: isComplete),
                const SizedBox(height: 24),
                const Text(
                  "Parcursul tău FutureMe",
                  style: TextStyle(
                    color: AppColors.uiHeading,
                    fontSize: 20,
                    fontFamily: AppFonts.heading,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                for (int i = 0; i < _modules.length; i++) ...[
                  _RoadmapStepStatus(
                    label: _modules[i].label,
                    state: i < completed
                        ? _StepState.completed
                        : (i == completed && !isComplete)
                        ? _StepState.available
                        : (isComplete
                              ? _StepState.completed
                              : _StepState.upcoming),
                    expanded: _expandedModule == i,
                    onTap: i < completed
                        ? () => setState(
                            () => _expandedModule = _expandedModule == i
                                ? null
                                : i,
                          )
                        : null,
                  ),
                  if (_expandedModule == i && i < completed)
                    _StageList(stages: _modules[i].stages),
                ],
                if (isComplete) ...[
                  const SizedBox(height: 24),
                  _NewAssessmentCard(
                    onStart: () => _startNewAssessment(context),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.currentIndex, required this.isComplete});

  final int currentIndex;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    final module = _modules[currentIndex];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.faint,
        border: Border.all(color: AppColors.borderStrong),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderStrong),
                  image: DecorationImage(
                    image: AssetImage(module.icon),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isComplete
                          ? "Parcurs finalizat"
                          : "Modulul ${currentIndex + 1}",
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w500,
                        height: 1.375,
                      ),
                    ),
                    Text(
                      isComplete
                          ? "Ai acum o imagine mai clară despre tine"
                          : module.label,
                      style: const TextStyle(
                        color: AppColors.uiHeading,
                        fontSize: 24,
                        fontFamily: AppFonts.heading,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isComplete
                          ? "Ai descoperit cum funcționezi, ce te atrage, care sunt punctele tale forte și ce direcții merită explorate mai departe."
                          : module.description,
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 14,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                isComplete ? "100%" : "0%",
                style: const TextStyle(
                  color: AppColors.grad1,
                  fontSize: 16,
                  fontFamily: AppFonts.body,
                  fontWeight: FontWeight.w500,
                  height: 1.375,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                "completat",
                style: TextStyle(
                  color: AppColors.uiHeadingSmall,
                  fontSize: 14,
                  fontFamily: AppFonts.body,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(9999),
            ),
            clipBehavior: Clip.antiAlias,
            child: isComplete
                ? const DecoratedBox(
                    decoration: BoxDecoration(color: AppColors.statusInfoFg),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          if (isComplete) ...[
            PrimaryButton(
              content: "Vezi rezultatele tale",
              onpressed: () => openChat(context),
            ),
            const SizedBox(height: 8),
            const Text(
              "Raportul și audio-ul tău ghidat sunt disponibile în secțiunea Raport.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.uiHeadingSmall,
                fontSize: 14,
                fontFamily: AppFonts.body,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ] else
            PrimaryButton(
              content: ModuleProgress.hasResume
                  ? "Continuă Modulul ${currentIndex + 1}"
                  : module.startLabel,
              onpressed: () => module.onStart(context),
            ),
        ],
      ),
    );
  }
}

enum _StepState { completed, available, upcoming }

class _RoadmapStepStatus extends StatelessWidget {
  const _RoadmapStepStatus({
    required this.label,
    required this.state,
    this.expanded = false,
    this.onTap,
  });

  final String label;
  final _StepState state;

  /// Whether this finished module's stage list is open below it.
  final bool expanded;

  /// Set for finished modules: opens or closes their stage list.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (badgeLabel, badgeBg, badgeBorder, badgeFg) = switch (state) {
      _StepState.completed => (
        "Finalizat",
        const Color(0xFFE9F3EE),
        const Color(0xFFB8D7C8),
        const Color(0xFF3F7A5F),
      ),
      _StepState.available => (
        "Disponibil",
        AppColors.statusInfoBg,
        const Color(0xFFC9C6EF),
        AppColors.statusInfoFg,
      ),
      _StepState.upcoming => (null, null, null, null),
    };
    final isMuted = state != _StepState.available;
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: state == _StepState.completed
                  ? AppColors.grad1
                  : Colors.transparent,
              border: state == _StepState.completed
                  ? null
                  : Border.all(color: AppColors.borderStrong),
            ),
            child: state == _StepState.completed
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isMuted ? AppColors.container : AppColors.dashboard,
                fontSize: 16,
                fontFamily: AppFonts.body,
                fontWeight: isMuted ? FontWeight.w400 : FontWeight.w500,
                height: 1.375,
              ),
            ),
          ),
          if (badgeLabel != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: badgeBg,
                border: Border.all(color: badgeBorder!),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(
                badgeLabel,
                style: TextStyle(
                  color: badgeFg,
                  fontSize: 12,
                  fontFamily: AppFonts.body,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ),
          ],
          if (onTap != null) ...[
            const SizedBox(width: 4),
            Icon(
              expanded ? Icons.expand_less : Icons.expand_more,
              size: 20,
              color: AppColors.uiHeadingSmall,
            ),
          ],
        ],
      ),
    );
    return onTap == null
        ? row
        : InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: row,
          );
  }
}

/// A finished module's stages, under its roadmap row: each opens that
/// stage's result read-only.
class _StageList extends StatelessWidget {
  const _StageList({required this.stages});

  final List<_StageLink> stages;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 32, top: 2, bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.faint,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < stages.length; i++) ...[
            if (i > 0)
              const Divider(height: 1, thickness: 1, color: AppColors.border),
            InkWell(
              onTap: () => stages[i].open(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 18,
                      color: AppColors.grad1,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        stages[i].label,
                        style: const TextStyle(
                          color: AppColors.dashboard,
                          fontSize: 14,
                          fontFamily: AppFonts.body,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: AppColors.uiHeadingSmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SubscriptionNudgeBanner extends StatelessWidget {
  const _SubscriptionNudgeBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.faint,
        border: Border.all(color: AppColors.grad1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.statusInfoBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline,
              size: 14,
              color: AppColors.statusInfoFg,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Activează experiența FutureMe",
                  style: TextStyle(
                    color: AppColors.uiHeading,
                    fontSize: 16,
                    fontFamily: AppFonts.body,
                    fontWeight: FontWeight.w500,
                    height: 1.375,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Plătești o singură dată pentru acces complet la module, chat AI și raportul final.",
                  style: TextStyle(
                    color: AppColors.uiHeadingSmall,
                    fontSize: 14,
                    fontFamily: AppFonts.body,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PricingPackage(),
                    ),
                  ),
                  child: const Text(
                    "Vezi detalii",
                    style: TextStyle(
                      color: AppColors.grad1,
                      fontSize: 14,
                      fontFamily: AppFonts.body,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shown once the journey is finished. A second run is a second purchase,
/// so this card sells rather than just offering a reset — the finished
/// results stay available regardless of whether the user buys again.
class _NewAssessmentCard extends StatelessWidget {
  const _NewAssessmentCard({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borderStrong),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderStrong),
                  image: const DecorationImage(
                    image: AssetImage(AppAssets.moduleIcon),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Vrei să parcurgi FutureMe din nou?",
                      style: TextStyle(
                        color: AppColors.uiHeading,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w500,
                        height: 1.375,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Poți începe o nouă evaluare și vei primi un nou raport personalizat.",
                      style: TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 14,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppColors.statusInfoBg,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            size: 10,
                            color: AppColors.statusInfoFg,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            "Rezultatele de acum rămân disponibile în secțiunea Raport.",
                            style: TextStyle(
                              color: AppColors.statusInfoFg,
                              fontSize: 12,
                              fontFamily: AppFonts.body,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onStart,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.faint,
                border: Border.all(color: AppColors.grad1),
                borderRadius: BorderRadius.circular(100),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Începe o nouă evaluare – 249 lei",
                style: TextStyle(
                  color: AppColors.grad1,
                  fontSize: 16,
                  fontFamily: AppFonts.body,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
