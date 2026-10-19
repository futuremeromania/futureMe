/// The perceived-control instrument used in Module 2, Stage 6 — 20 items
/// answered on a 1-5 scale, scored deterministically into four raw sums.
///
/// Unlike the other instruments in this module there are no reverse-scored
/// items and no means: each dimension is the plain sum of its five items,
/// 5-25, and the band it falls into selects one of the twelve fixed texts
/// in `perceived_control_feedback.dart`. No model is involved.
library;

enum PerceivedControlDimension {
  internality("Internalitate"),
  luck("Noroc"),
  helplessness("Neajutorare"),
  othersInfluence("Influența celorlalți");

  const PerceivedControlDimension(this.label);

  final String label;
}

/// FutureMe's descriptive bands over the 5-25 range. Internal descriptive
/// bands, not population norms.
enum PerceivedControlLevel { low, moderate, high }

class PerceivedControlItem {
  const PerceivedControlItem({required this.number, required this.statement, required this.dimension});

  /// 1-20, matching the printed questionnaire.
  final int number;

  final String statement;
  final PerceivedControlDimension dimension;
}

/// The five response options, in order. Index 0 is the answer value 1.
const List<String> perceivedControlScaleLabels = [
  "Deloc adevărat",
  "Mai degrabă fals",
  "Neutru",
  "Mai degrabă adevărat",
  "Foarte adevărat",
];

/// Shown in the order below. Each dimension is backed by exactly 5 items.
const List<PerceivedControlItem> perceivedControlItems = [
  PerceivedControlItem(number: 1, statement: "Ceea ce voi ajunge să fac în viitor depinde mult de efortul pe care îl depun.", dimension: PerceivedControlDimension.internality),
  PerceivedControlItem(number: 2, statement: "Cred că norocul va conta mult în ceea ce voi ajunge să fac profesional.", dimension: PerceivedControlDimension.luck),
  PerceivedControlItem(number: 3, statement: "Uneori simt că, oricât m-aș strădui, nu pot influența prea mult ceea ce voi ajunge să fac.", dimension: PerceivedControlDimension.helplessness),
  PerceivedControlItem(number: 4, statement: "Părerea părinților sau a familiei va conta mult în alegerea drumului meu profesional.", dimension: PerceivedControlDimension.othersInfluence),
  PerceivedControlItem(number: 5, statement: "Abilitățile pe care mi le dezvolt pot influența oportunitățile profesionale pe care le voi avea.", dimension: PerceivedControlDimension.internality),
  PerceivedControlItem(number: 6, statement: "Uneori, să fii în locul potrivit la momentul potrivit contează mai mult decât cât de bine te-ai pregătit.", dimension: PerceivedControlDimension.luck),
  PerceivedControlItem(number: 7, statement: "Nu sunt sigur(ă) că alegerile pe care le fac acum vor schimba prea mult viitorul meu profesional.", dimension: PerceivedControlDimension.helplessness),
  PerceivedControlItem(number: 8, statement: "Uneori simt că așteptările celorlalți pot influența mai mult decât alegerile mele ceea ce voi ajunge să fac.", dimension: PerceivedControlDimension.othersInfluence),
  PerceivedControlItem(number: 9, statement: "Dacă un drum nu funcționează, pot încerca alte variante ca să mă apropii de ceea ce îmi doresc.", dimension: PerceivedControlDimension.internality),
  PerceivedControlItem(number: 10, statement: "Jobul pe care îl voi avea va depinde în mare măsură de oportunitățile care apar întâmplător.", dimension: PerceivedControlDimension.luck),
  PerceivedControlItem(number: 11, statement: "Simt că sunt multe lucruri care îmi pot decide viitorul, fără ca eu să pot face mare lucru.", dimension: PerceivedControlDimension.helplessness),
  PerceivedControlItem(number: 12, statement: "Profesorii, părinții sau alți adulți importanți pot avea un rol foarte mare în direcția profesională pe care o voi urma.", dimension: PerceivedControlDimension.othersInfluence),
  PerceivedControlItem(number: 13, statement: "Șansele de a avea jobul pe care mi-l doresc cresc dacă mă pregătesc și muncesc pentru el.", dimension: PerceivedControlDimension.internality),
  PerceivedControlItem(number: 14, statement: "Oricât ai planifica, viitorul profesional depinde în mare parte de șansă.", dimension: PerceivedControlDimension.luck),
  PerceivedControlItem(number: 15, statement: "Uneori mă întreb dacă merită să depun atât de mult efort, când rezultatul nu depinde numai de mine.", dimension: PerceivedControlDimension.helplessness),
  PerceivedControlItem(number: 16, statement: "Pentru a ajunge la jobul pe care mi-l doresc, cred că va conta mult să întâlnesc oamenii potriviți.", dimension: PerceivedControlDimension.othersInfluence),
  PerceivedControlItem(number: 17, statement: "Prin alegerile și acțiunile mele pot influența direcția în care va merge viața mea profesională.", dimension: PerceivedControlDimension.internality),
  PerceivedControlItem(number: 18, statement: "Cred că o oportunitate norocoasă poate conta mai mult decât multe dintre alegerile pe care le fac acum.", dimension: PerceivedControlDimension.luck),
  PerceivedControlItem(number: 19, statement: "Când mă gândesc la viitorul meu profesional, uneori simt că am mai puțin control decât mi-aș dori.", dimension: PerceivedControlDimension.helplessness),
  PerceivedControlItem(number: 20, statement: "Uneori simt că viitorul meu profesional depinde mai mult de deciziile altor oameni decât de ale mele.", dimension: PerceivedControlDimension.othersInfluence),
];

/// FutureMe's descriptive bands over the 5-25 raw range.
PerceivedControlLevel perceivedControlLevelForScore(int score) {
  if (score <= 11) return PerceivedControlLevel.low;
  if (score <= 18) return PerceivedControlLevel.moderate;
  return PerceivedControlLevel.high;
}

class PerceivedControlDimensionResult {
  const PerceivedControlDimensionResult({required this.dimension, required this.score});

  final PerceivedControlDimension dimension;

  /// Sum of this dimension's five items, 5-25. No reversal, no mean.
  final int score;

  PerceivedControlLevel get level => perceivedControlLevelForScore(score);

  /// Stable identifier of the displayed feedback variant, stored for
  /// traceability — e.g. `internality_high`.
  String get feedbackId => '${dimension.name}_${level.name}';
}

class PerceivedControlResult {
  const PerceivedControlResult({required this.dimensions, required this.answers});

  final List<PerceivedControlDimensionResult> dimensions;

  /// Every item's raw answer (1-5), keyed by item number — kept so the
  /// stored result can be audited against the answers it came from.
  final Map<int, int> answers;

  PerceivedControlDimensionResult operator [](PerceivedControlDimension dimension) =>
      dimensions.firstWhere((d) => d.dimension == dimension);
}

/// Scores a completed questionnaire. [answers] maps an item number (1-20)
/// to the option the user picked, 1-5.
///
/// Every item is required, but a missing one simply contributes nothing
/// rather than throwing — the sum then falls below the 5-25 range.
PerceivedControlResult scorePerceivedControl(Map<int, int> answers) {
  final totals = {for (final d in PerceivedControlDimension.values) d: 0};

  for (final item in perceivedControlItems) {
    final answer = answers[item.number];
    if (answer == null) continue;
    totals[item.dimension] = totals[item.dimension]! + answer.clamp(1, 5);
  }

  return PerceivedControlResult(
    dimensions: [
      for (final d in PerceivedControlDimension.values)
        PerceivedControlDimensionResult(dimension: d, score: totals[d]!),
    ],
    answers: answers,
  );
}
