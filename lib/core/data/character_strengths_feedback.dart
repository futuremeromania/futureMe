import 'character_strengths.dart';

/// The fixed feedback library for Module 4, Stage 1. One entry per
/// strength, shown whole when that strength lands in the Top 5. Nothing is
/// generated: the ranking decides which five of these ten appear.
class StrengthFeedback {
  const StrengthFeedback({
    required this.headline,
    required this.body,
    required this.howToUseHeading,
    required this.howToUse,
  });

  /// The card's subtitle — a plain-language name for the strength.
  final String headline;

  /// The two explanatory paragraphs, in order.
  final List<String> body;

  /// "Cum o poți folosi" for nine of them, "Cum îl poți folosi" for
  /// leadership, whose Romanian noun is masculine.
  final String howToUseHeading;

  final String howToUse;
}

const String strengthsFeedbackVersion = "strengths-ro-v1";

const Map<StrengthDimension, StrengthFeedback> strengthsFeedback = {
  StrengthDimension.curiosity: StrengthFeedback(
    headline: "Vrei să afli mai mult",
    body: [
      "Când ceva îți atrage atenția, ai tendința să explorezi. Îți vin întrebări, cauți explicații și poți ajunge să descoperi lucruri pe care nimeni nu ți le-a cerut.",
      "Curiozitatea te ajută să intri în contact cu idei, experiențe și domenii noi. Uneori, exact așa descoperi ceva care ajunge să te intereseze cu adevărat.",
    ],
    howToUseHeading: "Cum o poți folosi",
    howToUse: "Când ceva îți stârnește interesul, urmărește întrebarea puțin mai departe. Vezi unde te duce.",
  ),
  StrengthDimension.loveOfLearning: StrengthFeedback(
    headline: "Îți place să mergi mai departe cu ceea ce înveți",
    body: [
      "Nu te atrage doar descoperirea unui lucru nou. Atunci când un subiect te interesează, poți simți nevoia să-l înțelegi mai bine, să afli mai mult sau să înveți ceva nou despre el.",
      "Această resursă te poate ajuta să construiești în timp cunoștințe și abilități, nu doar să treci de la o curiozitate la alta.",
    ],
    howToUseHeading: "Cum o poți folosi",
    howToUse: "Când descoperi ceva care te interesează, nu te opri la prima informație. Alege ceva ce ai vrea să înțelegi sau să înveți mai bine.",
  ),
  StrengthDimension.creativity: StrengthFeedback(
    headline: "Vezi și alte variante",
    body: [
      "Ai tendința să cauți mai mult de o soluție și să aduci ceva personal în ceea ce faci. În loc să urmezi automat primul drum, îți poate veni natural să te întrebi dacă există și o altă variantă.",
      "Creativitatea nu apare doar în artă. Poate apărea oriunde găsești o idee, o soluție sau un mod diferit de a face ceva.",
    ],
    howToUseHeading: "Cum o poți folosi",
    howToUse: "Când ai de rezolvat ceva, nu te opri întotdeauna la prima idee. Încearcă să mai găsești una sau două variante.",
  ),
  StrengthDimension.criticalThinking: StrengthFeedback(
    headline: "Nu accepți automat prima explicație",
    body: [
      "Ai tendința să verifici dacă o informație are sens, să cauți argumentele din spatele ei și să nu tragi imediat o concluzie.",
      "Un lucru important: gândirea critică nu înseamnă să contrazici totul. Înseamnă și să poți recunoaște un argument mai bun și să-ți schimbi părerea atunci când informațiile îl susțin.",
    ],
    howToUseHeading: "Cum o poți folosi",
    howToUse: "Când întâlnești o afirmație importantă, întreabă-te: „Ce dovezi o susțin?” și „Există și o altă explicație?”",
  ),
  StrengthDimension.perspective: StrengthFeedback(
    headline: "Vezi imaginea mai largă",
    body: [
      "Ai tendința să privești o situație dincolo de primul lucru care se vede. Poți face legături între informații și poți observa că aceeași situație poate fi privită din mai multe unghiuri.",
      "Uneori, această perspectivă îi poate ajuta și pe ceilalți să vadă ceva ce nu observaseră înainte.",
    ],
    howToUseHeading: "Cum o poți folosi",
    howToUse: "Când o situație pare complicată, încearcă să te întrebi: „Ce alt mod există de a privi lucrurile?” și „Ce legături nu am observat încă?”",
  ),
  StrengthDimension.perseverance: StrengthFeedback(
    headline: "Continui când devine greu",
    body: [
      "Când ceva este important pentru tine, dificultatea nu înseamnă automat că te oprești. Poți continua, încerca o altă cale sau accepta că unele rezultate au nevoie de timp.",
      "Perseverența nu înseamnă să continui orice, indiferent de situație. Înseamnă să poți menține efortul atunci când obiectivul merită pentru tine.",
    ],
    howToUseHeading: "Cum o poți folosi",
    howToUse: "Când întâlnești un obstacol, înainte să renunți, întreabă-te: „Trebuie să mă opresc sau trebuie doar să încerc altfel?”",
  ),
  StrengthDimension.futureOrientation: StrengthFeedback(
    headline: "Vezi un drum între ceea ce îți dorești și ceea ce poți face",
    body: [
      "Când te gândești la viitor, îți poți imagina lucruri pe care ai vrea să le construiești sau să le realizezi. Dacă un plan nu funcționează, poți căuta și alte căi.",
      "Important este că dorința nu rămâne doar o imagine despre viitor. Ai tendința să te gândești și la ce ai putea face pentru a te apropia de el.",
    ],
    howToUseHeading: "Cum o poți folosi",
    howToUse: "Alege ceva ce îți dorești și întreabă-te: „Care este un pas mic pe care îl pot face acum?”",
  ),
  StrengthDimension.socialIntelligence: StrengthFeedback(
    headline: "Observi ce se întâmplă între oameni",
    body: [
      "Ai tendința să observi cum se simt oamenii, cum reacționează și ce se întâmplă într-o situație socială. Îți poți adapta modul de comunicare în funcție de persoană și context.",
      "Asta te poate ajuta să navighezi mai ușor situații în care trebuie să înțelegi nu doar ce spun oamenii, ci și cum reacționează.",
    ],
    howToUseHeading: "Cum o poți folosi",
    howToUse:
        "Păstrează o diferență între ceea ce observi și ceea ce știi sigur. Dacă este important, verifică printr-o întrebare înainte să presupui ce gândește sau simte celălalt.",
  ),
  StrengthDimension.teamwork: StrengthFeedback(
    headline: "Știi să contribui la ceva construit împreună",
    body: [
      "Când lucrezi într-un grup, ai tendința să ții cont și de rezultatul comun, nu doar de partea ta. Îți asumi contribuția de care depind ceilalți și poți recunoaște o idee bună chiar dacă nu este a ta.",
      "A lucra bine într-o echipă nu înseamnă să fii întotdeauna de acord cu ceilalți. Înseamnă să poți contribui la un obiectiv pe care îl construiți împreună.",
    ],
    howToUseHeading: "Cum o poți folosi",
    howToUse: "Când lucrezi într-un grup, întreabă-te: „Ce depinde de mine ca echipa să poată merge mai departe?”",
  ),
  StrengthDimension.leadership: StrengthFeedback(
    headline: "Poți ajuta un grup să se pună în mișcare",
    body: [
      "Când un grup are nevoie de direcție sau organizare, îți poate veni natural să ajuți la clarificarea obiectivului, la împărțirea lucrurilor de făcut sau la aducerea oamenilor în jurul unei idei.",
      "Leadershipul nu înseamnă doar să conduci sau să fii cel care decide. Înseamnă și să ajuți un grup să funcționeze astfel încât oamenii să poată contribui.",
    ],
    howToUseHeading: "Cum îl poți folosi",
    howToUse: "Când coordonezi ceva, nu te întreba doar „Ce trebuie făcut?”, ci și „Cum îi ajut pe ceilalți să poată contribui?”",
  ),
};

StrengthFeedback strengthFeedbackFor(StrengthDimension dimension) => strengthsFeedback[dimension]!;

/// The one-line descriptions shown on the tie-break cards. Deliberately
/// shorter than the feedback: the person is choosing between two names,
/// not reading two results.
const Map<StrengthDimension, String> strengthsTieBreakTexts = {
  StrengthDimension.curiosity: "Îmi vine natural să pun întrebări și să explorez lucruri noi.",
  StrengthDimension.loveOfLearning: "Îmi vine natural să aprofundez lucrurile care mă interesează și să învăț mai mult despre ele.",
  StrengthDimension.creativity: "Îmi vine natural să găsesc idei, soluții sau moduri diferite de a face lucrurile.",
  StrengthDimension.criticalThinking: "Îmi vine natural să caut argumente și să verific dacă o informație are sens înainte să o accept.",
  StrengthDimension.perspective: "Îmi vine natural să văd imaginea de ansamblu, legăturile dintre lucruri și alte moduri de a privi o situație.",
  StrengthDimension.perseverance: "Îmi vine natural să continui sau să caut o altă cale atunci când ceva important devine dificil.",
  StrengthDimension.futureOrientation: "Îmi vine natural să mă gândesc la ce vreau să realizez și la pașii prin care pot ajunge acolo.",
  StrengthDimension.socialIntelligence: "Îmi vine natural să observ ce se întâmplă între oameni și să-mi adaptez felul de a comunica.",
  StrengthDimension.teamwork: "Îmi vine natural să-mi fac partea și să contribui la rezultatul comun al echipei.",
  StrengthDimension.leadership: "Îmi vine natural să ajut un grup să se organizeze și să se adune în jurul unui obiectiv.",
};

// ---------------------------------------------------------------------------
// Fixed screen copy.
// ---------------------------------------------------------------------------

const String strengthsScreenTitle = "Punctele tale forte";
const String strengthsPrompt = "Citește fiecare afirmație și alege cât de adevărată este pentru tine, așa cum ești în general.";
const String strengthsCaption = "Răspunde așa cum te vezi tu acum. Nu există răspunsuri corecte sau greșite.";

const String strengthsTieHeading = "Avem o egalitate";
const String strengthsTiePairText = "Două puncte forte au ieșit la egalitate. Ambele apar în răspunsurile tale.";
const String strengthsTiePairQuestion = "Care simți că te reprezintă mai bine?";
const String strengthsTiePairHint = "Alege una. Nu există un răspuns corect.";
const String strengthsTieManyText = "Mai multe puncte forte au ieșit la egalitate. Toate apar în răspunsurile tale.";

const String strengthsTopHeading = "5 puncte forte care ies în evidență la tine";
const String strengthsTopText =
    "Din răspunsurile tale, acestea sunt resursele care s-au evidențiat cel mai mult. Nu sunt un clasament și nu înseamnă că celelalte îți lipsesc.";
const String strengthsTopClosing =
    "Aceste rezultate arată ce a ieșit mai mult în evidență în răspunsurile tale acum. Nu există puncte forte «mai bune» sau «mai slabe». Important este și în care dintre ele te recunoști tu cel mai mult.";
const String strengthsTopButton = "Alege cele 3 în care te regăsești";

const String strengthsPickHeading = "Te regăsești în ele?";
const String strengthsPickText =
    "Uită-te încă o dată la cele 5 puncte forte care au ieșit în evidență. Alege 3 pe care simți că te bazezi cel mai mult atunci când ai ceva important de făcut. Nu există o alegere corectă. Alege-le pe cele în care te recunoști cel mai mult acum.";

const String strengthsFinalHeading = "Cele 3 puncte forte în care te regăsești cel mai mult";
const String strengthsFinalText = "Tu le-ai ales dintre cele 5 care au ieșit în evidență în răspunsurile tale.";
const String strengthsFinalClosing =
    "Acestea sunt resursele pe care simți că te poți baza cel mai mult acum. Merită să le observi, să le folosești și să le dezvolți. Celelalte puncte forte nu dispar. Folosim resurse diferite în situații diferite, iar unele se pot dezvolta în timp.";
