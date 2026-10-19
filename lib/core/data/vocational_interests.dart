/// The vocational-interests (RIASEC) instrument used in Module 3, Stage 1 —
/// 30 activities rated 1-5 on how much the person would enjoy doing them.
///
/// Scored as six plain sums of five items each, 5-25. There are no reversed
/// items, no means, no percentages and no low/moderate/high bands: the
/// reading is *relative*, comparing the person's own six scores against
/// each other. The top three, in order, form the RIASEC code and select
/// three of the six fixed texts in `vocational_interests_feedback.dart`.
///
/// Ties are never broken by arithmetic. When equal scores would decide who
/// enters the top three, or the order inside the code, the user is asked to
/// choose — see [pendingTie]. Their choice orders the profile; it never
/// changes a score.
library;

enum VocationalDimension {
  realistic("R", "Practic"),
  investigative("I", "Investigativ"),
  artistic("A", "Artistic"),
  social("S", "Social"),
  enterprising("E", "Antreprenorial"),
  conventional("C", "Convențional");

  const VocationalDimension(this.code, this.label);

  /// The RIASEC letter.
  final String code;

  /// The name shown to the user.
  final String label;
}

class VocationalInterestsItem {
  const VocationalInterestsItem({required this.number, required this.statement, required this.dimension});

  /// 1-30, matching the printed questionnaire.
  final int number;

  /// Always phrased in the first person, as "Mi-ar plăcea să...".
  final String statement;

  final VocationalDimension dimension;
}

/// The five response options, in order. Index 0 is the answer value 1.
const List<String> vocationalInterestsScaleLabels = [
  "Deloc",
  "Puțin",
  "Nici mult, nici puțin",
  "Mult",
  "Foarte mult",
];

/// Shown above the options on every item screen.
const String vocationalInterestsPrompt = "Alege cât de mult ți-ar plăcea să faci această activitate.";

/// Shown under the scale on every item screen.
const String vocationalInterestsCaption =
    "Răspunde doar după cât de mult ți-ar plăcea activitatea. Nu te gândi dacă ești deja bun(ă) la ea sau dacă știi cum să o faci.";

/// Shown in the order below — the six dimensions cycle, so every sixth item
/// belongs to the same one.
const List<VocationalInterestsItem> vocationalInterestsItems = [
  VocationalInterestsItem(number: 1, statement: "Mi-ar plăcea să construiesc dulapuri de bucătărie.", dimension: VocationalDimension.realistic),
  VocationalInterestsItem(number: 2, statement: "Mi-ar plăcea să contribui la dezvoltarea unui medicament nou.", dimension: VocationalDimension.investigative),
  VocationalInterestsItem(number: 3, statement: "Mi-ar plăcea să scriu cărți sau piese de teatru.", dimension: VocationalDimension.artistic),
  VocationalInterestsItem(number: 4, statement: "Mi-ar plăcea să ajut persoane care trec prin probleme personale sau emoționale.", dimension: VocationalDimension.social),
  VocationalInterestsItem(number: 5, statement: "Mi-ar plăcea să conduc un departament într-o companie mare.", dimension: VocationalDimension.enterprising),
  VocationalInterestsItem(number: 6, statement: "Mi-ar plăcea să instalez programe pe computerele unei rețele mari.", dimension: VocationalDimension.conventional),
  VocationalInterestsItem(number: 7, statement: "Mi-ar plăcea să repar aparate electrocasnice.", dimension: VocationalDimension.realistic),
  VocationalInterestsItem(number: 8, statement: "Mi-ar plăcea să studiez metode de reducere a poluării apei.", dimension: VocationalDimension.investigative),
  VocationalInterestsItem(number: 9, statement: "Mi-ar plăcea să compun sau să fac aranjamente muzicale.", dimension: VocationalDimension.artistic),
  VocationalInterestsItem(number: 10, statement: "Mi-ar plăcea să ofer oamenilor îndrumare în alegerea carierei.", dimension: VocationalDimension.social),
  VocationalInterestsItem(number: 11, statement: "Mi-ar plăcea să îmi dezvolt propria afacere.", dimension: VocationalDimension.enterprising),
  VocationalInterestsItem(number: 12, statement: "Mi-ar plăcea să lucrez la birou, pe computer, făcând calcule.", dimension: VocationalDimension.conventional),
  VocationalInterestsItem(number: 13, statement: "Mi-ar plăcea să asamblez componente electronice.", dimension: VocationalDimension.realistic),
  VocationalInterestsItem(number: 14, statement: "Mi-ar plăcea să fac experimente chimice.", dimension: VocationalDimension.investigative),
  VocationalInterestsItem(number: 15, statement: "Mi-ar plăcea să creez efecte speciale pentru filme.", dimension: VocationalDimension.artistic),
  VocationalInterestsItem(number: 16, statement: "Mi-ar plăcea să fac terapie de recuperare cu persoane care au nevoie de reabilitare.", dimension: VocationalDimension.social),
  VocationalInterestsItem(number: 17, statement: "Mi-ar plăcea să negociez contracte de afaceri.", dimension: VocationalDimension.enterprising),
  VocationalInterestsItem(number: 18, statement: "Mi-ar plăcea să țin evidența mărfurilor expediate și primite.", dimension: VocationalDimension.conventional),
  VocationalInterestsItem(number: 19, statement: "Mi-ar plăcea să conduc un camion pentru a livra colete la firme și locuințe.", dimension: VocationalDimension.realistic),
  VocationalInterestsItem(number: 20, statement: "Mi-ar plăcea să examinez probe de sânge la microscop.", dimension: VocationalDimension.investigative),
  VocationalInterestsItem(number: 21, statement: "Mi-ar plăcea să pictez decoruri pentru spectacole de teatru.", dimension: VocationalDimension.artistic),
  VocationalInterestsItem(number: 22, statement: "Mi-ar plăcea să fac voluntariat într-o organizație nonprofit.", dimension: VocationalDimension.social),
  VocationalInterestsItem(number: 23, statement: "Mi-ar plăcea să promovez o nouă colecție de îmbrăcăminte.", dimension: VocationalDimension.enterprising),
  VocationalInterestsItem(number: 24, statement: "Mi-ar plăcea să inventariez materiale folosind un dispozitiv electronic portabil.", dimension: VocationalDimension.conventional),
  VocationalInterestsItem(number: 25, statement: "Mi-ar plăcea să verific calitatea unor componente înainte de livrare.", dimension: VocationalDimension.realistic),
  VocationalInterestsItem(number: 26, statement: "Mi-ar plăcea să dezvolt metode mai bune de prognozare a vremii.", dimension: VocationalDimension.investigative),
  VocationalInterestsItem(number: 27, statement: "Mi-ar plăcea să scriu scenarii pentru filme sau emisiuni TV.", dimension: VocationalDimension.artistic),
  VocationalInterestsItem(number: 28, statement: "Mi-ar plăcea să predau unei clase de liceu.", dimension: VocationalDimension.social),
  VocationalInterestsItem(number: 29, statement: "Mi-ar plăcea să vând produse într-un magazin.", dimension: VocationalDimension.enterprising),
  VocationalInterestsItem(number: 30, statement: "Mi-ar plăcea să sortez și să distribui corespondența unei organizații.", dimension: VocationalDimension.conventional),
];

class VocationalDimensionResult {
  const VocationalDimensionResult({required this.dimension, required this.score});

  final VocationalDimension dimension;

  /// Sum of this dimension's five items, 5-25.
  final int score;
}

class VocationalInterestsResult {
  const VocationalInterestsResult({
    required this.scores,
    required this.answers,
    this.tieBreakChoices = const [],
  });

  final Map<VocationalDimension, int> scores;

  /// Every item's raw answer (1-5), keyed by item number.
  final Map<int, int> answers;

  /// Dimensions the user picked when asked to separate equal scores, in the
  /// order they picked them. Used only for ordering — never to alter a score.
  final List<VocationalDimension> tieBreakChoices;

  VocationalInterestsResult withTieBreak(VocationalDimension choice) => VocationalInterestsResult(
        scores: scores,
        answers: answers,
        tieBreakChoices: [...tieBreakChoices, choice],
      );

  int operator [](VocationalDimension dimension) => scores[dimension]!;

  /// All six dimensions, highest score first. Equal scores are ordered by
  /// the user's own choices where those exist, and otherwise fall back to
  /// the fixed R-I-A-S-E-C order so the list is never arbitrary.
  List<VocationalDimensionResult> get ranked {
    final order = [...VocationalDimension.values];
    order.sort((a, b) {
      final byScore = scores[b]!.compareTo(scores[a]!);
      if (byScore != 0) return byScore;

      final ia = tieBreakChoices.indexOf(a);
      final ib = tieBreakChoices.indexOf(b);
      if (ia != -1 && ib != -1) return ia.compareTo(ib);
      if (ia != -1) return -1;
      if (ib != -1) return 1;

      return VocationalDimension.values.indexOf(a).compareTo(VocationalDimension.values.indexOf(b));
    });
    return [for (final d in order) VocationalDimensionResult(dimension: d, score: scores[d]!)];
  }

  List<VocationalDimension> get topThree => [for (final r in ranked.take(3)) r.dimension];

  /// "S–I–A"
  String get code => topThree.map((d) => d.code).join("–");

  /// The dimensions the user still has to separate, or null when the
  /// profile is already unambiguous.
  ///
  /// A tie only matters when it reaches the top three: either because the
  /// tied dimensions straddle third place, or because they sit inside it and
  /// so decide the order of the code. A tie further down changes nothing
  /// that is displayed, and the user is not bothered with it.
  List<VocationalDimension>? get pendingTie {
    final list = ranked;
    for (var i = 0; i < list.length;) {
      var j = i;
      while (j + 1 < list.length && list[j + 1].score == list[i].score) {
        j++;
      }
      final groupSize = j - i + 1;
      final reachesTopThree = i <= 2;
      if (groupSize > 1 && reachesTopThree) {
        final unresolved = [
          for (var k = i; k <= j; k++)
            if (!tieBreakChoices.contains(list[k].dimension)) list[k].dimension,
        ];
        // One left is not a tie any more: its place is decided by elimination.
        if (unresolved.length > 1) return unresolved;
      }
      i = j + 1;
    }
    return null;
  }
}

/// Scores a completed questionnaire. [answers] maps an item number (1-30)
/// to the option the user picked, 1-5.
VocationalInterestsResult scoreVocationalInterests(Map<int, int> answers) {
  final totals = {for (final d in VocationalDimension.values) d: 0};

  for (final item in vocationalInterestsItems) {
    final answer = answers[item.number];
    if (answer == null) continue;
    totals[item.dimension] = totals[item.dimension]! + answer.clamp(1, 5);
  }

  return VocationalInterestsResult(scores: totals, answers: answers);
}
