// The fixed decision-style feedback library — 5 individual texts per style
// (one per score 0-4), 10 combination texts, a "profil multiplu" text and a
// "nicio strategie predominantă" text, plus the display-selection rules.
//
// These are the counsellor's own texts, reproduced as written. The score
// selects which entries are shown; nothing here is generated, rewritten,
// summarised or combined by a model.

import 'package:futureme/core/data/decision_style.dart';

/// The generic 0-4 score label, reused across every style (section 5 of the
/// spec): the heading shown above a style's body text.
const Map<int, String> decisionStyleScoreLabels = {
  0: "Nu este o strategie pe care o folosești frecvent",
  1: "Apare ocazional",
  2: "Este prezent în modul tău de a decide",
  3: "Este o strategie importantă pentru tine",
  4: "Este o strategie foarte prezentă",
};

/// The 25 fixed body texts (5 styles × 5 scores).
const Map<DecisionStyle, Map<int, String>> decisionStyleFeedbackBodies = {
  DecisionStyle.rational: {
    0: "Nu ai indicat niciuna dintre modalitățile de analiză rațională descrise aici. Asta nu înseamnă că nu ești rațional(ă), ci că, atunci când iei decizii, alte strategii par să apară mai natural.",
    1: "Folosești uneori analiza, verificarea informațiilor sau compararea variantelor, dar acestea nu par să aibă un rol important în majoritatea deciziilor tale.",
    2: "Analiza contează în deciziile tale, dar nu este singurul mod pe care te bazezi. Celelalte rezultate ne vor arăta cu ce alte strategii o combini.",
    3: "Ai tendința să analizezi informațiile, alternativele și consecințele înainte să alegi. Deciziile bine argumentate îți pot oferi mai multă siguranță.",
    4: "Te regăsești în toate cele patru comportamente asociate acestui stil. Analiza, verificarea informațiilor și cântărirea alternativelor au un rol foarte important în felul în care alegi.",
  },
  DecisionStyle.dependent: {
    0: "Nu pari să ai nevoie în mod obișnuit de sprijinul sau confirmarea celorlalți pentru a lua o decizie.",
    1: "Uneori iei în considerare sfatul sau sprijinul altora, dar acestea nu par să aibă un rol important în majoritatea deciziilor tale.",
    2: "Opinia și sprijinul celorlalți contează pentru tine în anumite situații. Important este să observi dacă le folosești ca sursă de informație sau dacă îți este dificil să alegi fără ele.",
    3: "Ai tendința să cauți sfatul, sprijinul sau îndrumarea altora înaintea unei decizii importante. Asta îți poate oferi perspective utile, dar merită să observi dacă uneori încrederea în propria alegere ajunge să depindă prea mult de confirmarea lor.",
    4: "Te regăsești în toate cele patru comportamente asociate acestui stil. Sprijinul și opiniile celorlalți au un rol foarte important în felul în care alegi. Merită să păstrezi avantajul consultării, fără să transferi altora responsabilitatea pentru decizia ta.",
  },
  DecisionStyle.avoidant: {
    0: "Nu pari să ai tendința de a amâna sau evita deciziile. Atunci când trebuie să alegi, alte strategii par să aibă un rol mai important.",
    1: "Uneori poți amâna o decizie, mai ales când este dificilă sau importantă, dar evitarea nu pare să fie o reacție obișnuită pentru tine.",
    2: "În anumite situații, ai tendința să amâni alegerea sau să ai nevoie de mai mult timp înainte să decizi. Merită să observi ce tip de decizii declanșează această reacție.",
    3: "Când o alegere devine dificilă, incertă sau apăsătoare, ai tendința să o amâni. Timpul suplimentar poate fi util dacă îl folosești pentru clarificare, dar poate deveni o problemă atunci când amânarea nu mai aduce informații noi.",
    4: "Te regăsești în toate cele patru comportamente asociate acestui stil. Deciziile importante pot deveni suficient de apăsătoare încât să le amâni cât mai mult. Pentru tine, un pas important poate fi să separi timpul de care ai nevoie ca să gândești de timpul în care doar amâni alegerea.",
  },
  DecisionStyle.intuitive: {
    0: "Nu pari să te bazezi în mod obișnuit pe intuiție, instinct sau pe ceea ce „simți” atunci când iei o decizie. Alte strategii par să cântărească mai mult.",
    1: "Uneori îți asculți instinctul sau reacția inițială, dar intuiția nu pare să fie unul dintre principalele repere după care alegi.",
    2: "Intuiția are un loc în deciziile tale, dar nu te bazezi exclusiv pe ea. În anumite situații, ceea ce simți că este potrivit poate conta alături de informații sau argumente.",
    3: "Ai tendința să ai încredere în instinct, impresii și reacțiile tale atunci când alegi. Intuiția te poate ajuta să ajungi repede la o direcție, mai ales în situații pe care le cunoști bine. Pentru deciziile importante, merită să verifici și ce informații susțin prima ta impresie.",
    4: "Te regăsești în toate cele patru comportamente asociate acestui stil. Ceea ce simți și reacția ta intuitivă au un rol foarte important în alegerile tale. Intuiția poate fi o resursă, dar pentru deciziile cu miză mare este util să o pui alături de informații și alternative înainte să alegi.",
  },
  DecisionStyle.spontaneous: {
    0: "Nu pari să iei în mod obișnuit decizii foarte repede sau sub impulsul momentului. Probabil ai nevoie de un alt tip de proces înainte să alegi.",
    1: "Uneori decizi repede, mai ales când situația este simplă sau nu simți nevoia unei analize mai lungi, dar spontaneitatea nu pare să îți definească modul obișnuit de a alege.",
    2: "Poți lua unele decizii rapid, fără să simți nevoia să analizezi fiecare variantă în detaliu. În alte situații folosești probabil strategii diferite.",
    3: "Ai tendința să alegi repede și să treci relativ ușor de la gând la acțiune. Asta te poate ajuta atunci când situația cere viteză. Când miza este mare sau consecințele sunt greu de schimbat, merită să introduci o scurtă pauză înainte de decizia finală.",
    4: "Te regăsești în toate cele patru comportamente asociate acestui stil. Rapiditatea și reacția de moment au un rol important în felul în care alegi. Poate fi un avantaj când este nevoie de acțiune rapidă, dar pentru deciziile importante merită să verifici dacă viteza te ajută sau te face să sari peste informații relevante.",
  },
};

class DecisionStyleCombo {
  const DecisionStyleCombo({
    required this.styleA,
    required this.styleB,
    required this.body,
    required this.question,
  });

  final DecisionStyle styleA;
  final DecisionStyle styleB;

  /// "Cum funcționează împreună".
  final String body;

  /// "Întrebarea care te poate ajuta".
  final String question;
}

/// All 10 unordered pairs of the 5 styles.
const List<DecisionStyleCombo> decisionStyleCombos = [
  DecisionStyleCombo(
    styleA: DecisionStyle.rational,
    styleB: DecisionStyle.dependent,
    body:
        "Ai tendința să analizezi informațiile înainte să alegi, dar contează pentru tine și perspectiva celorlalți. Nu te bazezi doar pe ce știi tu: cauți confirmări, sfaturi sau alte puncte de vedere.\n\nCombinația poate fi foarte utilă atunci când o decizie are nevoie atât de analiză, cât și de informații pe care nu le deții. Devine mai puțin utilă dacă, după ce ai analizat suficient, simți că tot nu poți decide fără aprobarea cuiva.",
    question: "Mai am nevoie de o informație sau am nevoie ca cineva să-mi confirme alegerea?",
  ),
  DecisionStyleCombo(
    styleA: DecisionStyle.rational,
    styleB: DecisionStyle.avoidant,
    body:
        "Ai tendința să analizezi atent înainte să alegi. În același timp, când decizia devine dificilă sau importantă, există tendința de a o amâna.\n\nAnaliza îți poate oferi claritate. Dar există un punct în care informațiile suplimentare nu mai schimbă semnificativ alegerea. Dacă continui să cauți, să compari sau să aștepți după acel moment, analiza poate deveni o formă de amânare.",
    question: "Mai am nevoie de informații sau știu deja suficient cât să aleg?",
  ),
  DecisionStyleCombo(
    styleA: DecisionStyle.rational,
    styleB: DecisionStyle.intuitive,
    body:
        "În deciziile tale apar două surse importante: ceea ce îți arată informațiile și ceea ce simți că este potrivit pentru tine.\n\nNu trebuie să alegi între logică și intuiție. Uneori, analiza te ajută să vezi ce are sens, iar intuiția îți arată ce variantă simți că ți se potrivește. Când cele două indică aceeași direcție, alegerea poate deveni mult mai clară. Când se contrazic, merită să afli de ce.",
    question: "Ce îmi spun informațiile și ce anume mă face să simt altceva?",
  ),
  DecisionStyleCombo(
    styleA: DecisionStyle.rational,
    styleB: DecisionStyle.spontaneous,
    body:
        "Ai capacitatea de a analiza, dar și tendința de a decide repede. În funcție de situație, poți trece de la evaluarea atentă a variantelor la acțiune rapidă.\n\nAsta poate însemna flexibilitate: nu toate deciziile merită aceeași cantitate de timp. Important este să alegi conștient când merită să încetinești. O decizie ușor reversibilă poate fi luată repede. Una cu efecte importante pe termen lung merită mai multă analiză.",
    question: "Decizia aceasta are nevoie de viteză sau de încă puțin timp?",
  ),
  DecisionStyleCombo(
    styleA: DecisionStyle.dependent,
    styleB: DecisionStyle.avoidant,
    body:
        "Când trebuie să iei o decizie dificilă, ai tendința să cauți sprijinul celorlalți, dar și să amâni alegerea.\n\nUneori, consultarea te ajută să vezi lucrurile mai clar. Alteori, prea multe opinii pot face alegerea și mai dificilă. Poți ajunge să aștepți ca altcineva să îți ofere certitudinea pe care nicio decizie importantă nu o poate garanta complet.",
    question: "Ce aș alege dacă nimeni nu mi-ar spune ce ar trebui să fac?",
  ),
  DecisionStyleCombo(
    styleA: DecisionStyle.dependent,
    styleB: DecisionStyle.intuitive,
    body:
        "În alegerile tale contează atât ceea ce simți tu, cât și ceea ce spun oamenii în care ai încredere.\n\nAsta îți oferă două perspective. Dificultatea apare atunci când instinctul tău spune ceva, iar oamenii importanți pentru tine spun altceva. În astfel de momente, este util să asculți opiniile lor fără să pierzi din vedere faptul că decizia îți aparține.",
    question: "Ce simt eu că mi se potrivește, înainte să aflu ce ar alege ceilalți?",
  ),
  DecisionStyleCombo(
    styleA: DecisionStyle.dependent,
    styleB: DecisionStyle.spontaneous,
    body:
        "Ai tendința să iei unele decizii repede, dar opiniile sau reacțiile celorlalți pot cântări mult în alegerea ta.\n\nAsta poate fi util când ai nevoie rapid de o perspectivă din exterior. Dar viteza combinată cu influența celorlalți poate face ca uneori să alegi înainte să verifici suficient ce vrei tu.",
    question: "Aleg asta pentru că mi se potrivește mie sau pentru că m-a convins repede cineva?",
  ),
  DecisionStyleCombo(
    styleA: DecisionStyle.avoidant,
    styleB: DecisionStyle.intuitive,
    body:
        "Intuiția îți poate indica destul de repede o direcție, dar asta nu înseamnă neapărat că îți este ușor să transformi senzația într-o decizie.\n\nPoți simți ce ai vrea să alegi și, totuși, să amâni momentul în care îți asumi alegerea. În astfel de situații, poate fi util să verifici intuiția prin câteva informații concrete, apoi să stabilești un moment în care vei decide.",
    question: "Ce anume mă împiedică să aleg, dacă în interiorul meu am deja o direcție?",
  ),
  DecisionStyleCombo(
    styleA: DecisionStyle.avoidant,
    styleB: DecisionStyle.spontaneous,
    body:
        "La prima vedere, aceste două tendințe par opuse: uneori amâni decizia, alteori o iei foarte repede. Tocmai combinația lor poate spune ceva important despre felul în care reacționezi la presiunea alegerii.\n\nEste posibil să amâni cât timp decizia te apasă, apoi să alegi rapid atunci când nu mai poți evita momentul. În acest caz, problema nu este neapărat lipsa capacității de a decide, ci momentul în care începi să te ocupi efectiv de alegere.",
    question: "Pot să încep să mă ocup de această decizie înainte să devină urgentă?",
  ),
  DecisionStyleCombo(
    styleA: DecisionStyle.intuitive,
    styleB: DecisionStyle.spontaneous,
    body:
        "Ai tendința să simți repede ce ți se pare potrivit și să transformi relativ repede acea impresie într-o alegere.\n\nAsta poate fi un avantaj în situațiile care cer reacție rapidă. Pentru deciziile importante, însă, prima impresie merită uneori verificată înainte să devină decizie finală. Nu pentru a-ți ignora instinctul, ci pentru a vedea dacă informațiile îl susțin.",
    question: "Ce informație ar trebui să verific înainte să merg mai departe cu ceea ce simt acum?",
  ),
];

DecisionStyleCombo? decisionStyleComboFor(DecisionStyle a, DecisionStyle b) {
  for (final combo in decisionStyleCombos) {
    if ((combo.styleA == a && combo.styleB == b) || (combo.styleA == b && combo.styleB == a)) {
      return combo;
    }
  }
  return null;
}

const String decisionStyleMultipleProfileTitle = "Folosești mai multe strategii atunci când iei decizii";
const String decisionStyleMultipleProfileBody =
    "Rezultatele tale arată că nu te bazezi pe un singur mod de a alege. Ai la dispoziție mai multe strategii, iar cea pe care o folosești poate depinde de situație, de cât de importantă este decizia sau de presiunea pe care o simți.\n\n"
    "Asta poate fi un avantaj: înseamnă că nu reacționezi la toate alegerile în același fel. Poți analiza într-o situație, îți poți asculta intuiția în alta, poți cere sprijin sau poți decide repede atunci când contextul o cere.\n\n"
    "În același timp, unele dintre aceste strategii pot intra în conflict. Poți, de exemplu, să analizezi foarte mult și totuși să amâni alegerea. Poți simți rapid ce îți dorești, dar să cauți confirmarea celorlalți înainte să decizi. Tocmai de aceea, pentru tine este important să observi ce strategie apare în ce situație și dacă te ajută în acel moment.\n\n"
    "Stilurile tale cu scor 4/4 sunt cele mai prezente. Cele cu 3/4 au și ele un rol important în felul în care alegi. Privește-le împreună: ele descriu mai bine modul tău de a lua decizii decât ar putea să o facă o singură etichetă.";
const String decisionStyleMultipleProfileQuestion =
    "Când am de luat o decizie importantă, care dintre aceste strategii apare prima și care apare atunci când încep să mă îndoiesc?";

const String decisionStyleNoDominantTitle = "Nu apare un singur mod dominant de a lua decizii";
const String decisionStyleNoDominantBody =
    "Rezultatele tale arată că nu te regăsești puternic în niciuna dintre cele cinci strategii analizate aici. Asta nu înseamnă că nu ai un mod de a decide sau că îți este greu să iei decizii.\n\n"
    "Este posibil ca felul în care alegi să depindă mult de situație. Uneori analizezi, alteori îți urmezi intuiția, ceri părerea cuiva sau decizi repede, fără ca una dintre aceste strategii să apară suficient de constant încât să devină predominantă.\n\n"
    "Mai există o posibilitate: să nu fi observat încă foarte clar cum iei deciziile, mai ales dacă până acum nu ai fost atent(ă) la procesul din spatele alegerilor tale.\n\n"
    "În cazul tău, cel mai util nu este să cauți o etichetă, ci să începi să observi ce faci atunci când ai de luat o decizie care contează cu adevărat pentru tine.";
const String decisionStyleNoDominantQuestion = "La ultima decizie importantă pe care am luat-o, ce am făcut concret înainte să aleg?";

/// Shown once, after all result blocks — never repeated per style.
const String decisionStyleFinalMessageBody =
    "Modul în care iei decizii nu este o problemă de „bine” sau de „rău”. Este o strategie pe care ai construit-o în timp, ca să funcționezi cât mai sigur pentru tine.\n\n"
    "Indiferent dacă ai tendința să analizezi mult înainte de a decide sau, dimpotrivă, să acționezi rapid și intuitiv, stilul decizional nu te limitează.\n\n"
    "Odată ce îl înțelegi, îl poți ajusta conștient, fără să te forțezi să fii „altfel decât ești”. Claritatea nu vine din a schimba cine ești, ci din a învăța cum să lucrezi cu propriul tău mod de a alege.\n\n"
    "Următorii pași din acest program sunt gândiți exact pentru asta: să îți ofere structură, încredere și direcție, astfel încât deciziile tale să devină mai ușoare, nu mai apăsătoare.";

enum DecisionStyleResultType { none, single, pair, multiple }

class DecisionStyleDisplay {
  const DecisionStyleDisplay({required this.relevant, required this.type, this.combo});

  /// Styles with score 3-4, ordered per section 7: 4/4 before 3/4, tied
  /// scores keep the fixed order Rațional, Dependent, Evitant, Intuitiv,
  /// Spontan.
  final List<DecisionStyleDimensionResult> relevant;
  final DecisionStyleResultType type;

  /// Set only when [type] is [DecisionStyleResultType.pair].
  final DecisionStyleCombo? combo;
}

/// Implements the section 7 selection/display rules over a scored result.
DecisionStyleDisplay resolveDecisionStyleDisplay(DecisionStyleResult result) {
  final order = DecisionStyle.values;
  final relevant = result.dimensions.where((d) => d.score >= 3).toList()
    ..sort((a, b) {
      if (a.score != b.score) return b.score.compareTo(a.score);
      return order.indexOf(a.style).compareTo(order.indexOf(b.style));
    });

  if (relevant.isEmpty) {
    return const DecisionStyleDisplay(relevant: [], type: DecisionStyleResultType.none);
  }
  if (relevant.length == 1) {
    return DecisionStyleDisplay(relevant: relevant, type: DecisionStyleResultType.single);
  }
  if (relevant.length == 2) {
    return DecisionStyleDisplay(
      relevant: relevant,
      type: DecisionStyleResultType.pair,
      combo: decisionStyleComboFor(relevant[0].style, relevant[1].style),
    );
  }
  return DecisionStyleDisplay(relevant: relevant, type: DecisionStyleResultType.multiple);
}