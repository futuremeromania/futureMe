/// The timed aptitude test used in Module 4, Stage 2 — 24 multiple-choice
/// exercises in four blocks of six, answered against one 30-minute clock.
///
/// PILOT. The items, their order, the time limit and the key are the ones
/// frozen for the pilot run. Nothing here is normed: there are no
/// percentiles, no population comparisons and no low/moderate/high labels,
/// and six items are far too few to call anything a strength. The point of
/// this version is to collect per-item accuracy and response times so the
/// difficulty ordering can be checked against real answers — which is why
/// every item's timing is stored even though it never touches the score.
library;

import 'spatial_figures.dart';

enum AptitudeCategory {
  logic("Raționament logic"),
  verbal("Raționament verbal"),
  numeric("Raționament numeric"),
  spatial("Raționament spațial");

  const AptitudeCategory(this.label);

  final String label;
}

/// What happened to one item. `unanswered` is kept apart from `incorrect`:
/// both score zero, but running out of time on an item and getting it
/// wrong are different facts, and the pilot analysis needs to tell them
/// apart.
enum AptitudeItemStatus { correct, incorrect, unanswered }

class AptitudeItem {
  const AptitudeItem({
    required this.id,
    required this.category,
    required this.title,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.promptFigure,
    this.optionFigures,
  });

  /// 1-24, in administration order.
  final int id;

  final AptitudeCategory category;

  /// The item type, e.g. "Șir numeric" — shown above the question.
  final String title;

  final String prompt;

  /// Exactly four options, in order A-D.
  final List<String> options;

  final int correctIndex;

  /// Fixed FutureMe copy shown in the review screen. Never generated.
  final String explanation;

  /// The figure the question is about, where it has one. The spatial
  /// block needs these. Geometry, not artwork: it is described in
  /// `spatial_figures.dart` and drawn by the app, so it stays sharp at any
  /// size and an answer figure can be tapped like any other option.
  final SpatialFigure? promptFigure;

  /// The four answer figures, where the options are shapes rather than
  /// words. When present, `options` holds their labels for the review
  /// screen and for anything that has to name an answer in words.
  final List<SpatialFigure>? optionFigures;

  bool get isVisual => promptFigure != null || optionFigures != null;
}

const String aptitudeTestVersion = "aptitudes-ro-pilot-v1";
const int aptitudeTimeLimitMinutes = 30;

/// A-D, used for the option chips and the review screen.
const List<String> aptitudeOptionLetters = ["A", "B", "C", "D"];

/// Fixed administration order: logic, then verbal, numeric, spatial.
///
/// `final` rather than `const` only because the cube structure is built
/// from its height map rather than written out cube by cube.
final List<AptitudeItem> aptitudeItems = [
  // ---- Raționament logic -------------------------------------------------
  AptitudeItem(
    id: 1,
    category: AptitudeCategory.logic,
    title: "Șir numeric",
    prompt: "Completează șirul: 2 → 4 → 8 → 16 → ?",
    options: ["18", "24", "32", "36"],
    correctIndex: 2,
    explanation: "Fiecare număr este dublul celui anterior: 2×2=4, 4×2=8, 8×2=16, iar 16×2=32.",
  ),
  AptitudeItem(
    id: 2,
    category: AptitudeCategory.logic,
    title: "Deducție",
    prompt: "Toți membrii clubului de robotică au ecuson. Mara este membră a clubului de robotică. Ce putem spune cu siguranță?",
    options: [
      "Mara construiește roboți acasă.",
      "Mara are ecuson.",
      "Mara conduce clubul.",
      "Mara este cea mai bună la robotică.",
    ],
    correctIndex: 1,
    explanation: "Dacă toți membrii clubului au ecuson, iar Mara este membră, rezultă în mod necesar că Mara are ecuson.",
  ),
  AptitudeItem(
    id: 3,
    category: AptitudeCategory.logic,
    title: "Clasificare",
    prompt:
        "Cutiile sunt organizate astfel: A = cercuri roșii; B = cercuri albastre; C = pătrate roșii; D = pătrate albastre. Unde trebuie pus un obiect roșu care nu este cerc?",
    options: ["Cutia A", "Cutia B", "Cutia C", "Cutia D"],
    correctIndex: 2,
    explanation: "Obiectul este roșu și nu este cerc, deci este pătrat roșu. Această categorie corespunde cutiei C.",
  ),
  AptitudeItem(
    id: 4,
    category: AptitudeCategory.logic,
    title: "Ordonare",
    prompt: "Ana este înaintea lui Bogdan. Carla este după Bogdan. Dan este înaintea Anei. Care este singura ordine posibilă?",
    options: [
      "Dan – Ana – Bogdan – Carla",
      "Ana – Dan – Bogdan – Carla",
      "Dan – Bogdan – Ana – Carla",
      "Carla – Dan – Ana – Bogdan",
    ],
    correctIndex: 0,
    explanation:
        "Dan trebuie să fie înaintea Anei, Ana înaintea lui Bogdan, iar Carla după Bogdan. Singura ordine care respectă toate condițiile este Dan – Ana – Bogdan – Carla.",
  ),
  AptitudeItem(
    id: 5,
    category: AptitudeCategory.logic,
    title: "Condiții",
    prompt:
        "Alex, Bianca și Cezar aleg fiecare câte o activitate diferită: debate, fotografie, programare. Alex nu alege programarea. Bianca nu alege fotografia. Cezar alege programarea sau fotografia. Alex nu alege fotografia. Care repartizare este posibilă?",
    options: [
      "Alex debate / Bianca fotografie / Cezar programare",
      "Alex debate / Bianca programare / Cezar fotografie",
      "Alex fotografie / Bianca debate / Cezar programare",
      "Alex programare / Bianca debate / Cezar fotografie",
    ],
    correctIndex: 1,
    explanation:
        "Alex nu poate alege nici programarea, nici fotografia, deci alege debate. Bianca nu poate alege fotografia, iar debate este deja ocupat, deci alege programarea. Cezar rămâne cu fotografia.",
  ),
  AptitudeItem(
    id: 6,
    category: AptitudeCategory.logic,
    title: "Regulă condițională",
    prompt:
        "Pe masă sunt patru carduri: A | D | 4 | 7. Fiecare card are o literă pe o parte și un număr pe cealaltă. Regula este: „Dacă pe o parte este o vocală, pe cealaltă parte trebuie să fie un număr par.” Ce carduri trebuie întoarse pentru a verifica regula?",
    options: ["Doar A", "A și 4", "A și 7", "A, 4 și 7"],
    correctIndex: 2,
    explanation:
        "Trebuie verificat cardul A, deoarece o vocală trebuie să aibă pe verso un număr par. Trebuie verificat și 7, deoarece dacă pe verso ar fi o vocală, regula ar fi încălcată. Cardul 4 nu trebuie verificat: regula nu spune că orice număr par trebuie să aibă o vocală.",
  ),

  // ---- Raționament verbal ------------------------------------------------
  AptitudeItem(
    id: 7,
    category: AptitudeCategory.verbal,
    title: "Analogie",
    prompt: "CARTE : CITIT :: HARTĂ : ?",
    options: ["desenat", "orientat", "împăturit", "colorat"],
    correctIndex: 1,
    explanation: "Cartea este folosită pentru citit, iar harta este folosită pentru orientare. Relația corectă este obiect → utilizare principală.",
  ),
  AptitudeItem(
    id: 8,
    category: AptitudeCategory.verbal,
    title: "Înțelegerea sensului",
    prompt:
        "„Deși colegii lui erau convinși că proiectul va eșua, Vlad a continuat să lucreze, fără să se lase descurajat.” Care variantă descrie cel mai bine situația?",
    options: [
      "Vlad nu știa ce credeau colegii.",
      "Vlad a schimbat proiectul.",
      "Vlad a continuat în ciuda părerii colegilor.",
      "Colegii l-au convins să continue.",
    ],
    correctIndex: 2,
    explanation: "Textul spune explicit că Vlad a continuat să lucreze chiar dacă ceilalți credeau că proiectul va eșua.",
  ),
  AptitudeItem(
    id: 9,
    category: AptitudeCategory.verbal,
    title: "Deducție verbală",
    prompt: "Toate obiectele numite „raveni” sunt ușoare. Niciun obiect ușor nu este făcut din fier. Ce este în mod necesar adevărat?",
    options: [
      "Niciun raven nu este făcut din fier.",
      "Toate obiectele din fier sunt raveni.",
      "Unii raveni sunt făcuți din fier.",
      "Toate obiectele ușoare sunt raveni.",
    ],
    correctIndex: 0,
    explanation: "Toți ravenii sunt ușori, iar niciun obiect ușor nu este din fier. Prin urmare, niciun raven nu poate fi făcut din fier.",
  ),
  AptitudeItem(
    id: 10,
    category: AptitudeCategory.verbal,
    title: "Ordonare verbală",
    prompt:
        "Trei prezentări — Istorie, Știință și Artă — au loc una după alta. Știința nu este prima. Arta este după Istorie. Știința este după Artă. Care este ordinea corectă?",
    options: [
      "Istorie – Artă – Știință",
      "Artă – Istorie – Știință",
      "Istorie – Știință – Artă",
      "Știință – Istorie – Artă",
    ],
    correctIndex: 0,
    explanation: "Arta trebuie să fie după Istorie, iar Știința după Artă. Rezultă ordinea Istorie – Artă – Știință.",
  ),
  AptitudeItem(
    id: 11,
    category: AptitudeCategory.verbal,
    title: "Condițional",
    prompt:
        "Dacă un elev participă la atelierul de teatru, atunci participă la cel puțin o activitate artistică. Unii elevi care participă la activități artistice participă și la debate. Matei participă la atelierul de teatru. Ce știm cu siguranță?",
    options: [
      "Matei participă la debate.",
      "Matei participă la cel puțin o activitate artistică.",
      "Matei participă la toate activitățile artistice.",
      "Matei nu participă la debate.",
    ],
    correctIndex: 1,
    explanation:
        "Participarea la atelierul de teatru implică sigur participarea la cel puțin o activitate artistică. Informația despre debate nu permite o concluzie sigură despre Matei.",
  ),
  AptitudeItem(
    id: 12,
    category: AptitudeCategory.verbal,
    title: "Concluzie necesară",
    prompt:
        "La un concurs, participanții pot intra în etapa finală numai dacă au trecut proba scrisă. Toți cei care au obținut peste 80 de puncte la proba scrisă au trecut proba. Mara a intrat în etapa finală. Vlad a obținut 86 de puncte la proba scrisă. Ce este sigur despre Mara?",
    options: [
      "Mara a obținut peste 80 de puncte.",
      "Mara a obținut mai mult decât Vlad.",
      "Mara a trecut proba scrisă.",
      "Mara a câștigat concursul.",
    ],
    correctIndex: 2,
    explanation: "Pentru a intra în etapa finală era necesar să fi trecut proba scrisă. Deoarece Mara a intrat în finală, știm sigur că a trecut proba scrisă.",
  ),

  // ---- Raționament numeric -----------------------------------------------
  AptitudeItem(
    id: 13,
    category: AptitudeCategory.numeric,
    title: "Relații numerice",
    prompt:
        "În trei cutii sunt în total 38 de bile. Cutia B are de două ori mai multe bile decât cutia A. Cutia C are cu 6 bile mai mult decât cutia A. Câte bile sunt în cutia B?",
    options: ["8", "14", "16", "20"],
    correctIndex: 2,
    explanation: "Dacă A=x, atunci B=2x și C=x+6. x+2x+x+6=38, deci 4x=32 și x=8. Cutia B are 2×8=16 bile.",
  ),
  AptitudeItem(
    id: 14,
    category: AptitudeCategory.numeric,
    title: "Proporție",
    prompt: "Pentru 4 porții sunt necesare 6 mere. Păstrând aceeași proporție, câte mere sunt necesare pentru 10 porții?",
    options: ["12", "15", "16", "18"],
    correctIndex: 1,
    explanation: "6 mere pentru 4 porții înseamnă 1,5 mere pentru o porție. Pentru 10 porții: 10×1,5=15.",
  ),
  AptitudeItem(
    id: 15,
    category: AptitudeCategory.numeric,
    title: "Compararea prețurilor",
    prompt: "Pachetul A: 3 caiete costă 18 lei. Pachetul B: 5 caiete costă 25 lei. Cu cât este mai ieftin un caiet din pachetul B față de unul din pachetul A?",
    options: ["1 leu", "2 lei", "3 lei", "5 lei"],
    correctIndex: 0,
    explanation: "În pachetul A, un caiet costă 18÷3=6 lei. În pachetul B, un caiet costă 25÷5=5 lei. Diferența este 1 leu.",
  ),
  AptitudeItem(
    id: 16,
    category: AptitudeCategory.numeric,
    title: "Comparație cantitativă",
    prompt: "Ana are 18. Bogdan are 24. Carla are cu 6 mai puțin decât Bogdan. Dan are cu 4 mai mult decât Ana. Care afirmație este corectă?",
    options: [
      "Bogdan și Dan au aceeași valoare.",
      "Carla și Ana au aceeași valoare.",
      "Dan și Carla au aceeași valoare.",
      "Ana are cea mai mare valoare.",
    ],
    correctIndex: 1,
    explanation: "Carla are 24−6=18, exact cât Ana. Dan are 18+4=22. Prin urmare, Carla și Ana au aceeași valoare.",
  ),
  AptitudeItem(
    id: 17,
    category: AptitudeCategory.numeric,
    title: "Date și ritm",
    prompt:
        "Luni: 30 minute / 12 exerciții; Marți: 45 minute / 15; Miercuri: 20 minute / 8; Joi: 40 minute / 20. În ce zi au fost rezolvate cele mai multe exerciții, în medie, la fiecare 10 minute?",
    options: ["Luni", "Marți", "Miercuri", "Joi"],
    correctIndex: 3,
    explanation: "Calculăm exercițiile la 10 minute: Luni 4; Marți aproximativ 3,33; Miercuri 4; Joi 5. Cea mai mare valoare este joi.",
  ),
  AptitudeItem(
    id: 18,
    category: AptitudeCategory.numeric,
    title: "Scor de concurs",
    prompt:
        "La un concurs se acordă +3 puncte pentru un răspuns corect și −1 punct pentru un răspuns greșit. Sunt 10 întrebări și toate au primit răspuns. Scorul final este 22. Câte răspunsuri au fost corecte?",
    options: ["6", "7", "8", "9"],
    correctIndex: 2,
    explanation: "Dacă x răspunsuri sunt corecte, 10−x sunt greșite. Scorul este 3x−(10−x)=22. Rezultă 4x−10=22, deci 4x=32 și x=8.",
  ),

  // ---- Raționament spațial -----------------------------------------------
  // Every item in this block carries a figure, described as geometry in
  // `spatial_figures.dart` and drawn by the app. Each key was checked
  // against that geometry rather than by eye: the rotation has exactly one
  // valid turn of the shape with its dot, the net gives exactly one cube
  // whose three visible faces are not opposites, the bar has exactly one
  // piece whose outline matches the gap, and the structure's height map
  // sums to 80.
  AptitudeItem(
    id: 19,
    category: AptitudeCategory.spatial,
    title: "Rotație 2D",
    prompt: "Care dintre variante arată forma inițială după ce a fost rotită? Forma nu este oglindită. Punctul negru se rotește odată cu forma.",
    promptFigure: rotationPrompt,
    optionFigures: rotationOptions,
    options: ["Varianta A", "Varianta B", "Varianta C", "Varianta D"],
    correctIndex: 3,
    explanation:
        "Forma trebuie rotită ca un întreg. Poziția fiecărei părți rămâne aceeași față de celelalte, inclusiv poziția punctului negru. Varianta D este singura care arată aceeași formă după rotire, fără să o transforme într-o imagine în oglindă.",
  ),
  AptitudeItem(
    id: 20,
    category: AptitudeCategory.spatial,
    title: "Piesa lipsă",
    prompt: "Care piesă completează corect modelul? Observă poziția celor două forme în fiecare zonă și alege piesa lipsă.",
    promptFigure: missingPiecePrompt,
    optionFigures: missingPieceOptions,
    options: ["Varianta A", "Varianta B", "Varianta C", "Varianta D"],
    correctIndex: 3,
    explanation:
        "În fiecare pătrat, triunghiul și cercul se află în colțuri opuse. Triunghiul își schimbă poziția de la stânga la dreapta, apoi de sus în jos. În pătratul lipsă, triunghiul trebuie să fie în colțul din dreapta-jos, iar cercul în colțul din stânga-sus. Aceasta este varianta D.",
  ),
  AptitudeItem(
    id: 21,
    category: AptitudeCategory.spatial,
    title: "Împăturirea hârtiei",
    prompt: "Urmărește împăturirea și perforarea foii. Care variantă arată corect foaia după desfacerea completă?",
    promptFigure: foldPrompt,
    optionFigures: foldOptions,
    options: ["Varianta A", "Varianta B", "Varianta C", "Varianta D"],
    correctIndex: 1,
    explanation:
        "Foaia este împăturită de două ori înainte de perforare. Când desfaci prima împăturire, perforația apare simetric și obții două găuri. Când desfaci și a doua împăturire, acestea se reflectă din nou. Rezultatul final are patru perforații în poziții simetrice, ca în varianta B.",
  ),
  AptitudeItem(
    id: 22,
    category: AptitudeCategory.spatial,
    title: "Cub desfășurat",
    prompt: "Care dintre aceste cuburi poate fi obținut prin împăturirea modelului? Alege varianta în care fețele pot ajunge una lângă alta exact ca în model.",
    promptFigure: cubeNetPrompt,
    optionFigures: cubeOptions,
    options: ["Varianta A", "Varianta B", "Varianta C", "Varianta D"],
    correctIndex: 3,
    explanation:
        "Când plasa este împăturită, unele fețe ajung față în față și nu pot fi alăturate pe același colț al cubului. În acest model, steaua este opusă cercului, triunghiul este opus pătratului, iar rombul este opus semnului plus. Variantele A, B și C pun alături câte două fețe care ar trebui să fie opuse. Doar varianta D este posibilă.",
  ),
  AptitudeItem(
    id: 23,
    category: AptitudeCategory.spatial,
    title: "Structura din cuburi",
    prompt: "Din câte cuburi mici este construită structura? Structura este formată din cuburi mici identice, iar unele dintre ele nu se văd direct.",
    promptFigure: cubeStructureFigure,
    options: ["76", "78", "80", "82"],
    correctIndex: 2,
    explanation:
        "Imaginează-ți mai întâi structura ca pe un bloc complet. Un rând are 5 × 4 = 20 de cuburi, iar cele 5 rânduri ar forma în total 100 de cuburi. Din bloc lipsesc 4 × 3 = 12 cuburi, apoi 3 × 2 = 6 cuburi, apoi încă 2 cuburi. În total lipsesc 20. 100 − 20 = 80.",
  ),
  AptitudeItem(
    id: 24,
    category: AptitudeCategory.spatial,
    title: "Completarea barei",
    prompt: "Care piesă completează corect bara? Piesa poate fi rotită, dar nu poate fi întoarsă în oglindă.",
    promptFigure: barPrompt,
    optionFigures: barPieceOptions,
    options: ["Varianta A", "Varianta B", "Varianta C", "Varianta D"],
    correctIndex: 2,
    explanation:
        "Piesa trebuie să completeze exact forma lipsă a barei. Ea poate fi rotită, dar nu poate fi transformată în imaginea ei în oglindă. Toate cele patru piese au aceeași suprafață, deci nu mărimea decide, ci conturul: trebuie să coincidă unghiurile, lungimile și poziția vârfului. La A vârful a alunecat în colț, la B este prea sus, iar D este imaginea în oglindă a piesei potrivite, așa că nicio rotire nu o aduce la loc. Doar piesa C se potrivește complet în spațiul liber.",
  ),
];

class AptitudeItemResult {
  const AptitudeItemResult({required this.item, required this.answer, required this.seconds});

  final AptitudeItem item;

  /// The option the user picked, 0-3, or null if they never answered.
  final int? answer;

  /// Seconds spent on this item. Pilot analysis only — it never affects
  /// the score.
  final int seconds;

  AptitudeItemStatus get status {
    if (answer == null) return AptitudeItemStatus.unanswered;
    return answer == item.correctIndex ? AptitudeItemStatus.correct : AptitudeItemStatus.incorrect;
  }

  int get points => status == AptitudeItemStatus.correct ? 1 : 0;
}

/// How the session ended. Recorded because a run that hit the wall is not
/// the same data as one the person finished with time to spare.
enum AptitudeFinish { completedByUser, timeExpired }

class AptitudeResult {
  const AptitudeResult({required this.items, required this.finish, required this.totalSeconds});

  final List<AptitudeItemResult> items;
  final AptitudeFinish finish;

  /// Actual time spent in the session, in seconds.
  final int totalSeconds;

  /// Correct answers in one block, 0-6.
  int scoreOf(AptitudeCategory category) =>
      items.where((r) => r.item.category == category).fold(0, (sum, r) => sum + r.points);

  /// 0-24. Stored for the pilot, never shown: a single number across four
  /// different kinds of task would invite exactly the general-ability
  /// reading this instrument does not support.
  int get totalScore => items.fold(0, (sum, r) => sum + r.points);

  List<AptitudeItemResult> itemsOf(AptitudeCategory category) =>
      [for (final r in items) if (r.item.category == category) r];
}

/// Scores a finished session. [answers] maps an item id to the picked
/// option (0-3); a missing id is an unanswered item. [seconds] maps an
/// item id to the time spent on it.
AptitudeResult scoreAptitudeTest({
  required Map<int, int> answers,
  required Map<int, int> seconds,
  required AptitudeFinish finish,
  required int totalSeconds,
}) {
  return AptitudeResult(
    items: [
      for (final item in aptitudeItems)
        AptitudeItemResult(item: item, answer: answers[item.id], seconds: seconds[item.id] ?? 0),
    ],
    finish: finish,
    totalSeconds: totalSeconds,
  );
}
