// The 45 fixed cognitive-style feedback texts — nine level combinations
// (3 levels for the first pole × 3 for the second) for each of the five
// dimensions.
//
// These are FutureMe's own texts, reproduced as written. The pair of
// levels selects one entry per dimension and it is displayed in full,
// unchanged: nothing here is generated, rewritten, summarised or combined
// by a model. The user sees five of the forty-five, one per dimension.
//
// No profession or career recommendation appears here by design — those
// belong to the final report, after every instrument has been integrated.

import 'package:futureme/core/data/cognitive_style.dart';

class CognitiveStyleFeedback {
  const CognitiveStyleFeedback({required this.title, required this.body});

  /// The one-line reading of the combination.
  final String title;

  /// The explanatory paragraphs, separated by blank lines.
  final String body;
}

/// Shown once, after all five dimensions — never after each one.
const String cognitiveStyleClosingNote =
    "Felul în care gândești este o resursă.\n"
    "Nu trebuie să îți forțezi mintea să funcționeze altfel.\n"
    "Este mai eficient să îți alegi un drum care lucrează cu tine, nu împotriva ta.";

/// Keyed dimension → level of the first pole → level of the second pole.
const Map<CognitiveDimension, Map<CognitiveLevel, Map<CognitiveLevel, CognitiveStyleFeedback>>>
    cognitiveStyleFeedback = {
  CognitiveDimension.analyticalIntuitive: {
    CognitiveLevel.low: {
      CognitiveLevel.low: CognitiveStyleFeedback(
        title: "Nu apare o preferință clară între analiza pas cu pas și intuiție.",
        body:
            "Răspunsurile tale nu arată o tendință puternică spre niciuna dintre aceste două modalități de gândire. Este posibil ca felul în care abordezi o problemă să depindă mult de situație sau să folosești alte strategii atunci când cauți o soluție.\n\n"
            "Asta nu înseamnă că îți lipsește un stil de gândire. Înseamnă doar că, în această dimensiune, nu apare o preferință clară.",
      ),
      CognitiveLevel.moderate: CognitiveStyleFeedback(
        title: "Intuiția apare în modul tău de a gândi, fără să fie foarte pronunțată.",
        body:
            "Uneori faci conexiuni rapide sau simți în ce direcție ar putea fi soluția înainte să poți explica exact cum ai ajuns acolo. Nu pari să ai însă o preferință puternică pentru analiza pas cu pas.\n\n"
            "În funcție de situație, este posibil să lași lucrurile să capete sens pe parcurs, fără să simți nevoia să analizezi fiecare etapă.",
      ),
      CognitiveLevel.high: CognitiveStyleFeedback(
        title: "Gândirea intuitivă este puternic prezentă în modul tău de a procesa informația.",
        body:
            "Ai tendința să faci rapid conexiuni între idei și să simți direcția unei soluții înainte să poți explica întotdeauna drumul până la ea. Nu ai nevoie de fiecare pas clarificat pentru ca o idee să înceapă să aibă sens.\n\n"
            "Această capacitate te poate ajuta atunci când este nevoie să vezi posibilități sau să găsești soluții noi. Pentru problemele importante sau complexe, poate fi util să verifici ulterior prin informații și argumente ceea ce intuiția ți-a sugerat inițial.",
      ),
    },
    CognitiveLevel.moderate: {
      CognitiveLevel.low: CognitiveStyleFeedback(
        title: "Analiza are un loc în modul tău de a gândi, fără să fie o preferință foarte pronunțată.",
        body:
            "În anumite situații îți este util să verifici informațiile, să urmărești logica unei probleme sau să o descompui în pași. Intuiția și impresiile rapide par să aibă un rol mai redus.\n\n"
            "Este posibil să folosești analiza mai ales atunci când problema o cere, fără să simți nevoia să abordezi astfel orice situație.",
      ),
      CognitiveLevel.moderate: CognitiveStyleFeedback(
        title: "Folosești atât analiza, cât și intuiția, fără ca una să domine clar.",
        body:
            "Poți aborda o problemă pas cu pas, dar poți face și conexiuni rapide sau avea o primă impresie despre direcția potrivită. Niciuna dintre cele două modalități nu apare ca foarte pronunțată.\n\n"
            "Asta îți poate permite să îți adaptezi modul de gândire la situație: uneori să analizezi, alteori să lași intuiția să îți ofere primul indiciu.",
      ),
      CognitiveLevel.high: CognitiveStyleFeedback(
        title: "Intuiția este puternic prezentă, iar analiza o poate completa.",
        body:
            "Îți vin natural conexiunile rapide, impresiile și soluțiile pe care uneori le vezi înainte să poți explica exact cum ai ajuns la ele. În același timp, poți folosi și analiza atunci când situația o cere.\n\n"
            "Pentru tine, o strategie eficientă poate fi să lași intuiția să genereze direcții, apoi să folosești analiza pentru a le verifica și clarifica.",
      ),
    },
    CognitiveLevel.high: {
      CognitiveLevel.low: CognitiveStyleFeedback(
        title: "Gândirea analitică este puternic prezentă în modul tău de a procesa informația.",
        body:
            "Îți vine natural să verifici informațiile, să urmărești logica unei probleme și să înțelegi pașii care duc la o concluzie. Preferi să știi de ce o soluție are sens, nu doar să simți că este potrivită.\n\n"
            "Această abordare te poate ajuta în situațiile care cer precizie, argumente și analiză. Uneori poate fi util să lași loc și unei prime impresii sau unei idei care nu este încă pe deplin explicată.",
      ),
      CognitiveLevel.moderate: CognitiveStyleFeedback(
        title: "Analiza este foarte prezentă, dar intuiția are și ea un loc în modul tău de a gândi.",
        body:
            "Ai tendința să verifici informațiile, să urmărești logica și să înțelegi cum ai ajuns la o concluzie. În același timp, uneori apar conexiuni sau soluții înainte să le fi analizat complet.\n\n"
            "Poți folosi această combinație în avantajul tău: intuiția poate deschide o direcție, iar analiza te ajută să verifici dacă direcția respectivă se susține.",
      ),
      CognitiveLevel.high: CognitiveStyleFeedback(
        title: "Ai la dispoziție două moduri puternice de a procesa informația.",
        body:
            "Poți analiza logic, verifica informații și urmări o problemă pas cu pas. În același timp, faci conexiuni rapide și poți vedea o posibilă soluție înainte să poți explica exact cum ai ajuns la ea.\n\n"
            "Cele două nu se contrazic. Din contră, pot lucra foarte bine împreună: intuiția poate genera o direcție, iar analiza o poate verifica, dezvolta sau corecta.",
      ),
    },
  },
  CognitiveDimension.practicalConceptual: {
    CognitiveLevel.low: {
      CognitiveLevel.low: CognitiveStyleFeedback(
        title: "Nu apare o preferință clară între abordarea practică și cea conceptuală.",
        body:
            "Răspunsurile tale nu arată o tendință puternică nici spre aplicarea imediată a informațiilor, nici spre explorarea ideilor și posibilităților. Este posibil ca modul în care abordezi lucrurile să depindă mult de situație.\n\n"
            "Asta nu înseamnă că îți lipsește un mod de a învăța sau de a înțelege. Înseamnă doar că, în această dimensiune, nu apare o preferință clară.",
      ),
      CognitiveLevel.moderate: CognitiveStyleFeedback(
        title: "Ideile și posibilitățile au un loc în modul tău de a gândi, fără să fie o preferință foarte pronunțată.",
        body:
            "Uneori îți place să explorezi idei, principii sau posibilități chiar înainte să știi exact cum ar putea fi folosite. Aplicarea imediată și concretă pare să conteze mai puțin pentru tine.\n\n"
            "În funcție de situație, este posibil să ai nevoie mai întâi să înțelegi ideea, apoi să vezi ce poți face cu ea.",
      ),
      CognitiveLevel.high: CognitiveStyleFeedback(
        title: "Gândirea conceptuală este puternic prezentă în modul tău de a procesa informația.",
        body:
            "Te atrag ideile, principiile și posibilitățile. Poți explora un subiect chiar dacă nu îi vezi imediat utilitatea și îți este natural să te gândești la ceea ce ar putea exista, nu doar la ceea ce există deja.\n\n"
            "Această preferință te poate ajuta să explorezi perspective noi. Uneori poate fi util să faci pasul următor și să întrebi cum poate fi transformată o idee într-o acțiune concretă.",
      ),
    },
    CognitiveLevel.moderate: {
      CognitiveLevel.low: CognitiveStyleFeedback(
        title: "Aplicarea concretă are un loc în modul tău de a înțelege lucrurile.",
        body:
            "În anumite situații, înțelegi mai ușor atunci când vezi cum poate fi folosită o informație sau când poți face ceva concret cu ea. Explorarea ideilor fără o legătură imediată cu realitatea pare să aibă un rol mai redus.\n\n"
            "Este posibil să cauți utilitatea practică mai ales atunci când subiectul sau problema o cere.",
      ),
      CognitiveLevel.moderate: CognitiveStyleFeedback(
        title: "Folosești atât abordarea practică, cât și cea conceptuală, fără ca una să domine clar.",
        body:
            "Poți fi interesat(ă) de modul în care o idee funcționează în realitate, dar și de principiile sau posibilitățile din spatele ei. Niciuna dintre cele două orientări nu apare ca foarte pronunțată.\n\n"
            "În funcție de situație, poți trece de la „Cum pot folosi asta?” la „Ce înseamnă și ce alte posibilități există?”.",
      ),
      CognitiveLevel.high: CognitiveStyleFeedback(
        title: "Gândirea conceptuală este puternic prezentă, iar orientarea practică o poate completa.",
        body:
            "Îți place să explorezi idei, principii și posibilități, inclusiv atunci când nu au o aplicare imediată. În același timp, poți căuta și modalități concrete de a folosi ceea ce înțelegi.\n\n"
            "Pentru tine, o strategie eficientă poate fi să explorezi liber o idee, apoi să te întrebi ce poate deveni în realitate.",
      ),
    },
    CognitiveLevel.high: {
      CognitiveLevel.low: CognitiveStyleFeedback(
        title: "Orientarea practică este puternic prezentă în modul tău de a învăța și de a rezolva probleme.",
        body:
            "Înțelegi mai ușor atunci când poți vedea cum funcționează ceva în realitate și ce poți face concret cu informația. Aplicarea te ajută să dai sens lucrurilor.\n\n"
            "Această abordare te poate ajuta să transformi repede informația în acțiune. Uneori poate fi util să explorezi și idei care nu par imediat aplicabile, înainte să decizi dacă îți sunt utile.",
      ),
      CognitiveLevel.moderate: CognitiveStyleFeedback(
        title: "Orientarea practică este foarte prezentă, dar ideile și conceptele au și ele un loc în modul tău de a gândi.",
        body:
            "Îți este natural să cauți aplicabilitatea unei informații și să înțelegi prin ceea ce poți face concret. În același timp, poți explora principii, idei sau posibilități atunci când situația o cere.\n\n"
            "Poți folosi această combinație pentru a transforma ideile în ceva concret, fără să pierzi din vedere sensul lor mai larg.",
      ),
      CognitiveLevel.high: CognitiveStyleFeedback(
        title: "Ai la dispoziție două moduri puternice de a înțelege și folosi informația.",
        body:
            "Poți explora idei, principii și posibilități, dar îți este natural și să cauți modul în care acestea pot fi aplicate în realitate.\n\n"
            "Cele două se pot completa foarte bine: gândirea conceptuală te ajută să vezi ce ar putea fi posibil, iar orientarea practică te ajută să transformi posibilitatea în ceva concret.",
      ),
    },
  },
  CognitiveDimension.detailBigPicture: {
    CognitiveLevel.low: {
      CognitiveLevel.low: CognitiveStyleFeedback(
        title: "Nu apare o preferință clară între focalizarea pe detalii și imaginea de ansamblu.",
        body:
            "Răspunsurile tale nu indică o tendință puternică spre observarea elementelor mici, dar nici spre căutarea imediată a ideii generale și a conexiunilor dintre informații.\n\n"
            "Este posibil ca felul în care privești informația să se schimbe în funcție de situație și de ceea ce ți se cere.",
      ),
      CognitiveLevel.moderate: CognitiveStyleFeedback(
        title: "Imaginea de ansamblu contează în modul tău de a procesa informația, fără să fie o preferință foarte pronunțată.",
        body:
            "Uneori cauți mai întâi ideea principală sau legăturile dintre informații. Detaliile mici par să îți atragă mai puțin atenția în mod spontan.\n\n"
            "În funcție de situație, este posibil să pornești de la sensul general și să intri în detalii doar atunci când ai nevoie de ele.",
      ),
      CognitiveLevel.high: CognitiveStyleFeedback(
        title: "Imaginea de ansamblu este puternic prezentă în modul tău de a procesa informația.",
        body:
            "Îți este natural să cauți ideea principală, să observi conexiunile și să înțelegi mai întâi cum se leagă lucrurile între ele. Nu ai nevoie să pornești de la fiecare detaliu pentru a înțelege direcția generală.\n\n"
            "Această perspectivă te poate ajuta să nu pierzi sensul general într-o cantitate mare de informații. Când precizia contează, poate fi util să revii apoi intenționat asupra detaliilor.",
      ),
    },
    CognitiveLevel.moderate: {
      CognitiveLevel.low: CognitiveStyleFeedback(
        title: "Detaliile au un loc în modul tău de a procesa informația.",
        body:
            "Observi anumite elemente, diferențe sau neconcordanțe și poți acorda atenție componentelor unei probleme. Imaginea generală și conexiunile largi par să apară mai puțin spontan.\n\n"
            "În anumite situații, poate fi util să te întrebi ce spun toate aceste elemente atunci când sunt privite împreună.",
      ),
      CognitiveLevel.moderate: CognitiveStyleFeedback(
        title: "Poți acorda atenție atât elementelor unei probleme, cât și imaginii generale, fără ca una dintre orientări să domine clar.",
        body:
            "Uneori observi detaliile, alteori cauți ideea principală și legăturile dintre informații.\n\n"
            "Modul în care privești lucrurile poate depinde de situație: poți apropia perspectiva atunci când contează precizia și o poți îndepărta atunci când ai nevoie să înțelegi sensul general.",
      ),
      CognitiveLevel.high: CognitiveStyleFeedback(
        title: "Imaginea de ansamblu este puternic prezentă, iar atenția la detalii o poate completa.",
        body:
            "Îți este natural să observi ideea principală și conexiunile dintre informații. În același timp, poți acorda atenție elementelor care compun întregul atunci când situația o cere.\n\n"
            "Pentru tine, poate funcționa bine să înțelegi mai întâi direcția generală, apoi să cobori spre detaliile importante.",
      ),
    },
    CognitiveLevel.high: {
      CognitiveLevel.low: CognitiveStyleFeedback(
        title: "Atenția la detalii este puternic prezentă în modul tău de a procesa informația.",
        body:
            "Observi ușor elemente mici, diferențe sau neconcordanțe și îți este natural să privești atent componentele unei probleme.\n\n"
            "Această atenție poate fi foarte utilă atunci când contează precizia. În situațiile cu multe informații, poate fi util să te oprești din când în când și să întrebi: „Care este ideea principală aici?”.",
      ),
      CognitiveLevel.moderate: CognitiveStyleFeedback(
        title: "Atenția la detalii este foarte prezentă, dar poți vedea și imaginea de ansamblu.",
        body:
            "Îți este natural să observi elementele mici și să urmărești cu atenție componentele unei probleme. În același timp, poți identifica ideea generală și legăturile dintre informații.\n\n"
            "Poți folosi această combinație pentru a înțelege întregul fără să pierzi din vedere elementele care îl construiesc.",
      ),
      CognitiveLevel.high: CognitiveStyleFeedback(
        title: "Ai la dispoziție două perspective puternice asupra informației.",
        body:
            "Poți observa detalii, diferențe și neconcordanțe, dar poți vedea și ideea principală, conexiunile și imaginea de ansamblu.\n\n"
            "Cele două perspective se pot completa foarte bine: una te ajută să vezi piesele, cealaltă să înțelegi cum se leagă ele într-un întreg.",
      ),
    },
  },
  CognitiveDimension.fastReflective: {
    CognitiveLevel.low: {
      CognitiveLevel.low: CognitiveStyleFeedback(
        title: "Nu apare o preferință clară pentru un anumit ritm de procesare.",
        body:
            "Răspunsurile tale nu arată nici o tendință puternică de a formula rapid idei și soluții, nici o nevoie pronunțată de a acorda mult timp reflecției.\n\n"
            "Este posibil ca ritmul în care procesezi informația să depindă mult de problemă, de cât de familiară îți este sau de cât de importantă o consideri.",
      ),
      CognitiveLevel.moderate: CognitiveStyleFeedback(
        title: "Reflecția are un loc în modul tău de a procesa informația.",
        body:
            "Uneori ai nevoie să îți acorzi timp pentru a înțelege bine o informație sau pentru a privi o problemă din mai multe unghiuri. Soluțiile și răspunsurile rapide par să apară mai puțin natural.\n\n"
            "A-ți acorda timp poate fi util, mai ales atunci când problema este nouă sau complexă.",
      ),
      CognitiveLevel.high: CognitiveStyleFeedback(
        title: "Procesarea reflexivă este puternic prezentă în modul tău de a gândi.",
        body:
            "Preferi să îți acorzi timp pentru a procesa informația, a privi problema din mai multe unghiuri și a formula un răspuns după ce ai avut timp să te gândești.\n\n"
            "Acest ritm îți poate permite să aprofundezi lucrurile înainte să ajungi la o concluzie. În situațiile în care timpul este limitat, poate fi util să observi când ai deja suficiente informații pentru a merge mai departe.",
      ),
    },
    CognitiveLevel.moderate: {
      CognitiveLevel.low: CognitiveStyleFeedback(
        title: "Procesarea rapidă apare în modul tău de a gândi, fără să fie foarte pronunțată.",
        body:
            "În anumite situații îți vin repede idei sau posibile soluții și poți începe să lucrezi cu ele fără o perioadă lungă de reflecție.\n\n"
            "Este posibil să folosești această rapiditate mai ales în situațiile familiare sau atunci când problema nu cere o analiză aprofundată.",
      ),
      CognitiveLevel.moderate: CognitiveStyleFeedback(
        title: "Ritmul tău de procesare se poate adapta situației.",
        body:
            "Poți ajunge relativ repede la idei sau soluții, dar îți poți acorda și timp pentru a privi o problemă mai atent. Nici rapiditatea, nici reflecția îndelungată nu apar ca preferințe foarte pronunțate.\n\n"
            "Este posibil să accelerezi atunci când situația este clară și să încetinești atunci când problema cere mai multă gândire.",
      ),
      CognitiveLevel.high: CognitiveStyleFeedback(
        title: "Reflecția este puternic prezentă, dar poți genera și relativ repede direcții sau soluții.",
        body:
            "Îți poți da seama destul de repede în ce direcție ai putea merge, însă preferi să acorzi timp procesării înainte să consideri că ai ajuns la o concluzie.\n\n"
            "Această combinație îți permite să folosești primele idei ca punct de plecare, apoi să le analizezi din mai multe perspective.",
      ),
    },
    CognitiveLevel.high: {
      CognitiveLevel.low: CognitiveStyleFeedback(
        title: "Procesarea rapidă este puternic prezentă în modul tău de a gândi.",
        body:
            "Îți vin repede în minte idei și posibile soluții și poți începe să lucrezi cu o problemă fără să ai nevoie de mult timp înainte de primul răspuns.\n\n"
            "Această rapiditate poate fi utilă atunci când este nevoie să te miști repede. Pentru problemele complexe, poate fi util să introduci intenționat un al doilea moment de gândire, după prima soluție care îți vine în minte.",
      ),
      CognitiveLevel.moderate: CognitiveStyleFeedback(
        title: "Procesezi repede informația, dar reflecția are și ea un loc în modul tău de a gândi.",
        body:
            "Îți vin natural idei și posibile soluții, iar direcția unei probleme poate deveni repede clară pentru tine. În același timp, poți încetini și privi lucrurile mai atent atunci când situația o cere.\n\n"
            "Prima idee poate deveni astfel un punct de pornire, nu neapărat răspunsul final.",
      ),
      CognitiveLevel.high: CognitiveStyleFeedback(
        title: "Poți genera repede idei și, în același timp, ai o tendință puternică spre reflecție.",
        body:
            "O posibilă soluție poate apărea rapid, dar asta nu înseamnă că te oprești la ea. Îți este natural și să acorzi timp procesării, să privești problema din mai multe unghiuri și să revii asupra primului răspuns.\n\n"
            "Cele două pot lucra foarte bine împreună: rapiditatea îți oferă puncte de plecare, iar reflecția îți permite să le verifici și să le dezvolți.",
      ),
    },
  },
  CognitiveDimension.structuredFlexible: {
    CognitiveLevel.low: {
      CognitiveLevel.low: CognitiveStyleFeedback(
        title: "Nu apare o preferință clară între structură și flexibilitate.",
        body:
            "Răspunsurile tale nu arată nici o nevoie puternică de planuri și organizare prealabilă, nici o preferință pronunțată pentru schimbare și adaptare din mers.\n\n"
            "Este posibil ca modul în care abordezi o activitate să depindă mai mult de situație decât de o preferință stabilă pentru una dintre aceste două variante.",
      ),
      CognitiveLevel.moderate: CognitiveStyleFeedback(
        title: "Flexibilitatea apare în modul tău de a funcționa, fără să fie foarte pronunțată.",
        body:
            "Te poți adapta atunci când lucrurile se schimbă și poți găsi o altă cale pe parcurs. Nu pari să ai o nevoie puternică de planuri sau de a ști exact de la început ce urmează.\n\n"
            "În funcție de situație, poți lăsa unele lucruri deschise și să decizi pe parcurs cum continui.",
      ),
      CognitiveLevel.high: CognitiveStyleFeedback(
        title: "Flexibilitatea este puternic prezentă în modul tău de a funcționa.",
        body:
            "Te adaptezi ușor atunci când planurile se schimbă și îți este natural să găsești alte variante pe parcurs. Nu ai nevoie ca totul să fie stabilit de la început pentru a putea continua.\n\n"
            "Această flexibilitate te poate ajuta în situațiile imprevizibile. Atunci când există multe lucruri de urmărit sau termene importante, o structură minimă poate fi utilă fără să îți limiteze libertatea.",
      ),
    },
    CognitiveLevel.moderate: {
      CognitiveLevel.low: CognitiveStyleFeedback(
        title: "Structura are un loc în modul tău de a funcționa.",
        body:
            "În anumite situații lucrezi mai ușor atunci când știi ce ai de făcut și ai o direcție stabilită. Schimbările de plan și improvizația par să îți vină mai puțin natural.\n\n"
            "Este posibil să cauți structură mai ales atunci când sarcina este nouă, complexă sau importantă.",
      ),
      CognitiveLevel.moderate: CognitiveStyleFeedback(
        title: "Poți folosi atât structura, cât și flexibilitatea, fără ca una să domine clar.",
        body:
            "Uneori îți este util să ai un plan și să știi ce urmează. Alteori te poți adapta și poți schimba direcția pe parcurs.\n\n"
            "Este posibil să îți ajustezi modul de lucru în funcție de situație: mai multă structură când ai nevoie de claritate, mai multă flexibilitate când apar schimbări.",
      ),
      CognitiveLevel.high: CognitiveStyleFeedback(
        title: "Flexibilitatea este puternic prezentă, iar structura o poate completa.",
        body:
            "Te adaptezi ușor la schimbări și poți găsi alte variante atunci când planul inițial nu mai funcționează. În același timp, poți folosi o anumită structură atunci când situația o cere.\n\n"
            "Pentru tine, un plan poate funcționa mai bine ca direcție decât ca regulă rigidă: suficient de clar încât să știi unde mergi, suficient de flexibil încât să îl poți modifica.",
      ),
    },
    CognitiveLevel.high: {
      CognitiveLevel.low: CognitiveStyleFeedback(
        title: "Structura este puternic prezentă în modul tău de a funcționa.",
        body:
            "Îți este natural să ai un plan, să știi ce ai de făcut și să ai o imagine clară asupra pașilor următori. Organizarea îți poate oferi claritate și te poate ajuta să îți concentrezi energia asupra a ceea ce ai de făcut.\n\n"
            "Atunci când lucrurile se schimbă neașteptat, poate fi util să privești planul ca pe un instrument care poate fi ajustat, nu ca pe ceva ce trebuie urmat cu orice preț.",
      ),
      CognitiveLevel.moderate: CognitiveStyleFeedback(
        title: "Structura este foarte prezentă, dar flexibilitatea are și ea un loc în modul tău de a funcționa.",
        body:
            "Îți place să ai un plan, să știi ce urmează și să pornești cu o direcție clară. În același timp, poți modifica traseul atunci când situația o cere.\n\n"
            "Această combinație îți permite să folosești organizarea ca punct de sprijin, fără ca orice schimbare să însemne că trebuie să o iei de la început.",
      ),
      CognitiveLevel.high: CognitiveStyleFeedback(
        title: "Ai la dispoziție atât o nevoie puternică de structură, cât și o capacitate puternică de adaptare.",
        body:
            "Îți place să pornești cu un plan clar și să știi ce urmează, dar te poți adapta atunci când realitatea schimbă planul. Structura și flexibilitatea nu se exclud.\n\n"
            "Împreună, îți permit să ai o direcție fără să rămâi blocat(ă) în ea: poți organiza ceea ce depinde de tine și modifica ceea ce trebuie schimbat.",
      ),
    },
  },
};

/// The fixed text selected by a dimension's pair of levels.
CognitiveStyleFeedback cognitiveFeedbackFor(CognitiveDimensionResult result) =>
    cognitiveStyleFeedback[result.dimension]![result.firstLevel]![result.secondLevel]!;