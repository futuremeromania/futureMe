// The fifteen fixed Big Five feedback texts — three levels for each of the
// five dimensions.
//
// These are the counsellor's own texts, reproduced as written. The score
// selects one entry per dimension and it is displayed in full, unchanged:
// nothing here is generated, rewritten, summarised or combined by a model.
// The user sees five of the fifteen, one per dimension.

import 'package:futureme/core/data/big_five.dart';

class BigFiveFeedback {
  const BigFiveFeedback({
    required this.whatItSays,
    required this.strengths,
    required this.watchOut,
    required this.howYouWork,
    required this.environment,
    required this.careerMeaning,
  });

  /// "Ce spune scorul despre tine"
  final String whatItSays;

  /// "Puncte forte"
  final String strengths;

  /// "La ce să fii atent(ă)"
  final String watchOut;

  /// "Cum lucrezi și înveți"
  final String howYouWork;

  /// "Mediul care te poate susține"
  final String environment;

  /// "Ce înseamnă pentru orientarea profesională"
  final String careerMeaning;
}

/// The section headings, shown above each part of a feedback entry.
const String bigFiveWhatItSaysHeading = "Ce spune scorul despre tine";
const String bigFiveStrengthsHeading = "Puncte forte";
const String bigFiveWatchOutHeading = "La ce să fii atent(ă)";
const String bigFiveHowYouWorkHeading = "Cum lucrezi și înveți";
const String bigFiveEnvironmentHeading = "Mediul care te poate susține";
const String bigFiveCareerMeaningHeading = "Ce înseamnă pentru orientarea profesională";

/// Shown once, after all five dimensions — never after each one.
const String bigFiveClosingNote =
    "Personalitatea ta este o resursă, nu o limită. Nu îți spune ce trebuie să fii. Îți arată cum ai tendința să funcționezi și ce tip de mediu îți poate susține mai bine încrederea și performanța.\n\n"
    "Acesta este doar un pas în procesul tău de clarificare. În raportul final, aceste rezultate vor fi puse alături de celelalte informații despre tine. Direcția profesională nu se construiește dintr-un singur scor. Se conturează acolo unde toate aceste informații despre tine încep să se întâlnească.";

/// The short subtitle shown next to each dimension's name.
const Map<BigFiveDimension, String> bigFiveDimensionSubtitles = {
  BigFiveDimension.openness: "Curiozitate, idei și explorare",
  BigFiveDimension.conscientiousness: "Organizare și responsabilitate",
  BigFiveDimension.extraversion: "Energie socială și inițiativă",
  BigFiveDimension.agreeableness: "Empatie și cooperare",
  BigFiveDimension.emotionalStability: "Reacția la stres și presiune",
};

const Map<BigFiveDimension, Map<BigFiveLevel, BigFiveFeedback>> bigFiveFeedback = {
  BigFiveDimension.openness: {
    BigFiveLevel.high: BigFiveFeedback(
      whatItSays:
          "Ai tendința să fii curios/curioasă, receptiv(ă) la idei noi și atras(ă) de explorare. Îți place să descoperi, să înțelegi, să faci conexiuni și să privești lucrurile din perspective diferite. Noutatea și posibilitatea de a învăța îți pot menține interesul.",
      strengths:
          "Curiozitate intelectuală, imaginație, flexibilitate în gândire, interes pentru învățare și capacitatea de a vedea mai multe variante ale unei probleme.",
      watchOut:
          "Noutatea poate deveni uneori mai interesantă decât finalizarea. Poți fi atras(ă) de mai multe direcții simultan sau te poți plictisi când activitatea devine repetitivă. Ideile bune au nevoie și de structură pentru a deveni rezultate.",
      howYouWork:
          "Tinzi să te implici mai mult când înțelegi sensul unei activități, poți explora și ai libertatea de a găsi soluții. Sarcinile exclusiv repetitive sau foarte rigide îți pot menține mai greu interesul.",
      environment:
          "Un mediu cu varietate, idei, învățare, explorare și suficientă autonomie pentru a încerca abordări diferite.",
      careerMeaning:
          "Scorul nu îți spune ce profesie trebuie să alegi. Ne arată însă că, atunci când vom analiza opțiunile profesionale, merită să acordăm atenție rolurilor în care curiozitatea, ideile, învățarea și rezolvarea unor probleme diferite sunt importante.",
    ),
    BigFiveLevel.moderate: BigFiveFeedback(
      whatItSays:
          "Îmbini deschiderea spre nou cu nevoia de concret. Poți aprecia ideile și schimbarea, fără să simți că totul trebuie reinventat permanent.",
      strengths:
          "Echilibru între explorare și pragmatism, capacitatea de a lucra atât cu idei noi, cât și cu metode cunoscute.",
      watchOut:
          "Interesul tău pentru noutate poate depinde mult de context. Uneori poți rămâne într-o variantă familiară chiar când explorarea ar fi utilă sau, invers, poți căuta schimbarea fără să fie necesară.",
      howYouWork:
          "Te poți adapta atât activităților structurate, cât și celor care cer creativitate, mai ales când vezi utilitatea lor.",
      environment:
          "Un mediu care combină stabilitatea cu posibilitatea de a învăța, de a îmbunătăți și de a încerca lucruri noi.",
      careerMeaning:
          "Nu este nevoie să alegem între profesii „creative” și „practice”. Vom urmări ce tip de activități îți trezesc interesul și câtă varietate ai nevoie în mod real.",
    ),
    BigFiveLevel.low: BigFiveFeedback(
      whatItSays:
          "Ai tendința să preferi lucrurile clare, concrete și verificabile. Te simți mai confortabil când știi ce ai de făcut, regulile sunt inteligibile și rezultatele pot fi observate.",
      strengths:
          "Pragmatism, realism, orientare spre concret și capacitatea de a lucra bine cu informații și proceduri clare.",
      watchOut:
          "Uneori poți respinge prea repede o idee doar pentru că este nouă, abstractă sau diferită de ceea ce cunoști. Familiarul nu este întotdeauna cea mai bună soluție.",
      howYouWork:
          "Tinzi să înveți mai ușor când informația este clară, aplicabilă și legată de exemple concrete.",
      environment:
          "Structură, obiective clare, aplicabilitate practică, continuitate și un grad rezonabil de predictibilitate.",
      careerMeaning:
          "Scorul nu înseamnă că „nu ești creativ(ă)”. Sugerează că ai putea funcționa mai confortabil în activități concrete și bine definite decât în roluri bazate permanent pe ambiguitate și explorare.",
    ),
  },
  BigFiveDimension.conscientiousness: {
    BigFiveLevel.high: BigFiveFeedback(
      whatItSays:
          "Ai tendința să fii organizat(ă), perseverent(ă) și atent(ă) la responsabilități. Când îți asumi un obiectiv, este important pentru tine să îl duci la capăt.",
      strengths:
          "Disciplină, planificare, seriozitate, consecvență, atenție la detalii și capacitatea de a lucra pentru obiective pe termen mai lung.",
      watchOut:
          "Nevoia de a face lucrurile bine poate deveni rigiditate, perfecționism sau dificultatea de a accepta că uneori planul trebuie schimbat.",
      howYouWork:
          "Structura, termenele și obiectivele clare tind să te ajute. Poți continua o activitate chiar și după ce entuziasmul inițial a scăzut.",
      environment:
          "Un mediu în care responsabilitatea, organizarea, calitatea și continuitatea sunt apreciate.",
      careerMeaning:
          "Conștiinciozitatea poate fi o resursă în foarte multe profesii. În raportul final ne va interesa unde se întâlnește această capacitate de organizare cu interesele, modul tău de gândire și celelalte rezultate.",
    ),
    BigFiveLevel.moderate: BigFiveFeedback(
      whatItSays:
          "Poți fi organizat(ă) și responsabil(ă), dar nu ai nevoie ca totul să fie planificat în detaliu. Nivelul tău de disciplină poate varia în funcție de interes, miză și context.",
      strengths:
          "Flexibilitate, capacitatea de a folosi structura când este necesară fără să depinzi permanent de reguli foarte stricte.",
      watchOut:
          "În activitățile care nu te motivează, poți amâna sau pierde ritmul. Obiectivele clare și împărțirea sarcinilor în pași mici te pot ajuta.",
      howYouWork:
          "Funcționezi bine când ai o direcție clară, dar și suficient spațiu pentru a-ți organiza singur(ă) munca.",
      environment:
          "Un mediu cu obiective și termene clare, fără control excesiv asupra fiecărui pas.",
      careerMeaning:
          "Vom urmări câtă structură ai nevoie pentru a performa constant și în ce tip de activități motivația ta apare natural.",
    ),
    BigFiveLevel.low: BigFiveFeedback(
      whatItSays:
          "Ai tendința să preferi flexibilitatea și spontaneitatea în locul planificării stricte. Te poți adapta repede la ceea ce apare pe parcurs.",
      strengths:
          "Flexibilitate, spontaneitate, disponibilitatea de a schimba direcția și toleranță mai mare față de planurile deschise.",
      watchOut:
          "Pot apărea amânarea, dezorganizarea, pierderea detaliilor sau dificultatea de a finaliza activități lungi și repetitive.",
      howYouWork:
          "Poți funcționa mai bine cu obiective scurte, termene vizibile, pași concreți și feedback mai frecvent decât cu planuri foarte îndepărtate.",
      environment:
          "Un mediu flexibil, dar nu complet lipsit de structură. Libertatea te ajută, însă câteva repere externe clare îți pot susține performanța.",
      careerMeaning:
          "Scorul nu spune că nu poți fi responsabil(ă). Ne arată că stilul de organizare și cerințele zilnice ale unei profesii trebuie analizate atent, nu doar domeniul în sine.",
    ),
  },
  BigFiveDimension.extraversion: {
    BigFiveLevel.high: BigFiveFeedback(
      whatItSays:
          "Tinzi să îți iei energia din interacțiune, activitate și contact cu oamenii. Îți poate fi ușor să intri în conversații, să te implici și să fii vizibil(ă) într-un grup.",
      strengths:
          "Inițiativă socială, comunicare, energie, ușurință în interacțiune și disponibilitatea de a participa activ.",
      watchOut:
          "Poți căuta prea multă stimulare sau poți ocupa repede spațiul într-o conversație. Unele situații cer răbdare, ascultare și timp de reflecție înainte de acțiune.",
      howYouWork:
          "Poți învăța bine prin discuții, colaborare, explicații cu voce tare și activități dinamice.",
      environment:
          "Interacțiune, colaborare, ritm activ și posibilitatea de a comunica sau de a lucra cu oameni.",
      careerMeaning:
          "Vom urmări rolurile în care nivelul de interacțiune se potrivește energiei tale, fără să presupunem automat că extraversia înseamnă leadership sau o anumită profesie.",
    ),
    BigFiveLevel.moderate: BigFiveFeedback(
      whatItSays:
          "Ai un echilibru între nevoia de interacțiune și nevoia de timp pentru tine. Te poți simți bine atât în grup, cât și lucrând independent.",
      strengths:
          "Adaptabilitate socială, capacitatea de a alterna colaborarea cu concentrarea individuală.",
      watchOut:
          "Nivelul optim de interacțiune poate depinde mult de context și de oamenii din jur. Prea multă izolare sau prea multă stimulare te pot obosi.",
      howYouWork:
          "Poți beneficia atât de discuții și lucru în echipă, cât și de perioade de lucru individual.",
      environment:
          "Un mediu mixt, în care există colaborare, dar și spațiu pentru concentrare.",
      careerMeaning:
          "Ai o plajă largă de contexte posibile. În raportul final vom căuta tipul de interacțiune care se potrivește intereselor și celorlalte caracteristici ale tale.",
    ),
    BigFiveLevel.low: BigFiveFeedback(
      whatItSays:
          "Tinzi să fii mai rezervat(ă) și să îți protejezi energia socială. Poți prefera interacțiunile mai profunde, grupurile mici sau perioadele în care lucrezi singur(ă).",
      strengths:
          "Capacitate de concentrare individuală, reflecție, autonomie și confort cu activități care nu cer interacțiune permanentă.",
      watchOut:
          "Poți evita uneori situații utile doar pentru că presupun expunere sau inițiere socială. Unele oportunități profesionale cer să îți faci ideile vizibile, chiar dacă nu îți place să fii în centrul atenției.",
      howYouWork:
          "Poți prefera să gândești înainte să răspunzi și să lucrezi într-un ritm care îți permite concentrare.",
      environment:
          "Spațiu pentru autonomie și concentrare, interacțiuni cu sens și un nivel de stimulare socială care nu este permanent ridicat.",
      careerMeaning:
          "Extraversia scăzută nu înseamnă lipsă de abilități sociale. Vom analiza câtă interacțiune presupune munca zilnică și în ce formă te simți cel mai eficient(ă).",
    ),
  },
  BigFiveDimension.agreeableness: {
    BigFiveLevel.high: BigFiveFeedback(
      whatItSays:
          "Tinzi să fii atent(ă) la oameni, cooperant(ă) și receptiv(ă) la emoțiile și nevoile lor. Armonia relațională poate conta mult pentru tine.",
      strengths:
          "Empatie, cooperare, disponibilitatea de a ajuta, tact și capacitatea de a crea relații de încredere.",
      watchOut:
          "Dorința de a păstra armonia poate face mai dificil să spui „nu”, să pui limite sau să susții o poziție nepopulară atunci când este necesar.",
      howYouWork:
          "Poți funcționa bine în contexte colaborative, în care există respect și un climat relațional bun.",
      environment:
          "Colaborare, respect reciproc, comunicare civilizată și sentimentul că munca ta are un efect util asupra oamenilor sau echipei.",
      careerMeaning:
          "Empatia este o resursă, dar nu indică singură o profesie. Vom vedea unde se întâlnește cu interesele, limitele personale și tipul de probleme pe care îți place să le rezolvi.",
    ),
    BigFiveLevel.moderate: BigFiveFeedback(
      whatItSays:
          "Poți fi empatic(ă) și cooperant(ă), dar și ferm(ă) atunci când situația o cere. Nu urmărești armonia cu orice preț.",
      strengths:
          "Echilibru între grijă față de oameni și capacitatea de a susține obiective, reguli sau limite.",
      watchOut:
          "În anumite contexte poți oscila între a ceda prea mult și a deveni prea direct(ă). Claritatea asupra propriilor limite te ajută.",
      howYouWork:
          "Te poți adapta atât muncii colaborative, cât și situațiilor în care sunt necesare dezbaterea și diferențele de opinie.",
      environment:
          "Un mediu în care cooperarea nu exclude autonomia, fermitatea sau feedbackul sincer.",
      careerMeaning:
          "Acest echilibru poate fi util în multe roluri. Restul profilului va arăta dacă te atrag mai mult activitățile centrate pe oameni, idei, date sau rezultate.",
    ),
    BigFiveLevel.low: BigFiveFeedback(
      whatItSays:
          "Tinzi să fii mai direct(ă), mai sceptic(ă) și mai puțin preocupat(ă) să menții armonia cu orice preț. Poți pune obiectivul sau argumentul înaintea confortului relațional.",
      strengths:
          "Fermitate, independență în opinie, capacitatea de a pune întrebări dificile și de a susține o poziție chiar când nu este populară.",
      watchOut:
          "Directitatea poate fi percepută uneori ca lipsă de tact. Merită să observi nu doar dacă mesajul este corect, ci și cum ajunge la celălalt.",
      howYouWork:
          "Poți prefera discuțiile clare, argumentele și evaluarea ideilor după merit, fără prea multă încărcătură relațională.",
      environment:
          "Un mediu în care dezacordul este permis, criteriile sunt clare și oamenii pot discuta direct fără ca diferențele de opinie să fie tratate ca atacuri personale.",
      careerMeaning:
          "Scorul nu înseamnă că nu îți pasă de oameni. Ne arată că stilul tău relațional poate fi mai direct și că potrivirea cu cultura unei echipe va conta.",
    ),
  },
  BigFiveDimension.emotionalStability: {
    BigFiveLevel.high: BigFiveFeedback(
      whatItSays:
          "Tinzi să îți păstrezi calmul și echilibrul în situații dificile. Stresul și incertitudinea te pot afecta mai puțin sau îți poți reveni relativ repede.",
      strengths:
          "Calm sub presiune, reziliență, capacitatea de a continua să gândești și să acționezi când apar dificultăți.",
      watchOut:
          "Faptul că tu gestionezi bine presiunea nu înseamnă că ceilalți o trăiesc la fel. Uneori poți subestima cât de solicitantă este o situație pentru altcineva.",
      howYouWork:
          "Poți funcționa bine când apar schimbări, termene, evaluări sau situații neprevăzute, mai ales dacă celelalte cerințe ale mediului ți se potrivesc.",
      environment:
          "Poți tolera o plajă mai largă de contexte, inclusiv unele cu presiune sau incertitudine. Asta nu înseamnă că stresul permanent este benefic.",
      careerMeaning:
          "Stabilitatea emoțională poate susține adaptarea în roluri solicitante, dar nu este suficientă pentru a recomanda un domeniu. Va fi interpretată împreună cu interesele și celelalte rezultate.",
    ),
    BigFiveLevel.moderate: BigFiveFeedback(
      whatItSays:
          "În general reușești să gestionezi stresul, dar reacția ta depinde de context, miză și nivelul de sprijin disponibil.",
      strengths:
          "Capacitatea de a funcționa în multe situații obișnuite și de a-ți reveni după perioade de tensiune.",
      watchOut:
          "Când presiunea se acumulează, emoțiile îți pot influența concentrarea sau deciziile. Este util să observi din timp semnele de suprasolicitare.",
      howYouWork:
          "Poți performa bine sub o presiune rezonabilă, mai ales când cerințele sunt clare și ai resurse suficiente.",
      environment:
          "Un mediu cu provocări gestionabile, feedback clar și suficientă predictibilitate pentru a nu transforma fiecare zi într-o urgență.",
      careerMeaning:
          "Vom analiza nu doar domeniul profesional, ci și ritmul, nivelul de presiune și tipul de responsabilitate pe care îl presupune munca de zi cu zi.",
    ),
    BigFiveLevel.low: BigFiveFeedback(
      whatItSays:
          "Tinzi să reacționezi mai intens la stres, incertitudine sau presiune. Poți observa mai repede riscurile și schimbările emoționale, dar perioadele solicitante îți pot consuma mai multă energie.",
      strengths:
          "Sensibilitate la context, vigilență și capacitatea de a observa devreme când ceva nu este în regulă.",
      watchOut:
          "Grijile, tensiunea sau autocritica pot ocupa uneori prea mult spațiu și pot face mai dificilă concentrarea sau luarea unei decizii.",
      howYouWork:
          "Poți funcționa mai bine când ai claritate, timp suficient, predictibilitate și strategii bune de gestionare a presiunii.",
      environment:
          "Un mediu sigur psihologic, cu așteptări clare, sprijin și un nivel de presiune care nu este constant excesiv.",
      careerMeaning:
          "Acest scor nu stabilește ce profesii „poți” sau „nu poți” face. Ne spune că, atunci când comparăm opțiunile, trebuie să analizăm atent mediul real de lucru, ritmul și expunerea la stres, nu doar titlul profesiei.",
    ),
  },
};
