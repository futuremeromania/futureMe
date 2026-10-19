import 'package:futureme/core/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:futureme/core/data/vocational_interests.dart';
import 'package:futureme/core/data/work_preferences.dart';
import 'package:futureme/core/data/work_preferences_feedback.dart';
import 'package:futureme/core/data/work_environments.dart';
import 'package:futureme/core/data/work_environments_feedback.dart';
import 'package:futureme/feature/dashboard/dashboard_navigation.dart';
import 'package:futureme/feature/dashboard/module4_flow.dart';
import 'package:futureme/feature/dashboard/module_answers.dart';
import 'package:futureme/feature/dashboard/module_resume.dart';
import 'package:futureme/feature/dashboard/stage_result_access.dart';
import 'package:futureme/feature/dashboard/module_progress.dart';
import 'package:futureme/feature/dashboard/templates/module_complete_screen.dart';
import 'package:futureme/feature/dashboard/templates/insight_feedback_gate.dart';
import 'package:futureme/feature/dashboard/templates/module_final_feedback_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_introduction_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_roadmap_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_scale_question_screen.dart';
import 'package:futureme/feature/dashboard/templates/vocational_interests_result_screen.dart';
import 'package:futureme/feature/dashboard/templates/vocational_tie_break_screen.dart';
import 'package:futureme/feature/dashboard/templates/work_preferences_result_screen.dart';
import 'package:futureme/feature/dashboard/templates/work_environments_result_screen.dart';

/// The closing message of Module 3, recorded rather than synthesised: the
/// words are the same for everyone here, and a real voice carries them
/// better than text-to-speech. Same arrangement as Modules 1 and 2.
const String _completeAudio = "assets/audio/module3_complete.m4a";

/// Opens Module 3 where the user left off, or at its introduction.
///
/// Module 3 has three stages and — unlike Module 2 — no per-stage
/// "Complete" screen: each stage goes straight from its last question to
/// its result (RIASEC, work preferences, work environments).
Future<void> startModule3(BuildContext context) async {
  final point = await loadResumePoint('module3');
  if (!context.mounted) return;
  if (point == null || !_resumeModule3(context, point)) {
    _openModule3Intro(context);
  }
}

bool _resumeModule3(BuildContext context, ResumePoint point) {
  switch (point.stage) {
    case 1:
      resumeStage(
        context,
        point,
        length: vocationalInterestsItems.length,
        intro: _openStage1Intro,
        question: (context, index) =>
            _openStage1Question(context, index, point.answersAs<int>()),
        complete: (context) => _resolveStage1(
          context,
          scoreVocationalInterests(point.answersAs<int>()),
        ),
      );
    case 2:
      resumeStage(
        context,
        point,
        length: workPreferencesItems.length,
        intro: _openStage2Intro,
        question: (context, index) =>
            _openStage2Question(context, index, point.answersAs<int>()),
        complete: (context) => Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (context) => _stage2Result(
              context,
              scoreWorkPreferences(point.answersAs<int>()),
            ),
          ),
        ),
      );
    case 3:
      resumeStage(
        context,
        point,
        length: workEnvironmentsItems.length,
        intro: _openStage3Intro,
        question: (context, index) =>
            _openStage3Question(context, index, point.answersAs<int>()),
        complete: (context) => _openStage3Result(
          context,
          scoreWorkEnvironments(point.answersAs<int>()),
          replace: true,
        ),
      );
    default:
      return false;
  }
  return true;
}

void _openModule3Intro(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Modulul 3",
        icon: AppAssets.m3IntroIcon,
        moduleTitle: "Interese & vocație",
        description:
            "În acest modul explorăm ce tipuri de activități îți stârnesc curiozitatea, cum îți place să lucrezi și în ce medii te-ai simți mai în largul tău.",
        nextSteps: const [
          "3 etape care te ajută să înțelegi ce te atrage",
          "Parcurgi afirmații scurte și alegi cât de mult ți se potrivesc",
          "La final, vezi ce interese ies în evidență, cum îți place să lucrezi și ce medii te susțin",
        ],
        continueLabel: "Vezi pașii modulului",
        progressNote:
            "Nu trebuie să știi deja ce carieră vrei. Începem să observăm ce pare să aibă sens pentru tine.",
        onContinue: () {
          markModuleStarted('module3');
          _openRoadmap(context);
        },
      ),
    ),
  );
}

void _openRoadmap(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleRoadmapScreen(
        moduleLabel: "Modulul 3",
        title: "Ce descoperim împreună",
        description:
            "În următoarele etape ne uităm la ce îți atrage atenția, cum îți vine mai natural să lucrezi și ce contexte te ajută să te simți în largul tău.",
        steps: const [
          RoadmapStep(
            title: "Ce te atrage",
            description:
                "Observi ce activități, teme sau domenii îți stârnesc interesul și îți captează atenția.",
          ),
          RoadmapStep(
            title: "Ce îți place să faci și ce rol preferi",
            description: "Vezi ce rol îți place și cum preferi să te implici.",
          ),
          RoadmapStep(
            title: "Medii de lucru",
            description: "Vezi în ce condiții îți place să lucrezi.",
          ),
        ],
        continueLabel: "Începe prima etapă",
        onContinue: () => _openStage1Intro(context),
      ),
    ),
  );
}

void _openStage1Intro(BuildContext context) {
  saveResumePoint('module3', 1, 0);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Etapa 1 din 3 • Interese vocaționale",
        icon: AppAssets.m3Stage1Icon,
        moduleTitle: "Ce te atrage",
        description:
            "Această etapă te ajută să observi ce tipuri de activități, teme și domenii îți stârnesc interesul.",
        nextSteps: [
          "${vocationalInterestsItems.length} de activități scurte",
          "Alegi cât de mult ți-ar plăcea să faci fiecare activitate",
          "La final, vezi ce zone de interes ies mai mult în evidență",
        ],
        continueLabel: "Începe etapa",
        progressNote:
            "Răspunde după cum simți acum. Interesele se pot schimba în timp, iar aici observăm doar ce îți atrage atenția.",
        onContinue: () => _openStage1Question(context, 0, const {}),
      ),
    ),
  );
}

/// [answers] maps an item number to the option the user picked, 1-5,
/// carried forward so the whole questionnaire is scored in one go.
void _openStage1Question(
  BuildContext context,
  int index,
  Map<int, int> answers,
) {
  final item = vocationalInterestsItems[index];
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleScaleQuestionScreen(
        sectionLabel: "Ce te atrage",
        statement: item.statement,
        subtitle: vocationalInterestsPrompt,
        caption: vocationalInterestsCaption,
        options: vocationalInterestsScaleLabels,
        questionNumber: index + 1,
        totalQuestions: vocationalInterestsItems.length,
        onContinue: (selection) {
          // The screen reports a 0-based index; the instrument scores 1-5.
          final answer = selection + 1;
          saveModuleAnswer(
            'module3',
            'stage1_q${item.number}',
            type: 'scale',
            value: {'selectedIndex': selection, 'answer': answer},
            stage: 1,
            questionNumber: item.number,
          );
          final next = {...answers, item.number: answer};
          saveResumePoint('module3', 1, index + 1, next);
          if (index + 1 < vocationalInterestsItems.length) {
            _openStage1Question(context, index + 1, next);
          } else {
            _resolveStage1(
              context,
              scoreVocationalInterests(next),
              replace: false,
            );
          }
        },
      ),
    ),
  );
}

/// Shows the tie-break question for as long as equal scores leave the top
/// three ambiguous, then the result. Each choice produces a new result with
/// one more preference recorded — the scores themselves are never touched.
void _resolveStage1(
  BuildContext context,
  VocationalInterestsResult result, {
  bool replace = true,
}) {
  final tie = result.pendingTie;

  final route = tie == null
      ? MaterialPageRoute<void>(
          builder: (context) => _stage1Result(context, result),
        )
      : MaterialPageRoute<void>(
          builder: (context) => VocationalTieBreakScreen(
            tied: tie,
            onChoice: (choice) =>
                _resolveStage1(context, result.withTieBreak(choice)),
          ),
        );

  if (replace) {
    Navigator.pushReplacement(context, route);
  } else {
    Navigator.push(context, route);
  }
}

Widget _stage1Result(BuildContext context, VocationalInterestsResult result) {
  // Stored the way the specification asks: the raw answers, the six scores,
  // the full ranking, the top three and the code, plus any tie-break the
  // user was asked to make — kept separately, so it is always clear that the
  // choice ordered the profile rather than changing a score.
  saveModuleAnswer(
    'module3',
    'stage1_result',
    type: 'vocational_interests_result',
    value: {
      'version': 'riasec-ro-v1',
      'answers': {for (final e in result.answers.entries) '${e.key}': e.value},
      'scores': {for (final e in result.scores.entries) e.key.name: e.value},
      'ranking': [for (final r in result.ranked) r.dimension.name],
      'topThree': [for (final d in result.topThree) d.name],
      'code': result.code,
      'tieBreakChoices': [for (final d in result.tieBreakChoices) d.name],
      'feedbackIds': [for (final d in result.topThree) 'riasec_${d.name}'],
    },
    stage: 1,
  );

  return VocationalInterestsResultScreen(
    result: result,
    onContinue: () => _openStage2Intro(context),
  );
}

void _openStage2Intro(BuildContext context) {
  saveResumePoint('module3', 2, 0);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Etapa 2 din 3 • Preferințe profesionale",
        icon: AppAssets.m3Stage2Icon,
        moduleTitle: "Ce îți place să faci și ce rol preferi?",
        description:
            "Această etapă te ajută să descoperi ce fel de activități și sarcini preferi, ce rol îți place să ai și cum preferi să te implici atunci când lucrezi.",
        nextSteps: [
          "${workPreferencesItems.length} afirmații scurte",
          "Alegi cât de mult ți se potrivește fiecare afirmație",
          "La final, vezi ce stiluri de lucru ies mai mult în evidență",
        ],
        continueLabel: "Începe etapa",
        progressNote:
            "Nu există un mod corect de a lucra. Observăm ce te ajută să te implici și să te simți în largul tău.",
        onContinue: () => _openStage2Question(context, 0, const {}),
      ),
    ),
  );
}

/// [answers] maps an item number to the option the user picked, 1-5,
/// carried forward so the whole questionnaire is scored in one go.
void _openStage2Question(
  BuildContext context,
  int index,
  Map<int, int> answers,
) {
  final item = workPreferencesItems[index];
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleScaleQuestionScreen(
        sectionLabel: "Preferințe profesionale",
        statement: item.statement,
        subtitle: workPreferencesPrompt,
        caption: workPreferencesCaption,
        options: workPreferencesScaleLabels,
        questionNumber: index + 1,
        totalQuestions: workPreferencesItems.length,
        onContinue: (selection) {
          // The screen reports a 0-based index; the instrument scores 1-5.
          final answer = selection + 1;
          saveModuleAnswer(
            'module3',
            'stage2_q${item.number}',
            type: 'scale',
            value: {'selectedIndex': selection, 'answer': answer},
            stage: 2,
            questionNumber: item.number,
          );
          final next = {...answers, item.number: answer};
          saveResumePoint('module3', 2, index + 1, next);
          if (index + 1 < workPreferencesItems.length) {
            _openStage2Question(context, index + 1, next);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) =>
                    _stage2Result(context, scoreWorkPreferences(next)),
              ),
            );
          }
        },
      ),
    ),
  );
}

Widget _stage2Result(BuildContext context, WorkPreferencesResult result) {
  // Stored the way the specification asks: the sixteen raw answers, the
  // eight pole scores with their real bands, which poles came out as
  // preferences, and the id of each displayed text. The band is kept even
  // though only "ridicat" selects a text, so the numbers stay readable
  // later without re-deriving them.
  saveModuleAnswer(
    'module3',
    'stage2_result',
    type: 'work_preferences_result',
    value: {
      'version': 'work-preferences-ro-v1',
      'answers': {for (final e in result.answers.entries) '${e.key}': e.value},
      'poles': {
        for (final e in result.poles.entries)
          e.key.name: {
            'score': e.value.score,
            'level': e.value.level.name,
            'isPreference': e.value.isPreference,
          },
      },
      'dimensions': [
        for (final d in result.dimensions)
          {
            'dimension': d.dimension.name,
            'outcome': d.outcome.name,
            'feedbackId': d.feedbackId,
          },
      ],
      'preferences': [
        for (final e in result.poles.entries)
          if (e.value.isPreference) e.key.name,
      ],
      'feedbackIds': [for (final d in result.dimensions) d.feedbackId],
    },
    stage: 2,
  );

  return WorkPreferencesResultScreen(
    result: result,
    onContinue: () => _openStage3Intro(context),
  );
}

void _openStage3Intro(BuildContext context) {
  saveResumePoint('module3', 3, 0);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Etapa 3 din 3",
        labelAccent: "Medii de lucru",
        icon: AppAssets.m3Stage3Icon,
        moduleTitle: "În ce condiții",
        titleAccent: "îți place să lucrezi?",
        description:
            "Această etapă te ajută să descoperi ce condiții și caracteristici ale unui mediu de lucru contează mai mult pentru tine.",
        nextSteps: [
          "${workEnvironmentsItems.length} de afirmații scurte",
          "Alegi cât de mult ți se potrivește fiecare afirmație",
          "La final, vezi ce fel de medii de lucru preferi",
        ],
        continueLabel: "Începe etapa",
        progressNote:
            "Nu există un mediu de lucru potrivit pentru toată lumea. Observăm în ce condiții îți place ție să lucrezi.",
        onContinue: () => _openStage3Question(context, 0, const {}),
      ),
    ),
  );
}

/// [answers] maps an item's id (I1-I28) to the option picked, 1-5, carried
/// forward so the whole questionnaire is scored in one go at the end.
void _openStage3Question(
  BuildContext context,
  int index,
  Map<int, int> answers,
) {
  final item = workEnvironmentsItems[index];
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleScaleQuestionScreen(
        sectionLabel: "Medii de lucru",
        statement: item.statement,
        subtitle: workEnvironmentsPrompt,
        caption: workEnvironmentsCaption,
        options: workEnvironmentsScaleLabels,
        questionNumber: index + 1,
        totalQuestions: workEnvironmentsItems.length,
        onContinue: (selection) {
          // The screen reports a 0-based index; the instrument scores 1-5.
          final answer = selection + 1;
          saveModuleAnswer(
            'module3',
            'stage3_q${item.number}',
            type: 'scale',
            value: {
              'selectedIndex': selection,
              'answer': answer,
              'position': index + 1,
            },
            stage: 3,
            questionNumber: item.number,
          );
          final next = {...answers, item.number: answer};
          saveResumePoint('module3', 3, index + 1, next);
          if (index + 1 < workEnvironmentsItems.length) {
            _openStage3Question(context, index + 1, next);
          } else {
            _openStage3Result(context, scoreWorkEnvironments(next));
          }
        },
      ),
    ),
  );
}

/// Saves and shows the Stage 3 result. What is stored is what the
/// specification lists: the fourteen scores with their bands, the state
/// of each dimension, and the id, title and full text of each displayed
/// feedback, with the versions. The 28 raw answers are stored item by item
/// (`stage3_q*`) and deliberately left out of this document, because this
/// document is what the Module 3 synthesis sends to the model, and the
/// model must not receive raw answers.
void _openStage3Result(
  BuildContext context,
  WorkEnvironmentsResult result, {
  bool replace = false,
}) {
  saveModuleAnswer(
    'module3',
    'stage3_result',
    type: 'work_environments_result',
    value: {
      'version': workEnvironmentsVersion,
      'scoringVersion': workEnvironmentsScoringVersion,
      'feedbackVersion': workEnvironmentsFeedbackVersion,
      'dimensions': [
        for (final d in result.dimensions)
          {
            'dimension': d.dimension.label,
            'poleA': {
              'pole': d.first.pole.label,
              'score': d.first.score,
              'level': d.first.level.label,
            },
            'poleB': {
              'pole': d.second.pole.label,
              'score': d.second.score,
              'level': d.second.level.label,
            },
            'state': d.outcome.code,
            'feedbackId': d.feedbackId,
            'feedbackTitle': workEnvironmentFeedbackFor(d).title,
            'feedbackText': workEnvironmentFeedbackFor(d).fullText,
          },
      ],
    },
    stage: 3,
  );

  final route = MaterialPageRoute<void>(
    builder: (context) => WorkEnvironmentsResultScreen(
      result: result,
      onContinue: () => _openFinalFeedback(context),
    ),
  );
  replace
      ? Navigator.pushReplacement(context, route)
      : Navigator.push(context, route);
}

/// The synthesis of the whole module. It is not another instrument: the
/// three instruments have already scored themselves and already picked
/// their fixed FutureMe texts, and this screen only puts them side by side.
///
/// So the model is sent the computed `*_result` documents alone — never the
/// raw item answers — and the closing message below is fixed FutureMe copy,
/// not something the model is asked to produce.
void _openFinalFeedback(BuildContext context, {bool readOnly = false}) {
  final route = MaterialPageRoute<void>(
    builder: (context) => InsightFeedbackGate(
      scope: 'module3_final',
      moduleId: 'module3',
      readOnly: readOnly,
      onContinue: _openModule3Complete,
      onlyTypes: const [
        'vocational_interests_result',
        'work_preferences_result',
        'work_environments_result',
      ],
      loadingLabel: "Modulul 3 · Imagine de ansamblu",
      builder: (context, insight) => ModuleFinalFeedbackScreen(
        moduleLabel: "Modulul 3 · Imagine de ansamblu",
        title: "Ce ai descoperit în Modulul 3",
        description:
            "Dacă punem împreună tot ce ai descoperit în acest modul, începe să se contureze o imagine despre ce te atrage, ce rol preferi și în ce condiții îți place să lucrezi.",
        synthesisTitle: "Ce iese în evidență",
        synthesisDescription:
            insight?.profileDescription ??
            "Par să merite explorate direcții în care poți lucra cu idei, oameni și sens. Îți poate fi mai ușor când ai spațiu să gândești, dar și repere clare ca să știi încotro mergi.",
        connectionsTitle: "Ce ai aflat despre tine",
        connections: insight != null && insight.items.isNotEmpty
            ? insightToConnectionItems(insight)
            : const [
                ConnectionItem(
                  icon: Icons.favorite_border,
                  title: "Ce te atrage",
                  description:
                      "Activități în care poți crea, explica, analiza sau înțelege mai bine oamenii și ideile.",
                ),
                ConnectionItem(
                  icon: Icons.build_outlined,
                  title: "Ce îți place să faci și ce rol preferi",
                  description:
                      "Cu libertate în felul în care abordezi lucrurile, dar și cu direcție, claritate și un ritm pe care îl poți susține.",
                ),
                ConnectionItem(
                  icon: Icons.home_outlined,
                  title: "Mediile care te susțin",
                  description:
                      "Mediile calme, respectuoase, cu presiune redusă și spațiu pentru concentrare.",
                ),
              ],
        explorationTitle: "Arii care merită explorate",
        explorationItems: insight != null && insight.explorationAreas.isNotEmpty
            ? insight.explorationAreas
            : const [
                "Comunicare & creație",
                "Oameni & sprijin",
                "Analiză & înțelegere",
              ],
        // Fixed FutureMe copy — never generated or rephrased by the model.
        infoNote:
            "Nu alegem încă o carieră finală. Aceste direcții sunt repere de explorare, iar în Modulul 4 vedem ce alte rezultate le susțin, le nuanțează sau deschid direcții noi.",
        continueLabel: readOnly
            ? "Înapoi la parcurs"
            : "Ascultă mesajul pentru tine",
        onContinue: readOnly
            ? () => Navigator.pop(context)
            : () => _openModule3Complete(context),
      ),
    ),
  );
  readOnly
      ? Navigator.push(context, route)
      : Navigator.pushReplacement(context, route);
}

void _openModule3Complete(BuildContext context) {
  ModuleProgress.markCompleted(3);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleCompleteScreen(
        title: "Modulul 3 este complet",
        message:
            "Ai explorat ce te atrage, cum îți place să lucrezi și ce medii te pot susține. Înainte să mergi mai departe, ia-ți un moment de pauză.",
        encouragementNote:
            "Nu trebuie să alegi o direcție finală acum. Lasă lucrurile să se așeze puțin.",
        continueLabel: "Continuă cu Modulul 4",
        nextModuleLabel: "Urmează Modulul 4",
        nextModuleTitle: "Aptitudini & puncte forte",
        nextModuleDescription:
            "Vei vedea ce îți vine mai natural, ce poți dezvolta și ce puncte forte pot susține direcțiile conturate în Modulul 3.",
        audioAssetPath: _completeAudio,
        onContinue: () => startModule4(context),
        onHome: () => goToDashboard(context),
      ),
    ),
  );
}

/// Debug-only entry points — see the note in `module4_flow.dart`.
void debugModule3Stage1(BuildContext context) => _openStage1Intro(context);

void debugModule3Stage2(BuildContext context) => _openStage2Intro(context);

void debugModule3Stage3(BuildContext context) => _openStage3Intro(context);

/// Reopens this module's synthesis from the dashboard, read-only.
void openModule3Summary(BuildContext context) =>
    _openFinalFeedback(context, readOnly: true);

// ---------------------------------------------------------------------------
// Read-only stage results, opened from the dashboard
// ---------------------------------------------------------------------------

/// Opens one finished stage's result read-only: scored again from the saved
/// item answers (plus, for the interests, the tie-break choices the user
/// made), without saving anything; the button only goes back.
void openModule3StageResult(BuildContext context, int stage) {
  Future<Map<int, int>> scale(String uid) =>
      loadStageAnswers<int>(uid, 'module3', stage, scaleAnswerOf);

  switch (stage) {
    case 1:
      openStageResult<VocationalInterestsResult>(
        context,
        load: (uid) async {
          final answers = await scale(uid);
          if (answers.length < vocationalInterestsItems.length) return null;
          var result = scoreVocationalInterests(answers);
          final saved = await loadSavedValue(
            uid,
            'module3',
            'vocational_interests_result',
          );
          for (final name in (saved?['tieBreakChoices'] as List?) ?? const []) {
            final choice = VocationalDimension.values
                .where((d) => d.name == name)
                .firstOrNull;
            if (choice != null) result = result.withTieBreak(choice);
          }
          return result;
        },
        build: (context, result, back) => VocationalInterestsResultScreen(
          result: result,
          continueLabel: readOnlyBackLabel,
          onContinue: back,
        ),
      );
    case 2:
      openStageResult<WorkPreferencesResult>(
        context,
        load: (uid) async {
          final answers = await scale(uid);
          return answers.length < workPreferencesItems.length
              ? null
              : scoreWorkPreferences(answers);
        },
        build: (context, result, back) => WorkPreferencesResultScreen(
          result: result,
          continueLabel: readOnlyBackLabel,
          onContinue: back,
        ),
      );
    case 3:
      openStageResult<WorkEnvironmentsResult>(
        context,
        load: (uid) async {
          final answers = await scale(uid);
          return answers.length < workEnvironmentsItems.length
              ? null
              : scoreWorkEnvironments(answers);
        },
        build: (context, result, back) => WorkEnvironmentsResultScreen(
          result: result,
          continueLabel: readOnlyBackLabel,
          onContinue: back,
        ),
      );
  }
}

/// Debug shortcut: the module's introduction, ignoring any resume point.
void debugModule3Start(BuildContext context) => _openModule3Intro(context);
