import 'package:futureme/core/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:futureme/core/auth/auth_service.dart';
import 'package:futureme/core/data/ai_content_repository.dart';
import 'package:futureme/core/data/module_progress_repository.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/feature/dashboard/dashboard_navigation.dart';
import 'package:futureme/feature/dashboard/module_answers.dart';
import 'package:futureme/feature/dashboard/module_resume.dart';
import 'package:futureme/feature/dashboard/templates/module_complete_screen.dart';
import 'package:futureme/feature/dashboard/module_progress.dart';
import 'package:futureme/feature/dashboard/templates/module_feedback_summary_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_introduction_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_loading_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_question_screen.dart';
import 'package:futureme/feature/dashboard/module2_flow.dart';
import 'package:futureme/feature/dashboard/templates/insight_feedback_gate.dart';

/// Wires the Module 1 screens (Figma frames 74:335, 80:408/510/550,
/// 88:521, 86:485) into a single push-based flow, entered from the
/// "Începe Modulul 1" button on the dashboard (ModuleInfo).
///
/// The 3 questions are fixed — everyone is asked the same thing, in the
/// same words, so answers stay comparable and the module reads the same
/// every time. Only the closing feedback is generated per-user by the
/// `generateInsight` Cloud Function ([AiContentRepository]); if that call
/// fails (not deployed, offline, model error) the flow falls back to the
/// fixed summary below, so the module always works.

const String _defaultHint = "Nu trebuie să scrii perfect. Spune doar ce simți.";

/// Recorded closing message for this module, played by the Complete
/// screen's audio card in place of text-to-speech.
const String _completeAudio = "assets/audio/module1_complete.m4a";

const List<GeneratedQuestion> _questions = [
  GeneratedQuestion(
    question: "Ce te-a adus la FutureMe chiar acum?",
    subtitle:
        "Poate fi o întrebare, o neliniște, o curiozitate sau pur și simplu faptul că nu știi încă încotro să mergi.",
    placeholder: "Scrie aici orice îți vine în minte...",
  ),
  GeneratedQuestion(
    question:
        "Dacă aș avea o baghetă magică și ți-aș putea îndeplini o dorință după această experiență, ce ai vrea să se schimbe pentru tine?",
    subtitle:
        "Imaginează-ți că, după FutureMe, lucrurile sunt puțin mai clare. Ce ai vrea să fie diferit pentru tine?",
    placeholder: "Scrie aici ce ai vrea să se schimbe...",
    hint: "Poate fi ceva mic sau ceva important. Scrie cum îți vine.",
  ),
  GeneratedQuestion(
    question:
        "Imaginează-ți că ai ajuns să faci exact ceea ce ți se potrivește",
    subtitle:
        "Nu trebuie să alegi o meserie exactă. Gândește-te la un drum în care te simți bine cu ce faci și cu oamenii din jur.",
    placeholder: "Scrie aici cum ți-ai imagina acest parcurs...",
    hint: "Nu trebuie să fie realist sau perfect. Scrie ce îți vine acum.",
  ),
];

/// Prompts shown under the last question. They're deliberately full
/// questions rather than keywords: the answer we're after is a description
/// of a whole working life, and most people need something concrete to
/// push against before that comes out.
const List<String> _lastQuestionTips = [
  "Ce job ai avea? Ce ai folosi mai mult: gândirea, creativitatea, îndemânarea sau energia fizică? Ai lucra mai mult cu mintea, cu mâinile sau ai prefera o muncă activă, în care să fii în mișcare?",
  "Cum ar fi colegii tăi? Cum v-ați înțelege? Ați lucra mai mult împreună sau fiecare pe cont propriu?",
  "Cum s-ar comporta șefii cu tine? Ți-ar spune exact ce ai de făcut sau ți-ar lăsa libertate? Cum ți-ar vorbi?",
  "Ce ai crede tu despre tine? Cum te-ai vedea ca om? De ce ai fi mândru?",
  "Cum s-ar simți asta în corpul tău și în atitudinea ta? Cum te-ai simți dimineața când mergi la muncă? Cu ce stare te-ai întoarce acasă?",
  "Cum te-ar privi și cum ți s-ar adresa familia și cunoscuții? Ce ai vrea să creadă sau să spună despre tine și despre ceea ce faci?",
];

const List<SummaryItem> _fallbackFeedbackItems = [
  SummaryItem(
    icon: Icons.wb_sunny_outlined,
    title: "Claritate",
    description:
        "Ai început să te gândești la ce ai vrea să înțelegi mai bine.",
  ),
  SummaryItem(
    icon: Icons.autorenew,
    title: "Schimbare",
    description: "Ai numit ce ai vrea să fie diferit pentru tine.",
  ),
  SummaryItem(
    icon: Icons.explore_outlined,
    title: "Direcție",
    description:
        "Ai imaginat un parcurs care s-ar putea simți mai potrivit pentru tine.",
  ),
];

const List<IconData> _insightIcons = [
  Icons.wb_sunny_outlined,
  Icons.autorenew,
  Icons.explore_outlined,
  Icons.psychology_outlined,
];

/// Opens Module 1 at the next unanswered question, or at its introduction.
Future<void> startModule1(BuildContext context) async {
  final point = await loadResumePoint('module1');
  if (!context.mounted) return;
  final answers = point?.answersAs<String>() ?? const <int, String>{};
  if (point != null &&
      point.index > 0 &&
      point.index < _questions.length &&
      answers.length >= point.index) {
    _openQuestion(context, point.index, [
      for (var i = 0; i < point.index; i++) answers[i] ?? '',
    ]);
  } else {
    _openModule1Intro(context);
  }
}

void _openModule1Intro(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Modulul 1",
        icon: AppAssets.m1IntroIcon,
        moduleTitle: "Cunoaștere & context",
        description:
            "Începem cu câteva întrebări simple despre tine: ce te-a adus aici, ce ți-ai dori să se schimbe și ce ai vrea să înțelegi mai clar.",
        nextSteps: const [
          "3 întrebări ghidate",
          "Răspunzi în ritmul tău",
          "Nu există răspunsuri greșite",
        ],
        continueLabel: "Începe Modulul 1",
        onContinue: () {
          markModuleStarted('module1');
          _openQuestion(context, 0, const []);
        },
      ),
    ),
  );
}

void _openQuestion(BuildContext context, int index, List<String> collected) {
  Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (context) {
        final q = _questions[index];
        final isLast = index == _questions.length - 1;
        final questionKey = 'q${index + 1}';
        return ModuleQuestionScreen(
          questionNumber: index + 1,
          totalQuestions: _questions.length,
          question: q.question,
          subtitle: q.subtitle,
          placeholder: q.placeholder,
          hint: q.hint ?? _defaultHint,
          continueLabel: isLast ? "Finalizează modulul" : "Continuă",
          textFieldHeight: isLast ? 205 : 170,
          buttonPinned: !isLast,
          tipsTitle: isLast ? "Te poate ajuta să te gândești la:" : null,
          tips: isLast ? _lastQuestionTips : null,
          onAutosave: (answer) => saveModuleAnswer(
            'module1',
            questionKey,
            type: 'text',
            value: answer,
            questionNumber: index + 1,
          ),
          onContinue: (answer) {
            saveModuleAnswer(
              'module1',
              questionKey,
              type: 'text',
              value: answer,
              questionNumber: index + 1,
            );
            final next = [...collected, answer];
            if (!isLast) saveResumePoint('module1', 0, index + 1, next.asMap());
            if (isLast) {
              _openComplete(context, next);
            } else {
              _openQuestion(context, index + 1, next);
            }
          },
        );
      },
    ),
  );
}

void _openComplete(BuildContext context, List<String> answers) {
  ModuleProgress.markCompleted(1);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleCompleteScreen(
        headerImage: AppAssets.headerM1Complete,
        title: "Modulul 1 este complet",
        message:
            "Ai făcut primul pas. Răspunsurile tale au fost salvate și ne ajută să înțelegem mai bine de unde pornești.",
        encouragementNote:
            "În continuare, îți arătăm un feedback scurt despre ce ai conturat până acum.",
        audioAssetPath: _completeAudio,
        onContinue: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _Module1FeedbackGate(answers),
          ),
        ),
        onHome: () => goToDashboard(context),
      ),
    ),
  );
}

/// Fetches the per-user feedback (or falls back), then replaces itself with
/// the feedback summary screen.
class _Module1FeedbackGate extends StatefulWidget {
  const _Module1FeedbackGate(this.answers, {this.readOnly = false});

  /// The three answers, in order; null reads them back from Firestore
  /// (reopening the feedback from the dashboard).
  final List<String>? answers;

  /// Reopened from the dashboard once the module is finished: the same
  /// feedback, with a button that only goes back.
  final bool readOnly;

  @override
  State<_Module1FeedbackGate> createState() => _Module1FeedbackGateState();
}

class _Module1FeedbackGateState extends State<_Module1FeedbackGate> {
  bool _pending = false;

  @override
  void initState() {
    super.initState();
    _resolve();
  }

  Future<void> _resolve() async {
    final answers = widget.answers ?? await _savedAnswers();
    final payload = [
      for (int i = 0; i < answers.length; i++)
        {'questionKey': 'q${i + 1}', 'type': 'text', 'value': answers[i]},
    ];
    // Same payload as when the module was finished, so the cached feedback
    // comes back rather than a newly generated one.
    final insight = answers.isEmpty
        ? null
        : await getIt<AiContentRepository>().insight(
            scope: 'module1',
            answers: payload,
          );
    if (!mounted) return;
    // Not ready within the wait: say so and let the user retry or go on,
    // rather than showing generic text as if it were their feedback.
    if (insight == null && answers.isNotEmpty) {
      setState(() => _pending = true);
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            _feedbackScreen(context, insight, readOnly: widget.readOnly),
      ),
    );
  }

  Future<List<String>> _savedAnswers() async {
    final uid = getIt<AuthService>().currentUser?.uid;
    if (uid == null) return const [];
    try {
      final saved = await getIt<ModuleProgressRepository>().fetchAnswersOfType(
        uid,
        'module1',
        const ['text'],
      );
      final byKey = {
        for (final a in saved)
          a['questionKey'] as String: '${a['value'] ?? ''}',
      };
      return [
        for (int i = 1; i <= _questions.length; i++)
          if (byKey['q$i'] != null) byKey['q$i']!,
      ];
    } catch (_) {
      return const [];
    }
  }

  @override
  Widget build(BuildContext context) => _pending
      ? InsightPendingScreen(
          moduleLabel: "Modulul 1 · Feedback",
          subject: "feedbackul",
          readOnly: widget.readOnly,
          onRetry: () {
            setState(() => _pending = false);
            _resolve();
          },
          onContinue: widget.readOnly
              ? () => Navigator.pop(context)
              : () => startModule2(context),
        )
      : const ModuleLoadingScreen(
    moduleLabel: "Modulul 1 · Feedback",
    title: "Pregătim feedbackul tău",
    description: "Ne uităm peste răspunsurile tale. Durează câteva secunde.",
    reminderText: "Acesta este un reper, nu o etichetă.",
  );
}

Widget _feedbackScreen(
  BuildContext context,
  GeneratedInsight? insight, {
  bool readOnly = false,
}) {
  final summaryItems = insight != null
      ? [
          for (int i = 0; i < insight.items.length; i++)
            // No level pill here on purpose: Module 1 has no instrument
            // behind it, only three written answers. A "Ridicat" badge would
            // read as a score the user never produced — and could end up
            // contradicted by the real scores in the modules that follow.
            SummaryItem(
              icon: _insightIcons[i % _insightIcons.length],
              title: insight.items[i].title,
              description: insight.items[i].description,
            ),
        ]
      : _fallbackFeedbackItems;

  return ModuleFeedbackSummaryScreen(
    moduleLabel: "Modulul 1 · Feedback scurt",
    title: "Un început de claritate",
    description:
        "În Modulul 1 ai conturat ce te-a adus aici, ce ai vrea să se schimbe și cum ar putea arăta un drum potrivit pentru tine.",
    profileLabel: insight?.profileLabel,
    profileValue: insight?.profileValue,
    profileDescription: insight?.profileDescription,
    summaryItems: summaryItems,
    nextModuleLabel: readOnly ? null : "Urmează Modulul 2",
    nextModuleTitle: readOnly ? null : "Profil psihologic & stil decizional",
    nextModuleDescription: readOnly
        ? null
        : "Vei explora felul în care gândești, iei decizii și reacționezi în situații diferite.",
    continueLabel: readOnly ? "Înapoi la parcurs" : "Continuă cu Modulul 2",
    onContinue: readOnly
        ? () => Navigator.pop(context)
        : () => startModule2(context),
  );
}

/// Reopens the Module 1 feedback from the dashboard, read-only.
void openModule1Summary(BuildContext context) => Navigator.push(
  context,
  MaterialPageRoute<void>(
    builder: (context) => const _Module1FeedbackGate(null, readOnly: true),
  ),
);

/// Debug shortcut: the module's introduction, ignoring any resume point.
void debugModule1Start(BuildContext context) => _openModule1Intro(context);
