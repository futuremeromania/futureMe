/// The decision-making style instrument used in Module 2, Stage 4 — 20
/// items, each belonging to exactly one of five decision styles, scored
/// deterministically.
///
/// There are no reversed items and no Likert scale: the user marks each
/// statement as matching them or not, and a style's score is simply how
/// many of its four items were marked. Nothing here is generated or
/// interpreted by a model — the score selects a fixed feedback text from
/// `decision_style_feedback.dart`.
library;

enum DecisionStyle {
  rational("Rațional"),
  dependent("Dependent"),
  avoidant("Evitant"),
  intuitive("Intuitiv"),
  spontaneous("Spontan");

  const DecisionStyle(this.label);

  final String label;
}

class DecisionStyleItem {
  const DecisionStyleItem({required this.number, required this.statement, required this.style});

  /// 1-20, matching the printed questionnaire.
  final int number;

  final String statement;
  final DecisionStyle style;
}

/// Shown in the order below. Each style is backed by exactly 4 items.
const List<DecisionStyleItem> decisionStyleItems = [
  DecisionStyleItem(number: 1, statement: "Când iau decizii tind să mă bazez pe intuiția mea.", style: DecisionStyle.intuitive),
  DecisionStyleItem(number: 2, statement: "De obicei nu iau decizii importante fără să mă consult cu alți oameni.", style: DecisionStyle.dependent),
  DecisionStyleItem(number: 3, statement: "Când iau o decizie este mai important să simt că decizia este corectă.", style: DecisionStyle.intuitive),
  DecisionStyleItem(number: 4, statement: "Înainte de a lua decizii verific de mai multe ori sursele de informație pe care mă bazez.", style: DecisionStyle.rational),
  DecisionStyleItem(number: 5, statement: "Țin cont de sfaturile altor oameni atunci când iau decizii importante.", style: DecisionStyle.dependent),
  DecisionStyleItem(number: 6, statement: "Amân luarea deciziilor pentru că mă neliniștește să mă tot gândesc la ele.", style: DecisionStyle.avoidant),
  DecisionStyleItem(number: 7, statement: "Iau decizii într-un mod logic și sistematic.", style: DecisionStyle.rational),
  DecisionStyleItem(number: 8, statement: "Când iau decizii fac ce mi se pare potrivit pe moment.", style: DecisionStyle.spontaneous),
  DecisionStyleItem(number: 9, statement: "De obicei iau decizii foarte rapid.", style: DecisionStyle.spontaneous),
  DecisionStyleItem(number: 10, statement: "Prefer să fiu ghidat de altcineva când trebuie să iau o decizie importantă.", style: DecisionStyle.dependent),
  DecisionStyleItem(number: 11, statement: "Am nevoie de o perioadă mare de gândire atunci când iau o decizie.", style: DecisionStyle.avoidant),
  DecisionStyleItem(number: 12, statement: "Când iau o decizie am încredere în sentimentele și reacțiile mele.", style: DecisionStyle.intuitive),
  DecisionStyleItem(number: 13, statement: "Opțiunile pe care le iau în considerare atunci când decid sunt ghidate de scopurile mele.", style: DecisionStyle.rational),
  DecisionStyleItem(number: 14, statement: "Iau decizii numai sub presiunea timpului.", style: DecisionStyle.avoidant),
  DecisionStyleItem(number: 15, statement: "Adesea iau decizii în mod impulsiv.", style: DecisionStyle.spontaneous),
  DecisionStyleItem(number: 16, statement: "Când iau decizii mă bazez pe instinct.", style: DecisionStyle.intuitive),
  DecisionStyleItem(number: 17, statement: "Amân să iau decizii cât de mult pot.", style: DecisionStyle.avoidant),
  DecisionStyleItem(number: 18, statement: "Iau rapid decizii.", style: DecisionStyle.spontaneous),
  DecisionStyleItem(number: 19, statement: "Dacă am sprijinul altora mi-e mai ușor să iau decizii.", style: DecisionStyle.dependent),
  DecisionStyleItem(number: 20, statement: "În general analizez care sunt dovezile pro și contra când iau o decizie.", style: DecisionStyle.rational),
];

/// The two response options shown for every item, in this order — index 0
/// is "not selected" (0 points), index 1 is "selected" (1 point).
const List<String> decisionStyleScaleLabels = ["Nu mi se potrivește", "Mi se potrivește"];

class DecisionStyleDimensionResult {
  const DecisionStyleDimensionResult({required this.style, required this.score});

  final DecisionStyle style;

  /// Count of this style's four items the user selected, 0-4.
  final int score;
}

class DecisionStyleResult {
  const DecisionStyleResult({required this.dimensions, required this.selectedAnswers});

  final List<DecisionStyleDimensionResult> dimensions;

  /// Every item's selected/not-selected state, keyed by item number — kept
  /// so the stored result can be audited against the raw answers.
  final Map<int, bool> selectedAnswers;

  DecisionStyleDimensionResult operator [](DecisionStyle style) => dimensions.firstWhere((d) => d.style == style);
}

/// Scores a completed questionnaire. [answers] maps an item number (1-20)
/// to whether the user selected it.
///
/// Missing items are treated as not selected, so a partially answered
/// questionnaire still scores rather than throwing.
DecisionStyleResult scoreDecisionStyle(Map<int, bool> answers) {
  final totals = {for (final s in DecisionStyle.values) s: 0};

  for (final item in decisionStyleItems) {
    if (answers[item.number] == true) {
      totals[item.style] = totals[item.style]! + 1;
    }
  }

  return DecisionStyleResult(
    dimensions: [for (final s in DecisionStyle.values) DecisionStyleDimensionResult(style: s, score: totals[s]!)],
    selectedAnswers: answers,
  );
}