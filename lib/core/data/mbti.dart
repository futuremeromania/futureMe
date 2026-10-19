/// The MBTI instrument used in Module 2, Stage 1 — 32 forced-choice items,
/// scored deterministically. Nothing here is generated or interpreted by a
/// model: the same answers always produce the same four letters, and those
/// letters select one of the sixteen fixed profiles in `mbti_profiles.dart`.
///
/// Scoring follows the official answer key: each item contributes its A and
/// B points to one pole of a single dimension, and the four dimensions each
/// draw on eight items.
library;

/// One of the eight poles a point can land on.
enum MbtiPole { e, i, s, n, t, f, j, p }

/// The four dimensions, each a pair of opposing poles.
enum MbtiDimension {
  energy(MbtiPole.e, MbtiPole.i),
  perception(MbtiPole.s, MbtiPole.n),
  judgement(MbtiPole.t, MbtiPole.f),
  lifestyle(MbtiPole.j, MbtiPole.p);

  const MbtiDimension(this.first, this.second);

  final MbtiPole first;
  final MbtiPole second;
}

class MbtiItem {
  const MbtiItem({
    required this.number,
    required this.statementA,
    required this.statementB,
    required this.dimension,
    required this.aPole,
  });

  /// 1-32, matching the printed questionnaire.
  final int number;

  final String statementA;
  final String statementB;

  final MbtiDimension dimension;

  /// The pole variant A scores toward; B scores toward the other pole of
  /// [dimension]. Which side is which flips from item to item, so this is
  /// stored per item rather than derived.
  final MbtiPole aPole;

  MbtiPole get bPole => aPole == dimension.first ? dimension.second : dimension.first;
}

/// Every item is prefixed "PREFER" on the printed form; the statements below
/// continue that sentence.
const List<MbtiItem> mbtiItems = [
  MbtiItem(
    number: 1,
    statementA: "să iau hotărâri după ce știu ce gândesc și ceilalți",
    statementB: "să iau decizii singur, fără să-i consult pe ceilalți",
    dimension: MbtiDimension.energy,
    aPole: MbtiPole.e,
  ),
  MbtiItem(
    number: 2,
    statementA: "să fiu considerat un tip intuitiv, cu imaginație",
    statementB: "să fiu considerat un om al faptelor, cu picioarele pe pământ",
    dimension: MbtiDimension.perception,
    aPole: MbtiPole.n,
  ),
  MbtiItem(
    number: 3,
    statementA: "să iau hotărâri bazându-mă pe datele problemei și pe o analiză sistematică a situației",
    statementB: "să iau hotărâri bazându-mă pe ce simt și pe înțelegerea nevoilor oamenilor",
    dimension: MbtiDimension.judgement,
    aPole: MbtiPole.t,
  ),
  MbtiItem(
    number: 4,
    statementA: "să-mi asum singur sarcinile de îndeplinit, după cum consider că este mai bine",
    statementB: "să mi se spună clar ce am de făcut pentru îndeplinirea obiectivelor",
    dimension: MbtiDimension.lifestyle,
    aPole: MbtiPole.p,
  ),
  MbtiItem(
    number: 5,
    statementA: "să lucrez singur, să pot reflecta în liniște",
    statementB: "să fiu mereu activ, în contact cu oamenii, în mijlocul lor",
    dimension: MbtiDimension.energy,
    aPole: MbtiPole.i,
  ),
  MbtiItem(
    number: 6,
    statementA: "să folosesc soluții verificate, despre care știu că s-au dovedit deja ca fiind bune",
    statementB: "să încerc să găsesc noi soluții, care se pot dovedi a fi mai bune decât cele de până acum",
    dimension: MbtiDimension.perception,
    aPole: MbtiPole.s,
  ),
  MbtiItem(
    number: 7,
    statementA: "să ajung la concluzii pe baza unei analize logice a faptelor, neinfluențat de sentimente",
    statementB: "să ajung la concluzii pe baza părerilor și experienței mele despre viață și oameni",
    dimension: MbtiDimension.judgement,
    aPole: MbtiPole.t,
  ),
  MbtiItem(
    number: 8,
    statementA: "să nu-mi fixez termene finale pentru o anumită muncă, să am flexibilitate în timp",
    statementB: "să-mi fixez un program pe care să-l respect cu strictețe",
    dimension: MbtiDimension.lifestyle,
    aPole: MbtiPole.p,
  ),
  MbtiItem(
    number: 9,
    statementA: "să discut puțin despre problema de rezolvat, după care să mă gândesc singur",
    statementB: "să discut mai mult fără rețineri despre problemă înainte de a mă hotărî",
    dimension: MbtiDimension.energy,
    aPole: MbtiPole.i,
  ),
  MbtiItem(
    number: 10,
    statementA: "să mă gândesc la toate variantele posibile ale unei soluții când decid ceva",
    statementB: "să consider strict faptele reale, concrete, atunci când iau o decizie",
    dimension: MbtiDimension.perception,
    aPole: MbtiPole.n,
  ),
  MbtiItem(
    number: 11,
    statementA: "să fiu considerat o persoană cerebrală, pragmatică",
    statementB: "să fiu considerat o persoană cu multă sensibilitate, caldă",
    dimension: MbtiDimension.judgement,
    aPole: MbtiPole.t,
  ),
  MbtiItem(
    number: 12,
    statementA: "să cântăresc mult fiecare alternativă înainte de a decide",
    statementB: "să analizez rapid informațiile și să decid pe loc",
    dimension: MbtiDimension.lifestyle,
    aPole: MbtiPole.p,
  ),
  MbtiItem(
    number: 13,
    statementA: "să-mi păstrez intimitatea gândurilor și a sentimentelor",
    statementB: "să-mi împărtășesc gândurile și sentimentele celor cu care lucrez",
    dimension: MbtiDimension.energy,
    aPole: MbtiPole.i,
  ),
  MbtiItem(
    number: 14,
    statementA: "să am de-a face cu abstractul, cu teoreticul",
    statementB: "să am de-a face cu realul, concretul",
    dimension: MbtiDimension.perception,
    aPole: MbtiPole.n,
  ),
  MbtiItem(
    number: 15,
    statementA: "să-i ajut pe ceilalți să-și cunoască sentimentele, să se autoînțeleagă",
    statementB: "să-i ajut pe ceilalți să ia decizii logice",
    dimension: MbtiDimension.judgement,
    aPole: MbtiPole.f,
  ),
  MbtiItem(
    number: 16,
    statementA: "schimbarea și posibilitatea liberei alegeri",
    statementB: "predictibilitatea și cunoașterea dinainte a ceea ce se poate întâmpla",
    dimension: MbtiDimension.lifestyle,
    aPole: MbtiPole.p,
  ),
  MbtiItem(
    number: 17,
    statementA: "să nu-mi comunic gândurile și sentimentele personale",
    statementB: "să-mi comunic liber gândurile și sentimentele",
    dimension: MbtiDimension.energy,
    aPole: MbtiPole.i,
  ),
  MbtiItem(
    number: 18,
    statementA: "să fiu orientat spre imaginea întregului, a generalului, spre viziunea viitorului",
    statementB: "să fiu orientat spre cunoașterea detaliilor, a concretului și prezentului",
    dimension: MbtiDimension.perception,
    aPole: MbtiPole.n,
  ),
  MbtiItem(
    number: 19,
    statementA: "obișnuiesc să-mi bazez deciziile pe convingeri și o argumentație bazată pe bunul simț",
    statementB: "obișnuiesc să-mi bazez deciziile strict pe date și pe analiză rațională, logică",
    dimension: MbtiDimension.judgement,
    aPole: MbtiPole.f,
  ),
  MbtiItem(
    number: 20,
    statementA: "obișnuiesc să-mi planific munca din timp, bazându-mă la nevoie pe statistici, prognoze",
    statementB: "obișnuiesc să-mi fac planuri doar la momentul necesar și după cum cere situația de moment",
    dimension: MbtiDimension.lifestyle,
    aPole: MbtiPole.j,
  ),
  MbtiItem(
    number: 21,
    statementA: "îmi place să cunosc mereu oameni noi",
    statementB: "îmi place să fiu singur, sau cu persoane pe care le cunosc bine",
    dimension: MbtiDimension.energy,
    aPole: MbtiPole.e,
  ),
  MbtiItem(
    number: 22,
    statementA: "îmi plac ideile",
    statementB: "îmi plac faptele",
    dimension: MbtiDimension.perception,
    aPole: MbtiPole.n,
  ),
  MbtiItem(
    number: 23,
    statementA: "îmi plac conceptele, principiile, convingerile",
    statementB: "îmi plac datele și concluziile verificabile",
    dimension: MbtiDimension.judgement,
    aPole: MbtiPole.f,
  ),
  MbtiItem(
    number: 24,
    statementA: "obișnuiesc să notez într-o agendă de lucru întâlnirile",
    statementB: "nu-mi place să folosesc o agendă de lucru",
    dimension: MbtiDimension.lifestyle,
    aPole: MbtiPole.j,
  ),
  MbtiItem(
    number: 25,
    statementA: "discut o problemă nouă cât mai detaliat în cadrul grupului",
    statementB: "analizez problemele în minte și apoi le comunic celorlalți concluzia la care am ajuns",
    dimension: MbtiDimension.energy,
    aPole: MbtiPole.e,
  ),
  MbtiItem(
    number: 26,
    statementA: "îmi place să pun în aplicare cu precizie planuri detaliate",
    statementB: "nu-mi plac constrângerile impuse de o planificare amănunțită",
    dimension: MbtiDimension.perception,
    aPole: MbtiPole.s,
  ),
  MbtiItem(
    number: 27,
    statementA: "îmi plac oamenii care manifestă o gândire logică",
    statementB: "îmi plac mai degrabă oamenii sensibili, cu o gândire de „artist”",
    dimension: MbtiDimension.judgement,
    aPole: MbtiPole.t,
  ),
  MbtiItem(
    number: 28,
    statementA: "îmi place să fiu lăsat să acționez după inspirația de moment",
    statementB: "îmi place să știu dinainte ce se așteaptă de la mine",
    dimension: MbtiDimension.lifestyle,
    aPole: MbtiPole.p,
  ),
  MbtiItem(
    number: 29,
    statementA: "îmi place să fiu în centrul atenției",
    statementB: "îmi place să fiu retras, să nu atrag atenția asupra mea",
    dimension: MbtiDimension.energy,
    aPole: MbtiPole.e,
  ),
  MbtiItem(
    number: 30,
    statementA: "îmi place să-mi las imaginația să zboare",
    statementB: "îmi place să examinez atent detaliile realității",
    dimension: MbtiDimension.perception,
    aPole: MbtiPole.n,
  ),
  MbtiItem(
    number: 31,
    statementA: "îmi place să trăiesc situații cu încărcătură emoțională",
    statementB: "îmi place să-mi folosesc capacitățile intelectuale pentru a analiza informațiile",
    dimension: MbtiDimension.judgement,
    aPole: MbtiPole.f,
  ),
  MbtiItem(
    number: 32,
    statementA: "îmi place să încep o întâlnire de lucru exact la momentul stabilit",
    statementB: "îmi place să încep o întâlnire de lucru atunci când toți au sosit, chiar dacă se întârzie",
    dimension: MbtiDimension.lifestyle,
    aPole: MbtiPole.j,
  ),
];

/// Which pole a dimension falls to when both sides score the same.
///
/// The printed key shows both letters in parentheses on a tie, which reads
/// as an error to someone expecting a four-letter type and leaves the rest
/// of the app without a single code to work from. Ties therefore resolve
/// toward I, N, F and P — the standard MBTI convention, on the reasoning
/// that the other pole has to be actively expressed to be claimed.
const Map<MbtiDimension, MbtiPole> _tieBreakers = {
  MbtiDimension.energy: MbtiPole.i,
  MbtiDimension.perception: MbtiPole.n,
  MbtiDimension.judgement: MbtiPole.f,
  MbtiDimension.lifestyle: MbtiPole.p,
};

/// The outcome of one dimension: both totals plus the winning pole. A tie
/// still resolves to a single pole (see [_tieBreakers]), but [isTied] stays
/// true so the result screen can say the two sides came out even.
class MbtiDimensionResult {
  const MbtiDimensionResult({
    required this.dimension,
    required this.firstScore,
    required this.secondScore,
  });

  final MbtiDimension dimension;

  /// Points on [MbtiDimension.first] (E, S, T or J).
  final int firstScore;

  /// Points on [MbtiDimension.second] (I, N, F or P).
  final int secondScore;

  bool get isTied => firstScore == secondScore;

  MbtiPole get winner => isTied
      ? _tieBreakers[dimension]!
      : (firstScore > secondScore ? dimension.first : dimension.second);

  String get label => _letter(winner);
}

class MbtiResult {
  const MbtiResult({required this.dimensions, required this.scores});

  final List<MbtiDimensionResult> dimensions;

  /// Raw totals for all eight poles, kept so the report can show the
  /// margins rather than just the four letters.
  final Map<MbtiPole, int> scores;

  /// True when no dimension had to be decided by a tie-break — the type is
  /// the same either way, but a tied dimension is a weaker signal and the
  /// final report may want to say so.
  bool get isClearCut => dimensions.every((d) => !d.isTied);

  /// Always one of the sixteen types, e.g. "ESTP".
  String get typeCode => dimensions.map((d) => d.label).join();
}

String _letter(MbtiPole pole) => switch (pole) {
      MbtiPole.e => "E",
      MbtiPole.i => "I",
      MbtiPole.s => "S",
      MbtiPole.n => "N",
      MbtiPole.t => "T",
      MbtiPole.f => "F",
      MbtiPole.j => "J",
      MbtiPole.p => "P",
    };

/// Scores a completed questionnaire. [answers] maps an item number (1-32)
/// to the points given to variant A; B is taken as `5 - A`, matching the
/// instruction that the five points are split between the two.
///
/// Missing items simply contribute nothing, so a partially answered
/// questionnaire still scores rather than throwing.
MbtiResult scoreMbti(Map<int, int> answers) {
  final scores = {for (final pole in MbtiPole.values) pole: 0};

  for (final item in mbtiItems) {
    final pointsForA = answers[item.number];
    if (pointsForA == null) continue;
    final clamped = pointsForA.clamp(0, 5);
    scores[item.aPole] = scores[item.aPole]! + clamped;
    scores[item.bPole] = scores[item.bPole]! + (5 - clamped);
  }

  final dimensions = [
    for (final dimension in MbtiDimension.values)
      MbtiDimensionResult(
        dimension: dimension,
        firstScore: scores[dimension.first]!,
        secondScore: scores[dimension.second]!,
      ),
  ];

  return MbtiResult(dimensions: dimensions, scores: scores);
}