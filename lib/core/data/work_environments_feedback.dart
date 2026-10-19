import 'work_environments.dart';

/// The fixed feedback library for Module 3, Stage 3 — seven dimensions by
/// four outcomes, twenty-eight texts, copied verbatim from the
/// specification. Nothing here is generated, combined or rephrased at
/// runtime: the instrument only selects.
const String workEnvironmentsFeedbackVersion = 'work-environments-feedback-ro-2026-09-20';

/// One of the optional closing notes of a text ("Ce te-ar ajuta",
/// "La ce să fii atent(ă)", "Ce merită să exersezi"). A text has only the
/// ones the specification gives it.
class WorkEnvironmentNote {
  const WorkEnvironmentNote(this.label, this.text);

  final String label;
  final String text;
}

class WorkEnvironmentFeedback {
  const WorkEnvironmentFeedback({required this.title, required this.body, this.notes = const []});

  final String title;

  /// The explanatory paragraphs, in order.
  final List<String> body;

  final List<WorkEnvironmentNote> notes;

  /// The whole text as displayed, for storage and for the spoken summary.
  String get fullText => [
        ...body,
        for (final note in notes) '${note.label}: ${note.text}',
      ].join('\n\n');
}

const Map<WorkEnvironmentDimension, Map<WorkEnvironmentOutcome, WorkEnvironmentFeedback>> workEnvironmentsFeedback = {
  WorkEnvironmentDimension.formalInformal: {
    WorkEnvironmentOutcome.firstOnly: WorkEnvironmentFeedback(
      title: "Preferi un mediu mai formal",
      body: [
        "Te atrag locurile în care relațiile profesionale au limite clare, iar oamenii păstrează un anumit stil în modul în care comunică și lucrează împreună. Îți place să înțelegi cum se comunică, cum se abordează anumite situații și ce se așteaptă de la fiecare.",
        "Asta nu înseamnă neapărat un mediu rigid sau rece. Mai degrabă, apreciezi claritatea în relațiile profesionale și faptul că oamenii știu când și cum să păstreze o anumită conduită.",
      ],
      notes: [
        WorkEnvironmentNote("Ce te-ar ajuta", "un loc în care modul de comunicare, relația cu superiorii, clienții sau colegii și limitele profesionale sunt ușor de înțeles."),
        WorkEnvironmentNote("Ce merită să exersezi", "să te simți confortabil și în contexte mai relaxate. Uneori o comunicare informală poate face colaborarea mai simplă fără să reducă profesionalismul."),
      ],
    ),
    WorkEnvironmentOutcome.secondOnly: WorkEnvironmentFeedback(
      title: "Preferi un mediu mai informal",
      body: [
        "Te atrag locurile în care oamenii pot comunica firesc, fără prea multe formalități sau distanțe create de funcții și titulaturi. Probabil apreciezi o atmosferă în care poți pune o întrebare, propune o idee sau începe o conversație fără să simți că trebuie să urmezi permanent un protocol.",
        "Pentru tine, profesionalismul nu trebuie să însemne neapărat formalitate. Îți place ca relațiile de lucru să lase loc pentru naturalețe și comunicare directă.",
      ],
      notes: [
        WorkEnvironmentNote("La ce să fii atent(ă)", "o atmosferă relaxată nu înseamnă că dispar limitele profesionale. Vor exista situații în care modul în care comunici, momentul ales sau rolul persoanei cu care vorbești contează."),
        WorkEnvironmentNote("Ce merită să exersezi", "să poți schimba registrul de comunicare în funcție de situație — relaxat când se poate, formal când contextul o cere."),
      ],
    ),
    WorkEnvironmentOutcome.both: WorkEnvironmentFeedback(
      title: "Îți plac profesionalismul și naturalețea",
      body: [
        "Pentru tine, cele două nu se exclud. Poți aprecia un mediu în care oamenii știu când este nevoie de o comunicare profesională și de limite clare, dar în care relațiile de zi cu zi rămân firești și apropiate.",
      ],
      notes: [
        WorkEnvironmentNote("Ce te-ar ajuta", "un loc în care seriozitatea apare acolo unde contează, fără ca fiecare interacțiune dintre oameni să devină rigidă sau protocolară."),
      ],
    ),
    WorkEnvironmentOutcome.neither: WorkEnvironmentFeedback(
      title: "Formalitatea mediului nu pare să fie esențială pentru tine",
      body: [
        "Rezultatele tale nu arată o preferință puternică nici pentru un mediu foarte formal, nici pentru unul foarte informal. Este posibil ca acest aspect să conteze mai puțin pentru tine decât alte caracteristici ale locului în care lucrezi.",
        "Asta îți poate oferi mai multă libertate de adaptare la culturi organizaționale diferite din acest punct de vedere.",
      ],
    ),
  },
  WorkEnvironmentDimension.structuredFlexible: {
    WorkEnvironmentOutcome.firstOnly: WorkEnvironmentFeedback(
      title: "Preferi un mediu bine organizat",
      body: [
        "Te atrag locurile în care există reguli, proceduri și un mod clar de organizare. Îți place să înțelegi cum funcționează lucrurile și care sunt reperele după care se lucrează.",
        "Un astfel de cadru reduce nevoia de a descoperi de fiecare dată de la zero cum trebuie procedat. Pentru tine, organizarea și regulile clare sunt caracteristici importante ale mediului.",
      ],
      notes: [
        WorkEnvironmentNote("Ce te-ar ajuta", "proceduri ușor de găsit, responsabilități explicate și un mod de lucru suficient de clar încât să știi de unde începi."),
        WorkEnvironmentNote("Ce merită să exersezi", "să poți acționa și atunci când nu există încă o procedură pentru situația respectivă. În orice organizație apar probleme pentru care „manualul” nu are încă un răspuns."),
      ],
    ),
    WorkEnvironmentOutcome.secondOnly: WorkEnvironmentFeedback(
      title: "Preferi un mediu care se poate adapta",
      body: [
        "Te atrag organizațiile în care regulile și modul de lucru nu sunt atât de rigide încât să împiedice adaptarea. Dacă situația se schimbă, îți place să existe libertatea de a schimba și felul în care este abordată.",
        "Probabil apreciezi mai mult întrebarea „Ce funcționează în situația aceasta?” decât aplicarea aceleiași reguli indiferent de context.",
      ],
      notes: [
        WorkEnvironmentNote("La ce să fii atent(ă)", "flexibilitatea funcționează mai bine atunci când oamenii știu ce rezultat urmăresc. Altfel, libertatea se poate transforma pur și simplu în lipsă de organizare."),
      ],
    ),
    WorkEnvironmentOutcome.both: WorkEnvironmentFeedback(
      title: "Preferi structură, dar nu rigiditate",
      body: [
        "Îți place să existe reguli, repere și un mod clar de organizare, dar nu vrei ca acestea să devină obstacole atunci când situația cere altceva.",
      ],
      notes: [
        WorkEnvironmentNote("Ce te-ar ajuta", "un sistem care spune clar ce trebuie obținut și care sunt regulile importante, dar permite adaptarea metodei atunci când există un motiv bun."),
      ],
    ),
    WorkEnvironmentOutcome.neither: WorkEnvironmentFeedback(
      title: "Modul de organizare nu pare să fie decisiv pentru tine",
      body: [
        "Nu apare o preferință clară nici pentru multă structură, nici pentru multă flexibilitate. Este posibil să te poți adapta ambelor variante sau pur și simplu alte caracteristici ale mediului să cântărească mai mult pentru tine.",
      ],
    ),
  },
  WorkEnvironmentDimension.competitiveCollaborative: {
    WorkEnvironmentOutcome.firstOnly: WorkEnvironmentFeedback(
      title: "Te atrage un mediu competitiv",
      body: [
        "Îți plac mediile în care există obiective ambițioase, comparație între rezultate și provocarea de a face mai bine. Competiția nu pare să fie ceva ce ai prefera să eviți; poate face activitatea mai interesantă pentru tine.",
        "Probabil apreciezi locurile în care rezultatele sunt vizibile și există standarde pe care merită să încerci să le depășești.",
      ],
      notes: [
        WorkEnvironmentNote("Ce te-ar ajuta", "obiective clare, criterii transparente și situații în care știi după ce reguli sunt comparate rezultatele."),
        WorkEnvironmentNote("Ce merită să exersezi", "să folosești competiția ca stimul pentru progres fără să transformi orice situație într-o comparație cu ceilalți. Unele rezultate se obțin mai bine concurând; altele, cooperând."),
      ],
    ),
    WorkEnvironmentOutcome.secondOnly: WorkEnvironmentFeedback(
      title: "Te atrage un mediu colaborativ",
      body: [
        "Preferi locurile în care oamenii își împărtășesc informațiile, se ajută și urmăresc rezultate împreună. Pentru tine contează ca munca să nu devină permanent o confruntare între colegi.",
        "Apreciezi mai degrabă ideea de „reușim împreună” decât pe cea de „fiecare pentru el”.",
      ],
      notes: [
        WorkEnvironmentNote("La ce să fii atent(ă)", "colaborarea nu înseamnă că responsabilitatea devine a tuturor și, în final, a nimănui. Chiar într-o echipă foarte unită trebuie să fie clar ce contribuție îi aparține fiecăruia."),
      ],
    ),
    WorkEnvironmentOutcome.both: WorkEnvironmentFeedback(
      title: "Îți plac colaborarea și provocarea",
      body: [
        "Nu vezi neapărat competiția și colaborarea ca opuse. Poți aprecia o echipă în care oamenii se ajută între ei, dar care își stabilește obiective ambițioase și vrea rezultate foarte bune.",
      ],
      notes: [
        WorkEnvironmentNote("Ce te-ar ajuta", "un mediu în care oamenii pot concura cu standarde înalte sau cu alte echipe fără să devină adversari între ei."),
      ],
    ),
    WorkEnvironmentOutcome.neither: WorkEnvironmentFeedback(
      title: "Competiția sau colaborarea nu par să definească mediul pe care îl cauți",
      body: [
        "Nu apare o preferință puternică pentru niciuna dintre variante. Modul în care oamenii se raportează la rezultate poate conta pentru tine mai puțin decât alte caracteristici ale mediului.",
      ],
    ),
  },
  WorkEnvironmentDimension.autonomySupervision: {
    WorkEnvironmentOutcome.firstOnly: WorkEnvironmentFeedback(
      title: "Preferi să ai libertate în modul în care lucrezi",
      body: [
        "Te atrag mediile care îți oferă spațiu să iei decizii și să alegi cum abordezi ceea ce ai de făcut. Nu înseamnă că vrei să lucrezi fără obiective sau responsabilitate, ci că apreciezi libertatea de a găsi propriul drum către rezultat.",
      ],
      notes: [
        WorkEnvironmentNote("Ce te-ar ajuta", "să știi clar ce rezultat se așteaptă de la tine, dar să ai libertate în alegerea modului în care ajungi acolo."),
        WorkEnvironmentNote("Ce merită să exersezi", "autonomia vine împreună cu responsabilitatea. Cu cât ai mai multă libertate, cu atât devin mai importante organizarea propriei activități, asumarea deciziilor și capacitatea de a cere ajutor înainte ca o problemă să devină prea mare."),
      ],
    ),
    WorkEnvironmentOutcome.secondOnly: WorkEnvironmentFeedback(
      title: "Preferi să existe îndrumare pe parcurs",
      body: [
        "Te atrag mediile în care există un coordonator prezent, care urmărește cum evoluează activitatea și poate oferi direcție atunci când este nevoie.",
        "Asta nu înseamnă că altcineva trebuie să facă lucrurile în locul tău. Înseamnă că apreciezi să existe repere, feedback și o persoană la care poți apela, în loc să fii lăsat să descoperi totul singur.",
      ],
      notes: [
        WorkEnvironmentNote("Ce merită să exersezi", "pe măsură ce capeți experiență, încearcă să iei singur(ă) tot mai multe dintre deciziile pe care deja ai suficiente informații să le iei. Îndrumarea poate fi un sprijin fără să devină dependență."),
      ],
    ),
    WorkEnvironmentOutcome.both: WorkEnvironmentFeedback(
      title: "Preferi libertate, dar și un punct de sprijin",
      body: [
        "Îți place să ai spațiu pentru propriile decizii, fără să fii complet pe cont propriu.",
      ],
      notes: [
        WorkEnvironmentNote("Ce te-ar ajuta", "un coordonator care stabilește direcția, este disponibil și oferă feedback, dar nu controlează fiecare pas. Pe scurt: „am încredere să fac singur, dar am la cine apela când am nevoie.”"),
      ],
    ),
    WorkEnvironmentOutcome.neither: WorkEnvironmentFeedback(
      title: "Gradul de coordonare nu pare să fie o preferință puternică",
      body: [
        "Nu apare o preferință clară nici pentru multă autonomie, nici pentru supervizare frecventă. Nivelul de coordonare de care ai nevoie poate depinde mai degrabă de situație: cât de nouă, dificilă sau familiară este activitatea.",
      ],
    ),
  },
  WorkEnvironmentDimension.stableInnovative: {
    WorkEnvironmentOutcome.firstOnly: WorkEnvironmentFeedback(
      title: "Preferi un mediu care oferă continuitate",
      body: [
        "Te atrag organizațiile în care direcțiile importante nu sunt schimbate permanent și există continuitate în modul în care se lucrează.",
        "Nu înseamnă că respingi orice schimbare. Mai degrabă, preferi ca schimbarea să aibă un motiv și să nu transforme permanent regulile jocului.",
      ],
      notes: [
        WorkEnvironmentNote("Ce te-ar ajuta", "o organizație care schimbă lucrurile atunci când există un motiv real, dar păstrează suficientă continuitate încât oamenii să poată construi pe ceea ce au făcut deja."),
        WorkEnvironmentNote("Ce merită să exersezi", "să separi schimbarea inutilă de schimbarea necesară. Uneori tocmai modificarea unui mod cunoscut de lucru permite unei organizații să rămână stabilă pe termen lung."),
      ],
    ),
    WorkEnvironmentOutcome.secondOnly: WorkEnvironmentFeedback(
      title: "Te atrag mediile deschise către idei noi",
      body: [
        "Îți plac organizațiile în care oamenii pot experimenta, testa soluții și pune sub semnul întrebării felul în care s-au făcut lucrurile până acum.",
        "Un mediu în care apare des întrebarea „Putem face asta mai bine sau altfel?” poate fi mai interesant pentru tine decât unul care păstrează aceleași metode doar pentru că sunt deja cunoscute.",
      ],
      notes: [
        WorkEnvironmentNote("La ce să fii atent(ă)", "nu orice idee nouă este automat și una mai bună. Inovația utilă presupune și testare, evaluarea rezultatelor și disponibilitatea de a renunța la o idee atunci când nu funcționează."),
      ],
    ),
    WorkEnvironmentOutcome.both: WorkEnvironmentFeedback(
      title: "Vrei progres fără să pierzi stabilitatea",
      body: [
        "Îți place ideea de schimbare și inovație, dar nu neapărat schimbarea făcută doar de dragul schimbării. Poți aprecia o organizație care are o bază stabilă și, în același timp, caută modalități mai bune de a face lucrurile.",
      ],
      notes: [
        WorkEnvironmentNote("Ce te-ar ajuta", "un loc care știe ce merită păstrat și ce merită schimbat. Pentru tine, stabilitatea și progresul pot merge împreună."),
      ],
    ),
    WorkEnvironmentOutcome.neither: WorkEnvironmentFeedback(
      title: "Stabilitatea sau inovația nu par să fie criterii decisive pentru tine",
      body: [
        "Nu apare o preferință puternică pentru una dintre aceste caracteristici. Ai putea accepta atât un mediu care păstrează mult din ceea ce funcționează deja, cât și unul care experimentează mai des, în funcție de celelalte lucruri pe care ți le oferă.",
      ],
    ),
  },
  WorkEnvironmentDimension.predictableDynamic: {
    WorkEnvironmentOutcome.firstOnly: WorkEnvironmentFeedback(
      title: "Preferi să știi, în general, la ce să te aștepți",
      body: [
        "Te atrag mediile în care activitatea de zi cu zi are o anumită continuitate și nu apar permanent schimbări neașteptate.",
        "Nu înseamnă că vrei ca fiecare zi să fie identică. Contează însă să poți anticipa într-o măsură rezonabilă ce urmează, care sunt prioritățile și cum va arăta activitatea ta.",
      ],
      notes: [
        WorkEnvironmentNote("Ce merită să exersezi", "să îți păstrezi capacitatea de acțiune și atunci când planul zilei se schimbă. Chiar și cele mai predictibile profesii au momente în care apare ceva ce nu putea fi anticipat."),
      ],
    ),
    WorkEnvironmentOutcome.secondOnly: WorkEnvironmentFeedback(
      title: "Te atrage un mediu în mișcare",
      body: [
        "Îți plac locurile în care apar situații noi, prioritățile se pot schimba și trebuie să te adaptezi din mers. Faptul că nu știi exact cum va arăta fiecare zi nu pare să fie ceva ce vrei neapărat să eviți.",
        "Poți aprecia un mediu în care există noutate și schimbare în activitatea de zi cu zi.",
      ],
      notes: [
        WorkEnvironmentNote("Ce te-ar ajuta", "contexte în care schimbarea aduce probleme noi de rezolvat, nu doar dezorganizare."),
        WorkEnvironmentNote("La ce să fii atent(ă)", "„dinamic” și „haotic” nu înseamnă același lucru. Un mediu poate avea multe schimbări și totuși să aibă priorități, responsabilități și obiective clare."),
      ],
    ),
    WorkEnvironmentOutcome.both: WorkEnvironmentFeedback(
      title: "Îți place schimbarea, dar vrei și câteva repere",
      body: [
        "Poți aprecia zilele diferite și provocările noi, fără să îți dorești sentimentul că totul este permanent imprevizibil.",
      ],
      notes: [
        WorkEnvironmentNote("Ce te-ar ajuta", "un mediu în care obiectivele importante sunt suficient de clare, dar drumul până la ele aduce situații, probleme și provocări diferite."),
      ],
    ),
    WorkEnvironmentOutcome.neither: WorkEnvironmentFeedback(
      title: "Cât de schimbătoare este activitatea de zi cu zi nu pare să fie decisiv pentru tine",
      body: [
        "Nu apare o preferință puternică nici pentru predictibilitate, nici pentru un mediu foarte dinamic. Ai putea tolera destul de bine ambele variante, dacă celelalte caracteristici importante pentru tine sunt prezente.",
      ],
    ),
  },
  WorkEnvironmentDimension.hierarchicalEgalitarian: {
    WorkEnvironmentOutcome.firstOnly: WorkEnvironmentFeedback(
      title: "Preferi roluri și responsabilități clare",
      body: [
        "Te atrag organizațiile în care este ușor de înțeles cine pentru ce răspunde, cine coordonează și unde se iau anumite decizii.",
        "Pentru tine, existența unei ierarhii nu este neapărat ceva negativ. Poate oferi claritate asupra responsabilității și asupra modului în care funcționează organizația.",
      ],
      notes: [
        WorkEnvironmentNote("La ce să fii atent(ă)", "o ierarhie clară poate organiza responsabilitatea, dar poziția unei persoane nu garantează automat că fiecare idee sau decizie a ei este cea mai bună."),
        WorkEnvironmentNote("Ce merită să exersezi", "să îți exprimi argumentat punctul de vedere și atunci când persoana cu care nu ești de acord are mai multă autoritate."),
      ],
    ),
    WorkEnvironmentOutcome.secondOnly: WorkEnvironmentFeedback(
      title: "Preferi un mediu cu distanțe mai mici între oameni",
      body: [
        "Te atrag organizațiile în care funcția unei persoane nu creează automat o distanță mare față de ceilalți. Îți place ideea că poți vorbi, pune întrebări sau propune ceva chiar și unei persoane aflate mai sus în organizație.",
        "Pentru tine contează ca ideile să poată fi ascultate pentru valoarea lor, nu doar în funcție de poziția celui care le spune.",
      ],
      notes: [
        WorkEnvironmentNote("La ce să fii atent(ă)", "egalitatea în comunicare nu înseamnă egalitatea responsabilității. Uneori cineva trebuie să ia decizia finală și să răspundă pentru ea, chiar dacă toate vocile au fost ascultate."),
      ],
    ),
    WorkEnvironmentOutcome.both: WorkEnvironmentFeedback(
      title: "Vrei roluri clare, fără bariere inutile între oameni",
      body: [
        "Poți aprecia o organizație în care se știe cine coordonează și cine răspunde de anumite decizii, dar în care aceste diferențe de rol nu împiedică oamenii să comunice deschis.",
      ],
      notes: [
        WorkEnvironmentNote("Ce te-ar ajuta", "o organizație în care autoritatea stabilește responsabilitatea, nu valoarea persoanei. Pe scurt, ierarhia poate organiza munca fără să stabilească cine are voie să aibă idei bune."),
      ],
    ),
    WorkEnvironmentOutcome.neither: WorkEnvironmentFeedback(
      title: "Structura de autoritate nu pare să fie un criteriu important pentru tine",
      body: [
        "Nu apare o preferință puternică nici pentru o organizație mai ierarhică, nici pentru una mai egalitară. Este posibil să conteze mai mult pentru tine cum este folosită autoritatea decât forma pe care o are structura organizației.",
      ],
    ),
  },
};

WorkEnvironmentFeedback workEnvironmentFeedbackFor(WorkEnvironmentDimensionResult result) =>
    workEnvironmentsFeedback[result.dimension]![result.outcome]!;

/// Shown once, after the seven texts.
const List<String> workEnvironmentsClosingNote = [
  "Un lucru important: un mediu de lucru nu trebuie să fie într-un singur fel. În organizațiile reale pot exista în același timp caracteristici diferite, uneori chiar aparent opuse. De exemplu, un loc poate fi bine organizat, dar flexibil atunci când situația o cere, sau stabil, dar deschis către idei noi.",
  "De aceea, dacă la tine apar preferințe ridicate pentru ambele caracteristici ale unei dimensiuni, nu este o contradicție. Înseamnă că te poți simți bine într-un mediu care le combină.",
];

/// Copy for the question screen.
const String workEnvironmentsPrompt = "Cât de mult ți se potrivește?";
const String workEnvironmentsCaption = "Nu există răspunsuri corecte sau greșite.";
