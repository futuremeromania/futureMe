/// The Big Five instrument used in Module 2, Stage 2 — the 50-item IPIP
/// Big-Five Factor Markers, scored deterministically.
///
/// Nothing here is generated or interpreted by a model: reversed items are
/// recoded, the ten items of each dimension are summed, and the total falls
/// into one of three descriptive bands that select a fixed feedback text
/// from `big_five_feedback.dart`.
library;

enum BigFiveDimension {
  openness("Deschidere / Intelect"),
  conscientiousness("Conștiinciozitate"),
  extraversion("Extraversie"),
  agreeableness("Agreabilitate"),
  emotionalStability("Stabilitate emoțională");

  const BigFiveDimension(this.label);

  final String label;
}

/// The three descriptive bands FutureMe uses for feedback.
///
/// These are a descriptive classification, not IPIP percentiles or
/// population norms. If norms for the target population are introduced
/// later, only [levelForRawScore] changes — the items and the scoring
/// itself stay as they are.
enum BigFiveLevel {
  low("Scăzut"),
  moderate("Moderat"),
  high("Ridicat");

  const BigFiveLevel(this.label);

  final String label;
}

class BigFiveItem {
  const BigFiveItem({
    required this.number,
    required this.statement,
    required this.dimension,
    this.isReversed = false,
  });

  /// 1-50, matching the printed questionnaire.
  final int number;

  final String statement;
  final BigFiveDimension dimension;

  /// Reversed items are recoded as `6 - answer` before being summed. The
  /// marking is never shown to the user.
  final bool isReversed;
}

/// The five response options, in order. Index 0 is the answer value 1.
const List<String> bigFiveScaleLabels = [
  "Deloc adevărat pentru mine",
  "Mai degrabă fals",
  "Nici adevărat, nici fals",
  "Mai degrabă adevărat",
  "Foarte adevărat pentru mine",
];

/// Shown in the order below.
const List<BigFiveItem> bigFiveItems = [
  BigFiveItem(number: 1, statement: "Îmi place să dau viață atmosferei când sunt într-un grup.", dimension: BigFiveDimension.extraversion),
  BigFiveItem(number: 2, statement: "Îmi pasă puțin de ceilalți.", dimension: BigFiveDimension.agreeableness, isReversed: true),
  BigFiveItem(number: 3, statement: "Sunt mereu pregătit(ă).", dimension: BigFiveDimension.conscientiousness),
  BigFiveItem(number: 4, statement: "Mă stresez ușor.", dimension: BigFiveDimension.emotionalStability, isReversed: true),
  BigFiveItem(number: 5, statement: "Am un vocabular bogat.", dimension: BigFiveDimension.openness),
  BigFiveItem(number: 6, statement: "Nu vorbesc prea mult.", dimension: BigFiveDimension.extraversion, isReversed: true),
  BigFiveItem(number: 7, statement: "Sunt interesat(ă) de oameni.", dimension: BigFiveDimension.agreeableness),
  BigFiveItem(number: 8, statement: "Îmi las lucrurile împrăștiate.", dimension: BigFiveDimension.conscientiousness, isReversed: true),
  BigFiveItem(number: 9, statement: "Sunt relaxat(ă) în cea mai mare parte a timpului.", dimension: BigFiveDimension.emotionalStability),
  BigFiveItem(number: 10, statement: "Îmi este greu să înțeleg ideile abstracte.", dimension: BigFiveDimension.openness, isReversed: true),
  BigFiveItem(number: 11, statement: "Mă simt confortabil în preajma oamenilor.", dimension: BigFiveDimension.extraversion),
  BigFiveItem(number: 12, statement: "Îi jignesc pe ceilalți.", dimension: BigFiveDimension.agreeableness, isReversed: true),
  BigFiveItem(number: 13, statement: "Sunt atent(ă) la detalii.", dimension: BigFiveDimension.conscientiousness),
  BigFiveItem(number: 14, statement: "Îmi fac multe griji.", dimension: BigFiveDimension.emotionalStability, isReversed: true),
  BigFiveItem(number: 15, statement: "Am o imaginație bogată.", dimension: BigFiveDimension.openness),
  BigFiveItem(number: 16, statement: "Prefer să rămân în plan secund.", dimension: BigFiveDimension.extraversion, isReversed: true),
  BigFiveItem(number: 17, statement: "Înțeleg și simt cu ușurință ceea ce trăiesc ceilalți.", dimension: BigFiveDimension.agreeableness),
  BigFiveItem(number: 18, statement: "Fac dezordine.", dimension: BigFiveDimension.conscientiousness, isReversed: true),
  BigFiveItem(number: 19, statement: "Rareori mă simt trist(ă) sau descurajat(ă).", dimension: BigFiveDimension.emotionalStability),
  BigFiveItem(number: 20, statement: "Nu mă interesează prea mult ideile abstracte.", dimension: BigFiveDimension.openness, isReversed: true),
  BigFiveItem(number: 21, statement: "Încep cu ușurință conversații.", dimension: BigFiveDimension.extraversion),
  BigFiveItem(number: 22, statement: "Nu mă interesează prea mult problemele altor oameni.", dimension: BigFiveDimension.agreeableness, isReversed: true),
  BigFiveItem(number: 23, statement: "Îmi fac sarcinile fără să le amân.", dimension: BigFiveDimension.conscientiousness),
  BigFiveItem(number: 24, statement: "Mă tulbur ușor.", dimension: BigFiveDimension.emotionalStability, isReversed: true),
  BigFiveItem(number: 25, statement: "Îmi vin idei foarte bune.", dimension: BigFiveDimension.openness),
  BigFiveItem(number: 26, statement: "De obicei am puține lucruri de spus.", dimension: BigFiveDimension.extraversion, isReversed: true),
  BigFiveItem(number: 27, statement: "Sunt o persoană sensibilă la nevoile celorlalți.", dimension: BigFiveDimension.agreeableness),
  BigFiveItem(number: 28, statement: "Uit adesea să pun lucrurile înapoi la locul lor.", dimension: BigFiveDimension.conscientiousness, isReversed: true),
  BigFiveItem(number: 29, statement: "Mă supăr ușor.", dimension: BigFiveDimension.emotionalStability, isReversed: true),
  BigFiveItem(number: 30, statement: "Nu am o imaginație prea bogată.", dimension: BigFiveDimension.openness, isReversed: true),
  BigFiveItem(number: 31, statement: "Vorbesc cu multe persoane atunci când sunt într-un grup mai mare.", dimension: BigFiveDimension.extraversion),
  BigFiveItem(number: 32, statement: "Nu sunt cu adevărat interesat(ă) de ceilalți.", dimension: BigFiveDimension.agreeableness, isReversed: true),
  BigFiveItem(number: 33, statement: "Îmi place ordinea.", dimension: BigFiveDimension.conscientiousness),
  BigFiveItem(number: 34, statement: "Starea mea de spirit se schimbă des.", dimension: BigFiveDimension.emotionalStability, isReversed: true),
  BigFiveItem(number: 35, statement: "Înțeleg repede lucrurile.", dimension: BigFiveDimension.openness),
  BigFiveItem(number: 36, statement: "Nu îmi place să atrag atenția asupra mea.", dimension: BigFiveDimension.extraversion, isReversed: true),
  BigFiveItem(number: 37, statement: "Îmi fac timp pentru ceilalți.", dimension: BigFiveDimension.agreeableness),
  BigFiveItem(number: 38, statement: "Îmi neglijez uneori responsabilitățile.", dimension: BigFiveDimension.conscientiousness, isReversed: true),
  BigFiveItem(number: 39, statement: "Am schimbări frecvente de dispoziție.", dimension: BigFiveDimension.emotionalStability, isReversed: true),
  BigFiveItem(number: 40, statement: "Folosesc uneori cuvinte mai complexe.", dimension: BigFiveDimension.openness),
  BigFiveItem(number: 41, statement: "Nu mă deranjează să fiu în centrul atenției.", dimension: BigFiveDimension.extraversion),
  BigFiveItem(number: 42, statement: "Simt ușor emoțiile celorlalți.", dimension: BigFiveDimension.agreeableness),
  BigFiveItem(number: 43, statement: "Îmi place să urmez un program.", dimension: BigFiveDimension.conscientiousness),
  BigFiveItem(number: 44, statement: "Mă irit ușor.", dimension: BigFiveDimension.emotionalStability, isReversed: true),
  BigFiveItem(number: 45, statement: "Petrec timp reflectând asupra lucrurilor.", dimension: BigFiveDimension.openness),
  BigFiveItem(number: 46, statement: "Sunt tăcut(ă) în preajma persoanelor pe care nu le cunosc.", dimension: BigFiveDimension.extraversion, isReversed: true),
  BigFiveItem(number: 47, statement: "Îi fac pe ceilalți să se simtă în largul lor.", dimension: BigFiveDimension.agreeableness),
  BigFiveItem(number: 48, statement: "Sunt exigent(ă) cu felul în care îmi fac treaba.", dimension: BigFiveDimension.conscientiousness),
  BigFiveItem(number: 49, statement: "Mă simt adesea trist(ă) sau descurajat(ă).", dimension: BigFiveDimension.emotionalStability, isReversed: true),
  BigFiveItem(number: 50, statement: "Am multe idei.", dimension: BigFiveDimension.openness),
];

/// FutureMe's descriptive bands over the 10-50 raw range.
BigFiveLevel levelForRawScore(int rawScore) {
  if (rawScore <= 24) return BigFiveLevel.low;
  if (rawScore <= 36) return BigFiveLevel.moderate;
  return BigFiveLevel.high;
}

class BigFiveDimensionResult {
  const BigFiveDimensionResult({required this.dimension, required this.rawScore});

  final BigFiveDimension dimension;

  /// Sum of the ten recoded item scores, 10-50.
  final int rawScore;

  /// 1.0-5.0, the raw score over its ten items.
  double get mean => rawScore / 10;

  BigFiveLevel get level => levelForRawScore(rawScore);
}

class BigFiveResult {
  const BigFiveResult({required this.dimensions, required this.recodedAnswers});

  final List<BigFiveDimensionResult> dimensions;

  /// Every item's score after reversal, keyed by item number — kept so the
  /// stored result can be audited against the raw answers it came from.
  final Map<int, int> recodedAnswers;

  BigFiveDimensionResult operator [](BigFiveDimension dimension) =>
      dimensions.firstWhere((d) => d.dimension == dimension);
}

/// Scores a completed questionnaire. [answers] maps an item number (1-50)
/// to the option the user picked, 1-5.
///
/// Missing items contribute nothing, so a partially answered questionnaire
/// still scores rather than throwing — the resulting raw scores will simply
/// sit below the 10-50 range.
BigFiveResult scoreBigFive(Map<int, int> answers) {
  final recoded = <int, int>{};
  final totals = {for (final d in BigFiveDimension.values) d: 0};

  for (final item in bigFiveItems) {
    final answer = answers[item.number];
    if (answer == null) continue;
    final clamped = answer.clamp(1, 5);
    final score = item.isReversed ? 6 - clamped : clamped;
    recoded[item.number] = score;
    totals[item.dimension] = totals[item.dimension]! + score;
  }

  return BigFiveResult(
    dimensions: [
      for (final d in BigFiveDimension.values)
        BigFiveDimensionResult(dimension: d, rawScore: totals[d]!),
    ],
    recodedAnswers: recoded,
  );
}