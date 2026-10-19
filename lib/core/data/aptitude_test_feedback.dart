import 'aptitude_test.dart';

/// Fixed FutureMe copy for the aptitude stage. Nothing here is generated,
/// and nothing here interprets: each line says how many of six exercises
/// the person solved and what those six asked of them. No labels, no
/// bands, no "this is a strength of yours" — six items cannot carry that,
/// and the pilot has no norms to lean on anyway.
const String aptitudeFeedbackVersion = "aptitudes-feedback-ro-v1";

const Map<AptitudeCategory, String> aptitudeCategoryDescriptions = {
  AptitudeCategory.logic: "probleme în care trebuia să descoperi reguli, relații și concluzii logice",
  AptitudeCategory.verbal: "probleme în care trebuia să înțelegi sensul informațiilor, relațiile dintre idei și concluziile care pot fi desprinse dintr-un text",
  AptitudeCategory.numeric: "probleme în care trebuia să folosești numere, proporții și informații cantitative pentru a ajunge la o soluție",
  AptitudeCategory.spatial: "probleme în care trebuia să îți imaginezi cum se rotesc, se pliază, se combină sau se organizează formele în spațiu",
};

/// The per-block line, e.g. "Ai rezolvat 5 dintre cele 6 probleme în care…".
String aptitudeCategorySentence(AptitudeCategory category, int score) =>
    "Ai rezolvat $score dintre cele $aptitudeItemsPerCategory ${aptitudeCategoryDescriptions[category]!}.";

const int aptitudeItemsPerCategory = 6;

String aptitudeScoreLine(int score) => "$score din $aptitudeItemsPerCategory răspunsuri corecte";

// ---------------------------------------------------------------------------
// Fixed screen copy.
// ---------------------------------------------------------------------------

const String aptitudeStageTitle = "Aptitudinile tale";

const String aptitudeIntroDescription =
    "În această etapă nu mai răspunzi la întrebări despre tine. Vei rezolva câteva exerciții scurte care ne ajută să vedem cum te descurci cu diferite tipuri de probleme.";
const List<String> aptitudeIntroSteps = [
  "Vei întâlni exerciții de logică, limbaj, numere și orientare spațială.",
  "Pentru fiecare exercițiu vei avea mai multe variante de răspuns.",
  "Unele ți se vor părea mai ușoare, altele mai dificile — este normal.",
];
const String aptitudeIntroNote =
    "Nu trebuie să fii bun(ă) la toate. Important este să încerci fiecare exercițiu și să alegi răspunsul pe care îl consideri corect.";

const String aptitudeRulesHeading = "Înainte să începi";
const String aptitudeRulesLead = "Vei rezolva 24 de exerciții: 6 de raționament logic, 6 verbal, 6 numeric și 6 spațial.";

class AptitudeRule {
  const AptitudeRule({required this.title, required this.description});

  final String title;
  final String description;
}

const List<AptitudeRule> aptitudeRules = [
  AptitudeRule(
    title: "Timp total: 30 de minute",
    description: "Ai 30 de minute pentru toate cele 24 de exerciții. Timpul rămas va fi afișat pe ecran.",
  ),
  AptitudeRule(
    title: "O singură sesiune",
    description: "După ce începi, etapa nu poate fi pusă pe pauză și continuată mai târziu.",
  ),
  AptitudeRule(
    title: "Poți reveni la exerciții",
    description: "Poți trece peste un exercițiu și poți reveni la el cât timp mai ai timp.",
  ),
  AptitudeRule(
    title: "Pregătește o foaie și un pix",
    description: "Le poți folosi pentru notițe și calcule.",
  ),
  AptitudeRule(
    title: "Fără calculator",
    description: "Nu folosi calculatorul sau alte aplicații ori instrumente de calcul.",
  ),
  AptitudeRule(
    title: "La 30 de minute, proba se oprește automat",
    description: "Nu vei mai putea completa sau modifica răspunsurile. Exercițiile la care nu ai răspuns vor rămâne fără răspuns.",
  ),
];

const String aptitudeStartButton = "Sunt pregătit(ă) · Începe testul";

const String aptitudeResultHeading = "Ai terminat toate exercițiile.";
const String aptitudeResultText =
    "Exercițiile au urmărit patru tipuri diferite de probleme. Rezultatele de mai jos arată cum te-ai descurcat în exercițiile FutureMe pe care tocmai le-ai rezolvat.";
const String aptitudeResultClosingOne =
    "Fiecare tip de exercițiu surprinde un mod diferit de a rezolva probleme, iar în raport ne interesează cum se combină aceste rezultate cu restul profilului tău.";
const String aptitudeResultClosingTwo =
    "Un rezultat nu spune singur ce carieră ți se potrivește. În raportul tău, vom pune aceste rezultate alături de interesele tale, felul în care gândești, punctele tale forte și celelalte lucruri pe care le-am descoperit despre tine.";
const String aptitudeReviewButton = "Vezi exercițiile și răspunsurile";

const String aptitudeReviewHeading = "Exercițiile și răspunsurile";
const String aptitudeReviewYourAnswer = "Răspunsul tău";
const String aptitudeReviewCorrectAnswer = "Răspunsul corect";
const String aptitudeReviewHowTo = "Cum se rezolvă";
const String aptitudeReviewNoAnswer = "Fără răspuns";

const String aptitudeTimeUpHeading = "S-au terminat cele 30 de minute";
const String aptitudeTimeUpText =
    "Proba s-a oprit automat. Exercițiile la care nu ai apucat să răspunzi rămân fără răspuns. Hai să vedem cum te-ai descurcat.";
