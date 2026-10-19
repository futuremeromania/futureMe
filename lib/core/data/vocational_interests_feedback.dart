// The six fixed RIASEC feedback texts, plus the copy for the tie-break
// screen.
//
// These are FutureMe's own texts, reproduced as written. The three highest
// scores select three of the six and they are displayed in full, in the
// order of the code: nothing here is generated, rewritten or summarised by
// a model, and the three lower dimensions get no feedback at all — only
// their scores stay visible.
//
// The occupation examples are illustrative, never recommendations; the
// closing note below says so, and it is shown once after the three texts.

import 'package:futureme/core/data/vocational_interests.dart';

class VocationalInterestsFeedback {
  const VocationalInterestsFeedback({
    required this.headline,
    required this.body,
    required this.examples,
  });

  /// The one-line reading of the interest area.
  final String headline;

  /// What tends to attract the person in this area.
  final String body;

  /// "Ca să-ți faci o idee: ..." — illustrative occupations.
  final String examples;
}

/// Shown once, after the three texts — never after each one.
const String vocationalInterestsClosingNote =
    "Exemplele de ocupații te ajută să înțelegi mai concret fiecare categorie de interese. Nu înseamnă că acestea sunt profesiile pe care ar trebui să le alegi. Direcțiile profesionale vor deveni mai clare după ce punem aceste rezultate alături de celelalte lucruri pe care le descoperim despre tine.";

const Map<VocationalDimension, VocationalInterestsFeedback> vocationalInterestsFeedback = {
  VocationalDimension.realistic: VocationalInterestsFeedback(
    headline: "Îți plac activitățile practice, în care lucrezi direct cu lucruri concrete și poți vedea rezultatul muncii tale.",
    body:
        "Te pot atrage activitățile în care construiești, repari, montezi, folosești unelte, echipamente sau utilaje. În această zonă intră și lucrul cu plante, animale, materiale ori activitățile desfășurate în aer liber. Problemele concrete, care cer o soluție practică, tind să fie mai interesante pentru tine decât activitățile care rămân doar la nivel de teorie.",
    examples:
        "Ca să-ți faci o idee: această categorie poate apărea în ocupații precum inginer, tehnician, electrician, mecanic, tâmplar, specialist în construcții, agricultură sau alte profesii tehnice și practice.",
  ),
  VocationalDimension.investigative: VocationalInterestsFeedback(
    headline: "Îți plac activitățile în care cercetezi, analizezi și încerci să înțelegi de ce sau cum se întâmplă lucrurile.",
    body:
        "Te pot atrage întrebările care cer gândire, observație, căutarea informațiilor, experimente sau rezolvarea unor probleme. Îți poate plăcea să cauți explicații, să descoperi legături între informații și să ajungi singur la o concluzie. Această zonă include interese legate de știință, sănătate, natură, matematică, date sau alte domenii în care analiza și cercetarea au un rol important.",
    examples:
        "Ca să-ți faci o idee: această categorie poate apărea în ocupații precum biolog, medic, veterinar, chimist, cercetător, matematician, specialist în date sau alte profesii bazate pe analiză și investigare.",
  ),
  VocationalDimension.artistic: VocationalInterestsFeedback(
    headline: "Îți plac activitățile în care poți crea, imagina și exprima idei într-un mod personal.",
    body:
        "Te pot atrage scrisul, muzica, imaginea, designul, filmul, spectacolul sau alte forme de expresie creativă. Îți poate plăcea să lucrezi cu idei, forme, imagini, sunete, povești sau concepte și să găsești propriul mod de a le transforma în ceva nou. În astfel de activități există adesea mai mult spațiu pentru originalitate și mai puține reguli rigide despre cum trebuie făcut un lucru.",
    examples:
        "Ca să-ți faci o idee: această categorie poate apărea în ocupații precum scriitor, actor, muzician, designer, regizor, ilustrator, director artistic sau alte profesii în care creația și expresia au un rol important.",
  ),
  VocationalDimension.social: VocationalInterestsFeedback(
    headline: "Îți plac activitățile în care lucrezi cu oamenii și poți contribui la dezvoltarea, sănătatea sau starea lor de bine.",
    body:
        "Te pot atrage situațiile în care ajuți, explici, înveți pe cineva, îngrijești, consiliezi sau oferi sprijin. Îți poate plăcea să vezi că ceea ce faci produce o schimbare concretă în viața altcuiva. În această zonă intră interese legate de educație, sănătate, consiliere, servicii sociale și alte activități în care relația directă cu oamenii este importantă.",
    examples:
        "Ca să-ți faci o idee: această categorie poate apărea în ocupații precum profesor, consilier, psiholog, asistent social, asistent medical sau alte profesii centrate pe educație, îngrijire, sprijin și dezvoltarea oamenilor.",
  ),
  VocationalDimension.enterprising: VocationalInterestsFeedback(
    headline: "Îți plac activitățile în care iei inițiativa, conduci, convingi, negociezi sau mobilizezi oameni în jurul unui obiectiv.",
    body:
        "Te pot atrage situațiile în care trebuie să iei decizii, să coordonezi oameni sau proiecte, să prezinți o idee, să vinzi, să negociezi ori să urmărești obținerea unui rezultat. Îți poate plăcea să pornești lucruri, să ai influență asupra modului în care evoluează și să transformi o idee într-un proiect concret. În această zonă intră interese legate de management, business, marketing, vânzări și vorbit în public.",
    examples:
        "Ca să-ți faci o idee: această categorie poate apărea în ocupații precum antreprenor, manager, specialist în vânzări, specialist în marketing sau alte roluri în care inițiativa, coordonarea, negocierea și influența au un rol important.",
  ),
  VocationalDimension.conventional: VocationalInterestsFeedback(
    headline: "Îți plac activitățile organizate, în care informațiile, datele și lucrurile trebuie gestionate atent și puse în ordine.",
    body:
        "Te pot atrage sarcinile care presupun calcule, evidențe, documente, verificări, baze de date, organizarea informațiilor sau respectarea unor pași și proceduri clare. Îți poate plăcea să lucrezi într-un sistem bine organizat, în care există reguli clare și contează precizia și atenția la detalii. În această zonă intră interese legate de finanțe, contabilitate, tehnologia informației și activități administrative.",
    examples:
        "Ca să-ți faci o idee: această categorie poate apărea în ocupații precum contabil, specialist financiar, inspector, specialist administrativ sau alte roluri în care organizarea, precizia și lucrul sistematic cu informațiile sunt importante.",
  ),
};

// ---------------------------------------------------------------------------
// Tie-break screen
// ---------------------------------------------------------------------------

const String vocationalTieBreakTitle = "Două zone au obținut același scor.";
const String vocationalTieBreakQuestion = "Care dintre aceste tipuri de activități simți că te atrage mai mult?";
const String vocationalTieBreakHint = "Alege varianta care simți că te reprezintă mai bine acum.";
const String vocationalTieBreakNote =
    "Alegerea ta stabilește doar ordinea profilului. Scorurile obținute rămân neschimbate.";

/// The two or three representative activities shown for a tied dimension.
///
/// The specification spells these out for Antreprenorial and Investigativ;
/// the other four are written here in the same shape, drawn from each
/// dimension's own feedback text above, so the wording stays FutureMe's.
const Map<VocationalDimension, String> vocationalTieBreakActivities = {
  VocationalDimension.realistic: "Să construiești · să repari · să lucrezi cu unelte și echipamente",
  VocationalDimension.investigative: "Să cercetezi · să faci experimente · să cauți explicații și soluții",
  VocationalDimension.artistic: "Să creezi · să imaginezi · să exprimi idei în felul tău",
  VocationalDimension.social: "Să ajuți · să explici · să sprijini oamenii din jur",
  VocationalDimension.enterprising: "Să pornești un proiect sau o afacere · să negociezi · să promovezi o idee",
  VocationalDimension.conventional: "Să organizezi · să ții evidențe · să lucrezi ordonat cu date și documente",
};

VocationalInterestsFeedback vocationalFeedbackFor(VocationalDimension dimension) =>
    vocationalInterestsFeedback[dimension]!;
