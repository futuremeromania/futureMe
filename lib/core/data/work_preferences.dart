/// The work-preferences instrument used in Module 3, Stage 2 — 16 items
/// rated 1-5, scored into eight poles of two items each.
///
/// The eight poles pair up into four dimensions, but the two poles of a
/// dimension are scored *independently*: nothing is subtracted, no A−B
/// difference is computed and there is no overall score, because both poles
/// can legitimately be high at once. A pole counts as a preference only
/// when it reaches 7-10; anything lower is simply not a preference, which
/// is why the feedback keys on "high / not high" rather than on the band.
library;

enum WorkPreferencePole {
  collaboration("Colaborare"),
  soloWork("Lucru individual"),
  coordination("Coordonare"),
  ownContribution("Contribuție individuală"),
  initiative("Inițiativă"),
  definedTasks("Sarcini clar definite"),
  variety("Varietate"),
  continuity("Continuitate / repetitivitate");

  const WorkPreferencePole(this.label);

  final String label;
}

/// The four blocks, in the fixed display order the specification sets.
enum WorkPreferenceDimension {
  workingWithOthers("Lucrul cu ceilalți", WorkPreferencePole.collaboration, WorkPreferencePole.soloWork),
  preferredRole("Rolul pe care îl preferi", WorkPreferencePole.coordination, WorkPreferencePole.ownContribution),
  taskApproach("Cum preferi să abordezi o sarcină", WorkPreferencePole.initiative, WorkPreferencePole.definedTasks),
  taskType("Tipul de sarcini pe care îl preferi", WorkPreferencePole.variety, WorkPreferencePole.continuity);

  const WorkPreferenceDimension(this.label, this.first, this.second);

  final String label;
  final WorkPreferencePole first;
  final WorkPreferencePole second;
}

/// FutureMe's descriptive bands over the 2-10 pole range. Internal
/// descriptive thresholds for an exploratory instrument, not population
/// norms.
enum WorkPreferenceLevel {
  low("Scăzut"),
  moderate("Moderat"),
  high("Ridicat");

  const WorkPreferenceLevel(this.label);

  final String label;
}

/// Which of a dimension's two poles came out as preferences. This, not the
/// band, is what selects the text.
enum WorkPreferenceOutcome { firstOnly, secondOnly, both, neither }

class WorkPreferencesItem {
  const WorkPreferencesItem({required this.number, required this.statement, required this.pole});

  /// 1-16, matching the printed questionnaire.
  final int number;

  final String statement;
  final WorkPreferencePole pole;
}

/// The five response options, in order. Index 0 is the answer value 1.
const List<String> workPreferencesScaleLabels = [
  "Deloc adevărat",
  "Mai degrabă fals",
  "Neutru",
  "Mai degrabă adevărat",
  "Foarte adevărat",
];

/// Shown in the order below. Every item is required; none are reversed.
const List<WorkPreferencesItem> workPreferencesItems = [
  WorkPreferencesItem(number: 1, statement: "Îmi place să lucrez împreună cu alții la o sarcină sau la un proiect.", pole: WorkPreferencePole.collaboration),
  WorkPreferencesItem(number: 2, statement: "Prefer să știu clar ce am de făcut înainte să încep o sarcină.", pole: WorkPreferencePole.definedTasks),
  WorkPreferencesItem(number: 3, statement: "Îmi place să preiau coordonarea atunci când lucrăm în grup.", pole: WorkPreferencePole.coordination),
  WorkPreferencesItem(number: 4, statement: "Îmi place să am sarcini diferite, nu mereu același tip de activitate.", pole: WorkPreferencePole.variety),
  WorkPreferencesItem(number: 5, statement: "Îmi place să am sarcini de care să mă ocup singur(ă).", pole: WorkPreferencePole.soloWork),
  WorkPreferencesItem(number: 6, statement: "Prefer să decid eu cum să abordez o sarcină.", pole: WorkPreferencePole.initiative),
  WorkPreferencesItem(number: 7, statement: "Prefer să mă concentrez pe partea mea de lucru decât să coordonez activitatea altora.", pole: WorkPreferencePole.ownContribution),
  WorkPreferencesItem(number: 8, statement: "Îmi place să pot rămâne mai mult timp concentrat(ă) pe același tip de activitate.", pole: WorkPreferencePole.continuity),
  WorkPreferencesItem(number: 9, statement: "Îmi place să discut ideile cu ceilalți atunci când lucrăm la ceva împreună.", pole: WorkPreferencePole.collaboration),
  WorkPreferencesItem(number: 10, statement: "Prefer ca sarcinile să aibă obiective și cerințe bine definite.", pole: WorkPreferencePole.definedTasks),
  WorkPreferencesItem(number: 11, statement: "Îmi place să organizez activitatea unui grup într-un proiect.", pole: WorkPreferencePole.coordination),
  WorkPreferencesItem(number: 12, statement: "Mă atrag activitățile în care trec de la un tip de sarcină la altul.", pole: WorkPreferencePole.variety),
  WorkPreferencesItem(number: 13, statement: "Mă simt bine când pot lucra pe cont propriu, concentrat(ă) pe ceea ce am de făcut.", pole: WorkPreferencePole.soloWork),
  WorkPreferencesItem(number: 14, statement: "Îmi place să propun eu cum ar putea fi făcut un lucru, nu doar să urmez o variantă deja stabilită.", pole: WorkPreferencePole.initiative),
  WorkPreferencesItem(number: 15, statement: "Prefer să răspund în primul rând de propria contribuție într-un proiect.", pole: WorkPreferencePole.ownContribution),
  WorkPreferencesItem(number: 16, statement: "Prefer activitățile în care fac, în mod repetat, același tip de sarcină.", pole: WorkPreferencePole.continuity),
];

/// FutureMe's descriptive bands over the 2-10 raw range.
WorkPreferenceLevel workPreferenceLevelForScore(int score) {
  if (score <= 3) return WorkPreferenceLevel.low;
  if (score <= 6) return WorkPreferenceLevel.moderate;
  return WorkPreferenceLevel.high;
}

class WorkPreferencePoleResult {
  const WorkPreferencePoleResult({required this.pole, required this.score});

  final WorkPreferencePole pole;

  /// Sum of this pole's two items, 2-10.
  final int score;

  WorkPreferenceLevel get level => workPreferenceLevelForScore(score);

  /// Only a high score counts as a preference. Low and moderate are kept as
  /// numbers and bands, but both read as "not a preference" when the text
  /// is chosen.
  bool get isPreference => level == WorkPreferenceLevel.high;
}

class WorkPreferenceDimensionResult {
  const WorkPreferenceDimensionResult({required this.dimension, required this.first, required this.second});

  final WorkPreferenceDimension dimension;
  final WorkPreferencePoleResult first;
  final WorkPreferencePoleResult second;

  WorkPreferenceOutcome get outcome {
    if (first.isPreference && second.isPreference) return WorkPreferenceOutcome.both;
    if (first.isPreference) return WorkPreferenceOutcome.firstOnly;
    if (second.isPreference) return WorkPreferenceOutcome.secondOnly;
    return WorkPreferenceOutcome.neither;
  }

  /// Stable identifier of the displayed variant, stored for traceability —
  /// e.g. `workingWithOthers_firstOnly`.
  String get feedbackId => '${dimension.name}_${outcome.name}';
}

class WorkPreferencesResult {
  const WorkPreferencesResult({required this.dimensions, required this.answers});

  final List<WorkPreferenceDimensionResult> dimensions;

  /// Every item's raw answer (1-5), keyed by item number.
  final Map<int, int> answers;

  WorkPreferenceDimensionResult operator [](WorkPreferenceDimension dimension) =>
      dimensions.firstWhere((d) => d.dimension == dimension);

  /// The eight pole scores, keyed by pole.
  Map<WorkPreferencePole, WorkPreferencePoleResult> get poles => {
        for (final d in dimensions) ...{d.first.pole: d.first, d.second.pole: d.second},
      };
}

/// Scores a completed questionnaire. [answers] maps an item number (1-16)
/// to the option the user picked, 1-5.
WorkPreferencesResult scoreWorkPreferences(Map<int, int> answers) {
  final totals = {for (final p in WorkPreferencePole.values) p: 0};

  for (final item in workPreferencesItems) {
    final answer = answers[item.number];
    if (answer == null) continue;
    totals[item.pole] = totals[item.pole]! + answer.clamp(1, 5);
  }

  return WorkPreferencesResult(
    dimensions: [
      for (final d in WorkPreferenceDimension.values)
        WorkPreferenceDimensionResult(
          dimension: d,
          first: WorkPreferencePoleResult(pole: d.first, score: totals[d.first]!),
          second: WorkPreferencePoleResult(pole: d.second, score: totals[d.second]!),
        ),
    ],
    answers: answers,
  );
}
