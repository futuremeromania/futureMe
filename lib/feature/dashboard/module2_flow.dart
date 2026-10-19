import 'package:futureme/core/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:futureme/core/data/big_five.dart';
import 'package:futureme/core/data/cognitive_style.dart';
import 'package:futureme/core/data/decision_style.dart';
import 'package:futureme/core/data/emotional_patterns.dart';
import 'package:futureme/core/data/mbti.dart';
import 'package:futureme/core/data/perceived_control.dart';
import 'package:futureme/core/data/mbti_profiles.dart';
import 'package:futureme/core/data/mbti_summaries.dart';
import 'package:futureme/feature/dashboard/dashboard_navigation.dart';
import 'package:futureme/feature/dashboard/module_answers.dart';
import 'package:futureme/feature/dashboard/module_resume.dart';
import 'package:futureme/feature/dashboard/stage_result_access.dart';
import 'package:futureme/feature/dashboard/templates/big_five_result_screen.dart';
import 'package:futureme/feature/dashboard/templates/cognitive_style_result_screen.dart';
import 'package:futureme/feature/dashboard/templates/decision_style_result_screen.dart';
import 'package:futureme/feature/dashboard/templates/emotional_patterns_result_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_complete_screen.dart';
import 'package:futureme/feature/dashboard/module_progress.dart';
import 'package:futureme/feature/dashboard/templates/insight_feedback_gate.dart';
import 'package:futureme/feature/dashboard/templates/module_feedback_summary_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_final_feedback_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_introduction_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_mbti_question_screen.dart';
import 'package:futureme/feature/dashboard/templates/perceived_control_result_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_roadmap_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_scale_question_screen.dart';
import 'package:futureme/feature/dashboard/module3_flow.dart';
import 'package:futureme/feature/dashboard/templates/stage_complete_screen.dart';

/// Wires the Module 2 screens into a push-based flow.
///
/// Every stage runs a real instrument: the MBTI items in
/// `core/data/mbti.dart`, the IPIP-50 Big Five items in
/// `core/data/big_five.dart`, the 30-item cognitive-style questionnaire in
/// `core/data/cognitive_style.dart`, and the 20-item decision-style
/// questionnaire in `core/data/decision_style.dart`. All four are scored by
/// their own published keys, and the result selects one of a fixed set of
/// texts. No model is involved, so the same answers always produce the same
/// result.
///
/// Recorded closing message for this module, played by the Complete
/// screen's audio card in place of text-to-speech — the same arrangement as
/// Module 1. Drop the recording at this path; the folder is already
/// declared in pubspec.yaml.
const String _completeAudio = "assets/audio/module2_complete.m4a";

/// Opens Module 2 where the user left off, or at its introduction.
Future<void> startModule2(BuildContext context) async {
  final point = await loadResumePoint('module2');
  if (!context.mounted) return;
  if (point == null || !_resumeModule2(context, point)) {
    _openModule2Intro(context);
  }
}

/// Debug shortcut: the module's introduction, ignoring any resume point.
void debugModule2Start(BuildContext context) => _openModule2Intro(context);

bool _resumeModule2(BuildContext context, ResumePoint point) {
  switch (point.stage) {
    case 1:
      resumeStage(
        context,
        point,
        length: mbtiItems.length,
        intro: _openStage1Intro,
        question: (context, index) =>
            _openStage1Question(context, index, point.answersAs<int>()),
        complete: (context) =>
            _openStage1Complete(context, scoreMbti(point.answersAs<int>())),
      );
    case 2:
      resumeStage(
        context,
        point,
        length: bigFiveItems.length,
        intro: _openStage2Intro,
        question: (context, index) =>
            _openStage2Question(context, index, point.answersAs<int>()),
        complete: (context) =>
            _openStage2Complete(context, scoreBigFive(point.answersAs<int>())),
      );
    case 3:
      resumeStage(
        context,
        point,
        length: cognitiveStyleItems.length,
        intro: _openStage3Intro,
        question: (context, index) =>
            _openStage3Question(context, index, point.answersAs<int>()),
        complete: (context) => _openStage3Complete(
          context,
          scoreCognitiveStyle(point.answersAs<int>()),
        ),
      );
    case 4:
      resumeStage(
        context,
        point,
        length: decisionStyleItems.length,
        intro: _openStage4Intro,
        question: (context, index) =>
            _openStage4Question(context, index, point.answersAs<bool>()),
        complete: (context) => _openStage4Complete(
          context,
          scoreDecisionStyle(point.answersAs<bool>()),
        ),
      );
    case 5:
      resumeStage(
        context,
        point,
        length: emotionalPatternsItems.length,
        intro: _openStage5Intro,
        question: (context, index) =>
            _openStage5Question(context, index, point.answersAs<int>()),
        complete: (context) => _openStage5Complete(
          context,
          scoreEmotionalPatterns(point.answersAs<int>()),
        ),
      );
    case 6:
      resumeStage(
        context,
        point,
        length: perceivedControlItems.length,
        intro: _openStage6Intro,
        question: (context, index) =>
            _openStage6Question(context, index, point.answersAs<int>()),
        complete: (context) => _openStage6Complete(
          context,
          scorePerceivedControl(point.answersAs<int>()),
        ),
      );
    default:
      return false;
  }
  return true;
}

void _openModule2Intro(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Modulul 2",
        icon: AppAssets.m2IntroIcon,
        moduleTitle: "Profil psihologic & stil decizional",
        description:
            "În acest modul explorăm cum gândești, iei decizii și reacționezi în situații diferite.",
        nextSteps: const [
          "Etape scurte, parcurse pe rând",
          "Răspunsuri sincere, nu perfecte",
          "Feedback scurt după fiecare etapă",
        ],
        continueLabel: "Vezi pașii modulului",
        progressNote:
            "Nu trebuie să termini totul dintr-o dată. Progresul tău este salvat.",
        onContinue: () {
          markModuleStarted('module2');
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
        moduleLabel: "Modulul 2",
        title: "Ce explorăm împreună",
        description:
            "Fiecare etapă adaugă o piesă nouă despre tine. Le parcurgem pe rând, fără presiune.",
        steps: const [
          RoadmapStep(
            title: "Cum preferi să funcționezi",
            description:
                "Preferințele tale în felul în care interacționezi, procesezi informația și abordezi alegerile.",
          ),
          RoadmapStep(
            title: "Care este personalitatea ta",
            description:
                "Trăsăturile fundamentale care conturează felul în care gândești, simți și te comporți în mod constant.",
          ),
          RoadmapStep(
            title: "Cum gândești",
            description:
                "Felul în care observi, procesezi informația și abordezi problemele.",
          ),
          RoadmapStep(
            title: "Cum iei decizii",
            description:
                "Ce te ajută sau te încurcă atunci când trebuie să alegi.",
          ),
          RoadmapStep(
            title: "Cum reacționezi sub presiune",
            description:
                "Ce se întâmplă când apar stresul, emoțiile puternice sau îndoiala.",
          ),
          RoadmapStep(
            title: "Cât control simți că ai",
            description:
                "În ce măsură simți că poți influența ceea ce ți se întâmplă.",
          ),
        ],
        continueLabel: "Începe prima etapă",
        onContinue: () => _openStage1Intro(context),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Stage 1 — MBTI
// ---------------------------------------------------------------------------

void _openStage1Intro(BuildContext context) {
  saveResumePoint('module2', 1, 0);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Etapa 1 din 6",
        icon: AppAssets.m2Stage1Icon,
        moduleTitle: "Cum preferi să funcționezi",
        description:
            "Această etapă te ajută să observi cum te raportezi la oameni și la alegerile pe care le faci.",
        nextSteps: [
          "${mbtiItems.length} de perechi de afirmații",
          "Împarți 5 puncte între cele două variante",
          "Exemple valide: 0+5, 1+4, 2+3, 3+2, 4+1, 5+0",
        ],
        continueLabel: "Începe etapa",
        progressNote:
            "Distribuie cele 5 puncte proporțional cu măsura în care fiecare variantă se potrivește felului tău de a fi. Nu există răspunsuri corecte.",
        onContinue: () => _openStage1Question(context, 0, const {}),
      ),
    ),
  );
}

/// [answers] maps an item number to the points given to variant A, carried
/// forward from screen to screen so the whole questionnaire can be scored
/// in one go at the end.
void _openStage1Question(
  BuildContext context,
  int index,
  Map<int, int> answers, {
  bool replace = false,
}) {
  final item = mbtiItems[index];
  final route = MaterialPageRoute<void>(
    builder: (context) => ModuleMbtiQuestionScreen(
      sectionLabel: "Cum preferi să funcționezi",
      statementA: item.statementA,
      statementB: item.statementB,
      questionNumber: index + 1,
      totalQuestions: mbtiItems.length,
      onContinue: (pointsForA, pointsForB) {
        saveModuleAnswer(
          'module2',
          'stage1_q${item.number}',
          type: 'mbti',
          value: {'pointsForA': pointsForA, 'pointsForB': pointsForB},
          stage: 1,
          questionNumber: item.number,
        );
        final next = {...answers, item.number: pointsForA};
        saveResumePoint('module2', 1, index + 1, next);
        if (index + 1 < mbtiItems.length) {
          if (index + 1 == 10) {
            openQuestionBreak(
              context,
              title: "Ia o scurtă pauză",
              headerImage: AppAssets.headerBreak1,
              openNext: (context) =>
                  _openStage1Question(context, index + 1, next, replace: true),
            );
          } else if (index + 1 == 22) {
            openQuestionBreak(
              context,
              title: "Mai ai doar câteva întrebări",
              message:
                  "Ai parcurs cea mai mare parte a întrebărilor. Mai sunt doar câteva. Continuăm când ești gata.",
              headerImage: AppAssets.headerBreak2,
              openNext: (context) =>
                  _openStage1Question(context, index + 1, next, replace: true),
            );
          } else {
            _openStage1Question(context, index + 1, next);
          }
        } else {
          _openStage1Complete(context, scoreMbti(next));
        }
      },
    ),
  );
  replace
      ? Navigator.pushReplacement(context, route)
      : Navigator.push(context, route);
}

void _openStage1Complete(BuildContext context, MbtiResult result) {
  // The computed type is stored alongside the raw answers so the final
  // report can use it without rescoring — and so the result is auditable
  // against the answers it came from.
  saveModuleAnswer(
    'module2',
    'stage1_result',
    type: 'mbti_result',
    value: {
      'typeCode': result.typeCode,
      'isClearCut': result.isClearCut,
      'scores': {
        for (final entry in result.scores.entries)
          entry.key.name.toUpperCase(): entry.value,
      },
    },
    stage: 1,
  );

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => StageCompleteScreen(
        stageLabel: "Modulul 2 · Etapa 1 din 6",
        headerImage: AppAssets.headerM2Stage1Complete,
        title: "Etapa 1 este completă",
        message:
            "Ai parcurs prima etapă a profilului tău. Răspunsurile tale rămân aici, iar în continuare le privim ca prime repere, nu ca o concluzie.",
        achievementTitle: "Cum preferi să funcționezi",
        achievementSubtitle: "${mbtiItems.length} de afirmații finalizate",
        infoNote:
            "Nu tragem concluzii încă. E doar primul pas. Profilul tău se construiește treptat.",
        primaryLabel: "Vezi rezultatul",
        onPrimary: () => _openStage1Feedback(context, result),
        secondaryLabel: "Revin mai târziu",
        onSecondary: () => goToDashboard(context),
      ),
    ),
  );
}

/// A one-line reading of each pole, used to describe whichever side won.
const Map<MbtiPole, String> _poleDescriptions = {
  MbtiPole.e:
      "Îți iei energia din contactul cu oamenii și din a fi în mijlocul lucrurilor.",
  MbtiPole.i:
      "Îți iei energia din liniște și din timpul petrecut cu propriile gânduri.",
  MbtiPole.s:
      "Te sprijini pe fapte concrete, detalii și pe ceea ce ai verificat din experiență.",
  MbtiPole.n:
      "Te sprijini pe intuiție, pe tipare și pe posibilitățile din spatele lucrurilor.",
  MbtiPole.t: "Când decizi, pornești de la logică și de la analiza faptelor.",
  MbtiPole.f:
      "Când decizi, ții cont de oameni, de valori și de ceea ce simți că e potrivit.",
  MbtiPole.j:
      "Preferi lucrurile planificate, structurate și stabilite din timp.",
  MbtiPole.p: "Preferi să rămâi flexibil și să decizi pe parcurs.",
};

/// What each letter stands for. The type code and the raw scores are
/// meaningless on their own — "T 15 · F 17" says nothing to the user, and
/// read aloud it says even less — so every letter is shown with its name.
const Map<MbtiPole, String> _poleNames = {
  MbtiPole.e: "Extraversie",
  MbtiPole.i: "Introversie",
  MbtiPole.s: "Senzație",
  MbtiPole.n: "Intuiție",
  MbtiPole.t: "Gândire",
  MbtiPole.f: "Sentiment",
  MbtiPole.j: "Judecată",
  MbtiPole.p: "Percepție",
};

/// The second word some poles carry in the FutureMe wording, used in the
/// legend under the type code but left out of the shorter score readouts.
const Map<MbtiPole, String> _poleQualifiers = {
  MbtiPole.f: "Valori",
  MbtiPole.j: "Structură",
  MbtiPole.p: "Flexibilitate",
};

const Map<MbtiDimension, (IconData, String)> _dimensionMeta = {
  MbtiDimension.energy: (Icons.bolt_outlined, "De unde îți iei energia"),
  MbtiDimension.perception: (Icons.lightbulb_outline, "Cum aduni informația"),
  MbtiDimension.judgement: (Icons.balance_outlined, "Cum iei decizii"),
  MbtiDimension.lifestyle: (
    Icons.event_note_outlined,
    "Cum îți organizezi viața",
  ),
};

String _poleLetter(MbtiPole pole) => pole.name.toUpperCase();

String _poleFullName(MbtiPole pole) {
  final qualifier = _poleQualifiers[pole];
  return qualifier == null
      ? _poleNames[pole]!
      : "${_poleNames[pole]!} ($qualifier)";
}

/// "E – Extraversie, S – Senzație, T – Gândire, J – Judecată (Structură)",
/// spelled out for the four letters this user actually got.
String _typeLegend(MbtiResult result) => result.dimensions
    .map((d) => "${_poleLetter(d.winner)} – ${_poleFullName(d.winner)}")
    .join(", ");

List<SummaryItem> _mbtiSummaryItems(MbtiResult result) {
  return [
    for (final d in result.dimensions)
      SummaryItem(
        icon: _dimensionMeta[d.dimension]!.$1,
        title: _dimensionMeta[d.dimension]!.$2,
        badgeLabel: "${d.label} · ${_poleNames[d.winner]!}",
        description: d.isTied
            ? "${_poleDescriptions[d.winner]!} Scorurile au ieșit egale (${_poleNames[d.dimension.first]!} ${d.firstScore}, ${_poleNames[d.dimension.second]!} ${d.secondScore}), deci pe această dimensiune preferința ta e mai puțin pronunțată."
            : "${_poleDescriptions[d.winner]!} (${_poleNames[d.dimension.first]!} ${d.firstScore}, ${_poleNames[d.dimension.second]!} ${d.secondScore})",
      ),
  ];
}

void _openStage1Feedback(BuildContext context, MbtiResult result) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => _stage1FeedbackScreen(
        result,
        continueLabel: "Continuă cu Personalitatea ta",
        onContinue: () => _openStage2Intro(context),
      ),
    ),
  );
}

Widget _stage1FeedbackScreen(
  MbtiResult result, {
  required String continueLabel,
  required VoidCallback onContinue,
}) {
  final summary = mbtiSummaries[result.typeCode];
  final profile = mbtiProfiles[result.typeCode];
  final legend = "${result.typeCode}: ${_typeLegend(result)}.";
  final short = [
    legend,
    if (summary != null && summary.isNotEmpty) summary,
  ].join("\n\n");
  final watchOuts = profile?.watchOuts ?? const <String>[];
  return ModuleFeedbackSummaryScreen(
    moduleLabel: "Etapa 1 · Rezultatul tău",
    title: "Profilul tău începe să se contureze",
    description:
        "Rezultatul de mai jos vine direct din felul în care ți-ai împărțit punctele.",
    profileLabel: "Tipul tău",
    profileValue: profile != null
        ? "${result.typeCode} · ${profile.title}"
        : result.typeCode,
    profileDescription: profile != null
        ? [legend, ...profile.description].join("\n\n")
        : short,
    profileDetailHeading: watchOuts.isNotEmpty ? mbtiWatchOutsHeading : null,
    profileDetail: watchOuts.isNotEmpty ? watchOuts.join("\n\n") : null,
    summaryScope: "module2_stage1",
    summaryItems: _mbtiSummaryItems(result),
    infoNote:
        "Acesta este un reper, nu o etichetă. Următoarele etape vor adăuga context.",
    continueLabel: continueLabel,
    onContinue: onContinue,
  );
}

// ---------------------------------------------------------------------------
// Stage 2 — Big Five (IPIP-50)
// ---------------------------------------------------------------------------

void _openStage2Intro(BuildContext context) {
  saveResumePoint('module2', 2, 0);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Etapa 2 din 6",
        icon: AppAssets.m2Stage2Icon,
        moduleTitle: "Care este personalitatea ta",
        description:
            "Acest chestionar explorează 5 dimensiuni fundamentale ale personalității tale: deschidere către experiențe, conștiinciozitate, extraversie, agreabilitate și stabilitate emoțională.",
        nextSteps: [
          "${bigFiveItems.length} de afirmații scurte",
          "Alegi cât de adevărată se simte fiecare afirmație",
          "Descoperi cum se conturează cele 5 dimensiuni ale personalității tale",
        ],
        continueLabel: "Începem",
        progressNote: "Răspunde sincer, nu cum crezi că „ar trebui”.",
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
  Map<int, int> answers, {
  bool replace = false,
}) {
  final item = bigFiveItems[index];
  final route = MaterialPageRoute<void>(
    builder: (context) => ModuleScaleQuestionScreen(
      sectionLabel: "Care este personalitatea ta",
      statement: item.statement,
      options: bigFiveScaleLabels,
      questionNumber: index + 1,
      totalQuestions: bigFiveItems.length,
      onContinue: (selection) {
        // The screen reports a 0-based index; the instrument scores 1-5.
        final answer = selection + 1;
        saveModuleAnswer(
          'module2',
          'stage2_q${item.number}',
          type: 'scale',
          value: {'selectedIndex': selection, 'answer': answer},
          stage: 2,
          questionNumber: item.number,
        );
        final next = {...answers, item.number: answer};
        saveResumePoint('module2', 2, index + 1, next);
        if (index + 1 < bigFiveItems.length) {
          if (index + 1 == 25) {
            openQuestionBreak(
              context,
              title: "Ai ajuns la jumătate",
              message:
                  "Ai parcurs jumătate din întrebări. Unele alegeri pot fi clare, altele mai greu de simțit. E normal. Continuăm când ești gata.",
              headerImage: AppAssets.headerBreak1,
              openNext: (context) =>
                  _openStage2Question(context, index + 1, next, replace: true),
            );
          } else {
            _openStage2Question(context, index + 1, next);
          }
        } else {
          _openStage2Complete(context, scoreBigFive(next));
        }
      },
    ),
  );
  replace
      ? Navigator.pushReplacement(context, route)
      : Navigator.push(context, route);
}

void _openStage2Complete(BuildContext context, BigFiveResult result) {
  // Stored the way the specification asks: the recoded score of every item,
  // plus each dimension's raw score, mean and band, so the result can be
  // audited against the raw answers saved alongside it.
  saveModuleAnswer(
    'module2',
    'stage2_result',
    type: 'big_five_result',
    value: {
      'version': 'ipip-50-ro-v1',
      'recoded': {
        for (final e in result.recodedAnswers.entries) '${e.key}': e.value,
      },
      'dimensions': {
        for (final d in result.dimensions)
          d.dimension.name: {
            'rawScore': d.rawScore,
            'mean': d.mean,
            'level': d.level.name,
          },
      },
    },
    stage: 2,
  );

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => StageCompleteScreen(
        stageLabel: "Modulul 2 · Etapa 2 din 6",
        headerImage: AppAssets.headerM2Stage2Complete,
        title: "Etapa 2 este completă",
        message:
            "Ai parcurs etapa despre personalitatea ta. Răspunsurile tale încep să așeze câteva repere, iar în continuare le privim fără concluzii fixe.",
        achievementTitle: "Care este personalitatea ta",
        achievementSubtitle: "${bigFiveItems.length} de afirmații finalizate",
        infoNote:
            "Nu trebuie să te recunoști perfect în fiecare reper. Căutăm direcții, nu definiții.",
        primaryLabel: "Vezi rezultatul",
        onPrimary: () => _openStage2Feedback(context, result),
        secondaryLabel: "Revin mai târziu",
        onSecondary: () => goToDashboard(context),
      ),
    ),
  );
}

void _openStage2Feedback(BuildContext context, BigFiveResult result) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => BigFiveResultScreen(
        result: result,
        onContinue: () => _openStage3Intro(context),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Stage 3 — Cognitive style
// ---------------------------------------------------------------------------

void _openStage3Intro(BuildContext context) {
  saveResumePoint('module2', 3, 0);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Etapa 3 din 6 · Stil cognitiv",
        icon: AppAssets.m2Stage3Icon,
        moduleTitle: "Cum",
        titleAccent: "gândești",
        description:
            "Această etapă explorează felul în care observi, procesezi informația și abordezi problemele.",
        nextSteps: [
          "${cognitiveStyleItems.length} de afirmații scurte",
          "Alegi cât de mult te regăsești în fiecare",
          "Afli ce îți vine natural când înveți și cauți soluții",
        ],
        continueLabel: "Începe etapa",
        progressNote:
            "Nu măsurăm inteligența. Explorăm felul în care mintea ta funcționează cel mai natural.",
        onContinue: () => _openStage3Question(context, 0, const {}),
      ),
    ),
  );
}

/// [answers] maps an item number to the option the user picked, 1-5,
/// carried forward so the whole questionnaire is scored in one go.
void _openStage3Question(
  BuildContext context,
  int index,
  Map<int, int> answers,
) {
  final item = cognitiveStyleItems[index];
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleScaleQuestionScreen(
        sectionLabel: "Cum gândești",
        statement: item.statement,
        options: cognitiveStyleScaleLabels,
        questionNumber: index + 1,
        totalQuestions: cognitiveStyleItems.length,
        onContinue: (selection) {
          // The screen reports a 0-based index; the instrument scores 1-5.
          final answer = selection + 1;
          saveModuleAnswer(
            'module2',
            'stage3_q${item.number}',
            type: 'scale',
            value: {'selectedIndex': selection, 'answer': answer},
            stage: 3,
            questionNumber: item.number,
          );
          final next = {...answers, item.number: answer};
          saveResumePoint('module2', 3, index + 1, next);
          if (index + 1 < cognitiveStyleItems.length) {
            _openStage3Question(context, index + 1, next);
          } else {
            _openStage3Complete(context, scoreCognitiveStyle(next));
          }
        },
      ),
    ),
  );
}

void _openStage3Complete(BuildContext context, CognitiveStyleResult result) {
  // Stored the way the specification asks: every item's raw answer, the ten
  // pole scores with their levels, and each dimension's resulting
  // combination plus the id of the feedback variant shown to the user.
  saveModuleAnswer(
    'module2',
    'stage3_result',
    type: 'cognitive_style_result',
    value: {
      'version': 'cognitive-style-ro-v1',
      'answers': {for (final e in result.answers.entries) '${e.key}': e.value},
      'poles': {
        for (final e in result.poleScores.entries)
          e.key.name: {
            'score': e.value,
            'level': cognitiveLevelForScore(e.value).name,
          },
      },
      'dimensions': {
        for (final d in result.dimensions)
          d.dimension.name: {
            'firstPole': d.dimension.first.name,
            'firstScore': d.firstScore,
            'firstLevel': d.firstLevel.name,
            'secondPole': d.dimension.second.name,
            'secondScore': d.secondScore,
            'secondLevel': d.secondLevel.name,
            'feedbackId': d.feedbackId,
          },
      },
    },
    stage: 3,
  );

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => StageCompleteScreen(
        stageLabel: "Modulul 2 · Etapa 3 din 6",
        headerImage: AppAssets.headerM2Stage3Complete,
        title: "Etapa 3 este completă",
        message:
            "Ai parcurs etapa despre felul în care gândești. Răspunsurile tale ne ajută să observăm un stil, nu să măsurăm cât de „bine” gândești.",
        achievementTitle: "Cum gândești",
        achievementSubtitle:
            "${cognitiveStyleItems.length} de afirmații finalizate",
        infoNote:
            "Nu măsurăm cât de bine gândești. Observăm cum îți vine mai natural să înțelegi lucrurile.",
        primaryLabel: "Vezi rezultatul",
        onPrimary: () => _openStage3Feedback(context, result),
        secondaryLabel: "Revin mai târziu",
        onSecondary: () => goToDashboard(context),
      ),
    ),
  );
}

void _openStage3Feedback(BuildContext context, CognitiveStyleResult result) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => CognitiveStyleResultScreen(
        result: result,
        onContinue: () => _openStage4Intro(context),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Stage 4 — Decision style
// ---------------------------------------------------------------------------

void _openStage4Intro(BuildContext context) {
  saveResumePoint('module2', 4, 0);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Etapa 4 din 6 · Stil decizional",
        icon: AppAssets.m2Stage4Icon,
        moduleTitle: "Cum iei",
        titleAccent: "decizii",
        description: "Ce te ajută sau te încurcă atunci când trebuie să alegi.",
        nextSteps: [
          "${decisionStyleItems.length} de afirmații scurte",
          "Bifezi afirmațiile care ți se potrivesc",
          "Înțelegi ce contează pentru tine când faci alegeri",
        ],
        continueLabel: "Începe etapa",
        progressNote:
            "Nu trebuie să alegi perfect. Doar observăm ce te ajută să alegi mai clar.",
        progressNoteBoldLead: true,
        onContinue: () => _openStage4Question(context, 0, const {}),
      ),
    ),
  );
}

/// [answers] maps an item number to whether the user selected it, carried
/// forward so the whole questionnaire is scored in one go.
void _openStage4Question(
  BuildContext context,
  int index,
  Map<int, bool> answers,
) {
  final item = decisionStyleItems[index];
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleScaleQuestionScreen(
        sectionLabel: "Cum iei decizii",
        statement: item.statement,
        subtitle: "Alege dacă afirmația ți se potrivește.",
        caption: "Nu există răspunsuri corecte sau greșite.",
        options: decisionStyleScaleLabels,
        questionNumber: index + 1,
        totalQuestions: decisionStyleItems.length,
        onContinue: (selection) {
          final selected = selection == 1;
          saveModuleAnswer(
            'module2',
            'stage4_q${item.number}',
            type: 'binary',
            value: {'selected': selected},
            stage: 4,
            questionNumber: item.number,
          );
          final next = {...answers, item.number: selected};
          saveResumePoint('module2', 4, index + 1, next);
          if (index + 1 < decisionStyleItems.length) {
            _openStage4Question(context, index + 1, next);
          } else {
            _openStage4Complete(context, scoreDecisionStyle(next));
          }
        },
      ),
    ),
  );
}

void _openStage4Complete(BuildContext context, DecisionStyleResult result) {
  // Stored the way the specification asks: every item's selected state,
  // plus each style's 0-4 score, so the result can be audited against the
  // raw answers saved alongside it.
  saveModuleAnswer(
    'module2',
    'stage4_result',
    type: 'decision_style_result',
    value: {
      'version': 'decision-style-ro-v1',
      'selected': {
        for (final e in result.selectedAnswers.entries) '${e.key}': e.value,
      },
      'styles': {
        for (final d in result.dimensions) d.style.name: {'score': d.score},
      },
    },
    stage: 4,
  );

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => StageCompleteScreen(
        stageLabel: "Modulul 2 · Etapa 4 din 6",
        headerImage: AppAssets.headerM2Stage4Complete,
        title: "Etapa 4 este completă",
        message:
            "Ai parcurs etapa despre felul în care iei decizii. Răspunsurile tale ne ajută să vedem ce te poate susține când ai de ales.",
        achievementTitle: "Cum iei decizii",
        achievementSubtitle:
            "${decisionStyleItems.length} de afirmații finalizate",
        infoNote:
            "Stilul tău decizional nu te limitează. Îți arată ce te poate ajuta să alegi mai clar.",
        primaryLabel: "Vezi rezultatul",
        onPrimary: () => _openStage4Feedback(context, result),
        secondaryLabel: "Revin mai târziu",
        onSecondary: () => goToDashboard(context),
      ),
    ),
  );
}

void _openStage4Feedback(BuildContext context, DecisionStyleResult result) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => DecisionStyleResultScreen(
        result: result,
        onContinue: () => _openStage5Intro(context),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Stage 5 — Emotional patterns
// ---------------------------------------------------------------------------

void _openStage5Intro(BuildContext context) {
  saveResumePoint('module2', 5, 0);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Etapa 5 din 6 · Tipare emoționale",
        icon: AppAssets.m2Stage5Icon,
        moduleTitle: "Cum reacționezi",
        titleAccent: "sub presiune",
        description:
            "Ce se întâmplă când apar stresul, emoțiile puternice sau îndoiala.",
        nextSteps: [
          "${emotionalPatternsItems.length} de afirmații scurte",
          "Alegi cât de adevărată se simte fiecare afirmație pentru tine",
          "Înțelegi ce se întâmplă cu tine în momente solicitante",
        ],
        continueLabel: "Începe etapa",
        progressNote:
            "Emoțiile tale nu sunt ceva de reparat. Sunt semnale care te ajută să înțelegi ce ai nevoie.",
        progressNoteBoldLead: true,
        onContinue: () => _openStage5Question(context, 0, const {}),
      ),
    ),
  );
}

/// [answers] maps an item number to the option the user picked, 1-5,
/// carried forward so the whole questionnaire is scored in one go. The
/// reverse-scored items are recoded at scoring time, never here.
void _openStage5Question(
  BuildContext context,
  int index,
  Map<int, int> answers, {
  bool replace = false,
}) {
  final item = emotionalPatternsItems[index];
  final route = MaterialPageRoute<void>(
    builder: (context) => ModuleScaleQuestionScreen(
      sectionLabel: "Cum reacționezi sub presiune",
      statement: item.statement,
      caption:
          "Gândește-te la cum ești de obicei, nu doar la o singură situație.",
      options: emotionalPatternsScaleLabels,
      questionNumber: index + 1,
      totalQuestions: emotionalPatternsItems.length,
      onContinue: (selection) {
        // The screen reports a 0-based index; the instrument scores 1-5.
        final answer = selection + 1;
        saveModuleAnswer(
          'module2',
          'stage5_q${item.number}',
          type: 'scale',
          value: {'selectedIndex': selection, 'answer': answer},
          stage: 5,
          questionNumber: item.number,
        );
        final next = {...answers, item.number: answer};
        saveResumePoint('module2', 5, index + 1, next);
        if (index + 1 < emotionalPatternsItems.length) {
          if (index + 1 == 15) {
            openQuestionBreak(
              context,
              title: "Ai ajuns la jumătate",
              message:
                  "Ai parcurs jumătate din întrebări. Unele alegeri pot fi clare, altele mai greu de simțit. E normal. Continuăm când ești gata.",
              headerImage: AppAssets.headerBreak2,
              openNext: (context) =>
                  _openStage5Question(context, index + 1, next, replace: true),
            );
          } else {
            _openStage5Question(context, index + 1, next);
          }
        } else {
          _openStage5Complete(context, scoreEmotionalPatterns(next));
        }
      },
    ),
  );
  replace
      ? Navigator.pushReplacement(context, route)
      : Navigator.push(context, route);
}

void _openStage5Complete(BuildContext context, EmotionalPatternsResult result) {
  // Stored the way the specification asks: every item's recoded score, each
  // dimension's two-decimal mean with its level, and the id of the feedback
  // variant shown — all auditable against the raw answers saved alongside.
  saveModuleAnswer(
    'module2',
    'stage5_result',
    type: 'emotional_patterns_result',
    value: {
      'version': 'emotional-patterns-ro-v1',
      'recoded': {
        for (final e in result.recodedAnswers.entries) '${e.key}': e.value,
      },
      'dimensions': {
        for (final d in result.dimensions)
          d.dimension.name: {
            'score': d.score,
            'level': d.level.name,
            'itemCount': d.itemCount,
            'feedbackId': d.feedbackId,
          },
      },
    },
    stage: 5,
  );

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => StageCompleteScreen(
        stageLabel: "Modulul 2 · Etapa 5 din 6",
        headerImage: AppAssets.headerM2Stage5Complete,
        title: "Etapa 5 este completă",
        message:
            "Ai parcurs o etapă mai sensibilă. Răspunsurile tale au fost salvate, iar în continuare le privim cu grijă, fără concluzii grăbite.",
        achievementTitle: "Cum reacționezi sub presiune",
        achievementSubtitle:
            "${emotionalPatternsItems.length} de afirmații finalizate",
        infoNote:
            "Nu trebuie să tragi concluzii singur(ă). Le luăm pe rând, cu calm.",
        primaryLabel: "Vezi rezultatul",
        onPrimary: () => _openStage5Feedback(context, result),
        secondaryLabel: "Revin mai târziu",
        onSecondary: () => goToDashboard(context),
      ),
    ),
  );
}

void _openStage5Feedback(BuildContext context, EmotionalPatternsResult result) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => EmotionalPatternsResultScreen(
        result: result,
        onContinue: () => _openStage6Intro(context),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Stage 6 — Perceived control
// ---------------------------------------------------------------------------

void _openStage6Intro(BuildContext context) {
  saveResumePoint('module2', 6, 0);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Etapa 6 din 6 · Control perceput",
        icon: AppAssets.m2Stage6Icon,
        moduleTitle: "Cât control simți că ai",
        description:
            "În ce măsură simți că poți influența ceea ce ți se întâmplă.",
        nextSteps: [
          "${perceivedControlItems.length} de afirmații scurte",
          "Alegi cât de adevărată se simte fiecare afirmație",
          "Descoperi ce crezi că îți influențează viitorul",
        ],
        continueLabel: "Începe etapa",
        progressNote:
            "Nu trebuie să controlezi totul ca să mergi mai departe. Uneori, claritatea începe cu lucrurile mici pe care le poți alege azi.",
        onContinue: () => _openStage6Question(context, 0, const {}),
      ),
    ),
  );
}

/// [answers] maps an item number to the option the user picked, 1-5,
/// carried forward so the whole questionnaire is scored in one go.
void _openStage6Question(
  BuildContext context,
  int index,
  Map<int, int> answers,
) {
  final item = perceivedControlItems[index];
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleScaleQuestionScreen(
        sectionLabel: "Cât control simți că ai",
        statement: item.statement,
        options: perceivedControlScaleLabels,
        questionNumber: index + 1,
        totalQuestions: perceivedControlItems.length,
        onContinue: (selection) {
          // The screen reports a 0-based index; the instrument scores 1-5.
          final answer = selection + 1;
          saveModuleAnswer(
            'module2',
            'stage6_q${item.number}',
            type: 'scale',
            value: {'selectedIndex': selection, 'answer': answer},
            stage: 6,
            questionNumber: item.number,
          );
          final next = {...answers, item.number: answer};
          saveResumePoint('module2', 6, index + 1, next);
          if (index + 1 < perceivedControlItems.length) {
            _openStage6Question(context, index + 1, next);
          } else {
            _openStage6Complete(context, scorePerceivedControl(next));
          }
        },
      ),
    ),
  );
}

void _openStage6Complete(BuildContext context, PerceivedControlResult result) {
  // Stored the way the specification asks: the raw answers, each
  // dimension's raw 5-25 score with its band, and the id of the feedback
  // variant shown. No means are computed or stored for this instrument.
  saveModuleAnswer(
    'module2',
    'stage6_result',
    type: 'perceived_control_result',
    value: {
      'version': 'perceived-control-ro-v1',
      'answers': {for (final e in result.answers.entries) '${e.key}': e.value},
      'dimensions': {
        for (final d in result.dimensions)
          d.dimension.name: {
            'score': d.score,
            'level': d.level.name,
            'feedbackId': d.feedbackId,
          },
      },
    },
    stage: 6,
  );

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => StageCompleteScreen(
        stageLabel: "Modulul 2 · Etapa 6 din 6",
        headerImage: AppAssets.headerM2Stage6Complete,
        title: "Etapa 6 este completă",
        message:
            "Ai parcurs ultima etapă a profilului psihologic. Răspunsurile tale ne ajută să vedem cum se leagă piesele între ele.",
        achievementTitle: "Cât control simți că ai",
        achievementSubtitle:
            "${perceivedControlItems.length} de afirmații finalizate",
        infoNote:
            "Ai ajuns la ultima piesă din acest modul. În curând le vom pune pe toate cap la cap.",
        primaryLabel: "Vezi rezultatul",
        onPrimary: () => _openStage6Feedback(context, result),
        secondaryLabel: "Revin mai târziu",
        onSecondary: () => goToDashboard(context),
      ),
    ),
  );
}

void _openStage6Feedback(BuildContext context, PerceivedControlResult result) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => PerceivedControlResultScreen(
        result: result,
        onContinue: () => _openModule2FinalFeedback(context),
      ),
    ),
  );
}

/// [readOnly] reopens the synthesis from the dashboard once the module is
/// finished: the same screen, but its button only goes back.
void _openModule2FinalFeedback(BuildContext context, {bool readOnly = false}) {
  final route = MaterialPageRoute<void>(
    builder: (context) => InsightFeedbackGate(
      scope: 'module2_final',
      moduleId: 'module2',
      loadingLabel: "Modulul 2 · Imagine de ansamblu",
      readOnly: readOnly,
      onContinue: _openModule2Complete,
      builder: (context, insight) => ModuleFinalFeedbackScreen(
        moduleLabel: "Modulul 2 · Imagine de ansamblu",
        title: "Ce ai înțeles despre tine în Modulul 2",
        description:
            "Cele 6 etape au privit lucrurile din unghiuri diferite. Împreună, ele arată cum gândești, cum alegi și ce ai nevoie ca să vezi mai clar direcția ta.",
        synthesisTitle: "Ce se conturează când le privim împreună",
        synthesisDescription:
            insight?.profileDescription ??
            "Se conturează un mod atent de a privi lucrurile, orientat spre sens și claritate. Pari să ai nevoie ca alegerile să aibă logică pentru tine, nu doar să pară corecte din exterior.",
        connectionsTitle: "Cum se leagă între ele",
        connections: insight != null && insight.items.isNotEmpty
            ? insightToConnectionItems(insight)
            : const [
                ConnectionItem(
                  icon: Icons.lightbulb_outline,
                  title: "Când înțelegi sensul",
                  description:
                      "Te poți implica mai ușor când vezi de ce contează o alegere pentru tine și cum se leagă de ce îți dorești.",
                ),
                ConnectionItem(
                  icon: Icons.compress_outlined,
                  title: "Când presiunea crește",
                  description:
                      "Poți avea nevoie de timp, repere și claritate ca să alegi cu mai multă încredere.",
                ),
                ConnectionItem(
                  icon: Icons.arrow_forward_outlined,
                  title: "Când vezi următorul pas",
                  description:
                      "Nu trebuie să controlezi totul ca să mergi mai departe. Uneori ajută să vezi ce pas mic depinde de tine acum.",
                ),
              ],
        infoNote:
            "Aceste repere ne ajută, în următoarele module, să legăm felul în care funcționezi de interesele, aptitudinile și direcțiile potrivite pentru tine.",
        continueLabel: readOnly
            ? "Înapoi la parcurs"
            : "Ascultă mesajul pentru tine",
        onContinue: readOnly
            ? () => Navigator.pop(context)
            : () => _openModule2Complete(context),
      ),
    ),
  );
  readOnly
      ? Navigator.push(context, route)
      : Navigator.pushReplacement(context, route);
}

void _openModule2Complete(BuildContext context) {
  ModuleProgress.markCompleted(2);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleCompleteScreen(
        headerImage: AppAssets.headerM2Complete,
        title: "Modulul 2 este complet",
        message:
            "Ai parcurs un modul intens. Înainte să trecem mai departe, ți-am pregătit un scurt mesaj care pune lucrurile în perspectivă, cu calm.",
        encouragementNote:
            "Nu trebuie să tragi concluzii acum. E suficient să lași lucrurile să se așeze puțin.",
        audioAssetPath: _completeAudio,
        continueLabel: "Continuă cu Modulul 3",
        nextModuleLabel: "Urmează Modulul 3",
        nextModuleTitle: "Interese & vocație",
        nextModuleDescription:
            "Vei explora ce tipuri de activități, domenii și medii de lucru se potrivesc mai bine cu tine.",
        onContinue: () => startModule3(context),
        onHome: () => goToDashboard(context),
      ),
    ),
  );
}

/// Reopens this module's synthesis from the dashboard, read-only.
void openModule2Summary(BuildContext context) =>
    _openModule2FinalFeedback(context, readOnly: true);

// ---------------------------------------------------------------------------
// Read-only stage results, opened from the dashboard
// ---------------------------------------------------------------------------

/// Opens one finished stage's result read-only. The result is scored again
/// from the saved item answers with the same key, so it is the screen the
/// user saw at the end of the stage; nothing is saved and the button only
/// goes back.
void openModule2StageResult(BuildContext context, int stage) {
  Future<Map<int, int>> scale(String uid) =>
      loadStageAnswers<int>(uid, 'module2', stage, scaleAnswerOf);

  switch (stage) {
    case 1:
      openStageResult<MbtiResult>(
        context,
        load: (uid) async {
          final answers = await loadStageAnswers<int>(
            uid,
            'module2',
            1,
            (v) => (v['pointsForA'] as num?)?.toInt(),
          );
          return answers.length < mbtiItems.length ? null : scoreMbti(answers);
        },
        build: (context, result, back) => _stage1FeedbackScreen(
          result,
          continueLabel: readOnlyBackLabel,
          onContinue: back,
        ),
      );
    case 2:
      openStageResult<BigFiveResult>(
        context,
        load: (uid) async {
          final answers = await scale(uid);
          return answers.length < bigFiveItems.length
              ? null
              : scoreBigFive(answers);
        },
        build: (context, result, back) => BigFiveResultScreen(
          result: result,
          continueLabel: readOnlyBackLabel,
          onContinue: back,
        ),
      );
    case 3:
      openStageResult<CognitiveStyleResult>(
        context,
        load: (uid) async {
          final answers = await scale(uid);
          return answers.length < cognitiveStyleItems.length
              ? null
              : scoreCognitiveStyle(answers);
        },
        build: (context, result, back) => CognitiveStyleResultScreen(
          result: result,
          continueLabel: readOnlyBackLabel,
          onContinue: back,
        ),
      );
    case 4:
      openStageResult<DecisionStyleResult>(
        context,
        load: (uid) async {
          final answers = await loadStageAnswers<bool>(
            uid,
            'module2',
            4,
            (v) => v['selected'] as bool?,
          );
          return answers.length < decisionStyleItems.length
              ? null
              : scoreDecisionStyle(answers);
        },
        build: (context, result, back) => DecisionStyleResultScreen(
          result: result,
          continueLabel: readOnlyBackLabel,
          onContinue: back,
        ),
      );
    case 5:
      openStageResult<EmotionalPatternsResult>(
        context,
        load: (uid) async {
          final answers = await scale(uid);
          return answers.length < emotionalPatternsItems.length
              ? null
              : scoreEmotionalPatterns(answers);
        },
        build: (context, result, back) => EmotionalPatternsResultScreen(
          result: result,
          continueLabel: readOnlyBackLabel,
          onContinue: back,
        ),
      );
    case 6:
      openStageResult<PerceivedControlResult>(
        context,
        load: (uid) async {
          final answers = await scale(uid);
          return answers.length < perceivedControlItems.length
              ? null
              : scorePerceivedControl(answers);
        },
        build: (context, result, back) => PerceivedControlResultScreen(
          result: result,
          continueLabel: readOnlyBackLabel,
          onContinue: back,
        ),
      );
  }
}

/// Debug shortcuts: each stage's introduction, ignoring any resume point.
void debugModule2Stage1(BuildContext context) => _openStage1Intro(context);
void debugModule2Stage2(BuildContext context) => _openStage2Intro(context);
void debugModule2Stage3(BuildContext context) => _openStage3Intro(context);
void debugModule2Stage4(BuildContext context) => _openStage4Intro(context);
void debugModule2Stage5(BuildContext context) => _openStage5Intro(context);
void debugModule2Stage6(BuildContext context) => _openStage6Intro(context);
