/// The emotional-patterns instrument used in Module 2, Stage 5 — 30 items
/// answered on a 1-5 scale, scored deterministically into four dimension
/// means.
///
/// Fourteen items are reverse-scored (`6 - answer`) so that, after recoding,
/// a higher score always means a *greater* emotional impact in that
/// dimension. The reversal is never shown to the user. Each dimension's
/// score is the mean of its items, 1.00-5.00, and the band it falls into
/// selects one of the twelve fixed texts in
/// `emotional_patterns_feedback.dart`. No model is involved.
library;

enum EmotionalDimension {
  pressure("Reacția la presiune", "Presiunea"),
  setback("Reacția la greșeală și eșec", "Greșeala și eșecul"),
  confidence("Încrederea în sine sub îndoială/evaluare", "Evaluarea și îndoiala"),
  regulation("Reglarea emoțională", "Emoțiile puternice");

  const EmotionalDimension(this.label, this.shortLabel);

  /// The full name of what the dimension explores.
  final String label;

  /// The heading the feedback library uses, e.g. "Presiunea".
  final String shortLabel;
}

/// FutureMe's descriptive bands over the 1.00-5.00 mean. Internal
/// descriptive thresholds — not population norms and not clinical cut-offs.
enum EmotionalLevel {
  low("Te afectează puțin"),
  moderate("Te afectează uneori"),
  high("Te afectează mult");

  const EmotionalLevel(this.label);

  final String label;
}

class EmotionalPatternsItem {
  const EmotionalPatternsItem({
    required this.number,
    required this.statement,
    required this.dimension,
    this.isReversed = false,
  });

  /// 1-30, matching the printed questionnaire.
  final int number;

  final String statement;
  final EmotionalDimension dimension;

  /// Reverse-scored items are recoded as `6 - answer` before being averaged.
  /// The marking is internal and never shown to the user.
  final bool isReversed;
}

/// The five response options, in order. Index 0 is the answer value 1.
const List<String> emotionalPatternsScaleLabels = [
  "Deloc adevărat",
  "Mai degrabă fals",
  "Neutru",
  "Mai degrabă adevărat",
  "Foarte adevărat",
];

/// Shown in the order below.
const List<EmotionalPatternsItem> emotionalPatternsItems = [
  EmotionalPatternsItem(number: 1, statement: "Când am multe lucruri importante de făcut, simt că presiunea mă copleșește.", dimension: EmotionalDimension.pressure),
  EmotionalPatternsItem(number: 2, statement: "După o greșeală, pot să mă uit la ce s-a întâmplat ca să înțeleg ce pot face diferit.", dimension: EmotionalDimension.setback, isReversed: true),
  EmotionalPatternsItem(number: 3, statement: "Când cineva îmi critică rezultatul, încep ușor să mă îndoiesc de mine.", dimension: EmotionalDimension.confidence),
  EmotionalPatternsItem(number: 4, statement: "După un moment tensionat, reușesc să mă liniștesc.", dimension: EmotionalDimension.regulation, isReversed: true),
  EmotionalPatternsItem(number: 5, statement: "Chiar și atunci când miza este mare, reușesc să mă concentrez la ce am de făcut.", dimension: EmotionalDimension.pressure, isReversed: true),
  EmotionalPatternsItem(number: 6, statement: "Când ceva nu îmi iese, îmi este greu să nu mă mai gândesc la acel lucru.", dimension: EmotionalDimension.setback),
  EmotionalPatternsItem(number: 7, statement: "Pot să fac ceva important chiar dacă nu sunt complet sigur(ă) că voi reuși.", dimension: EmotionalDimension.confidence, isReversed: true),
  EmotionalPatternsItem(number: 8, statement: "Când simt o emoție foarte puternică, tind să reacționez înainte să mă gândesc.", dimension: EmotionalDimension.regulation),
  EmotionalPatternsItem(number: 9, statement: "Dacă trebuie să fac ceva important într-un timp scurt, devin agitat(ă).", dimension: EmotionalDimension.pressure),
  EmotionalPatternsItem(number: 10, statement: "După o dezamăgire, reușesc să încerc din nou.", dimension: EmotionalDimension.setback, isReversed: true),
  EmotionalPatternsItem(number: 11, statement: "Când știu că sunt evaluat(ă), mă preocupă mult ce vor crede ceilalți despre rezultat.", dimension: EmotionalDimension.confidence),
  EmotionalPatternsItem(number: 12, statement: "Când ceva mă afectează puternic, îmi este greu să-mi mut atenția spre ceea ce am de făcut.", dimension: EmotionalDimension.regulation),
  EmotionalPatternsItem(number: 13, statement: "Chiar dacă sunt stresat(ă), reușesc să mă apuc de ceea ce am de făcut.", dimension: EmotionalDimension.pressure, isReversed: true),
  EmotionalPatternsItem(number: 14, statement: "Când greșesc la ceva important pentru mine, devin foarte critic(ă) cu mine.", dimension: EmotionalDimension.setback),
  EmotionalPatternsItem(number: 15, statement: "Când întâlnesc ceva dificil, cred că pot găsi o cale să mă descurc.", dimension: EmotionalDimension.confidence, isReversed: true),
  EmotionalPatternsItem(number: 16, statement: "Chiar dacă sunt foarte emoționat(ă), pot să aleg cum să reacționez.", dimension: EmotionalDimension.regulation, isReversed: true),
  EmotionalPatternsItem(number: 17, statement: "Când simt că se așteaptă mult de la mine, îmi este mai greu să dau tot ce pot.", dimension: EmotionalDimension.pressure),
  EmotionalPatternsItem(number: 18, statement: "Un rezultat slab mă face uneori să mă întreb dacă sunt suficient de bun(ă).", dimension: EmotionalDimension.setback),
  EmotionalPatternsItem(number: 19, statement: "Chiar dacă ceilalți nu sunt siguri că voi reuși, pot avea încredere în ceea ce sunt capabil(ă) să fac.", dimension: EmotionalDimension.confidence, isReversed: true),
  EmotionalPatternsItem(number: 20, statement: "Uneori o emoție neplăcută rămâne cu mine mult după ce situația s-a terminat.", dimension: EmotionalDimension.regulation),
  EmotionalPatternsItem(number: 21, statement: "Când sunt sub presiune, îmi este mai greu să gândesc clar.", dimension: EmotionalDimension.pressure),
  EmotionalPatternsItem(number: 22, statement: "Dacă am greșit o dată, devin mai precaut(ă) când trebuie să încerc din nou.", dimension: EmotionalDimension.setback),
  EmotionalPatternsItem(number: 23, statement: "Când mă compar cu cineva care se descurcă mai bine, încrederea mea poate scădea.", dimension: EmotionalDimension.confidence),
  EmotionalPatternsItem(number: 24, statement: "Când mă simt copleșit(ă) emoțional, găsesc de obicei ceva care mă ajută să-mi recapăt echilibrul.", dimension: EmotionalDimension.regulation, isReversed: true),
  EmotionalPatternsItem(number: 25, statement: "Într-o situație importantă, teama că lucrurile ar putea merge prost îmi consumă atenția.", dimension: EmotionalDimension.pressure),
  EmotionalPatternsItem(number: 26, statement: "Un rezultat slab nu mă face să renunț la ceva important pentru mine.", dimension: EmotionalDimension.setback, isReversed: true),
  EmotionalPatternsItem(number: 27, statement: "Dacă primesc un feedback negativ, îmi este greu să separ ceea ce am făcut de ceea ce cred despre mine.", dimension: EmotionalDimension.confidence),
  EmotionalPatternsItem(number: 28, statement: "Pot să observ ce simt fără să las emoția să decidă imediat ce fac.", dimension: EmotionalDimension.regulation, isReversed: true),
  EmotionalPatternsItem(number: 29, statement: "Când situația devine dificilă, reușesc de obicei să mă mobilizez.", dimension: EmotionalDimension.pressure, isReversed: true),
  EmotionalPatternsItem(number: 30, statement: "După ce ceva nu mi-a ieșit, reușesc să-mi recapăt treptat încrederea.", dimension: EmotionalDimension.setback, isReversed: true),
];

/// FutureMe's descriptive bands, applied to the two-decimal score.
EmotionalLevel emotionalLevelForScore(double score) {
  if (score <= 2.33) return EmotionalLevel.low;
  if (score <= 3.66) return EmotionalLevel.moderate;
  return EmotionalLevel.high;
}

class EmotionalDimensionResult {
  const EmotionalDimensionResult({
    required this.dimension,
    required this.recodedSum,
    required this.itemCount,
  });

  final EmotionalDimension dimension;

  /// Sum of this dimension's items after reversal.
  final int recodedSum;

  /// How many of its items were answered (8, 8, 7 or 7 when complete).
  final int itemCount;

  /// The mean, rounded to two decimals — the value that is displayed,
  /// banded and stored, so screen, level and record can never disagree.
  double get score =>
      itemCount == 0 ? 0 : double.parse((recodedSum / itemCount).toStringAsFixed(2));

  EmotionalLevel get level => emotionalLevelForScore(score);

  /// "4,13" — Romanian decimal comma, for display and for speech.
  String get formattedScore => score.toStringAsFixed(2).replaceAll('.', ',');

  /// Stable identifier of the displayed feedback variant, stored for
  /// traceability — e.g. `pressure_high`.
  String get feedbackId => '${dimension.name}_${level.name}';
}

class EmotionalPatternsResult {
  const EmotionalPatternsResult({required this.dimensions, required this.recodedAnswers});

  final List<EmotionalDimensionResult> dimensions;

  /// Every item's score after reversal, keyed by item number — kept so the
  /// stored result can be audited against the raw answers it came from.
  final Map<int, int> recodedAnswers;

  EmotionalDimensionResult operator [](EmotionalDimension dimension) =>
      dimensions.firstWhere((d) => d.dimension == dimension);
}

/// Scores a completed questionnaire. [answers] maps an item number (1-30)
/// to the option the user picked, 1-5.
///
/// Missing items are left out of both the sum and the count, so a partially
/// answered questionnaire still averages correctly rather than throwing.
EmotionalPatternsResult scoreEmotionalPatterns(Map<int, int> answers) {
  final recoded = <int, int>{};
  final sums = {for (final d in EmotionalDimension.values) d: 0};
  final counts = {for (final d in EmotionalDimension.values) d: 0};

  for (final item in emotionalPatternsItems) {
    final answer = answers[item.number];
    if (answer == null) continue;
    final clamped = answer.clamp(1, 5);
    final score = item.isReversed ? 6 - clamped : clamped;
    recoded[item.number] = score;
    sums[item.dimension] = sums[item.dimension]! + score;
    counts[item.dimension] = counts[item.dimension]! + 1;
  }

  return EmotionalPatternsResult(
    dimensions: [
      for (final d in EmotionalDimension.values)
        EmotionalDimensionResult(dimension: d, recodedSum: sums[d]!, itemCount: counts[d]!),
    ],
    recodedAnswers: recoded,
  );
}
