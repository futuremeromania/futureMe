import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:injectable/injectable.dart';

const _callTimeout = Duration(seconds: 25);

/// The career plan is a long generation; the function itself allows 300s.
const _careerPlanTimeout = Duration(seconds: 300);

/// A per-user feedback or module synthesis. The syntheses put several
/// stages together and can take well over half a minute.
const _insightTimeout = Duration(seconds: 90);

/// A spoken summary of a long result screen; on a timeout the card falls
/// back to reading the whole text, so this must not be too tight.
const _summaryTimeout = Duration(seconds: 60);

/// The final report function runs up to 9 minutes.
const _reportTimeout = Duration(minutes: 9);

/// One reflective question generated for Module 1.
class GeneratedQuestion {
  const GeneratedQuestion({
    required this.question,
    required this.subtitle,
    required this.placeholder,
    this.hint,
  });

  final String question;
  final String subtitle;
  final String placeholder;
  final String? hint;

  static GeneratedQuestion fromMap(Map<String, dynamic> m) => GeneratedQuestion(
        question: (m['question'] as String?) ?? '',
        subtitle: (m['subtitle'] as String?) ?? '',
        placeholder: (m['placeholder'] as String?) ?? 'Scrie aici...',
        hint: (m['hint'] as String?)?.trim().isNotEmpty ?? false ? m['hint'] as String : null,
      );
}

/// 'low' | 'medium' | 'high'
enum InsightLevel { low, medium, high }

InsightLevel? _levelFrom(Object? raw) {
  switch (raw) {
    case 'low':
      return InsightLevel.low;
    case 'medium':
      return InsightLevel.medium;
    case 'high':
      return InsightLevel.high;
    default:
      return null;
  }
}

class GeneratedInsightItem {
  const GeneratedInsightItem({required this.title, required this.description, this.level});

  final String title;
  final String description;
  final InsightLevel? level;

  static GeneratedInsightItem fromMap(Map<String, dynamic> m) => GeneratedInsightItem(
        title: (m['title'] as String?) ?? '',
        description: (m['description'] as String?) ?? '',
        level: _levelFrom(m['level']),
      );
}

/// Per-user interpretation of one module/stage — mirrors the `generateInsight`
/// Cloud Function response (see `functions/ai.js`).
class GeneratedInsight {
  const GeneratedInsight({
    this.profileLabel,
    this.profileValue,
    this.profileDescription,
    required this.items,
    this.explorationAreas = const [],
  });

  final String? profileLabel;
  final String? profileValue;
  final String? profileDescription;
  final List<GeneratedInsightItem> items;

  /// Broad families of activity worth exploring — only the Module 3
  /// synthesis produces these, and only 2-4 of them. Empty everywhere else.
  final List<String> explorationAreas;

  static GeneratedInsight fromMap(Map<String, dynamic> m) => GeneratedInsight(
        profileLabel: m['profileLabel'] as String?,
        profileValue: m['profileValue'] as String?,
        profileDescription: m['profileDescription'] as String?,
        items: ((m['items'] as List?) ?? const [])
            .map((e) => GeneratedInsightItem.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList(),
        explorationAreas: ((m['explorationAreas'] as List?) ?? const []).map((e) => e.toString()).toList(),
      );
}

/// 'primary' | 'warm' | 'subtle' — mirrors `CardPillTone` in
/// `tagged_card_list_screen.dart`.
enum GeneratedCardTone { primary, warm, subtle }

GeneratedCardTone? _toneFrom(Object? raw) => switch (raw) {
      'primary' => GeneratedCardTone.primary,
      'warm' => GeneratedCardTone.warm,
      'subtle' => GeneratedCardTone.subtle,
      _ => null,
    };

/// One Module 5 "tagged card" (a career direction or its AI-impact
/// counterpart, or a training option) — mirrors the `TaggedCard` shape.
class GeneratedTaggedCard {
  const GeneratedTaggedCard({required this.title, required this.description, required this.tags, this.pillLabel, this.pillTone});

  final String title;
  final String description;
  final List<String> tags;
  final String? pillLabel;
  final GeneratedCardTone? pillTone;

  static GeneratedTaggedCard fromMap(Map<String, dynamic> m) => GeneratedTaggedCard(
        title: (m['title'] as String?) ?? '',
        description: (m['description'] as String?) ?? '',
        tags: ((m['tags'] as List?) ?? const []).map((e) => e.toString()).toList(),
        pillLabel: m['pillLabel'] as String?,
        pillTone: _toneFrom(m['pillTone']),
      );
}

class GeneratedRecommendation {
  const GeneratedRecommendation({required this.title, required this.description, this.examples = const []});

  final String title;
  final String description;

  /// 1-3 concrete ways to act on the recommendation, shown under "Exemple:".
  final List<String> examples;

  static GeneratedRecommendation fromMap(Map<String, dynamic> m) => GeneratedRecommendation(
        title: (m['title'] as String?) ?? '',
        description: (m['description'] as String?) ?? '',
        examples: ((m['tags'] as List?) ?? const []).map((e) => e.toString()).toList(),
      );
}

class GeneratedPlanStep {
  const GeneratedPlanStep({required this.title, required this.periodLabel, required this.description, this.checklist});

  final String title;
  final String periodLabel;
  final String description;
  final List<String>? checklist;

  static GeneratedPlanStep fromMap(Map<String, dynamic> m) => GeneratedPlanStep(
        title: (m['title'] as String?) ?? '',
        periodLabel: (m['periodLabel'] as String?) ?? '',
        description: (m['description'] as String?) ?? '',
        checklist: (m['checklist'] as List?)?.map((e) => e.toString()).toList(),
      );
}

class GeneratedPlan {
  const GeneratedPlan({
    required this.directionTitle,
    required this.directionDescription,
    required this.firstStepTitle,
    required this.firstStepDescription,
    required this.steps,
  });

  final String directionTitle;
  final String directionDescription;
  final String firstStepTitle;
  final String firstStepDescription;
  final List<GeneratedPlanStep> steps;

  static GeneratedPlan fromMap(Map<String, dynamic> m) => GeneratedPlan(
        directionTitle: (m['directionTitle'] as String?) ?? '',
        directionDescription: (m['directionDescription'] as String?) ?? '',
        firstStepTitle: (m['firstStepTitle'] as String?) ?? '',
        firstStepDescription: (m['firstStepDescription'] as String?) ?? '',
        steps: ((m['steps'] as List?) ?? const []).map((e) => GeneratedPlanStep.fromMap(Map<String, dynamic>.from(e as Map))).toList(),
      );
}

/// Module 5's per-user career plan — directions, their AI-impact readout,
/// practical recommendations, training options and a 3-step plan. Mirrors
/// the `generateCareerPlan` Cloud Function response.
class GeneratedCareerPlan {
  const GeneratedCareerPlan({
    required this.directions,
    required this.aiImpact,
    required this.recommendations,
    required this.training,
    this.plan,
  });

  final List<GeneratedTaggedCard> directions;
  final List<GeneratedTaggedCard> aiImpact;
  final List<GeneratedRecommendation> recommendations;
  final List<GeneratedTaggedCard> training;
  /// Null until the user has chosen a direction and its plan was built
  /// (`generateDirectionPlan`).
  final GeneratedPlan? plan;

  GeneratedCareerPlan withPlan(GeneratedPlan plan) =>
      GeneratedCareerPlan(directions: directions, aiImpact: aiImpact, recommendations: recommendations, training: training, plan: plan);

  static GeneratedCareerPlan fromMap(Map<String, dynamic> m) => GeneratedCareerPlan(
        directions: ((m['directions'] as List?) ?? const []).map((e) => GeneratedTaggedCard.fromMap(Map<String, dynamic>.from(e as Map))).toList(),
        aiImpact: ((m['aiImpact'] as List?) ?? const []).map((e) => GeneratedTaggedCard.fromMap(Map<String, dynamic>.from(e as Map))).toList(),
        recommendations:
            ((m['recommendations'] as List?) ?? const []).map((e) => GeneratedRecommendation.fromMap(Map<String, dynamic>.from(e as Map))).toList(),
        training: ((m['training'] as List?) ?? const []).map((e) => GeneratedTaggedCard.fromMap(Map<String, dynamic>.from(e as Map))).toList(),
        plan: m['plan'] is Map ? GeneratedPlan.fromMap(Map<String, dynamic>.from(m['plan'] as Map)) : null,
      );
}

class GeneratedReportSection {
  const GeneratedReportSection({required this.title, required this.body});

  final String title;
  final String body;

  static GeneratedReportSection fromMap(Map<String, dynamic> m) =>
      GeneratedReportSection(title: (m['title'] as String?) ?? '', body: (m['body'] as String?) ?? '');
}

/// One point inside a report item — e.g. "De ce ți se potrivește" under a
/// recommended direction.
class GeneratedReportPoint {
  const GeneratedReportPoint({required this.label, required this.text});

  final String label;
  final String text;

  static GeneratedReportPoint fromMap(Map<String, dynamic> m) =>
      GeneratedReportPoint(label: (m['label'] as String?) ?? '', text: (m['text'] as String?) ?? '');
}

/// A subsection of a report block: an optional subheading, its text, and
/// (for the recommended directions) labelled points.
class GeneratedReportItem {
  const GeneratedReportItem({this.heading, required this.text, this.points = const []});

  final String? heading;
  final String text;
  final List<GeneratedReportPoint> points;

  static GeneratedReportItem fromMap(Map<String, dynamic> m) => GeneratedReportItem(
        heading: (m['heading'] as String?)?.trim().isEmpty ?? true ? null : m['heading'] as String,
        text: (m['text'] as String?) ?? '',
        points: ((m['points'] as List?) ?? const []).map((e) => GeneratedReportPoint.fromMap(Map<String, dynamic>.from(e as Map))).toList(),
      );
}

/// One numbered section of the report, in the order of the report structure.
class GeneratedReportBlock {
  const GeneratedReportBlock({required this.title, required this.items});

  final String title;
  final List<GeneratedReportItem> items;

  static GeneratedReportBlock fromMap(Map<String, dynamic> m) => GeneratedReportBlock(
        title: (m['title'] as String?) ?? '',
        items: ((m['items'] as List?) ?? const []).map((e) => GeneratedReportItem.fromMap(Map<String, dynamic>.from(e as Map))).toList(),
      );
}

/// The final personalized report — the `users/{uid}/reports/finalReport`
/// document written by the `generateFinalReport` Cloud Function. [sections]
/// is the same content flattened to `{title, body}` for the in-app preview;
/// [blocks] keeps the subsections for the PDF.
class GeneratedReport {
  const GeneratedReport({required this.sections, this.summary, this.blocks = const [], this.generatedAt, this.userName});

  /// The name on the cover, as stored on the profile when the report was made.
  final String? userName;
  final String? summary;
  final List<GeneratedReportSection> sections;
  final List<GeneratedReportBlock> blocks;
  final DateTime? generatedAt;

  List<Map<String, String>> get sectionMaps => [for (final s in sections) {'title': s.title, 'body': s.body}];

  static GeneratedReport fromMap(Map<String, dynamic> m) {
    final generatedAt = m['generatedAt'];
    final userName = (m['userName'] as String?)?.trim();
    return GeneratedReport(
      userName: userName == null || userName.isEmpty ? null : userName,
      summary: m['summary'] as String?,
      sections: ((m['sections'] as List?) ?? const []).map((e) => GeneratedReportSection.fromMap(Map<String, dynamic>.from(e as Map))).toList(),
      blocks: ((m['blocks'] as List?) ?? const []).map((e) => GeneratedReportBlock.fromMap(Map<String, dynamic>.from(e as Map))).toList(),
      generatedAt: generatedAt is Timestamp ? generatedAt.toDate() : null,
    );
  }
}

/// What a `generateFinalReport` request came back with.
enum FinalReportRequest {
  /// This call generated the report; it is saved.
  ready,

  /// Another run is already working on it.
  generating,

  /// The server tried and failed; the document says `failed`.
  failed,

  /// No answer (timeout, network): the server may still finish — watch the document.
  unknown,
}

/// Claude-backed dynamic module content. **Every method returns null on any
/// failure** (function not deployed, network, model error, bad JSON) — callers
/// must fall back to the built-in static content so the app never breaks.
/// See `functions/ai.js` for `generateModule1Questions` / `generateInsight` /
/// `generateCareerPlan` / `generateFinalReport`.
@lazySingleton
class AiContentRepository {
  AiContentRepository(this._functions);

  final FirebaseFunctions _functions;

  Future<List<GeneratedQuestion>?> module1Questions({String? ageBracket}) async {
    try {
      final callable = _functions.httpsCallable(
        'generateModule1Questions',
        options: HttpsCallableOptions(timeout: _callTimeout),
      );
      final result = await callable.call<Map<String, dynamic>>({
        if (ageBracket != null) 'ageBracket': ageBracket,
      });
      final raw = (result.data['questions'] as List?) ?? const [];
      final questions =
          raw.map((e) => GeneratedQuestion.fromMap(Map<String, dynamic>.from(e as Map))).toList();
      return questions.length == 3 ? questions : null;
    } catch (_) {
      return null;
    }
  }

  Future<GeneratedInsight?> insight({
    required String scope,
    required List<Map<String, dynamic>> answers,
  }) async {
    if (answers.isEmpty) return null;
    try {
      final callable = _functions.httpsCallable(
        'generateInsight',
        options: HttpsCallableOptions(timeout: _insightTimeout),
      );
      final result = await callable.call<Map<String, dynamic>>({
        'scope': scope,
        'answers': answers,
      });
      final insight = GeneratedInsight.fromMap(result.data);
      return insight.items.isEmpty ? null : insight;
    } catch (_) {
      return null;
    }
  }

  /// A spoken summary of a result screen's own validated text. Returns null
  /// on any failure — the caller then speaks the full text as before.
  Future<String?> spokenSummary({required String scope, required String text}) async {
    if (text.trim().isEmpty) return null;
    try {
      final callable = _functions.httpsCallable('generateSpokenSummary', options: HttpsCallableOptions(timeout: _summaryTimeout));
      final result = await callable.call<Map<String, dynamic>>({'scope': scope, 'text': text});
      final summary = (result.data['summary'] as String?)?.trim();
      return summary == null || summary.isEmpty ? null : summary;
    } catch (_) {
      return null;
    }
  }

  Future<GeneratedCareerPlan?> careerPlan({required List<Map<String, dynamic>> answers}) async {
    if (answers.isEmpty) return null;
    try {
      final callable = _functions.httpsCallable('generateCareerPlan', options: HttpsCallableOptions(timeout: _careerPlanTimeout));
      final result = await callable.call<Map<String, dynamic>>({'answers': answers});
      final plan = GeneratedCareerPlan.fromMap(result.data);
      return plan.directions.isEmpty ? null : plan;
    } catch (_) {
      return null;
    }
  }

  /// The three-step plan for the direction the user chose in Module 5.
  /// Saved server-side next to the career plan. Null on any failure.
  Future<GeneratedPlan?> directionPlan({required String directionTitle}) async {
    try {
      final callable = _functions.httpsCallable('generateDirectionPlan', options: HttpsCallableOptions(timeout: _careerPlanTimeout));
      final result = await callable.call<Map<String, dynamic>>({'directionTitle': directionTitle});
      final plan = GeneratedPlan.fromMap(Map<String, dynamic>.from(result.data));
      return plan.steps.isEmpty ? null : plan;
    } catch (_) {
      return null;
    }
  }

  /// Asks the server to generate the final report from what is already
  /// stored. The server writes the result to Firestore itself, so the app can
  /// leave the screen while it runs; the long timeout only covers staying.
  Future<({FinalReportRequest status, GeneratedReport? report})> requestFinalReport() async {
    try {
      final callable = _functions.httpsCallable('generateFinalReport', options: HttpsCallableOptions(timeout: _reportTimeout));
      final result = await callable.call<Map<String, dynamic>>(const <String, dynamic>{});
      final data = Map<String, dynamic>.from(result.data);
      return switch (data['status']) {
        'ready' => (status: FinalReportRequest.ready, report: GeneratedReport.fromMap(data)),
        'generating' => (status: FinalReportRequest.generating, report: null),
        _ => (status: FinalReportRequest.unknown, report: null),
      };
    } on FirebaseFunctionsException catch (e) {
      final status = e.code == 'internal' || e.code == 'failed-precondition' ? FinalReportRequest.failed : FinalReportRequest.unknown;
      return (status: status, report: null);
    } catch (_) {
      return (status: FinalReportRequest.unknown, report: null);
    }
  }

}
