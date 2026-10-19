// The twelve fixed emotional-patterns feedback texts — three levels for
// each of the four dimensions.
//
// These are FutureMe's own texts, reproduced as written. Each dimension's
// score selects one entry and it is displayed in full, unchanged: nothing
// here is generated, rewritten, summarised or combined by a model, and no
// combination across dimensions is ever produced. The user sees four of
// the twelve, one per dimension, then the closing note once.
//
// No profession or career direction appears here by design — those belong
// to the final report, after every instrument has been integrated.

import 'package:futureme/core/data/emotional_patterns.dart';

class EmotionalPatternsFeedback {
  const EmotionalPatternsFeedback({required this.body, required this.help});

  /// The reading of the result, one or more paragraphs.
  final String body;

  /// "Ce te poate ajuta" — the practical part.
  final String help;
}

/// The heading shown above the practical part of every entry.
const String emotionalHelpHeading = "Ce te poate ajuta";

/// Shown once, after all four dimensions — never after each one.
const String emotionalPatternsClosingNote =
    "Emoțiile tale nu sunt o slăbiciune. Sunt un sistem de semnalizare.\n\n"
    "Când înțelegi ce te afectează și cum reacționezi, îți este mai ușor să alegi ce te ajută să mergi mai departe.\n\n"
    "Nu este vorba să nu simți. Este vorba să înțelegi ce simți și să nu lași un moment dificil să decidă în locul tău.";

const Map<EmotionalDimension, Map<EmotionalLevel, EmotionalPatternsFeedback>> emotionalPatternsFeedback = {
  EmotionalDimension.pressure: {
    EmotionalLevel.low: EmotionalPatternsFeedback(
      body:
          "Presiunea nu pare să îți schimbe foarte mult felul în care funcționezi. Chiar când miza crește, reușești de obicei să te concentrezi, să gândești destul de clar și să te mobilizezi.\n\n"
          "Asta nu înseamnă că nu simți stres. Înseamnă că poți continua să funcționezi chiar și atunci când îl simți.",
      help:
          "Păstrează strategiile care deja funcționează pentru tine. În perioadele foarte solicitante, fii atent(ă) să nu confunzi faptul că reziști bine la presiune cu ideea că trebuie să poți duce oricât.",
    ),
    EmotionalLevel.moderate: EmotionalPatternsFeedback(
      body:
          "În unele situații, presiunea te mobilizează. În altele, începe să îți consume din energie și concentrare. Contează cât de mare este miza, cât timp ai la dispoziție sau cât simți că se așteaptă de la tine.\n\n"
          "Important este să observi momentul în care presiunea încetează să te mobilizeze și începe să te încurce.",
      help:
          "Când simți că tensiunea crește, simplifică. Stabilește ce este important acum, care este primul pas și ce poate aștepta. Mai puține lucruri ținute simultan în minte înseamnă mai mult spațiu pentru ceea ce ai de făcut.",
    ),
    EmotionalLevel.high: EmotionalPatternsFeedback(
      body:
          "Când miza crește, presiunea îți poate consuma o parte importantă din energie. Îți poate fi mai greu să te concentrezi, să gândești clar, să începi sau să arăți ceea ce știi de fapt.\n\n"
          "Asta nu spune cât de capabil(ă) ești. Spune că stresul poate influența accesul la ceea ce știi și poți atunci când contează.",
      help:
          "Nu încerca să gestionezi totul deodată. Clarifică primul pas. Apoi următorul. Când mintea pleacă spre „Dacă nu reușesc?”, readu atenția la o întrebare mai utilă: „Ce pot face acum?”",
    ),
  },
  EmotionalDimension.setback: {
    EmotionalLevel.low: EmotionalPatternsFeedback(
      body:
          "Când ceva nu îți iese, reușești de obicei să mergi mai departe. Poți fi dezamăgit(ă), dar greșeala nu pare să îți schimbe ușor încrederea în tine sau dorința de a continua.\n\n"
          "Ai tendința să vezi greșeala mai degrabă ca pe o informație despre ce poți ajusta, nu ca pe un verdict despre tine.",
      help:
          "Folosește această capacitate. După un rezultat slab, întreabă-te: Ce a funcționat? Ce nu a funcționat? Ce fac diferit data viitoare? Așa transformi experiența în informație pentru următoarea încercare.",
    ),
    EmotionalLevel.moderate: EmotionalPatternsFeedback(
      body:
          "Unele greșeli trec repede. Altele rămân cu tine, mai ales când rezultatul era important. Poți deveni mai critic(ă), mai precaut(ă) sau poți începe să te îndoiești de ceea ce poți.\n\n"
          "Contează ce faci după acel moment: rămâi prins(ă) în ceea ce nu a mers sau începi să cauți ce poți învăța din el?",
      help:
          "Încearcă să separi rezultatul de concluzia despre tine. „Nu mi-a ieșit” este un fapt despre o situație. „Nu sunt în stare” este o concluzie. Nu sunt același lucru.",
    ),
    EmotionalLevel.high: EmotionalPatternsFeedback(
      body:
          "Greșelile și rezultatele slabe pot avea pentru tine o greutate emoțională mare. Poți deveni foarte critic(ă) cu tine, îți poți pierde încrederea sau îți poate fi greu să încerci din nou.\n\n"
          "Uneori, un rezultat riscă să devină mai mult decât un rezultat: începe să spună ceva despre cât de bun(ă) crezi că ești.",
      help:
          "După o greșeală, schimbă întrebarea. Nu „Ce spune asta despre mine?”, ci: „Ce nu a funcționat? Ce am aflat? Ce pot face diferit?” Greșeala devine astfel informație, nu identitate.",
    ),
  },
  EmotionalDimension.confidence: {
    EmotionalLevel.low: EmotionalPatternsFeedback(
      body:
          "Încrederea ta pare să rămână destul de stabilă chiar și atunci când ești evaluat(ă), comparat(ă) sau primești o observație critică.\n\n"
          "Poți avea emoții sau îndoieli fără ca acestea să schimbe imediat ceea ce crezi despre propriile capacități. Nu ai nevoie să fii complet sigur(ă) că vei reuși ca să încerci.",
      help:
          "Păstrează această diferență între feedback și valoarea personală. Ascultă ce îți este util din părerea celorlalți, fără să îi dai automat puterea de a defini ce poți.",
    ),
    EmotionalLevel.moderate: EmotionalPatternsFeedback(
      body:
          "Părerea celorlalți îți poate influența încrederea, mai ales când situația este importantă pentru tine. Uneori poți folosi feedbackul și merge mai departe. Alteori critica, comparația sau evaluarea te fac să te îndoiești de ceea ce poți.\n\n"
          "Aici contează ce faci cu feedbackul după ce îl primești.",
      help:
          "Separă două lucruri: „Ce spune această persoană despre ceea ce am făcut?” și „Ce ajung eu să cred despre mine din cauza asta?” Păstrează informația utilă. Verifică înainte să transformi restul într-o concluzie despre tine.",
    ),
    EmotionalLevel.high: EmotionalPatternsFeedback(
      body:
          "Evaluarea, critica sau comparația cu ceilalți pot avea un impact puternic asupra încrederii tale. Când cineva nu apreciază ceea ce ai făcut sau când vezi că altcineva se descurcă mai bine, poți începe să îți pui la îndoială propriile capacități.\n\n"
          "Uneori, teama de evaluare poate deveni aproape la fel de importantă ca sarcina însăși.",
      help:
          "Când primești feedback, caută mai întâi informația concretă: Ce anume pot îmbunătăți? O observație despre ceea ce ai făcut nu este automat o concluzie despre cine ești sau despre cât poți deveni.",
    ),
  },
  EmotionalDimension.regulation: {
    EmotionalLevel.low: EmotionalPatternsFeedback(
      body:
          "Chiar când emoțiile devin intense, reușești de obicei să păstrezi un anumit spațiu între ceea ce simți și ceea ce faci. Te poți liniști, îți poți muta atenția și poți alege cum vrei să reacționezi.\n\n"
          "Asta nu înseamnă că simți mai puțin. Înseamnă că emoția nu decide automat comportamentul.",
      help:
          "Continuă să observi ce faci deja bine atunci când apare o emoție puternică. Capacitatea de a recunoaște ce simți înainte să reacționezi este o resursă pe care merită să o păstrezi.",
    ),
    EmotionalLevel.moderate: EmotionalPatternsFeedback(
      body:
          "În unele situații îți reglezi bine emoțiile. În altele, intensitatea lor te poate prinde nepregătit(ă). Poți avea nevoie de timp ca să te liniștești, să îți recapeți concentrarea sau să vezi situația mai clar.\n\n"
          "Important este că revenirea la echilibru nu arată întotdeauna la fel.",
      help:
          "Observă ce funcționează pentru tine după un moment dificil: puțin timp, distanță față de situație, mișcare, să vorbești cu cineva sau să îți pui în ordine gândurile. Cu cât îți cunoști mai bine strategiile eficiente, cu atât le poți folosi mai conștient.",
    ),
    EmotionalLevel.high: EmotionalPatternsFeedback(
      body:
          "Când emoțiile devin foarte puternice, îți poate fi greu să creezi distanță între ceea ce simți și felul în care reacționezi. Poți reacționa repede, îți poate fi dificil să te concentrezi sau poți rămâne mult timp prins(ă) în starea respectivă.\n\n"
          "Scopul nu este să nu mai simți intens. Este să existe mai mult spațiu între emoție și reacție.",
      help:
          "Nu trebuie să rezolvi totul în vârful emoției. Oprește reacția pentru puțin timp, observă ce simți, lasă intensitatea să scadă, apoi decide ce vrei să faci. Emoția poate fi ascultată fără să decidă singură ce urmează.",
    ),
  },
};

/// The fixed text selected by a dimension's level.
EmotionalPatternsFeedback emotionalFeedbackFor(EmotionalDimensionResult result) =>
    emotionalPatternsFeedback[result.dimension]![result.level]!;
