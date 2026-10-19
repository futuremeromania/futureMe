/// The cognitive-style instrument used in Module 2, Stage 3 — 30 items
/// answered on a 1-5 scale, scored deterministically into ten pole scores.
///
/// The two poles of a dimension are scored independently: a high score on
/// one does not lower the other, nothing is subtracted, converted to a
/// percentage or reduced to a "winning" pole. Each pole has exactly three
/// items, so a pole score runs 3-15. There are no reversed items, and no
/// model is involved — the pair of levels selects one of the 45 fixed texts
/// in `cognitive_style_feedback.dart`.
library;

enum CognitivePole {
  analytical("Analitic"),
  intuitive("Intuitiv"),
  practical("Practic"),
  conceptual("Conceptual"),
  detail("Detalii"),
  bigPicture("Imagine de ansamblu"),
  fast("Rapid"),
  reflective("Reflexiv"),
  structured("Structurat"),
  flexible("Flexibil");

  const CognitivePole(this.label);

  final String label;
}

/// FutureMe's descriptive bands over the 3-15 pole range. These are
/// internal descriptive thresholds, not population norms.
enum CognitiveLevel {
  low("Scăzut"),
  moderate("Moderat"),
  high("Ridicat");

  const CognitiveLevel(this.label);

  final String label;
}

enum CognitiveDimension {
  analyticalIntuitive(CognitivePole.analytical, CognitivePole.intuitive),
  practicalConceptual(CognitivePole.practical, CognitivePole.conceptual),
  detailBigPicture(CognitivePole.detail, CognitivePole.bigPicture),
  fastReflective(CognitivePole.fast, CognitivePole.reflective),
  structuredFlexible(CognitivePole.structured, CognitivePole.flexible);

  const CognitiveDimension(this.first, this.second);

  final CognitivePole first;
  final CognitivePole second;

  String get label => "${first.label} ↔ ${second.label}";
}

class CognitiveStyleItem {
  const CognitiveStyleItem({required this.number, required this.statement, required this.pole});

  /// 1-30, matching the printed questionnaire.
  final int number;

  final String statement;
  final CognitivePole pole;
}

/// The five response options, in order. Index 0 is the answer value 1.
const List<String> cognitiveStyleScaleLabels = [
  "Deloc adevărat",
  "Mai degrabă fals",
  "Neutru",
  "Mai degrabă adevărat",
  "Foarte adevărat",
];

/// Shown in the order below — deliberately shuffled across poles so
/// consecutive items don't invite answering by resemblance.
const List<CognitiveStyleItem> cognitiveStyleItems = [
  CognitiveStyleItem(number: 1, statement: "Prefer să înțeleg imaginea de ansamblu înainte de detalii.", pole: CognitivePole.bigPicture),
  CognitiveStyleItem(number: 2, statement: "Când încerc să rezolv o problemă, prefer să o descompun în pași.", pole: CognitivePole.analytical),
  CognitiveStyleItem(number: 3, statement: "Mă adaptez ușor atunci când trebuie să schimb planul pe parcurs.", pole: CognitivePole.flexible),
  CognitiveStyleItem(number: 4, statement: "Înțeleg mai ușor ceva atunci când văd cum poate fi folosit în realitate.", pole: CognitivePole.practical),
  CognitiveStyleItem(number: 5, statement: "Am nevoie de timp ca să procesez bine informațiile noi.", pole: CognitivePole.reflective),
  CognitiveStyleItem(number: 6, statement: "Uneori văd soluția înainte să pot explica exact cum am ajuns la ea.", pole: CognitivePole.intuitive),
  CognitiveStyleItem(number: 7, statement: "Observ ușor detalii pe care alții le pot trece cu vederea.", pole: CognitivePole.detail),
  CognitiveStyleItem(number: 8, statement: "Îmi place să explorez idei chiar dacă nu au imediat o utilitate practică.", pole: CognitivePole.conceptual),
  CognitiveStyleItem(number: 9, statement: "Când apare o problemă, îmi vin repede în minte posibile soluții.", pole: CognitivePole.fast),
  CognitiveStyleItem(number: 10, statement: "Lucrez mai ușor când știu clar ce am de făcut.", pole: CognitivePole.structured),
  CognitiveStyleItem(number: 11, statement: "Când primesc multe informații, caut mai întâi ideea principală.", pole: CognitivePole.bigPicture),
  CognitiveStyleItem(number: 12, statement: "Îmi place să înțeleg logic cum am ajuns la o concluzie.", pole: CognitivePole.analytical),
  CognitiveStyleItem(number: 13, statement: "Îmi place să găsesc pe moment o altă cale atunci când situația se schimbă.", pole: CognitivePole.flexible),
  CognitiveStyleItem(number: 14, statement: "Învăț mai ușor atunci când pot pune în practică ceea ce aflu.", pole: CognitivePole.practical),
  CognitiveStyleItem(number: 15, statement: "Îmi place să mă gândesc la o problemă din mai multe unghiuri înainte să ajung la o concluzie.", pole: CognitivePole.reflective),
  CognitiveStyleItem(number: 16, statement: "Când caut o soluție, mă bazez și pe ceea ce simt că ar putea funcționa.", pole: CognitivePole.intuitive),
  CognitiveStyleItem(number: 17, statement: "Îmi dau repede seama când există o mică greșeală sau neconcordanță.", pole: CognitivePole.detail),
  CognitiveStyleItem(number: 18, statement: "Mă atrage să înțeleg principiile sau ideile din spatele unui lucru.", pole: CognitivePole.conceptual),
  CognitiveStyleItem(number: 19, statement: "Înțeleg repede direcția unei probleme și încep să caut soluția.", pole: CognitivePole.fast),
  CognitiveStyleItem(number: 20, statement: "Îmi place să am un plan înainte să încep ceva.", pole: CognitivePole.structured),
  CognitiveStyleItem(number: 21, statement: "Îmi este natural să observ cum se leagă mai multe informații între ele.", pole: CognitivePole.bigPicture),
  CognitiveStyleItem(number: 22, statement: "Prefer să verific informațiile înainte să trag o concluzie.", pole: CognitivePole.analytical),
  CognitiveStyleItem(number: 23, statement: "Mă simt confortabil să continui chiar dacă nu știu de la început exact cum vor evolua lucrurile.", pole: CognitivePole.flexible),
  CognitiveStyleItem(number: 24, statement: "Când apare o problemă, mă gândesc repede la ce pot face concret.", pole: CognitivePole.practical),
  CognitiveStyleItem(number: 25, statement: "Înainte să formulez un răspuns, prefer să îmi acord timp să mă gândesc.", pole: CognitivePole.reflective),
  CognitiveStyleItem(number: 26, statement: "Fac ușor conexiuni între idei, chiar dacă nu le analizez pas cu pas.", pole: CognitivePole.intuitive),
  CognitiveStyleItem(number: 27, statement: "Când încerc să înțeleg ceva, acord atenție elementelor care îl compun.", pole: CognitivePole.detail),
  CognitiveStyleItem(number: 28, statement: "Îmi place să mă gândesc la posibilități și la lucruri care încă nu există.", pole: CognitivePole.conceptual),
  CognitiveStyleItem(number: 29, statement: "Pot formula repede o idee chiar dacă nu am analizat încă toate detaliile.", pole: CognitivePole.fast),
  CognitiveStyleItem(number: 30, statement: "Mă simt confortabil când lucrurile sunt organizate și știu ce urmează.", pole: CognitivePole.structured),
];

/// FutureMe's descriptive bands over the 3-15 pole range.
CognitiveLevel cognitiveLevelForScore(int score) {
  if (score <= 5) return CognitiveLevel.low;
  if (score <= 9) return CognitiveLevel.moderate;
  return CognitiveLevel.high;
}

class CognitiveDimensionResult {
  const CognitiveDimensionResult({
    required this.dimension,
    required this.firstScore,
    required this.secondScore,
  });

  final CognitiveDimension dimension;

  /// Sum of the three items of [CognitiveDimension.first], 3-15.
  final int firstScore;

  /// Sum of the three items of [CognitiveDimension.second], 3-15.
  final int secondScore;

  CognitiveLevel get firstLevel => cognitiveLevelForScore(firstScore);
  CognitiveLevel get secondLevel => cognitiveLevelForScore(secondScore);

  /// Stable identifier of the displayed feedback variant, saved alongside
  /// the result so the exact text shown to the user stays traceable —
  /// e.g. `analytical_high__intuitive_high`.
  String get feedbackId =>
      '${dimension.first.name}_${firstLevel.name}__${dimension.second.name}_${secondLevel.name}';

  /// The header shown above the feedback, e.g. "Analitic Ridicat + Intuitiv Ridicat".
  String get combinationLabel =>
      '${dimension.first.label} ${firstLevel.label} + ${dimension.second.label} ${secondLevel.label}';
}

class CognitiveStyleResult {
  const CognitiveStyleResult({required this.dimensions, required this.answers});

  final List<CognitiveDimensionResult> dimensions;

  /// Every item's raw answer (1-5), keyed by item number — kept so the
  /// stored result can be audited against the answers it came from.
  final Map<int, int> answers;

  CognitiveDimensionResult operator [](CognitiveDimension dimension) =>
      dimensions.firstWhere((d) => d.dimension == dimension);

  /// The ten raw pole scores, keyed by pole.
  Map<CognitivePole, int> get poleScores => {
        for (final d in dimensions) ...{
          d.dimension.first: d.firstScore,
          d.dimension.second: d.secondScore,
        },
      };
}

/// Scores a completed questionnaire. [answers] maps an item number (1-30)
/// to the option the user picked, 1-5.
///
/// Missing items contribute nothing, so a partially answered questionnaire
/// still scores rather than throwing — the resulting pole scores will
/// simply sit below the 3-15 range.
CognitiveStyleResult scoreCognitiveStyle(Map<int, int> answers) {
  final totals = {for (final p in CognitivePole.values) p: 0};

  for (final item in cognitiveStyleItems) {
    final answer = answers[item.number];
    if (answer == null) continue;
    totals[item.pole] = totals[item.pole]! + answer.clamp(1, 5);
  }

  return CognitiveStyleResult(
    dimensions: [
      for (final d in CognitiveDimension.values)
        CognitiveDimensionResult(
          dimension: d,
          firstScore: totals[d.first]!,
          secondScore: totals[d.second]!,
        ),
    ],
    answers: answers,
  );
}