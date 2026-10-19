import 'dart:async';

import 'package:futureme/core/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:futureme/core/auth/auth_service.dart';
import 'package:futureme/core/data/ai_content_repository.dart';
import 'package:futureme/core/data/module_progress_repository.dart';
import 'package:futureme/core/data/user_repository.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/core/report/report_pdf_actions.dart';
import 'package:futureme/feature/chat/chat_flow.dart';
import 'package:futureme/feature/dashboard/dashboard_navigation.dart';
import 'package:futureme/feature/dashboard/module_answers.dart';
import 'package:futureme/feature/dashboard/module5/module5_complete_screen.dart';
import 'package:futureme/feature/dashboard/module_progress.dart';
import 'package:futureme/feature/dashboard/module_resume.dart';
import 'package:futureme/feature/dashboard/stage_result_access.dart';
import 'package:futureme/feature/report/report_screen.dart';
import 'package:futureme/feature/dashboard/module5/module5_plan_screen.dart';
import 'package:futureme/feature/dashboard/module5/module5_direction_choice_screen.dart';
import 'package:futureme/feature/dashboard/module5/module5_report_preview_screen.dart';
import 'package:futureme/feature/dashboard/module5/module5_report_ready_screen.dart';
import 'package:futureme/feature/dashboard/templates/insight_feedback_gate.dart';
import 'package:futureme/feature/dashboard/templates/module_audio_message_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_final_feedback_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_introduction_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_loading_screen.dart';
import 'package:futureme/feature/dashboard/templates/tagged_card_list_screen.dart';
import 'package:futureme/feature/dashboard/module5/app_feedback_screen.dart';

/// Fetches modules 1-4's saved answers for the current user, shaped for a
/// Cloud Function payload (mirrors [InsightFeedbackGate]'s own fetch).
Future<List<Map<String, dynamic>>> _fetchAnswersAcross(
  List<String> moduleIds,
) async {
  final uid = getIt<AuthService>().currentUser?.uid;
  if (uid == null) return const [];
  final repo = getIt<ModuleProgressRepository>();
  final answers = <Map<String, dynamic>>[];
  for (final moduleId in moduleIds) {
    // Tagged with their module: item keys like `stage1_q3` repeat across
    // modules, and the report has to tell Module 1's own words apart from
    // the later results.
    for (final answer in await repo.fetchAnswers(uid, moduleId)) {
      answers.add({...answer, 'moduleId': moduleId});
    }
  }
  return answers;
}

/// Wires the Module 5 screens ("Drumul tău mai departe") into a
/// push-based flow. Module 5 is flat and linear — no stages, no
/// Roadmap — and unlike Modules 1-4 most of its screens are unique
/// layouts (tagged card lists, a plan screen, report screens) rather
/// than the shared question/feedback templates.
///
/// Report Loading 2 (Figma frame 487:2349, "Încă puțin") replaces Report
/// Loading 1 once generation has taken 20 seconds (see
/// [_ReportGenerationGate]).
// Where Module 5 can be resumed (the `stage` of its resume point). Module 5
// has no questions; each step is a screen, and the generated content it
// needs is read back from what the server saved rather than generated again.
const int _m5Profile = 1;
const int _m5Directions = 2;
const int _m5AiImpact = 3;
const int _m5Recommendations = 4;
const int _m5Training = 5;
const int _m5Choice = 6;
const int _m5Plan = 7;
const int _m5AudioMessage = 8;
const int _m5Report = 9;
const int _m5GuidedAudio = 10;

void _saveModule5Step(int step) => saveResumePoint('module5', step, 0);

/// The career plan saved for the current journey, or null.
Future<GeneratedCareerPlan?> _savedCareerPlan() async {
  final uid = getIt<AuthService>().currentUser?.uid;
  if (uid == null) return null;
  try {
    final saved = await getIt<UserRepository>().fetchCareerPlan(uid);
    if (saved == null) return null;
    final plan = GeneratedCareerPlan.fromMap(saved);
    return plan.directions.isEmpty ? null : plan;
  } catch (_) {
    return null;
  }
}

/// Opens Module 5 where the user left off, or at its introduction.
Future<void> startModule5(BuildContext context) async {
  final point = await loadResumePoint('module5');
  if (!context.mounted) return;
  if (point == null || point.stage < _m5Profile) {
    _openModule5Intro(context);
    return;
  }
  await _resumeModule5(context, point.stage);
}

Future<void> _resumeModule5(BuildContext context, int step) async {
  if (step == _m5Profile) {
    _openPersonalProfile(context);
    return;
  }
  if (step <= _m5Plan) {
    final plan = await _savedCareerPlan();
    if (!context.mounted) return;
    if (plan == null) {
      // Nothing saved to show: build the directions again.
      _openCareerPlanGate(context);
      return;
    }
    switch (step) {
      case _m5Directions:
        _openDirections(context, plan);
      case _m5AiImpact:
        _openAiImpact(context, plan);
      case _m5Recommendations:
        _openRecommendations(context, plan);
      case _m5Training:
        _openTraining(context, plan);
      case _m5Choice:
        _openDirectionChoice(context, plan);
      default:
        if (plan.plan == null) {
          _openDirectionChoice(context, plan);
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => _planScreen(context, plan)));
        }
    }
    return;
  }
  if (step == _m5AudioMessage) {
    _openAudioMessage(context);
    return;
  }
  if (step == _m5Report) {
    // A report already generated is opened, not generated again.
    final uid = getIt<AuthService>().currentUser?.uid;
    Map<String, dynamic>? doc;
    try {
      doc = uid == null ? null : await getIt<UserRepository>().fetchFinalReport(uid);
    } catch (_) {
      doc = null;
    }
    if (!context.mounted) return;
    if (doc != null && doc['status'] == 'ready') {
      final report = GeneratedReport.fromMap(doc);
      openOverPlaceholder(context, (ctx) => _openReportReady(ctx, report));
    } else {
      _openReportLoading(context);
    }
    return;
  }
  _openGuidedAudio(context);
}

void _openModule5Intro(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Modulul 5",
        icon: AppAssets.m5IntroIcon,
        moduleTitle: "Drumul tău mai departe",
        description:
            "Până acum ai descoperit repere importante despre tine: ce îți dorești, cum funcționezi, ce te atrage și ce puncte forte se văd mai clar. Acum le punem împreună, ca să vezi ce direcții și pași concreți pot avea sens pentru tine.",
        richNextSteps: const [
          ConnectionItem(
            icon: Icons.dashboard_outlined,
            title: "Imagine de ansamblu",
            description: "Punem împreună reperele din modulele parcurse.",
          ),
          ConnectionItem(
            icon: Icons.explore_outlined,
            title: "Direcții și recomandări",
            description:
                "Vezi ce opțiuni merită explorate și ce te poate ajuta să alegi mai clar.",
          ),
          ConnectionItem(
            icon: Icons.description_outlined,
            title: "Planul și raportul tău",
            description:
                "Încheiem cu pași practici și un raport pe care îl poți reciti oricând.",
          ),
        ],
        continueLabel: "Vezi imaginea de ansamblu",
        progressNote:
            "Nu trebuie să decizi totul acum. Modulul acesta te ajută să vezi mai clar ce merită explorat în continuare.",
        onContinue: () {
          markModuleStarted('module5');
          _openPersonalProfile(context);
        },
      ),
    ),
  );
}

void _openPersonalProfile(BuildContext context, {bool readOnly = false}) {
  if (!readOnly) _saveModule5Step(_m5Profile);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => InsightFeedbackGate(
        scope: 'module5_synthesis',
        moduleId: 'module1',
        readOnly: readOnly,
        onContinue: _openCareerPlanGate,
        alsoFromModules: const ['module2', 'module3', 'module4'],
        loadingLabel: "Modulul 5 · Imagine de ansamblu",
        builder: (context, insight) => ModuleFinalFeedbackScreen(
          moduleLabel: "Modulul 5 · Imagine de ansamblu",
          title: "Ce se vede când punem totul împreună",
          description:
              "Răspunsurile tale încep să arate cum funcționezi, ce te atrage și ce ai nevoie ca să alegi mai clar.",
          synthesisTitle: "Pe scurt",
          synthesisDescription:
              insight?.profileDescription ??
              "Pari să funcționezi mai bine când ai spațiu să gândești, repere clare și sens în ceea ce faci. Direcțiile care merită explorate par să combine idei, oameni și sens.",
          connectionsTitle: "Reperele tale principale",
          connections: insight != null && insight.items.isNotEmpty
              ? insightToConnectionItems(insight)
              : const [
                  ConnectionItem(
                    icon: Icons.favorite_border,
                    title: "Ce îți dorești acum",
                    description:
                        "Mai multă claritate și un drum care să se simtă potrivit pentru tine, nu doar corect „pe hârtie”.",
                  ),
                  ConnectionItem(
                    icon: Icons.psychology_outlined,
                    title: "Cum funcționezi mai bine",
                    description:
                        "Ai nevoie de timp, sens și repere clare ca să nu te pierzi în prea multe variante.",
                  ),
                  ConnectionItem(
                    icon: Icons.explore_outlined,
                    title: "Ce te atrage",
                    description:
                        "Par să merite explorate zone în care lucrezi cu idei, oameni și înțelegere.",
                  ),
                  ConnectionItem(
                    icon: Icons.star_border,
                    title: "Ce puncte forte se văd",
                    description:
                        "Analiza, comunicarea și organizarea par să fie zone pe care poți construi mai departe.",
                  ),
                ],
          infoNote:
              "Nu este o concluzie finală. Este o imagine de ansamblu care ne ajută să alegem direcții mai potrivite de explorat.",
          continueLabel: readOnly
              ? "Înapoi la parcurs"
              : "Vezi direcțiile de explorat",
          onContinue: readOnly
              ? () => Navigator.pop(context)
              : () => _openCareerPlanGate(context),
        ),
      ),
    ),
  );
}

/// Maps a Claude-generated [GeneratedTaggedCard] to the [TaggedCard] the
/// tagged-card-list screens render.
TaggedCard _toTaggedCard(GeneratedTaggedCard c) => TaggedCard(
  pillLabel: c.pillLabel,
  pillTone: switch (c.pillTone) {
    GeneratedCardTone.primary => CardPillTone.primary,
    GeneratedCardTone.warm => CardPillTone.warm,
    GeneratedCardTone.subtle => CardPillTone.subtle,
    null => null,
  },
  title: c.title,
  description: c.description,
  tags: c.tags,
);

PlanStep _toPlanStep(GeneratedPlanStep s) => PlanStep(
  title: s.title,
  periodLabel: s.periodLabel,
  description: s.description,
  checklist: s.checklist,
);

/// Fetches the per-user career plan (or falls back to null, meaning every
/// downstream screen uses its fixed content), then replaces itself with the
/// Directions screen.
void _openCareerPlanGate(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const _CareerPlanGate()),
  );
}

class _CareerPlanGate extends StatefulWidget {
  const _CareerPlanGate();

  @override
  State<_CareerPlanGate> createState() => _CareerPlanGateState();
}

class _CareerPlanGateState extends State<_CareerPlanGate> {
  @override
  void initState() {
    super.initState();
    _resolve();
  }

  Future<void> _resolve() async {
    GeneratedCareerPlan? plan;
    // Already generated in this run of the module (the user went back past
    // the directions, or left and came back): reuse it, never generate a
    // second, different set.
    final point = await loadResumePoint('module5');
    if (point != null && point.stage >= _m5Directions) {
      plan = await _savedCareerPlan();
      if (plan != null) {
        if (!mounted) return;
        _openDirections(context, plan, replace: true);
        return;
      }
    }
    try {
      final answers = await _fetchAnswersAcross(const [
        'module1',
        'module2',
        'module3',
        'module4',
      ]);
      if (answers.isNotEmpty) {
        plan = await getIt<AiContentRepository>().careerPlan(answers: answers);
      }
    } catch (_) {
      plan = null;
    }
    if (!mounted) return;
    _openDirections(context, plan, replace: true);
  }

  @override
  Widget build(BuildContext context) => const ModuleLoadingScreen(
    moduleLabel: "Modulul 5 · Direcții",
    title: "Pregătim direcțiile tale",
    description:
        "Punem cap la cap reperele din modulele parcurse. Poate dura un minut sau două.",
    reminderText: "Acestea sunt puncte de pornire, nu alegeri finale.",
  );
}

void _openDirections(
  BuildContext context,
  GeneratedCareerPlan? plan, {
  bool replace = false,
  VoidCallback? back,
}) {
  if (back == null) _saveModule5Step(_m5Directions);
  final route = MaterialPageRoute(
    builder: (context) => _directionsScreen(context, plan, back: back),
  );
  if (replace) {
    Navigator.pushReplacement(context, route);
  } else {
    Navigator.push(context, route);
  }
}

void _openAiImpact(
  BuildContext context,
  GeneratedCareerPlan? plan, {
  VoidCallback? back,
}) {
  if (back == null) _saveModule5Step(_m5AiImpact);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => _aiImpactScreen(context, plan, back: back),
    ),
  );
}

void _openRecommendations(
  BuildContext context,
  GeneratedCareerPlan? plan, {
  VoidCallback? back,
}) {
  if (back == null) _saveModule5Step(_m5Recommendations);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => _recommendationsScreen(context, plan, back: back),
    ),
  );
}

void _openTraining(
  BuildContext context,
  GeneratedCareerPlan? plan, {
  VoidCallback? back,
}) {
  if (back == null) _saveModule5Step(_m5Training);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => _trainingScreen(context, plan, back: back),
    ),
  );
}

/// The directions shown when no generated plan is available (same titles
/// as the built-in example cards on the Directions screen).
const List<DirectionOption> _fallbackDirectionOptions = [
  DirectionOption(title: "UX / Product Design", description: ""),
  DirectionOption(title: "Psihologie / Consiliere", description: ""),
  DirectionOption(title: "Comunicare & Content", description: ""),
  DirectionOption(title: "Research / Analiză", description: ""),
];

/// The user picks the direction to plan for; the plan is then generated
/// for that direction only (`generateDirectionPlan`).
void _openDirectionChoice(BuildContext context, GeneratedCareerPlan? careerPlan) {
  _saveModule5Step(_m5Choice);
  final options = careerPlan != null && careerPlan.directions.isNotEmpty
      ? [for (final d in careerPlan.directions) DirectionOption(title: d.title, description: d.description)]
      : _fallbackDirectionOptions;
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Module5DirectionChoiceScreen(
        options: options,
        initialTitle: careerPlan?.plan?.directionTitle,
        onChoose: (option) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => _DirectionPlanGate(careerPlan: careerPlan, direction: option)),
        ),
      ),
    ),
  );
}

class _DirectionPlanGate extends StatefulWidget {
  const _DirectionPlanGate({required this.careerPlan, required this.direction});

  final GeneratedCareerPlan? careerPlan;
  final DirectionOption direction;

  @override
  State<_DirectionPlanGate> createState() => _DirectionPlanGateState();
}

class _DirectionPlanGateState extends State<_DirectionPlanGate> {
  @override
  void initState() {
    super.initState();
    _resolve();
  }

  Future<void> _resolve() async {
    final plan = await getIt<AiContentRepository>().directionPlan(directionTitle: widget.direction.title);
    if (!mounted) return;
    if (plan == null) {
      // Back to the choice, which stays as it was; the user can try again.
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(const SnackBar(content: Text("Nu am putut construi planul acum. Încearcă din nou.")));
      return;
    }
    final base = widget.careerPlan;
    final withPlan = base != null
        ? base.withPlan(plan)
        : GeneratedCareerPlan(directions: const [], aiImpact: const [], recommendations: const [], training: const [], plan: plan);
    _saveModule5Step(_m5Plan);
    // Replaces this loading screen; back from the plan returns to the choice.
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => _planScreen(context, withPlan)));
  }

  @override
  Widget build(BuildContext context) => ModuleLoadingScreen(
        moduleLabel: "Modulul 5 • Plan",
        title: "Construim planul tău",
        description: "Transformăm direcția „${widget.direction.title}” în pași concreți, potriviți pentru tine. Durează puțin.",
        reminderText: "Este un plan de explorare, nu un angajament.",
      );
}

void _openAudioMessage(BuildContext context) {
  _saveModule5Step(_m5AudioMessage);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleAudioMessageScreen(
        moduleLabel: "Modulul 5 • Mesaj pentru tine",
        title: "Un moment înainte de raportul tău",
        description:
            "Ai parcurs o etapă importantă. Înainte să vezi raportul tău, ascultă un mesaj scurt care îți amintește că nu trebuie să ai toate răspunsurile acum. Poți merge mai departe, pas cu pas, în ritmul tău.",
        messageTitle: "Mesaj pentru tine",
        messageSubtitle:
            "Un moment scurt de încurajare înainte de raportul tău.",
        videoAssetPath: "assets/videos/final.mp4",
        continueLabel: "Continuă către raport",
        onContinue: () => _openReportLoading(context),
      ),
    ),
  );
}

/// Asks the server to generate the final report and waits for it. The
/// server builds it from the stored results and the Module 5 plan and saves
/// it itself, so if the user leaves this screen the report still reaches the
/// Report tab. After 20 seconds the loading copy switches to "Încă puțin"
/// (Report Loading 2), which says so.
void _openReportLoading(BuildContext context) {
  _saveModule5Step(_m5Report);
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const _ReportGenerationGate()),
  );
}

class _ReportGenerationGate extends StatefulWidget {
  const _ReportGenerationGate();

  @override
  State<_ReportGenerationGate> createState() => _ReportGenerationGateState();
}

class _ReportGenerationGateState extends State<_ReportGenerationGate> {
  bool _slow = false;
  Timer? _slowTimer;

  @override
  void initState() {
    super.initState();
    _slowTimer = Timer(const Duration(seconds: 20), () {
      if (mounted) setState(() => _slow = true);
    });
    _resolve();
  }

  @override
  void dispose() {
    _slowTimer?.cancel();
    super.dispose();
  }

  Future<void> _resolve() async {
    final uid = getIt<AuthService>().currentUser?.uid;
    GeneratedReport? report;
    if (uid != null) {
      try {
        final request = await getIt<AiContentRepository>().requestFinalReport();
        if (request.status == FinalReportRequest.ready) {
          report = request.report;
        } else if (request.status != FinalReportRequest.failed) {
          // Another run is working on it, or this call timed out while the
          // server kept going: wait for the server's copy of the document.
          final doc = await getIt<UserRepository>()
              .watchFinalReport(uid, serverOnly: true)
              .firstWhere((d) => d != null && d['status'] != 'generating')
              .timeout(const Duration(minutes: 10));
          if (doc?['status'] == 'ready') report = GeneratedReport.fromMap(doc!);
        }
      } catch (_) {
        report = null;
      }
    }
    if (!mounted) return;
    _openReportReady(context, report);
  }

  @override
  Widget build(BuildContext context) => _slow
      ? const ModuleLoadingScreen(
          moduleLabel: "Modulul 5 • Raport",
          title: "Încă puțin",
          description:
              "Raportul tău are mai multe părți și durează puțin mai mult. Poți rămâne aici sau poți reveni mai târziu: îl vei găsi în secțiunea Raport.",
          reminderText: "Raportul tău se pregătește...",
        )
      : const ModuleLoadingScreen(
          moduleLabel: "Modulul 5 • Raport",
          title: "Pregătim raportul tău",
          description:
              "Punem cap la cap răspunsurile, direcțiile, recomandările și pașii tăi. Mai durează puțin.",
          reminderText: "Raportul tău se pregătește...",
        );
}

void _openReportReady(BuildContext context, GeneratedReport? report) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => Module5ReportReadyScreen(
        moduleLabel: "Modulul 5 • Raport",
        title: "Raportul tău este gata",
        description:
            "Raportul dezvoltă mai pe larg rezultatele pe care le-ai văzut în aplicație, cu explicații, recomandări și un plan la care poți reveni oricând.",
        achievementTitle: "Raportul tău FutureMe",
        pillLabel: "Raport personalizat • PDF",
        achievementDescription:
            "Profilul tău și stilul decizional, interesele, punctele forte, direcțiile profesionale, impactul AI, opțiunile de formare și planul tău.",
        infoNote:
            "După ce vezi raportul, mai urmează un scurt audio ghidat.",
        continueLabel: "Vezi raportul",
        onContinue: () => _openReportPreview(context, report),
      ),
    ),
  );
}

void _openReportPreview(BuildContext context, GeneratedReport? report) {
  final sections = report?.sectionMaps;
  final userName = getIt<AuthService>().currentUser?.displayName?.trim();
  final displayName = (userName?.isNotEmpty ?? false)
      ? userName!
      : "Contul tău";
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Module5ReportPreviewScreen(
        titleLabel: "Raportul tău",
        primaryLabel: "Ascultă audio-ul ghidat",
        chatLabel: "Discută raportul în Chat",
        summary: report?.summary,
        sections: sections,
        onDownload: report == null
            ? null
            : () => downloadReportPdf(userName: displayName, report: report),
        onShare: report == null
            ? null
            : () => shareReportPdf(userName: displayName, report: report),
        onPrimary: () => _openGuidedAudio(context),
        onChat: () => openChat(context, ignoreCompletionGate: true),
      ),
    ),
  );
}

void _openGuidedAudio(BuildContext context) {
  _saveModule5Step(_m5GuidedAudio);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleAudioMessageScreen(
        moduleLabel: "Modulul 5 • Audio ghidat",
        title: "Un audio pentru final de drum",
        description:
            "Înainte să închei parcursul, îți lăsăm un audio ghidat scurt, care te ajută să privești pașii următori cu mai multă claritate și încredere.",
        messageTitle: "Încredere în propriul ritm",
        messageSubtitle: "Un audio ghidat de sub un minut, despre claritate și încredere în propriul ritm.",
        audioAssetPath: "assets/audio/module5_guided.m4a",
        infoNote:
            "Îl poți asculta acum sau mai târziu. După finalizarea parcursului, îl vei găsi în secțiunea Raport.",
        continueLabel: "Finalizează parcursul",
        onContinue: () => _openModule5Complete(context),
      ),
    ),
  );
}

void _openModule5Complete(BuildContext context) {
  ModuleProgress.markCompleted(5);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => Module5CompleteScreen(
        title: "Parcursul tău FutureMe este complet",
        description:
            "Ai ajuns la final. Acum ai o imagine mai clară despre tine, direcțiile pe care le poți explora și pașii cu care poți începe.",
        continueLabel: "Continuă",
        onContinue: () => _openAppFeedback(context),
      ),
    ),
  );
}

/// The very last screen: three questions about FutureMe itself.
///
/// Placed after the "complete" screen so the journey still ends on its own
/// closing note, and reached by replacing it — once the feedback is behind
/// them, going back to a screen that says they have finished would be a
/// loop with nothing in it.
void _openAppFeedback(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) =>
          AppFeedbackScreen(onDone: () => goToDashboard(context)),
    ),
  );
}

/// Debug-only entry point — see the note in `module4_flow.dart`.
void debugAppFeedback(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          AppFeedbackScreen(onDone: () => Navigator.pop(context)),
    ),
  );
}

/// Reopens this module's synthesis from the dashboard, read-only.
void openModule5Summary(BuildContext context) =>
    _openPersonalProfile(context, readOnly: true);

/// The Module 5 screens that can be reopened from the dashboard.
enum Module5Screen { directions, aiImpact, recommendations, training, plan }

/// Reopens one Module 5 screen read-only, with the career plan the user saw
/// (saved by `generateCareerPlan`). Journeys finished before the plan was
/// saved have none, and get a message instead of the built-in example copy.
void openModule5Screen(BuildContext context, Module5Screen screen) {
  openStageResult<GeneratedCareerPlan>(
    context,
    emptyMessage: screen == Module5Screen.plan
        ? "Pentru acest parcurs nu există încă un plan salvat pentru o direcție aleasă."
        : "Pentru acest parcurs nu au fost salvate direcțiile din Modulul 5.",
    load: (uid) async {
      final saved = await getIt<UserRepository>().fetchCareerPlan(uid);
      if (saved == null) return null;
      final plan = GeneratedCareerPlan.fromMap(saved);
      if (plan.directions.isEmpty) return null;
      // A plan exists only once a direction was chosen.
      if (screen == Module5Screen.plan && plan.plan == null) return null;
      return plan;
    },
    build: (context, plan, back) => switch (screen) {
      Module5Screen.directions => _directionsScreen(context, plan, back: back),
      Module5Screen.aiImpact => _aiImpactScreen(context, plan, back: back),
      Module5Screen.recommendations => _recommendationsScreen(
        context,
        plan,
        back: back,
      ),
      Module5Screen.training => _trainingScreen(context, plan, back: back),
      Module5Screen.plan => _planScreen(context, plan, back: back),
    },
  );
}

/// The Report tab, reached from Module 5's list on the dashboard.
void openModule5Report(BuildContext context) => Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const ReportScreen()),
);

Widget _directionsScreen(
  BuildContext context,
  GeneratedCareerPlan? plan, {
  VoidCallback? back,
}) {
  return TaggedCardListScreen(
    moduleLabel: "Modulul 5 · Direcții",
    title: "Direcții care merită explorate",
    description:
        "Pe baza răspunsurilor tale, se conturează câteva direcții care merită explorate mai departe. Nu sunt alegeri finale, ci puncte de pornire.",
    tagsLabel: "Ce poți explora:",
    cards: plan != null
        // No fit labels, also on plans saved before they were dropped.
        ? [
            for (final d in plan.directions)
              TaggedCard(title: d.title, description: d.description, tags: d.tags),
          ]
        : const [
            TaggedCard(
              title: "UX / Product Design",
              description:
                  "Poate avea sens pentru tine pentru că îmbină analiza, creativitatea și înțelegerea oamenilor. Este o direcție în care poți transforma observațiile în soluții clare și utile.",
              tags: [
                "Interfețe digitale",
                "Prototipare",
                "Experiență de utilizare",
              ],
            ),
            TaggedCard(
              title: "Psihologie / Consiliere",
              description:
                  "Poate fi o direcție potrivită dacă te atrage să înțelegi oamenii, să asculți cu atenție și să oferi sprijin într-un mod structurat și empatic.",
              tags: [
                "Consiliere",
                "Orientare vocațională",
                "Psihologie educațională",
                "Suport emoțional",
              ],
            ),
            TaggedCard(
              title: "Comunicare & Content",
              description:
                  "Poate avea sens dacă îți place să explici idei, să creezi mesaje clare și să dai formă unor lucruri care pentru alții par greu de pus în cuvinte.",
              tags: [
                "Content writing",
                "Storytelling",
                "Social media",
                "Strategie de comunicare",
              ],
            ),
            TaggedCard(
              title: "Research / Analiză",
              description:
                  "Poate deveni o direcție bună dacă îți place să înțelegi lucrurile în profunzime, să observi tipare și să lucrezi cu informații înainte de a trage concluzii.",
              tags: [
                "User research",
                "Analiză de date",
                "Cercetare",
                "Strategie",
              ],
            ),
            TaggedCard(
              title: "Educație / Training",
              description:
                  "Poate avea sens dacă îți place să explici, să ghidezi și să ajuți oamenii să înțeleagă mai ușor lucruri importante pentru ei.",
              tags: [
                "Training",
                "Mentorat",
                "Educație non-formală",
                "Materiale de învățare",
              ],
            ),
          ],
    infoNote:
        "Aceste direcții sunt puncte de pornire. Unele se leagă mai clar de reperele tale de acum, iar altele pot merita explorate mai departe.",
    continueLabel: back != null ? readOnlyBackLabel : "Vezi impactul AI",
    onContinue: back ?? () => _openAiImpact(context, plan),
  );
}

Widget _aiImpactScreen(
  BuildContext context,
  GeneratedCareerPlan? plan, {
  VoidCallback? back,
}) {
  return TaggedCardListScreen(
    moduleLabel: "Modulul 5 • Impactul AI",
    title: "Cum pot evolua aceste direcții",
    description:
        "AI poate schimba o parte din felul în care se lucrează în aceste domenii. Asta nu înseamnă că direcțiile își pierd valoarea, ci că unele abilități pot deveni mai importante în timp.",
    tagsLabel: "Ce rămâne valoros:",
    cards: plan != null
        ? plan.aiImpact.map(_toTaggedCard).toList()
        : const [
            TaggedCard(
              pillLabel: "Impact AI moderat",
              pillTone: CardPillTone.warm,
              title: "UX / Product Design",
              description:
                  "AI poate accelera ideile, wireframe-urile, prototipurile și variantele vizuale. Diferența rămâne în felul în care înțelegi oamenii, clarifici problema și iei decizii de design.",
              tags: [
                "Research",
                "Empatie",
                "Gândire strategică",
                "Decizii de produs",
              ],
            ),
            TaggedCard(
              pillLabel: "Impact AI redus",
              pillTone: CardPillTone.primary,
              title: "Psihologie / Consiliere",
              description:
                  "AI poate susține reflecția sau accesul la informații, dar nu poate înlocui relația umană, ascultarea atentă și responsabilitatea profesională.",
              tags: [
                "Relație umană",
                "Empatie",
                "Etică",
                "Ghidaj personalizat",
              ],
            ),
            TaggedCard(
              pillLabel: "Impact AI moderat",
              pillTone: CardPillTone.warm,
              title: "Comunicare & Content",
              description:
                  "AI poate genera rapid texte, idei și variante de conținut. Direcția rămâne valoroasă când implică strategie, voce autentică și înțelegerea publicului.",
              tags: [
                "Strategie",
                "Storytelling",
                "Voce de brand",
                "Gândire editorială",
              ],
            ),
            TaggedCard(
              pillLabel: "Impact AI moderat",
              pillTone: CardPillTone.warm,
              title: "Research / Analiză",
              description:
                  "AI poate organiza informații, sintetiza date și observa tipare. Valoarea umană rămâne în întrebările bune, interpretare și înțelegerea contextului.",
              tags: [
                "Gândire critică",
                "Interpretare",
                "Structurare",
                "Context",
              ],
            ),
            TaggedCard(
              pillLabel: "Impact AI moderat",
              pillTone: CardPillTone.warm,
              title: "Educație / Training",
              description:
                  "AI poate ajuta la crearea de materiale, exerciții și explicații. Ce rămâne important este felul în care ghidezi oamenii, adaptezi informația și susții învățarea.",
              tags: ["Claritate", "Ghidaj", "Adaptare", "Relație cu oamenii"],
            ),
          ],
    infoNote:
        "Impactul AI nu elimină automat o direcție. Te ajută să vezi ce se poate schimba și ce abilități merită dezvoltate ca să rămâi adaptabil.",
    continueLabel: back != null ? readOnlyBackLabel : "Vezi recomandările tale",
    onContinue: back ?? () => _openRecommendations(context, plan),
  );
}

Widget _recommendationsScreen(
  BuildContext context,
  GeneratedCareerPlan? plan, {
  VoidCallback? back,
}) {
  return TaggedCardListScreen(
    moduleLabel: "Modulul 5 · Recomandări",
    title: "Ce te poate ajuta să alegi mai clar",
    description:
        "Direcțiile conturate pentru tine pot fi mai ușor de explorat când ai câteva repere clare. Aceste recomandări te ajută să vezi ce merită căutat, testat sau evitat mai departe.",
    tagsLabel: "Exemple:",
    cards: plan != null
        ? plan.recommendations
              .map(
                (r) => TaggedCard(
                  title: r.title,
                  description: r.description,
                  tags: r.examples,
                ),
              )
              .toList()
        : const [
            TaggedCard(
              title: "Caută combinația dintre idei, oameni și structură",
              description:
                  "Pentru tine, par să aibă sens direcțiile în care poți lucra cu idei, poți înțelege oamenii și poți construi ceva clar. Rolurile care combină analiza cu partea umană pot fi un punct bun de pornire.",
              tags: ["Un job shadowing de o zi", "Un proiect de voluntariat"],
            ),
            TaggedCard(
              title: "Testează direcțiile înainte să alegi",
              description:
                  "Poate fi mai util să testezi puțin: un proiect mic, un curs scurt sau o conversație cu cineva din domeniu.",
              tags: [
                "Un curs online scurt",
                "O discuție cu cineva din domeniu",
              ],
            ),
            TaggedCard(
              title: "Alege medii cu repere clare",
              description:
                  "Pari să funcționezi mai bine când ai structură, pași clari și suficient timp să înțelegi lucrurile înainte să decizi. Un mediu foarte haotic sau lipsit de direcție s-ar putea să te consume mai mult decât să te ajute.",
              tags: ["Un program de internship", "Un mentor în domeniu"],
            ),
            TaggedCard(
              title: "Construiește pe analiză și comunicare",
              description:
                  "Merită să dezvolți abilități precum research-ul, comunicarea clară și înțelegerea oamenilor.",
              tags: ["Un curs de comunicare", "Un mic proiect de research"],
            ),
            TaggedCard(
              title: "Nu exclude o direcție prea repede",
              description:
                  "Impactul AI nu înseamnă automat că o direcție nu mai merită explorată. Mai important este să vezi ce se schimbă și ce rămâne valoros.",
              tags: [
                "Un articol despre AI în domeniu",
                "O discuție cu un profesionist",
              ],
            ),
            TaggedCard(
              title: "Nu alege doar din presiune",
              description:
                  "Dacă o opțiune pare „corectă” doar pentru că sună sigură, cunoscută sau apreciată de alții, merită verificat dacă se potrivește și cu felul tău de a funcționa. Claritatea apare mai ușor când alegerea are sens și pentru tine.",
              tags: ["O listă cu motivele tale", "O discuție cu un consilier"],
            ),
          ],
    infoNote:
        "Nu trebuie să aplici toate recomandările deodată. Alege una sau două care par cele mai utile acum și folosește-le ca punct de plecare.",
    continueLabel: back != null
        ? readOnlyBackLabel
        : "Vezi opțiunile de formare",
    onContinue: back ?? () => _openTraining(context, plan),
  );
}

Widget _trainingScreen(
  BuildContext context,
  GeneratedCareerPlan? plan, {
  VoidCallback? back,
}) {
  return TaggedCardListScreen(
    moduleLabel: "Modulul 5 • Formare",
    title: "Cum poți începe să te pregătești",
    description:
        "Direcțiile conturate pentru tine pot avea mai multe rute de explorare. Unele pot cere studii mai lungi, iar altele pot fi testate prin cursuri, proiecte, mentorat sau experiență practică.",
    tagsLabel: "Exemple:",
    cards: plan != null
        ? plan.training.map(_toTaggedCard).toList()
        : const [
            TaggedCard(
              title: "Studii universitare",
              description:
                  "Pot fi utile pentru direcțiile care cer o bază academică mai clară, o calificare oficială sau un parcurs profesional reglementat.",
              tags: [
                "Psihologie",
                "Științe cognitive",
                "Comunicare",
                "Design",
                "Educație",
              ],
            ),
            TaggedCard(
              title: "Cursuri & certificări",
              description:
                  "Pot fi o variantă bună dacă vrei să testezi mai rapid o direcție, să înveți o abilitate concretă sau să vezi dacă domeniul ți se potrivește în practică.",
              tags: [
                "UX Design",
                "User Research",
                "Content Strategy",
                "Facilitation",
                "Data Analysis",
              ],
            ),
            TaggedCard(
              title: "Experiență practică",
              description:
                  "Pentru unele direcții, claritatea apare mai ușor când încerci ceva real, chiar la scară mică. Un proiect, un internship sau o conversație cu cineva din domeniu te pot ajuta să înțelegi cum arată munca de zi cu zi.",
              tags: [
                "Portofoliu",
                "Voluntariat",
                "Internship",
                "Mentorat",
                "Proiecte personale",
              ],
            ),
          ],
    infoNote:
        "Nu există o singură rută corectă. Important este să alegi o cale care se potrivește cu ritmul tău, cu resursele tale și cu direcția pe care vrei să o testezi mai întâi.",
    continueLabel: back != null ? readOnlyBackLabel : "Vezi planul tău",
    onContinue: back ?? () => _openDirectionChoice(context, plan),
  );
}

Widget _planScreen(
  BuildContext context,
  GeneratedCareerPlan? careerPlan, {
  VoidCallback? back,
}) {
  final plan = careerPlan?.plan;
  return Module5PlanScreen(
    moduleLabel: "Modulul 5 • Plan",
    title: "Următorii tăi pași",
    description:
        "Ai ales direcția cu care vrei să începi. Acum o transformăm în pași concreți, ușor de urmat.",
    directionLabel: "Direcția de pornire",
    directionTitle: plan?.directionTitle ?? "UX / Product Design",
    directionDescription:
        plan?.directionDescription ??
        "O poți explora treptat fără să o transformi imediat într-o alegere finală.",
    firstStepTitle: plan?.firstStepTitle ?? "Primul pas",
    firstStepDescription:
        plan?.firstStepDescription ??
        "În următoarele 7 zile, uită-te la 2–3 proiecte reale din această direcție. Notează ce te atrage și ce ai vrea să înveți mai departe.",
    planSectionLabel: "Planul tău în 3 etape",
    steps: plan != null
        ? plan.steps.map(_toPlanStep).toList()
        : const [
            PlanStep(
              title: "Explorează",
              periodLabel: "2-4 săptămâni",
              description:
                  "Înțelege cum arată munca reală în această direcție.",
              checklist: [
                "Uită-te la proiecte reale",
                "Caută un curs introductiv",
                "Notează ce te atrage și ce nu simți că ți se potrivește",
              ],
            ),
            PlanStep(
              title: "Testează",
              periodLabel: "1-3 luni",
              description:
                  "Claritatea apare mai ușor când încerci ceva concret.",
            ),
            PlanStep(
              title: "Clarifică",
              periodLabel: "3-6 luni",
              description:
                  "După ce ai testat direcția, uită-te la ce ai observat și decide ce merită continuat.",
            ),
          ],
    infoNote:
        "Planul acesta este un punct de pornire. Îl poți ajusta pe măsură ce descoperi ce ți se potrivește mai bine.",
    continueLabel: back != null ? readOnlyBackLabel : "Ascultă mesajul tău",
    onContinue: back ?? () => _openAudioMessage(context),
  );
}

/// Debug shortcuts into Module 5.
void debugModule5Start(BuildContext context) => _openModule5Intro(context);
void debugModule5Profile(BuildContext context) => _openPersonalProfile(context);
void debugModule5Directions(BuildContext context) => _openCareerPlanGate(context);
void debugModule5Report(BuildContext context) => _openReportLoading(context);
