/// The work-environments instrument used in Module 3, Stage 3 ("Medii de
/// lucru") — 28 items rated 1-5, scored into fourteen poles of two items
/// each, which pair up into seven dimensions.
///
/// As in Stage 2, the two poles of a dimension are scored independently:
/// nothing is subtracted, there is no A−B difference and no overall score,
/// and both poles can be preferences at once. Only a high score (7-10)
/// counts as a preference.
///
/// Source: "X. Medii de lucru — FutureMe (etapizat)", final version of
/// 20 September 2026.
library;

/// Versions stored with every result, so a result can always be read
/// against the exact item set, scoring rule and texts it was produced with.
const String workEnvironmentsVersion = 'work-environments-ro-2026-09-20';
const String workEnvironmentsScoringVersion = 'work-environments-scoring-2026-09-20';

enum WorkEnvironmentPole {
  formal("Formal"),
  informal("Informal"),
  structured("Structurat"),
  flexible("Flexibil"),
  competitive("Competitiv"),
  collaborative("Colaborativ"),
  autonomy("Autonomie"),
  supervision("Supervizare"),
  stable("Stabil"),
  innovative("Inovativ"),
  predictable("Predictibil"),
  dynamic("Dinamic"),
  hierarchical("Ierarhic"),
  egalitarian("Egalitar");

  const WorkEnvironmentPole(this.label);

  final String label;
}

/// The seven dimensions, in the fixed display order of the specification.
/// The first pole is "A", the second "B".
enum WorkEnvironmentDimension {
  formalInformal(WorkEnvironmentPole.formal, WorkEnvironmentPole.informal),
  structuredFlexible(WorkEnvironmentPole.structured, WorkEnvironmentPole.flexible),
  competitiveCollaborative(WorkEnvironmentPole.competitive, WorkEnvironmentPole.collaborative),
  autonomySupervision(WorkEnvironmentPole.autonomy, WorkEnvironmentPole.supervision),
  stableInnovative(WorkEnvironmentPole.stable, WorkEnvironmentPole.innovative),
  predictableDynamic(WorkEnvironmentPole.predictable, WorkEnvironmentPole.dynamic),
  hierarchicalEgalitarian(WorkEnvironmentPole.hierarchical, WorkEnvironmentPole.egalitarian);

  const WorkEnvironmentDimension(this.first, this.second);

  final WorkEnvironmentPole first;
  final WorkEnvironmentPole second;

  /// "FORMAL ↔ INFORMAL" — the full dimension name shown above each text.
  String get label => '${first.label.toUpperCase()} ↔ ${second.label.toUpperCase()}';
}

/// FutureMe's descriptive bands over the 2-10 pole range — internal
/// thresholds, not population norms.
enum WorkEnvironmentLevel {
  low("Scăzut"),
  moderate("Moderat"),
  high("Ridicat");

  const WorkEnvironmentLevel(this.label);

  final String label;
}

/// Which poles of a dimension came out as preferences. This, not the band,
/// selects the text. [code] is the state name the specification uses.
enum WorkEnvironmentOutcome {
  firstOnly('A_PREFERENCE'),
  secondOnly('B_PREFERENCE'),
  both('BOTH_PREFERENCE'),
  neither('NO_CLEAR_PREFERENCE');

  const WorkEnvironmentOutcome(this.code);

  final String code;
}

class WorkEnvironmentsItem {
  const WorkEnvironmentsItem({required this.number, required this.statement, required this.pole});

  /// I1-I28, the item's id in the specification and in the scoring key.
  final int number;

  final String statement;
  final WorkEnvironmentPole pole;
}

/// The five response options, in order. Index 0 is the answer value 1.
const List<String> workEnvironmentsScaleLabels = [
  "Deloc adevărat",
  "Mai degrabă fals",
  "Neutru",
  "Mai degrabă adevărat",
  "Foarte adevărat",
];

/// The display order. The specification lists the items grouped by pole
/// and allows mixing them on screen as long as ids and scoring stay the
/// same; the order is fixed (not random) so that a stage left part-way
/// resumes at the same statement. Opposite poles are seven items apart and
/// the two items of a pole fourteen apart.
const List<WorkEnvironmentsItem> workEnvironmentsItems = [
  WorkEnvironmentsItem(number: 1, statement: "Mi-ar plăcea să lucrez într-o organizație în care relațiile profesionale și modul de comunicare sunt mai formale.", pole: WorkEnvironmentPole.formal),
  WorkEnvironmentsItem(number: 5, statement: "Mi-ar plăcea să lucrez într-o organizație în care există reguli și proceduri clare.", pole: WorkEnvironmentPole.structured),
  WorkEnvironmentsItem(number: 9, statement: "Mi-ar plăcea să lucrez într-o organizație în care există competiție între oameni sau echipe.", pole: WorkEnvironmentPole.competitive),
  WorkEnvironmentsItem(number: 13, statement: "Mi-ar plăcea o organizație care le oferă oamenilor libertate în modul în care își fac treaba.", pole: WorkEnvironmentPole.autonomy),
  WorkEnvironmentsItem(number: 17, statement: "Mi-ar plăcea să lucrez într-o organizație care pune preț pe stabilitate și continuitate.", pole: WorkEnvironmentPole.stable),
  WorkEnvironmentsItem(number: 21, statement: "Mi-ar plăcea un mediu în care știu, în general, la ce să mă aștept de la o perioadă la alta.", pole: WorkEnvironmentPole.predictable),
  WorkEnvironmentsItem(number: 25, statement: "Mi-ar plăcea o organizație în care rolurile și nivelurile de responsabilitate sunt clar delimitate.", pole: WorkEnvironmentPole.hierarchical),
  WorkEnvironmentsItem(number: 3, statement: "Mi-ar plăcea să lucrez într-o organizație cu o atmosferă relaxată și informală.", pole: WorkEnvironmentPole.informal),
  WorkEnvironmentsItem(number: 7, statement: "Mi-ar plăcea o organizație în care regulile se pot adapta atunci când situația o cere.", pole: WorkEnvironmentPole.flexible),
  WorkEnvironmentsItem(number: 11, statement: "Mi-ar plăcea să lucrez într-o organizație în care oamenii se ajută între ei.", pole: WorkEnvironmentPole.collaborative),
  WorkEnvironmentsItem(number: 15, statement: "Mi-ar plăcea un loc de muncă în care un coordonator urmărește periodic cum evoluează activitatea și oferă îndrumare.", pole: WorkEnvironmentPole.supervision),
  WorkEnvironmentsItem(number: 19, statement: "Mi-ar plăcea o organizație în care se testează frecvent idei și soluții noi.", pole: WorkEnvironmentPole.innovative),
  WorkEnvironmentsItem(number: 23, statement: "Mi-ar plăcea să lucrez într-o organizație în care apar frecvent situații și provocări noi.", pole: WorkEnvironmentPole.dynamic),
  WorkEnvironmentsItem(number: 27, statement: "Mi-ar plăcea o organizație în care diferențele de poziție nu creează distanțe mari între oameni.", pole: WorkEnvironmentPole.egalitarian),
  WorkEnvironmentsItem(number: 2, statement: "Aș prefera un loc de muncă în care oamenii păstrează un stil profesional în felul în care comunică și se raportează unii la alții.", pole: WorkEnvironmentPole.formal),
  WorkEnvironmentsItem(number: 6, statement: "Aș prefera un mediu în care modul de organizare este bine stabilit.", pole: WorkEnvironmentPole.structured),
  WorkEnvironmentsItem(number: 10, statement: "Aș prefera un mediu în care oamenii sunt provocați să obțină rezultate mai bune decât ceilalți.", pole: WorkEnvironmentPole.competitive),
  WorkEnvironmentsItem(number: 14, statement: "Aș prefera un loc în care oamenii pot lua singuri multe dintre deciziile legate de activitatea lor.", pole: WorkEnvironmentPole.autonomy),
  WorkEnvironmentsItem(number: 18, statement: "Aș prefera un loc de muncă în care schimbările importante nu se produc foarte des.", pole: WorkEnvironmentPole.stable),
  WorkEnvironmentsItem(number: 22, statement: "Aș prefera o organizație în care modul de lucru și activitatea de zi cu zi sunt relativ previzibile.", pole: WorkEnvironmentPole.predictable),
  WorkEnvironmentsItem(number: 26, statement: "Aș prefera un loc de muncă în care este clar cine ia deciziile și cine coordonează activitatea.", pole: WorkEnvironmentPole.hierarchical),
  WorkEnvironmentsItem(number: 4, statement: "Aș prefera un loc în care oamenii comunică firesc, fără prea multe formalități.", pole: WorkEnvironmentPole.informal),
  WorkEnvironmentsItem(number: 8, statement: "Aș prefera un mediu în care modul de lucru poate fi adaptat în funcție de situație.", pole: WorkEnvironmentPole.flexible),
  WorkEnvironmentsItem(number: 12, statement: "Aș prefera un mediu în care oamenii colaborează pentru a obține rezultate împreună.", pole: WorkEnvironmentPole.collaborative),
  WorkEnvironmentsItem(number: 16, statement: "Aș prefera o organizație în care oamenii primesc frecvent îndrumare din partea unui coordonator.", pole: WorkEnvironmentPole.supervision),
  WorkEnvironmentsItem(number: 20, statement: "Aș prefera un mediu în care oamenii sunt încurajați să experimenteze și să încerce moduri noi de a face lucrurile.", pole: WorkEnvironmentPole.innovative),
  WorkEnvironmentsItem(number: 24, statement: "Aș prefera un mediu în care lucrurile se schimbă des și trebuie să te adaptezi.", pole: WorkEnvironmentPole.dynamic),
  WorkEnvironmentsItem(number: 28, statement: "Aș prefera un mediu în care ideile oamenilor sunt ascultate indiferent de poziția pe care o au în organizație.", pole: WorkEnvironmentPole.egalitarian),
];

WorkEnvironmentLevel workEnvironmentLevelForScore(int score) {
  if (score <= 3) return WorkEnvironmentLevel.low;
  if (score <= 6) return WorkEnvironmentLevel.moderate;
  return WorkEnvironmentLevel.high;
}

class WorkEnvironmentPoleResult {
  const WorkEnvironmentPoleResult({required this.pole, required this.score});

  final WorkEnvironmentPole pole;

  /// Sum of this pole's two items, 2-10.
  final int score;

  WorkEnvironmentLevel get level => workEnvironmentLevelForScore(score);

  /// Only "Ridicat" is a preference; "Scăzut" and "Moderat" are kept as
  /// bands but both read as "not a preference".
  bool get isPreference => level == WorkEnvironmentLevel.high;
}

class WorkEnvironmentDimensionResult {
  const WorkEnvironmentDimensionResult({required this.dimension, required this.first, required this.second});

  final WorkEnvironmentDimension dimension;
  final WorkEnvironmentPoleResult first;
  final WorkEnvironmentPoleResult second;

  WorkEnvironmentOutcome get outcome {
    if (first.isPreference && second.isPreference) return WorkEnvironmentOutcome.both;
    if (first.isPreference) return WorkEnvironmentOutcome.firstOnly;
    if (second.isPreference) return WorkEnvironmentOutcome.secondOnly;
    return WorkEnvironmentOutcome.neither;
  }

  /// Stable id of the displayed text, e.g. `formalInformal_secondOnly`.
  String get feedbackId => '${dimension.name}_${outcome.name}';
}

class WorkEnvironmentsResult {
  const WorkEnvironmentsResult({required this.dimensions, required this.answers});

  /// The seven dimensions, in display order.
  final List<WorkEnvironmentDimensionResult> dimensions;

  /// Every item's raw answer (1-5), keyed by item number.
  final Map<int, int> answers;

  Map<WorkEnvironmentPole, WorkEnvironmentPoleResult> get poles => {
        for (final d in dimensions) ...{d.first.pole: d.first, d.second.pole: d.second},
      };
}

/// Scores a completed questionnaire. [answers] maps an item number (1-28)
/// to the option picked, 1-5. No item is reversed.
WorkEnvironmentsResult scoreWorkEnvironments(Map<int, int> answers) {
  final totals = {for (final p in WorkEnvironmentPole.values) p: 0};

  for (final item in workEnvironmentsItems) {
    final answer = answers[item.number];
    if (answer == null) continue;
    totals[item.pole] = totals[item.pole]! + answer.clamp(1, 5);
  }

  return WorkEnvironmentsResult(
    dimensions: [
      for (final d in WorkEnvironmentDimension.values)
        WorkEnvironmentDimensionResult(
          dimension: d,
          first: WorkEnvironmentPoleResult(pole: d.first, score: totals[d.first]!),
          second: WorkEnvironmentPoleResult(pole: d.second, score: totals[d.second]!),
        ),
    ],
    answers: answers,
  );
}
