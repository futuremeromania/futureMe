import 'work_preferences.dart';

/// The fixed feedback library for Module 3, Stage 2 — four dimensions by
/// four outcomes, sixteen texts. Nothing here is generated, combined or
/// rephrased at runtime: the instrument only selects.
class WorkPreferenceFeedback {
  const WorkPreferenceFeedback({required this.headline, required this.body, required this.advice});

  final String headline;

  /// The two explanatory paragraphs, in order.
  final List<String> body;

  /// The closing "Te-ar ajuta să…" paragraph.
  final String advice;
}

const Map<WorkPreferenceDimension, Map<WorkPreferenceOutcome, WorkPreferenceFeedback>> workPreferencesFeedback = {
  WorkPreferenceDimension.workingWithOthers: {
    WorkPreferenceOutcome.firstOnly: WorkPreferenceFeedback(
      headline: "Îți place să lucrezi împreună cu ceilalți.",
      body: [
        "Schimbul de idei, contribuția mai multor persoane și construirea unui rezultat împreună tind să te atragă. Într-un proiect, este posibil să te implici mai ușor atunci când poți discuta idei, construi pe ideile altora și contribui la ceva realizat în comun.",
        "Asta nu înseamnă că nu poți lucra bine singur. Rezultatul arată că interacțiunea și colaborarea fac parte dintre lucrurile care îți pot susține implicarea.",
      ],
      advice:
          "Te-ar ajuta să cauți activități și proiecte în care ai ocazia să lucrezi cu alții, să schimbi idei și să contribui la un rezultat comun. Observă în ce tip de echipă te implici cel mai ușor și ce fel de colaborare îți place.",
    ),
    WorkPreferenceOutcome.secondOnly: WorkPreferenceFeedback(
      headline: "Îți place să ai spațiu să lucrezi pe cont propriu.",
      body: [
        "Îți poate plăcea să ai o sarcină de care răspunzi tu, asupra căreia să te poți concentra fără să depinzi permanent de interacțiunea cu ceilalți. Momentele de lucru individual îți oferă spațiu să te ocupi de ceea ce ai de făcut în felul tău.",
        "Asta nu înseamnă că nu îți place să lucrezi cu oamenii sau că nu poți face parte dintr-o echipă. A prefera să lucrezi individual și a fi sociabil sunt lucruri diferite. Rezultatul vorbește despre felul în care preferi să îți desfășori activitatea.",
      ],
      advice:
          "Te-ar ajuta să ai activități în care există responsabilități individuale clare, de care să te poți ocupa singur. Observă câtă interacțiune îți place să existe într-un proiect și în ce momente preferi să ai propriul spațiu de lucru.",
    ),
    WorkPreferenceOutcome.both: WorkPreferenceFeedback(
      headline: "Îți plac atât colaborarea, cât și lucrul pe cont propriu.",
      body: [
        "Îți poate plăcea să discuți, să construiești idei împreună cu ceilalți și să contribui la un rezultat comun. În același timp, apreciezi și momentele în care ai propria sarcină și te poți concentra singur asupra ei.",
        "Nu este o contradicție. Pentru tine, colaborarea și lucrul individual pot avea roluri diferite în aceeași activitate. Poți prefera, de exemplu, să construiești o idee împreună cu ceilalți, apoi să ai propria parte de lucru.",
      ],
      advice:
          "Te-ar ajuta să cauți proiecte care îți permit să alternezi colaborarea cu perioade de lucru individual. Observă când simți nevoia să lucrezi împreună cu ceilalți și când preferi să ai propriul spațiu.",
    ),
    WorkPreferenceOutcome.neither: WorkPreferenceFeedback(
      headline: "În această zonă nu apare, deocamdată, o preferință clară.",
      body: [
        "Nici colaborarea, nici lucrul individual nu ies suficient de mult în evidență încât să spunem că unul dintre aceste moduri de lucru reprezintă o preferință pentru tine. Este posibil ca alegerea să depindă mai mult de activitate, de situație sau de oamenii implicați.",
        "Asta nu înseamnă că nu îți place niciunul dintre ele. Pur și simplu, felul în care lucrezi cu ceilalți nu pare să fie acum un criteriu care se detașează clar.",
      ],
      advice:
          "Te-ar ajuta să observi în experiențele viitoare când alegi spontan să lucrezi cu ceilalți și când preferi să te ocupi singur de ceea ce ai de făcut. Preferința poate deveni mai clară pe măsură ce încerci situații diferite.",
    ),
  },
  WorkPreferenceDimension.preferredRole: {
    WorkPreferenceOutcome.firstOnly: WorkPreferenceFeedback(
      headline: "Te atrage să ai un rol de coordonare.",
      body: [
        "Îți poate plăcea să preiei inițiativa într-un grup, să organizezi activitatea și să ajuți oamenii să meargă în aceeași direcție. Nu te atrage doar propria sarcină, ci și ceea ce se întâmplă cu proiectul sau cu echipa în ansamblu.",
        "Un scor ridicat aici nu spune că ești deja un lider bun și nici că trebuie să ocupi un rol de conducere. Arată că acest tip de responsabilitate te atrage.",
      ],
      advice:
          "Te-ar ajuta să cauți ocazii în care poți coordona un proiect mic, o echipă sau o activitate. Observă ce parte îți place mai mult: organizarea, luarea deciziilor, responsabilitatea pentru direcția proiectului sau faptul că îi ajuți pe ceilalți să lucreze împreună.",
    ),
    WorkPreferenceOutcome.secondOnly: WorkPreferenceFeedback(
      headline: "Preferi să te concentrezi asupra propriei contribuții.",
      body: [
        "Într-un proiect, îți poate fi mai natural să știi care este partea ta, să te concentrezi asupra ei și să răspunzi de ceea ce ai de făcut, fără să simți nevoia să coordonezi activitatea celorlalți.",
        "Asta nu înseamnă lipsă de inițiativă sau de responsabilitate. Poți avea un rol important într-o echipă fără să fii persoana care o conduce. Contribuția proprie și coordonarea unui grup sunt două tipuri diferite de rol.",
      ],
      advice:
          "Te-ar ajuta să observi ce responsabilități îți place să preiei într-un proiect și în ce tip de sarcină simți că vrei să ai o contribuție clară, de care să răspunzi tu.",
    ),
    WorkPreferenceOutcome.both: WorkPreferenceFeedback(
      headline: "Îți place atât să coordonezi, cât și să ai propria contribuție clară.",
      body: [
        "Te atrage să ai un rol în organizarea și direcția unui proiect, dar în același timp vrei să fii implicat concret în ceea ce se realizează. Pentru tine, coordonarea nu pare să însemne doar să organizezi ceea ce fac ceilalți.",
        "Cele două preferințe se pot completa. Poți dori să coordonezi un proiect și, în același timp, să ai propria parte de muncă în el.",
      ],
      advice:
          "Te-ar ajuta să experimentezi roluri în care coordonarea și contribuția personală se combină. Observă cât de mult îți place să organizezi activitatea celorlalți și cât de important este pentru tine să rămâi implicat direct în ceea ce se construiește.",
    ),
    WorkPreferenceOutcome.neither: WorkPreferenceFeedback(
      headline: "În această zonă nu apare, deocamdată, o preferință clară.",
      body: [
        "Nici rolul de coordonare, nici cel centrat pe propria contribuție nu ies suficient de mult în evidență încât să spunem că unul dintre ele te atrage în mod special. Rolul pe care îl preferi poate depinde de proiect, de oamenii implicați sau de cât de familiară îți este activitatea.",
        "Asta nu înseamnă că nu poți ocupa unul dintre aceste roluri. Rezultatul spune doar că, în acest moment, niciunul nu apare ca o preferință clară.",
      ],
      advice:
          "Te-ar ajuta să încerci roluri diferite în proiecte și să observi ce alegi atunci când ai libertatea să decizi: să organizezi activitatea grupului sau să preiei o parte concretă de care să răspunzi tu.",
    ),
  },
  WorkPreferenceDimension.taskApproach: {
    WorkPreferenceOutcome.firstOnly: WorkPreferenceFeedback(
      headline: "Îți place să ai libertate în felul în care abordezi o sarcină.",
      body: [
        "Te atrage să găsești propriile soluții, să propui variante și să alegi cum ajungi la rezultat. Atunci când primești o sarcină, îți place să existe suficient spațiu pentru propriile idei și pentru propriul mod de a o rezolva.",
        "Asta nu înseamnă că nu ai nevoie de obiective sau reguli. Rezultatul arată că îți place să ai un cuvânt de spus în modul în care îți faci treaba.",
      ],
      advice:
          "Te-ar ajuta să cauți activități în care primești un obiectiv, dar ai libertatea să alegi drumul până la el. Observă câtă libertate îți place să ai și din ce punct lipsa reperelor începe să te încurce.",
    ),
    WorkPreferenceOutcome.secondOnly: WorkPreferenceFeedback(
      headline: "Îți place să știi clar ce ai de făcut.",
      body: [
        "Obiectivele bine definite și cerințele clare îți oferă repere concrete de la început. Preferi să știi ce se urmărește și ce se așteaptă de la tine, în loc să fii nevoit să stabilești singur toate aceste lucruri.",
        "Asta nu înseamnă că nu poți avea idei proprii sau că ai nevoie permanent de cineva care să îți spună ce să faci. A prefera claritatea și a avea inițiativă sunt lucruri diferite.",
      ],
      advice:
          "Te-ar ajuta să ai obiective și așteptări clare înainte să începi o activitate. Observă câtă libertate îți dorești apoi în alegerea modului în care ajungi la rezultatul cerut.",
    ),
    WorkPreferenceOutcome.both: WorkPreferenceFeedback(
      headline: "Îți plac atât claritatea, cât și libertatea de a găsi propriile soluții.",
      body: [
        "Vrei să știi ce trebuie obținut și care sunt reperele importante, dar în același timp îți place să ai libertatea de a decide cum ajungi acolo.",
        "„Spune-mi unde trebuie să ajung, dar lasă-mă să găsesc drumul” descrie bine această combinație. Nu este contradictoriu să vrei structură și inițiativă în același timp. Una îți oferă direcția, cealaltă îți lasă spațiu pentru propriile idei.",
      ],
      advice:
          "Te-ar ajuta să cauți activități în care obiectivele sunt clare, dar metoda rămâne suficient de deschisă încât să poți propune variante, încerca soluții și lua propriile decizii.",
    ),
    WorkPreferenceOutcome.neither: WorkPreferenceFeedback(
      headline: "În această zonă nu apare, deocamdată, o preferință clară.",
      body: [
        "Nici libertatea de a decide singur cum abordezi sarcina, nici existența unor cerințe foarte clare nu ies suficient de mult în evidență încât să vorbim despre o preferință.",
        "Este posibil ca pentru tine să conteze mai mult ce ai de făcut decât cât de mult este stabilit dinainte modul în care trebuie făcut.",
      ],
      advice:
          "Te-ar ajuta să observi ce se întâmplă în situații concrete: când primești libertate, îți place să găsești singur soluția? Când primești cerințe clare, simți că acestea îți sunt utile? În timp, vei putea vedea mai clar ce variantă te atrage.",
    ),
  },
  WorkPreferenceDimension.taskType: {
    WorkPreferenceOutcome.firstOnly: WorkPreferenceFeedback(
      headline: "Îți place să ai activități diferite.",
      body: [
        "Schimbarea tipului de sarcină și posibilitatea de a te ocupa de lucruri diverse tind să te atragă. Îți place ca ceea ce faci să nu însemne permanent același tip de activitate.",
        "Asta nu înseamnă că nu poți persevera sau că te plictisești repede de orice. Rezultatul vorbește despre preferința ta pentru diversitate în ceea ce faci, nu despre capacitatea de concentrare.",
      ],
      advice:
          "Te-ar ajuta să cauți proiecte care includ sarcini diferite sau îți permit să alternezi între mai multe tipuri de activități. Observă câtă varietate îți menține interesul fără să simți că sunt prea multe lucruri deodată.",
    ),
    WorkPreferenceOutcome.secondOnly: WorkPreferenceFeedback(
      headline: "Îți place să poți rămâne mai mult timp asupra aceluiași tip de activitate.",
      body: [
        "Nu ai nevoie ca sarcinile să se schimbe permanent. Îți poate plăcea să continui un tip de activitate pe care îl cunoști și să ai suficient timp să rămâi implicat în el, fără să treci mereu de la un lucru la altul.",
        "Asta nu înseamnă că nu îți place nimic nou. Preferința pentru continuitate nu este același lucru cu rezistența la schimbare. Arată doar că schimbarea permanentă a sarcinilor nu este ceva ce cauți în mod special.",
      ],
      advice:
          "Te-ar ajuta să ai activități în care poți rămâne suficient timp asupra aceluiași tip de sarcină. Observă câtă continuitate îți place și din ce punct repetarea începe să devină monotonă pentru tine.",
    ),
    WorkPreferenceOutcome.both: WorkPreferenceFeedback(
      headline: "Îți plac atât varietatea, cât și continuitatea.",
      body: [
        "Poți aprecia proiectele care îți oferă lucruri diferite de făcut, dar și perioadele în care rămâi asupra aceluiași tip de activitate. Pentru tine, cele două nu se exclud.",
        "Este posibil să îți placă să existe o bază suficient de stabilă încât să poți continua ceea ce faci, dar și suficientă varietate încât activitatea să nu devină mereu aceeași.",
      ],
      advice:
          "Te-ar ajuta să cauți activități care combină perioade de continuitate cu sarcini sau provocări diferite. Observă ce combinație dintre cele două îți place cel mai mult.",
    ),
    WorkPreferenceOutcome.neither: WorkPreferenceFeedback(
      headline: "În această zonă nu apare, deocamdată, o preferință clară.",
      body: [
        "Nici varietatea sarcinilor, nici continuitatea aceluiași tip de activitate nu ies suficient de mult în evidență încât să spunem că una dintre ele reprezintă o preferință pentru tine.",
        "Este posibil ca ceea ce faci să conteze mai mult decât cât de des se schimbă tipul de sarcină.",
      ],
      advice:
          "Te-ar ajuta să observi, în activitățile pe care le faci deja, ce îți menține interesul: faptul că apar lucruri noi, posibilitatea de a continua mai mult timp aceeași activitate sau, pur și simplu, conținutul activității în sine.",
    ),
  },
};

WorkPreferenceFeedback workPreferenceFeedbackFor(WorkPreferenceDimensionResult result) =>
    workPreferencesFeedback[result.dimension]![result.outcome]!;

/// Shown once, after the four blocks.
const String workPreferencesClosingNote =
    "Aceste rezultate nu spun ce profesie ar trebui să alegi. Ele ne ajută să înțelegem ce fel de activități și roluri preferi atunci când lucrezi. Le vom pune alături de celelalte lucruri pe care le descoperim despre tine pentru a contura, la final, direcțiile profesionale care merită explorate.";

/// Copy for the stage intro and the question screen.
const String workPreferencesPrompt = "Cât de mult ți se potrivește?";
const String workPreferencesCaption = "Nu există răspunsuri corecte sau greșite.";
