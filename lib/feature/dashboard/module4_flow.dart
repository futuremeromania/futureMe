import 'package:futureme/core/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:futureme/core/data/character_strengths.dart';
import 'package:futureme/core/data/character_strengths_feedback.dart';
import 'package:futureme/core/data/aptitude_test.dart';
import 'package:futureme/core/data/aptitude_test_feedback.dart';
import 'package:futureme/feature/dashboard/dashboard_navigation.dart';
import 'package:futureme/feature/dashboard/module5_flow.dart';
import 'package:futureme/feature/dashboard/module_answers.dart';
import 'package:futureme/feature/dashboard/module_resume.dart';
import 'package:futureme/feature/dashboard/stage_result_access.dart';
import 'package:futureme/feature/dashboard/templates/module_complete_screen.dart';
import 'package:futureme/feature/dashboard/module_progress.dart';
import 'package:futureme/feature/dashboard/templates/insight_feedback_gate.dart';
import 'package:futureme/feature/dashboard/templates/module_final_feedback_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_introduction_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_scale_question_screen.dart';
import 'package:futureme/feature/dashboard/templates/aptitude_result_screen.dart';
import 'package:futureme/feature/dashboard/templates/aptitude_review_screen.dart';
import 'package:futureme/feature/dashboard/templates/aptitude_rules_screen.dart';
import 'package:futureme/feature/dashboard/templates/aptitude_test_screen.dart';
import 'package:futureme/feature/dashboard/templates/strengths_pick_three_screen.dart';
import 'package:futureme/feature/dashboard/templates/strengths_tie_break_screen.dart';
import 'package:futureme/feature/dashboard/templates/strengths_top_five_screen.dart';
import 'package:futureme/feature/dashboard/templates/strengths_top_three_screen.dart';

/// The closing message of Module 4, recorded rather than synthesised, as in
/// Modules 1 to 3.
const String _completeAudio = "assets/audio/module4_complete.m4a";

/// Wires the Module 4 screens ("Puncte forte și aptitudini") into a
/// push-based flow. Two stages: the strengths instrument, then aptitudes.
///
/// Opens Module 4 where the user left off, or at its introduction.
Future<void> startModule4(BuildContext context) async {
  final point = await loadResumePoint('module4');
  if (!context.mounted) return;
  if (point == null || !_resumeModule4(context, point)) {
    _openModule4Intro(context);
  }
}

bool _resumeModule4(BuildContext context, ResumePoint point) {
  switch (point.stage) {
    case 1:
      resumeStage(
        context,
        point,
        length: strengthsItems.length,
        intro: _openStage1Intro,
        question: (context, index) =>
            _openStage1Question(context, index, point.answersAs<int>()),
        complete: (context) =>
            _resolveStage1(context, scoreStrengths(point.answersAs<int>())),
      );
    case 2:
      // Index 0: not yet taken (introduction). Index 1: taken, so the
      // module continues with its final feedback.
      resumeStage(
        context,
        point,
        length: 1,
        intro: _openStage2Intro,
        question: (context, index) => _openStage2Intro(context),
        complete: _openFinalFeedback,
        checkAnswers: false,
      );
    default:
      return false;
  }
  return true;
}

void _openModule4Intro(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Modulul 4",
        icon: AppAssets.m4IntroIcon,
        moduleTitle: "Puncte forte și aptitudini",
        description:
            "În acest modul explorăm punctele forte și aptitudinile tale. Vedem ce resurse folosești mai natural și cum te descurci în diferite tipuri de sarcini.",
        nextSteps: const [
          "Puncte forte",
          "Aptitudini",
          "Punem rezultatele împreună",
        ],
        continueLabel: "Începe Modulul 4",
        progressNote:
            "Nu căutăm să fii bun la toate. Căutăm să înțelegem mai bine ce resurse ai și ce aptitudini ies în evidență la tine.",
        onContinue: () {
          markModuleStarted('module4');
          _openStage1Intro(context);
        },
      ),
    ),
  );
}

void _openStage1Intro(BuildContext context) {
  saveResumePoint('module4', 1, 0);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Etapa 1 din 2",
        icon: AppAssets.m4Stage1Icon,
        moduleTitle: "Puncte forte",
        description:
            "În această etapă descoperim ce puncte forte ies în evidență la tine și care dintre ele te reprezintă cel mai bine.",
        nextSteps: [
          "${strengthsItems.length} de afirmații scurte",
          "Alegi cât de mult ți se potrivește fiecare afirmație",
          "La final, vezi $strengthsTopCount puncte forte care ies în evidență la tine",
        ],
        continueLabel: "Începe etapa",
        progressNote:
            "Nu căutăm ce îți lipsește. Observăm resursele pe care te poți baza și pe care le poți dezvolta mai departe.",
        onContinue: () => _openStage1Question(context, 0, const {}),
      ),
    ),
  );
}

/// [index] walks the frozen display order; [answers] is keyed by each
/// item's original id, which is what the scoring key uses.
void _openStage1Question(
  BuildContext context,
  int index,
  Map<int, int> answers,
) {
  final item = strengthsItems[index];
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleScaleQuestionScreen(
        sectionLabel: strengthsScreenTitle,
        statement: item.statement,
        subtitle: strengthsPrompt,
        caption: strengthsCaption,
        options: strengthsScaleLabels,
        questionNumber: index + 1,
        totalQuestions: strengthsItems.length,
        onContinue: (selection) {
          // The screen reports a 0-based index; the instrument scores 1-5.
          final answer = selection + 1;
          saveModuleAnswer(
            'module4',
            'stage1_q${item.id}',
            type: 'scale',
            value: {
              'selectedIndex': selection,
              'answer': answer,
              'position': index + 1,
            },
            stage: 1,
            questionNumber: item.id,
          );
          final next = {...answers, item.id: answer};
          saveResumePoint('module4', 1, index + 1, next);
          if (index + 1 < strengthsItems.length) {
            _openStage1Question(context, index + 1, next);
          } else {
            _resolveStage1(context, scoreStrengths(next), replace: false);
          }
        },
      ),
    ),
  );
}

/// Shows the tie-break for as long as equal scores leave the Top 5
/// undecided, then the result. Each round records one more choice; the
/// scores themselves are never touched.
void _resolveStage1(
  BuildContext context,
  StrengthsResult result, {
  bool replace = true,
}) {
  final tie = result.pendingTie;

  final route = tie == null
      ? MaterialPageRoute<void>(
          builder: (context) => _stage1TopFive(context, result),
        )
      : MaterialPageRoute<void>(
          builder: (context) => StrengthsTieBreakScreen(
            tie: tie,
            onChoice: (choices) =>
                _resolveStage1(context, result.withTieBreak(choices)),
          ),
        );

  if (replace) {
    Navigator.pushReplacement(context, route);
  } else {
    Navigator.push(context, route);
  }
}

Widget _stage1TopFive(BuildContext context, StrengthsResult result) {
  // Stored the way the specification asks: the raw answers under their
  // original ids, the ten scores, the full internal ranking with ties left
  // as ties, whatever the tie-break decided, and the exact text shown for
  // each of the five — so the result can be read back later without
  // re-deriving anything.
  final topFive = result.topFive;
  saveModuleAnswer(
    'module4',
    'stage1_result',
    type: 'strengths_result',
    value: {
      'version': 'strengths-ro-v1',
      'feedbackVersion': strengthsFeedbackVersion,
      'answers': {for (final e in result.answers.entries) '${e.key}': e.value},
      'displayOrder': [for (final item in strengthsItems) item.id],
      'scores': {for (final s in result.scores) s.dimension.name: s.score},
      'ranking': [for (final s in result.ranked) s.dimension.name],
      'tieBreak': {
        'required': result.tieBreakChoices.isNotEmpty,
        'choices': [for (final d in result.tieBreakChoices) d.name],
      },
      'topFive': [
        for (final d in topFive)
          {
            'dimension': d.name,
            'label': d.label,
            'score': result.scoreOf(d),
            'feedbackId': 'strength_${d.name}',
            'headline': strengthFeedbackFor(d).headline,
            'body': strengthFeedbackFor(d).body,
            'howToUse':
                '${strengthFeedbackFor(d).howToUseHeading}: ${strengthFeedbackFor(d).howToUse}',
          },
      ],
    },
    stage: 1,
  );

  return StrengthsTopFiveScreen(
    topFive: topFive,
    onContinue: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StrengthsPickThreeScreen(
          topFive: topFive,
          onContinue: (picked) => _openStage1TopThree(context, picked),
        ),
      ),
    ),
  );
}

void _openStage1TopThree(BuildContext context, List<StrengthDimension> picked) {
  // Kept separate from `stage1_result` and labelled as self-selection,
  // because it is not a measurement: it says which of the five the person
  // recognises themselves in, not which of them scored highest.
  saveModuleAnswer(
    'module4',
    'stage1_self_selection',
    type: 'strengths_self_selection',
    value: {
      'version': 'strengths-ro-v1',
      'selfSelected': true,
      'topThree': [for (final d in picked) d.name],
      'labels': [for (final d in picked) d.label],
    },
    stage: 1,
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => StrengthsTopThreeScreen(
        topThree: picked,
        onContinue: () => _openStage2Intro(context),
      ),
    ),
  );
}

void _openStage2Intro(BuildContext context) {
  saveResumePoint('module4', 2, 0);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Etapa 2 din 2",
        icon: AppAssets.m4Stage2Icon,
        moduleTitle: aptitudeStageTitle,
        description: aptitudeIntroDescription,
        nextSteps: aptitudeIntroSteps,
        continueLabel: "Începe etapa",
        progressNote: aptitudeIntroNote,
        onContinue: () => _openStage2Rules(context),
      ),
    ),
  );
}

/// The rules get a screen of their own between the introduction and the
/// clock: after this point the session cannot be paused, resumed or
/// restarted, so it is the last moment anything can be explained.
void _openStage2Rules(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          AptitudeRulesScreen(onStart: () => _openStage2Test(context)),
    ),
  );
}

/// [replace] drops the rules screen from the back stack — once the timer
/// is running there is nothing to go back to. The debug shortcut passes
/// false, so jumping in from the dashboard does not replace the dashboard.
void _openStage2Test(BuildContext context, {bool replace = true}) {
  final route = MaterialPageRoute<void>(
    builder: (context) => AptitudeTestScreen(
      onFinished: (result) => _openStage2Result(context, result),
    ),
  );
  replace
      ? Navigator.pushReplacement(context, route)
      : Navigator.push(context, route);
}

void _openStage2Result(
  BuildContext context,
  AptitudeResult result, {
  bool replace = true,
}) {
  // The timed test is over: from here the module resumes at its final
  // feedback, never at the test again.
  saveResumePoint('module4', 2, 1);
  // Stored the way the pilot needs it: every answer with its status and
  // point, the time spent on each item, the four block scores, the
  // internal total, how the session ended, and the versions of the item
  // set, the key and the feedback — without which none of this can be
  // compared later against a changed instrument.
  saveModuleAnswer(
    'module4',
    'stage2_result',
    type: 'aptitude_result',
    value: {
      'version': aptitudeTestVersion,
      'feedbackVersion': aptitudeFeedbackVersion,
      'scoringVersion': aptitudeTestVersion,
      'pilot': true,
      'finish': result.finish.name,
      'totalSeconds': result.totalSeconds,
      'timeLimitMinutes': aptitudeTimeLimitMinutes,
      'scores': {
        for (final c in AptitudeCategory.values) c.name: result.scoreOf(c),
      },
      'totalScore': result.totalScore,
      'items': [
        for (final r in result.items)
          {
            'id': r.item.id,
            'category': r.item.category.name,
            'answer': r.answer,
            'correct': r.item.correctIndex,
            'status': r.status.name,
            'points': r.points,
            'seconds': r.seconds,
          },
      ],
    },
    stage: 2,
  );

  // Only the four scores and the exact sentences shown reach the model —
  // never the raw answers, the picked options or the per-item times.
  saveModuleAnswer(
    'module4',
    'stage2_summary',
    type: 'aptitude_summary',
    value: {
      'version': aptitudeTestVersion,
      'feedbackVersion': aptitudeFeedbackVersion,
      'scores': {
        for (final c in AptitudeCategory.values)
          c.name: {
            'label': c.label,
            'score': result.scoreOf(c),
            'outOf': aptitudeItemsPerCategory,
            'feedback':
                '${c.label}. ${aptitudeScoreLine(result.scoreOf(c))}. ${aptitudeCategorySentence(c, result.scoreOf(c))}',
          },
      },
    },
    stage: 2,
  );

  final route = MaterialPageRoute<void>(
    builder: (context) => AptitudeResultScreen(
      result: result,
      onReview: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AptitudeReviewScreen(
            result: result,
            onContinue: () => _openFinalFeedback(context),
          ),
        ),
      ),
      onContinue: () => _openFinalFeedback(context),
    ),
  );
  replace
      ? Navigator.pushReplacement(context, route)
      : Navigator.push(context, route);
}

void _openFinalFeedback(BuildContext context, {bool readOnly = false}) {
  final route = MaterialPageRoute<void>(
    builder: (context) => InsightFeedbackGate(
      scope: 'module4_final',
      moduleId: 'module4',
      readOnly: readOnly,
      onContinue: _openModule4Complete,
      // The strengths specification is explicit that the model never sees
      // the 30 raw item answers — only the computed result and the exact
      // texts that were shown.
      onlyTypes: const [
        'strengths_result',
        'strengths_self_selection',
        'aptitude_summary',
      ],
      loadingLabel: "Modulul 4 · Imagine de ansamblu",
      builder: (context, insight) => ModuleFinalFeedbackScreen(
        moduleLabel: "Modulul 4 · Imagine de ansamblu",
        title: "Ce puncte forte se văd mai clar",
        description:
            insight?.profileDescription ??
            "Răspunsurile tale arată câteva zone în care îți poate fi mai natural să înveți, să contribui și să construiești mai departe.",
        connectionsTitle: "Puncte forte care ies în evidență",
        connections: insight != null && insight.items.isNotEmpty
            ? insightToConnectionItems(insight)
            : const [
                ConnectionItem(
                  icon: Icons.psychology_outlined,
                  title: "Gândire analitică",
                  description:
                      "Pari să ai ușurință în a înțelege situații, a observa legături și a găsi soluții când lucrurile nu sunt simple.",
                ),
                ConnectionItem(
                  icon: Icons.forum_outlined,
                  title: "Comunicare și colaborare",
                  description:
                      "Îți poate fi mai natural să explici, să asculți și să lucrezi cu oameni atunci când există un scop clar.",
                ),
                ConnectionItem(
                  icon: Icons.checklist_outlined,
                  title: "Organizare și implementare",
                  description:
                      "Poți funcționa bine când ai lucruri de dus la capăt, pași clari și un rezultat concret de construit.",
                ),
              ],
        secondConnectionsTitle: "O zonă care merită dezvoltată",
        secondConnections: const [
          ConnectionItem(
            icon: Icons.self_improvement_outlined,
            title: "Autonomie și responsabilitate",
            description:
                "Această zonă poate deveni mai puternică pe măsură ce exersezi să îți organizezi pașii și să duci lucrurile mai departe în ritmul tău.",
          ),
        ],
        infoNote:
            "Aceste puncte forte ne ajută să vedem care dintre direcțiile din Modulul 3 pot fi susținute și în practică, nu doar să pară interesante.",
        continueLabel: readOnly
            ? "Înapoi la parcurs"
            : "Ascultă mesajul pentru tine",
        onContinue: readOnly
            ? () => Navigator.pop(context)
            : () => _openModule4Complete(context),
      ),
    ),
  );
  readOnly
      ? Navigator.push(context, route)
      : Navigator.pushReplacement(context, route);
}

void _openModule4Complete(BuildContext context) {
  ModuleProgress.markCompleted(4);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleCompleteScreen(
        title: "Modulul 4 este complet",
        message:
            "Ai explorat punctele tale forte și felul în care te-ai descurcat în diferite tipuri de raționament. Acum avem încă două repere importante pentru a înțelege mai bine ce ți se potrivește.\n\nIa-ți un moment de pauză înainte să mergi mai departe.",
        encouragementNote:
            "Nu trebuie să alegi încă. În Modulul 5, transformăm reperele de până acum într-o imagine mai clară.",
        continueLabel: "Continuă cu Modulul 5",
        nextModuleLabel: "Urmează Modulul 5",
        nextModuleTitle: "Drumul tău mai departe",
        nextModuleDescription:
            "Punem împreună ce ai descoperit despre tine: ce îți dorești, cum funcționezi, ce te atrage și ce puncte forte se văd mai clar. Apoi vedem ce direcții și pași concreți pot avea sens pentru tine.",
        audioAssetPath: _completeAudio,
        onContinue: () => startModule5(context),
        onHome: () => goToDashboard(context),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Debug-only entry points, used by the jump menu on the dashboard. They are
// ordinary functions; what keeps them out of a release build is that the
// only thing calling them sits behind `kDebugMode`.
// ---------------------------------------------------------------------------

void debugModule4Stage1(BuildContext context) => _openStage1Intro(context);

void debugModule4Stage2(BuildContext context) => _openStage2Intro(context);

void debugModule4Stage2Test(BuildContext context) =>
    _openStage2Test(context, replace: false);

/// Jumps straight to the result screen with a made-up set of answers, so
/// the four score cards and the review screen can be checked without
/// sitting through the test.
void debugModule4Stage2Result(BuildContext context) {
  final answers = <int, int>{};
  for (final item in aptitudeItems) {
    // Right for roughly two out of three, so the four blocks come out with
    // different scores rather than all full marks.
    answers[item.id] = item.id % 3 == 0
        ? (item.correctIndex + 1) % 4
        : item.correctIndex;
  }
  answers.remove(
    aptitudeItems.last.id,
  ); // one left unanswered, to see that state

  _openStage2Result(
    context,
    scoreAptitudeTest(
      answers: answers,
      seconds: {for (final item in aptitudeItems) item.id: 20},
      finish: AptitudeFinish.completedByUser,
      totalSeconds: 480,
    ),
    replace: false,
  );
}

/// Reopens this module's synthesis from the dashboard, read-only.
void openModule4Summary(BuildContext context) =>
    _openFinalFeedback(context, readOnly: true);

// ---------------------------------------------------------------------------
// Read-only stage results, opened from the dashboard
// ---------------------------------------------------------------------------

/// Opens one finished stage's result read-only, without saving anything.
///
/// Stage 1 is scored again from the saved answers and the tie-break choices,
/// and its Top 5 leads to the three strengths the user picked. Stage 2 is
/// rebuilt from the saved test record (answers, times, how it ended), since
/// a timed test can't be scored from the items alone; its review stays
/// available.
void openModule4StageResult(BuildContext context, int stage) {
  switch (stage) {
    case 1:
      openStageResult<(StrengthsResult, List<StrengthDimension>)>(
        context,
        load: (uid) async {
          final answers = await loadStageAnswers<int>(
            uid,
            'module4',
            1,
            scaleAnswerOf,
          );
          if (answers.length < strengthsItems.length) return null;
          var result = scoreStrengths(answers);
          final saved = await loadSavedValue(
            uid,
            'module4',
            'strengths_result',
          );
          final choices = [
            for (final name
                in ((saved?['tieBreak'] as Map?)?['choices'] as List?) ??
                    const [])
              ...StrengthDimension.values.where((d) => d.name == name),
          ];
          if (choices.isNotEmpty) result = result.withTieBreak(choices);
          final selection = await loadSavedValue(
            uid,
            'module4',
            'strengths_self_selection',
          );
          final picked = [
            for (final name in (selection?['topThree'] as List?) ?? const [])
              ...StrengthDimension.values.where((d) => d.name == name),
          ];
          return (result, picked);
        },
        build: (context, data, back) {
          final (result, picked) = data;
          return StrengthsTopFiveScreen(
            topFive: result.topFive,
            continueLabel: picked.isEmpty
                ? readOnlyBackLabel
                : "Vezi cele 3 alese de tine",
            onContinue: picked.isEmpty
                ? back
                : () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StrengthsTopThreeScreen(
                        topThree: picked,
                        continueLabel: readOnlyBackLabel,
                        onContinue: back,
                      ),
                    ),
                  ),
          );
        },
      );
    case 2:
      openStageResult<AptitudeResult>(
        context,
        load: (uid) async {
          final saved = await loadSavedValue(uid, 'module4', 'aptitude_result');
          final items = (saved?['items'] as List?) ?? const [];
          if (items.isEmpty) return null;
          final answers = <int, int>{};
          final seconds = <int, int>{};
          for (final raw in items.whereType<Map>()) {
            final id = (raw['id'] as num?)?.toInt();
            if (id == null) continue;
            final answer = (raw['answer'] as num?)?.toInt();
            if (answer != null) answers[id] = answer;
            seconds[id] = (raw['seconds'] as num?)?.toInt() ?? 0;
          }
          return scoreAptitudeTest(
            answers: answers,
            seconds: seconds,
            finish:
                AptitudeFinish.values
                    .where((f) => f.name == saved?['finish'])
                    .firstOrNull ??
                AptitudeFinish.completedByUser,
            totalSeconds: (saved?['totalSeconds'] as num?)?.toInt() ?? 0,
          );
        },
        build: (context, result, back) => AptitudeResultScreen(
          result: result,
          continueLabel: readOnlyBackLabel,
          onReview: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AptitudeReviewScreen(
                result: result,
                continueLabel: "Înapoi la rezultat",
                onContinue: () => Navigator.pop(context),
              ),
            ),
          ),
          onContinue: back,
        ),
      );
  }
}

/// Debug shortcut: the module's introduction, ignoring any resume point.
void debugModule4Start(BuildContext context) => _openModule4Intro(context);
