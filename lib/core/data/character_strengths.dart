/// The strengths instrument used in Module 4, Stage 1 — 30 items rated 1-5,
/// scored into ten strengths of three items each.
///
/// Deliberately absent: percentages, means, an overall score and the
/// low/moderate/high bands the other instruments use. The ten scores exist
/// only to rank a person against their own other nine, never against
/// anyone else, and a lower score is not a weakness — it is simply a
/// strength that did not stand out this time. That is why the screens show
/// no numbers and no positions.
library;

/// Listed in scoring-key order, which also decides ties that no tie-break
/// resolves, so the same answers always produce the same profile.
enum StrengthDimension {
  curiosity("Curiozitate"),
  loveOfLearning("Dorință de a învăța"),
  creativity("Creativitate"),
  criticalThinking("Gândire critică"),
  perspective("Perspectivă"),
  perseverance("Perseverență"),
  futureOrientation("Orientare spre viitor"),
  socialIntelligence("Inteligență socială"),
  teamwork("Lucru în echipă"),
  leadership("Leadership");

  const StrengthDimension(this.label);

  final String label;
}

class StrengthsItem {
  const StrengthsItem({required this.id, required this.statement, required this.dimension});

  /// The original questionnaire id, 1-30. Scoring uses this, never the
  /// display position — the two differ, because the items are shown
  /// interleaved so three questions about the same strength never arrive
  /// in a row.
  final int id;

  final String statement;
  final StrengthDimension dimension;
}

/// The five response options, in order. Index 0 is the answer value 1.
const List<String> strengthsScaleLabels = [
  "Deloc adevărat",
  "Mai degrabă fals",
  "Neutru",
  "Mai degrabă adevărat",
  "Foarte adevărat",
];

/// The frozen display order. Position in this list is the question number;
/// `id` stays the scoring id. Every item is required and none are reversed.
const List<StrengthsItem> strengthsItems = [
  StrengthsItem(id: 1, dimension: StrengthDimension.curiosity, statement: "Când întâlnesc ceva ce nu înțeleg, vreau să aflu mai multe."),
  StrengthsItem(id: 28, dimension: StrengthDimension.leadership, statement: "Când un grup nu știe cum să înceapă, îmi vine natural să ajut la organizarea lucrurilor."),
  StrengthsItem(id: 8, dimension: StrengthDimension.creativity, statement: "Îmi place să găsesc un mod diferit de a face lucrurile."),
  StrengthsItem(id: 22, dimension: StrengthDimension.socialIntelligence, statement: "Îmi dau seama destul de repede când cineva nu se simte în largul lui."),
  StrengthsItem(id: 13, dimension: StrengthDimension.perspective, statement: "Când apare o problemă, încerc să văd situația în ansamblu."),
  StrengthsItem(id: 16, dimension: StrengthDimension.perseverance, statement: "Dacă ceva este important pentru mine, continui chiar când devine dificil."),
  StrengthsItem(id: 25, dimension: StrengthDimension.teamwork, statement: "Când lucrez într-un grup, mă interesează ca rezultatul întregii echipe să fie bun."),
  StrengthsItem(id: 5, dimension: StrengthDimension.loveOfLearning, statement: "Când un subiect mă interesează, caut să înțeleg tot mai mult despre el."),
  StrengthsItem(id: 10, dimension: StrengthDimension.criticalThinking, statement: "Înainte să cred o informație, mă gândesc dacă are sens."),
  StrengthsItem(id: 19, dimension: StrengthDimension.futureOrientation, statement: "Când mă gândesc la viitor, îmi pot imagina lucruri pe care aș vrea să le construiesc sau să le realizez."),
  StrengthsItem(id: 7, dimension: StrengthDimension.creativity, statement: "Îmi vin adesea mai multe idei pentru aceeași problemă."),
  StrengthsItem(id: 23, dimension: StrengthDimension.socialIntelligence, statement: "Îmi adaptez felul de a vorbi în funcție de persoana și situația în care mă aflu."),
  StrengthsItem(id: 2, dimension: StrengthDimension.curiosity, statement: "Îmi vin des întrebări despre cum sau de ce funcționează lucrurile."),
  StrengthsItem(id: 26, dimension: StrengthDimension.teamwork, statement: "Când ceilalți depind de partea mea de lucru, mă străduiesc să o duc la capăt."),
  StrengthsItem(id: 20, dimension: StrengthDimension.futureOrientation, statement: "Chiar dacă un plan nu merge, caut alte căi prin care pot ajunge unde îmi doresc."),
  StrengthsItem(id: 11, dimension: StrengthDimension.criticalThinking, statement: "Când aud o afirmație, încerc să văd ce argumente o susțin."),
  StrengthsItem(id: 29, dimension: StrengthDimension.leadership, statement: "Pot să-i aduc pe ceilalți în jurul unei idei sau al unui obiectiv comun."),
  StrengthsItem(id: 14, dimension: StrengthDimension.perspective, statement: "Reușesc să fac legături între lucruri care la început par separate."),
  StrengthsItem(id: 4, dimension: StrengthDimension.loveOfLearning, statement: "Îmi place să descopăr lucruri pe care înainte nu le știam."),
  StrengthsItem(id: 17, dimension: StrengthDimension.perseverance, statement: "După ce întâmpin un obstacol, caut o altă cale de a merge mai departe."),
  StrengthsItem(id: 24, dimension: StrengthDimension.socialIntelligence, statement: "De multe ori înțeleg ce se întâmplă între oameni chiar dacă nu spun direct ce simt."),
  StrengthsItem(id: 12, dimension: StrengthDimension.criticalThinking, statement: "Pot să-mi schimb părerea atunci când găsesc argumente mai bune."),
  StrengthsItem(id: 9, dimension: StrengthDimension.creativity, statement: "Când creez ceva, îmi place să-i dau o formă personală."),
  StrengthsItem(id: 30, dimension: StrengthDimension.leadership, statement: "Când coordonez ceva, încerc să mă asigur că fiecare știe ce are de făcut și poate contribui."),
  StrengthsItem(id: 3, dimension: StrengthDimension.curiosity, statement: "Ajung să explorez subiecte noi chiar dacă nu mi le-a cerut nimeni."),
  StrengthsItem(id: 18, dimension: StrengthDimension.perseverance, statement: "Pot continua un lucru chiar dacă rezultatul nu apare imediat."),
  StrengthsItem(id: 15, dimension: StrengthDimension.perspective, statement: "Când cineva îmi cere părerea despre o situație, reușesc adesea să-i arăt și un alt mod de a o privi."),
  StrengthsItem(id: 6, dimension: StrengthDimension.loveOfLearning, statement: "Îmi place să învăț lucruri noi chiar și atunci când nu am nevoie imediată de ele."),
  StrengthsItem(id: 21, dimension: StrengthDimension.futureOrientation, statement: "Când îmi doresc ceva important pentru viitorul meu, încerc să fac pași concreți în direcția aceea."),
  StrengthsItem(id: 27, dimension: StrengthDimension.teamwork, statement: "Pot susține ideea altcuiva atunci când este mai bună decât a mea."),
];

/// How many strengths the result screen shows.
const int strengthsTopCount = 5;

/// How many of those five the user then picks as the ones they recognise
/// themselves in most.
const int strengthsSelfPickCount = 3;

class StrengthScore {
  const StrengthScore({required this.dimension, required this.score});

  final StrengthDimension dimension;

  /// Sum of this strength's three items, 3-15. Never shown to the user.
  final int score;
}

/// A tie that decides who makes the Top 5 and therefore has to be resolved
/// by the person rather than by an arbitrary order.
class StrengthsTie {
  const StrengthsTie({required this.tied, required this.slots});

  /// The equal-scoring strengths still waiting to be chosen between.
  final List<StrengthDimension> tied;

  /// How many of them still fit in the Top 5.
  final int slots;
}

class StrengthsResult {
  const StrengthsResult({required this.scores, required this.answers, this.tieBreakChoices = const []});

  /// Every strength's raw score, in scoring-key order.
  final List<StrengthScore> scores;

  /// Every item's raw answer (1-5), keyed by its original id 1-30.
  final Map<int, int> answers;

  /// Strengths the user picked when a tie decided the last Top 5 places,
  /// in the order they picked them. These order the profile; they never
  /// change a score.
  final List<StrengthDimension> tieBreakChoices;

  int scoreOf(StrengthDimension dimension) => scores.firstWhere((s) => s.dimension == dimension).score;

  /// Highest first. Equal scores are ordered by the user's tie-break picks
  /// where they made any, then by the scoring-key order, so the ranking is
  /// stable for the same answers.
  List<StrengthScore> get ranked {
    final sorted = [...scores];
    sorted.sort((a, b) {
      if (a.score != b.score) return b.score.compareTo(a.score);
      final ai = tieBreakChoices.indexOf(a.dimension);
      final bi = tieBreakChoices.indexOf(b.dimension);
      if (ai != bi) return (ai == -1 ? 999 : ai).compareTo(bi == -1 ? 999 : bi);
      return a.dimension.index.compareTo(b.dimension.index);
    });
    return sorted;
  }

  List<StrengthDimension> get topFive => [for (final s in ranked.take(strengthsTopCount)) s.dimension];

  /// The tie that still needs the user's decision, or null.
  ///
  /// Only a tie that straddles the fifth place matters: several strengths
  /// sharing a score entirely inside the Top 5, or entirely outside it,
  /// change nothing about who is shown. When one does straddle it, the
  /// person chooses which of the tied strengths take the remaining places.
  StrengthsTie? get pendingTie {
    final order = ranked;
    final boundaryScore = order[strengthsTopCount - 1].score;
    final tied = [for (final s in order) if (s.score == boundaryScore) s.dimension];
    final above = order.where((s) => s.score > boundaryScore).length;
    final slots = strengthsTopCount - above;

    if (tied.length <= slots) return null; // the whole group fits — nothing to decide

    final chosen = tied.where(tieBreakChoices.contains).length;
    final remaining = slots - chosen;
    if (remaining <= 0) return null;

    final undecided = [for (final d in tied) if (!tieBreakChoices.contains(d)) d];
    return StrengthsTie(tied: undecided, slots: remaining);
  }

  StrengthsResult withTieBreak(List<StrengthDimension> choices) => StrengthsResult(
        scores: scores,
        answers: answers,
        tieBreakChoices: [...tieBreakChoices, ...choices],
      );
}

/// Scores a completed questionnaire. [answers] maps an item's original id
/// (1-30) to the option the user picked, 1-5.
StrengthsResult scoreStrengths(Map<int, int> answers) {
  final totals = {for (final d in StrengthDimension.values) d: 0};

  for (final item in strengthsItems) {
    final answer = answers[item.id];
    if (answer == null) continue;
    totals[item.dimension] = totals[item.dimension]! + answer.clamp(1, 5);
  }

  return StrengthsResult(
    scores: [for (final d in StrengthDimension.values) StrengthScore(dimension: d, score: totals[d]!)],
    answers: answers,
  );
}
