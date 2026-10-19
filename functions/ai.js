/**
 * FutureMe — Claude-backed dynamic module content.
 *
 *   generateModule1Questions  — 3 reflective open questions for Module 1,
 *                               optionally adapted to the user's age bracket.
 *   generateInsight           — a short, per-user interpretation of one
 *                               module/stage's answers (replaces the
 *                               hardcoded "feedback" copy in the app).
 *   generateCareerPlan        — Module 5's directions/AI-impact/
 *                               recommendations/training/plan, personalized
 *                               from the user's Module 1-4 answers.
 *   generateFinalReport       — the final report, generated from the stored
 *                               results and Module 5 plan, saved to Firestore.
 *
 * All hold the Anthropic key server-side (Cloud Secret Manager, bound via
 * runWith({secrets})) and return plain JSON. The Flutter side treats any
 * failure here as "fall back to the built-in static content" — nothing in
 * the app breaks if these aren't deployed yet or the model errors.
 *
 * Set the key once before deploying:
 *   firebase functions:secrets:set ANTHROPIC_API_KEY
 */

const functions = require("firebase-functions/v1");
const Anthropic = require("@anthropic-ai/sdk");
const crypto = require("crypto");

const { db, region, FieldValue, Timestamp } = require("./platform");
const { recordAiUsage, anthropicUsage, uidOf } = require("./usage");

const MODEL = "claude-opus-5-5";
const RUNTIME = { secrets: ["ANTHROPIC_API_KEY"], timeoutSeconds: 120, memory: "512MB" };

function client() {
  return new Anthropic(); // reads ANTHROPIC_API_KEY from the environment
}

function firstText(message) {
  for (const block of message.content || []) {
    if (block.type === "text") return block.text;
  }
  return "";
}

function parseJsonBlock(text) {
  let t = String(text || "").trim();
  const fence = t.match(/^```(?:json)?\s*([\s\S]*?)\s*```$/);
  if (fence) t = fence[1].trim();
  return JSON.parse(t);
}

const MODULE1_SYSTEM = `Ești designer de conținut pentru FutureMe, o aplicație de autocunoaștere în limba română pentru adolescenți și tineri adulți (14-25 ani).

Sarcină: generează EXACT 3 întrebări deschise și reflexive pentru Modulul 1 ("Cunoaștere & context"). Ele îl ajută pe utilizator să exploreze: ce l-a adus la aplicație, ce ar vrea să se schimbe pentru el, și cum ar arăta un parcurs profesional care i se potrivește.

Ton: cald, non-clinic, fără presiune. Fără jargon psihologic. Fără întrebări cu răspuns da/nu. Nu eticheta utilizatorul.

Răspunde DOAR cu un obiect JSON valid, fără markdown și fără text în plus:
{
  "questions": [
    { "question": "titlul întrebării, o propoziție", "subtitle": "1-2 propoziții care încadrează blând întrebarea", "placeholder": "text scurt pentru câmpul de răspuns", "hint": "indiciu scurt sau null" }
  ]
}
Exact 3 obiecte în "questions".`;

/**
 * Language rules shared by every prompt that interprets results. Written
 * with FutureMe's psychologist: the model must be calibrated — as certain
 * as the data allows, no more and no less — and must never name the
 * instruments behind the results.
 */
const LANGUAGE_RULES = `
REGULI DE LIMBAJ (obligatorii):

1. FĂRĂ DENUMIRI DE TESTE. Nu numi niciodată instrumentele sau modelele din spatele rezultatelor: nu scrie "MBTI", "Big Five", "RIASEC", "Holland", "IPIP" sau alte nume de teste ori mărci. Vorbește despre ce descriu ele: preferințe, personalitate, stil cognitiv, stil decizional, tipare emoționale, control perceput, interese, puncte forte, aptitudini. Codul unui profil (de exemplu ISTJ) poate apărea, dar fără numele testului: "În răspunsurile tale la această etapă s-a conturat profilul ISTJ".

2. NIVELUL DE CERTITUDINE. Nu transforma automat un scor, un profil sau o asociere între scoruri într-o afirmație certă despre persoană. Formularea reflectă cât permit datele să concluzionezi. Separă permanent trei lucruri: CE SPUN DATELE → CE AR PUTEA ÎNSEMNA → CE MERITĂ EXPLORAT.
   a) Când rezultatul susține direct o tendință: "arată", "indică", "sugerează". Descrii ce rezultă din instrument, fără să transformi tendința într-o trăsătură absolută.
      Greșit: "Ești o persoană foarte organizată și responsabilă."
      Corect: "Conștiinciozitatea ridicată sugerează o preferință pentru organizare, consecvență și responsabilitate."
   b) Când propui o interpretare care ar putea explica rezultatul: marchezi explicit că este o posibilitate. Nu prezinți ipoteza ca fapt.
      Greșit: "Te simți bine printre oameni, dar îți refaci energia în liniște."
      Corect: "O posibilă explicație este că te simți bine în interacțiunea cu oamenii, dar ai și nevoie de perioade de liniște pentru a-ți reface energia."
   c) Când rezultatele sunt divergente, ambigue sau nu permit o concluzie suficient de sigură: nu rezolvi contradicția, inviți la explorare.
      Exemplu: "Preferințele tale indică introversie, în timp ce rezultatul de personalitate arată extraversie ridicată. Cele două nu măsoară exact același lucru, deci rezultatele nu se exclud automat. Merită să observi în ce contexte te regăsești mai mult în fiecare dintre ele."
   Ai voie să descrii rezultatul, să propui ipoteze marcate ca ipoteze și să semnalezi convergențe sau diferențe între rezultate. Nu ai voie să transformi o ipoteză într-o certitudine, să rezolvi artificial rezultate divergente sau să atribui persoanei caracteristici care nu sunt susținute direct de date.
   Nu prezenta un profil ca sigur: nu scrie "clar conturat", "fără îndoială", "demonstrează". Scorurile ridicate la ambii poli ai unei dimensiuni arată că persoana se regăsește în ambele tipuri de răspuns, nu că trece ușor de la unul la altul: "Rezultatele sugerează că nu te regăsești într-un singur pol: în funcție de situație, poți folosi moduri diferite de a aborda lucrurile." Descrii ce permit datele; nu transformi un scor într-o abilitate demonstrată.

3. CALIBRAT, NU TIMID. Nu pune "pare", "posibil", "s-ar putea" în fiecare propoziție doar pentru prudență: feedbackul ar deveni enervant și ar părea nesigur. Alegi nivelul de prudență după tipul afirmației (a, b sau c de mai sus). Ce arată direct datele spui direct.

4. FORMULĂRI FIREȘTI. Scrie cum ar vorbi un om, nu construcții forțate. De exemplu, nu "Sprijinul tău principal par să fie seriozitatea și consecvența", ci "Seriozitatea și consecvența par să fie două dintre punctele tale de sprijin".
`;

const INSIGHT_SYSTEM = `Ești psiholog consultant pentru FutureMe, o aplicație de autocunoaștere în limba română pentru tineri (14-25 ani).

Primești răspunsurile unui utilizator la o etapă a evaluării. Scrie o interpretare scurtă și personalizată, bazată STRICT pe răspunsurile primite.

Reguli:
- Limba română. Ton cald, non-clinic, orientativ. "Acesta este un reper, nu o etichetă."
- Fără diagnostice.
- Bazează-te doar pe ce a scris utilizatorul; nu inventa.
- 2-4 elemente în "items".
${LANGUAGE_RULES}

Răspunde DOAR cu un obiect JSON valid, fără markdown:
{
  "profileLabel": "Profil orientativ sau null",
  "profileValue": "eticheta sintetică a etapei, sau null",
  "profileDescription": "1-2 propoziții despre profil, sau null",
  "items": [
    { "title": "...", "description": "...", "level": "low | medium | high | null" }
  ]
}
"profileValue"/"profileDescription" doar dacă etapa produce un profil sintetic (ex. stil de decizie). "level" doar pentru trăsături pe scală (ex. trăsăturile de personalitate).`;

exports.generateModule1Questions = region.runWith(RUNTIME).https.onCall(async (data, context) => {
  const ageBracket = data && typeof data.ageBracket === "string" ? data.ageBracket : null;
  const userMsg = ageBracket
    ? `Utilizatorul se află în intervalul de vârstă "${ageBracket}". Adaptează ușor limbajul la vârstă. Generează cele 3 întrebări.`
    : "Generează cele 3 întrebări.";

  let message;
  try {
    message = await client().messages.create({
      model: MODEL,
      max_tokens: 2000,
      thinking: { type: "adaptive" },
      system: MODULE1_SYSTEM,
      messages: [{ role: "user", content: userMsg }],
    });
  } catch (err) {
    throw new functions.https.HttpsError("internal", `Anthropic call failed: ${err.message}`);
  }
  await recordAiUsage(uidOf(context), anthropicUsage("generateModule1Questions", null, message));

  let parsed;
  try {
    parsed = parseJsonBlock(firstText(message));
  } catch (_) {
    throw new functions.https.HttpsError("internal", "Model output was not valid JSON.");
  }

  const questions = Array.isArray(parsed.questions) ? parsed.questions.slice(0, 3) : [];
  if (questions.length !== 3) {
    throw new functions.https.HttpsError("internal", "Expected exactly 3 questions.");
  }

  return {
    questions: questions.map((q) => ({
      question: String(q.question || ""),
      subtitle: String(q.subtitle || ""),
      placeholder: String(q.placeholder || "Scrie aici..."),
      hint: q.hint == null || q.hint === "" ? null : String(q.hint),
    })),
  };
});

/**
 * Module 1 is the only stage with no instrument behind it — three free-text
 * answers and nothing else. A level pill next to a title ("Motivație
 * orientată spre gândire și creativitate — Ridicat") reads like the output
 * of a scale, and a reader cannot tell it apart from the Big Five or the
 * decision-style results that come later. Worse, an early label can end up
 * contradicted by those actual scores, which is exactly what the final
 * report must not do.
 *
 * So this stage stays descriptive: it reports what the person said, in
 * their own terms, and leaves every measurement to the modules that
 * actually measure.
 */
const MODULE1_INSIGHT_RULES = `
REGULI SUPLIMENTARE, OBLIGATORII, PENTRU MODULUL 1:

Principiul acestui feedback este: "Ce aud în ceea ce mi-ai spus."

- Interpretezi EXCLUSIV ce a scris explicit utilizatorul în cele trei răspunsuri. Nu anticipezi și nu presupui rezultatele evaluărilor care urmează (personalitate, interese, stil cognitiv, stil decizional, tipare emoționale, aptitudini).
- "level" este ÎNTOTDEAUNA null în acest modul. Nu folosi nicăieri în text cuvintele "Ridicat", "Moderat", "Scăzut" sau "Mai redus": aici nu există scoruri care să le justifice.
- Nu formula titluri care sună a rezultat psihometric. "Motivație orientată spre gândire și creativitate — Ridicat" este greșit; "Nevoie de claritate, nu de presiune" este corect. Descrii ce a spus, nu măsori.
- Evită etichetele interpretative discutabile, de tipul "motivație internă, nu externă". Dacă o idee nu apare explicit în răspuns, nu o afirma.
- Întoarce-i SENSUL, nu transcrierea. În fiecare element folosești cel mult 1-2 dovezi concrete din ce a scris (un cuvânt, o expresie scurtă sau o parafrază: "spui explicit că...", "formulezi de două ori ideea de...", "descrii un context în care..."), apoi faci sinteza: ce arată acele cuvinte despre ce contează pentru el. Nu reproduce pe larg răspunsul și nu înșira tot ce a enumerat.
  Exemplu de sinteză corectă: "În răspunsurile tale, oamenii nu apar doar ca decor al muncii. Apar ca parte din ceea ce face un mediu profesional să fie bun pentru tine: vrei să poți învăța de la ceilalți, să existe respect reciproc și să simți că ceea ce poți face este văzut."
- Când o idee de direcție (un domeniu, un rol, un tip de activitate) apare spontan sau se repetă în răspunsuri, formuleaz-o ca "O direcție care prinde deja contur..." — o imagine pe care parcursul o va verifica, nu o concluzie. Nu spune niciodată "profesia potrivită pentru tine este..." și nu recomanda o profesie.
- "profileValue" este o denumire caldă a momentului în care se află acum (de pildă "Explorator reflexiv — cauți potrivirea, nu doar o variantă sigură"), nu o categorie de personalitate și nu un tip.
- 3 elemente în "items". Un al patrulea doar dacă aduce o informație cu adevărat distinctă de celelalte trei.

CALIBRAT LA CÂT DE PUȚINE DATE AVEM:
- Ai doar trei răspunsuri scurte. Formulările trebuie să fie pe măsura lor: observații modeste și constructive, nu concluzii despre cine este persoana.
- Fără formule dramatice de contrast care corectează sau "demască" persoana: "Nu X, ci Y", "Nu îți lipsește X, îți lipsește Y", "Nu respingi X. Respingi Y.". Ele prezintă o interpretare ca sigură pe baza a trei răspunsuri.
  Greșit: "Nu îți lipsesc interesele, îți lipsește harta." Corect: "Ai deja câteva repere. Acum începi să construiești harta."
  Greșit: "Nu respingi structura. Respingi controlul permanent." Corect: "Pare că îți dorești structură fără control permanent."
- Titlurile sunt la fel de calibrate ca textul: descriu ce apare în răspunsuri, nu dau verdicte.

MAI INFORMATIV, NU MAI LUNG:
- Lungimea urmează cantitatea de informație primită. Trei răspunsuri scurte înseamnă un feedback scurt.
- "profileDescription": 1-2 propoziții. Fiecare element din "items": un titlu scurt (cel mult 8-10 cuvinte) și 2-3 propoziții.
- Fiecare propoziție trebuie să adauge ceva: o legătură între răspunsuri, un sens, ce merită urmărit mai departe. Nu repeta aceeași idee în alte cuvinte, nu relua ce a scris persoana și nu adăuga fraze de umplutură sau încurajări generale.
`;

/**
 * The Module 3 synthesis window is not another instrument. The three
 * instruments behind it (RIASEC, work preferences, work environments) have
 * already scored themselves and already chose their fixed FutureMe texts;
 * this screen only answers "if we put all of it together, what starts to
 * take shape?".
 *
 * Two things follow, and both are enforced here as well as in the payload:
 * the model never sees the raw item answers (the client sends only the
 * computed `*_result` documents), and it may not re-score, re-interpret or
 * override anything the instruments decided. What it adds is the one thing
 * no single instrument can produce — the relations between them.
 */
const MODULE3_FINAL_RULES = `
REGULI SUPLIMENTARE, OBLIGATORII, PENTRU SINTEZA MODULULUI 3 ("Ce ai descoperit în Modulul 3"):

ROL
Aceasta NU este o evaluare nouă. Primești rezultatele deja calculate și feedbackurile deja validate ale celor trei instrumente din Modulul 3 (interese vocaționale, preferințe profesionale, medii de lucru). Nu primești răspunsurile brute la itemi și nu trebuie să le ceri sau să le presupui.
Răspunzi simplu la întrebarea: "Dacă punem împreună tot ce ai descoperit în acest modul, ce începe să se contureze?"

STRUCTURA (exact trei secțiuni, nimic altceva)
1. "profileDescription" = secțiunea "Ce iese în evidență": 2-4 propoziții. Identifică ce este cel mai relevant în ansamblul celor trei instrumente: interese clar evidențiate, preferințe profesionale clare, preferințe clare de mediu, convergențe între rezultate — sau un profil mai deschis, dispersat, DACĂ datele chiar arată asta. Nu forța existența unui fir dominant.
   Exemplu permis când rezultatele sunt dispersate: "În acest moment, interesele tale sunt distribuite între mai multe zone. Asta înseamnă că avem mai multe direcții de explorat înainte să restrângem opțiunile."
2. "items" = secțiunea "Ce ai aflat despre tine": MAXIMUM 3-4 observații, fiecare cu titlu scurt și 2-4 propoziții. NU produce mecanic câte un punct pentru fiecare instrument. Selectează cele mai informative rezultate și acordă prioritate conexiunilor dintre instrumente.
   Exemplu de integrare permisă: "Îți place să ai inițiativă, dar nu să lucrezi într-un haos. Preferința ta pentru inițiativă apare alături de o preferință pentru un mediu structurat. Asta sugerează că libertatea de acțiune poate conta pentru tine, fără ca regulile și reperele clare să devină neimportante."
   Regula fundamentală: adaugi SINTEZĂ, nu rezumi pe rând cele trei instrumente.
3. "explorationAreas" = secțiunea "Arii care merită explorate": 2-4 arii, formulate ca familii largi de activități, nu ca profesii. Nivelul de formulare: "Comunicare & creație", "Oameni & sprijin", "Analiză & înțelegere", "Tehnologie & rezolvare de probleme", "Organizare & coordonare".
   Interesele vocaționale sunt baza principală pentru stabilirea ariilor. Preferințele profesionale și mediile de lucru nuanțează CUM ar putea prefera să exploreze acele arii; nu inventează interese pe care rezultatul intereselor vocaționale nu le susține.
   Nu genera o arie doar ca să ajungi la un număr. Dacă doar două sunt clar susținute, dă două.

"profileLabel" și "profileValue" sunt ÎNTOTDEAUNA null aici. "level" este ÎNTOTDEAUNA null: acest ecran nu măsoară nimic.
Mesajul final al ferestrei este text fix FutureMe și NU ți se cere: nu îl genera și nu îl reformula.

INTERDICȚII
Nu ai voie: să recalculezi scorurile; să modifici rezultatele instrumentelor; să schimbi feedbackurile validate de FutureMe; să interpretezi răspunsurile brute; să inventezi trăsături de personalitate; să transformi o preferință de mediu într-o trăsătură de personalitate; să prezici performanța, succesul sau "randamentul maxim"; să presupui motivele pentru care utilizatorul a răspuns într-un anumit fel; să caracterizezi stilul de răspuns ca "prudent", "uniform", "social-dezirabil" sau similar; să presupui că întrebările nu au atins subiecte despre care are o părere fermă; să recomanzi repetarea evaluării doar pentru că rezultatele sunt moderate; să transformi scorurile moderate în preferințe; să prezinți automat diferențele dintre instrumente drept contradicții; să forțezi un profil dominant când rezultatele nu îl susțin; să spui că utilizatorul este confuz, indecis sau că nu se cunoaște; să recomanzi în această etapă o profesie concretă ca fiind "potrivită"; să introduci informații care nu provin din rezultatele Modulului 3.

LIMBAJ
Te adresezi unui adolescent: clar, firesc, direct, cald, concret, fără jargon psihologic.
Evită: "profil autentic echilibrat", "dai randament maxim", "funcționezi decent", "pattern de răspuns", "filtre profesionale", "profil slab conturat".
Vorbești despre ce arată rezultatele, nu declari cine este adolescentul.
Formulări preferate: "Rezultatele tale arată...", "Pare să conteze pentru tine...", "În acest moment se conturează...", "Merită explorată...", "Cele două rezultate apar împreună...".

INTENSITATE ȘI INCERTITUDINE
Rezultat clar -> formulare clară. Rezultat moderat -> formulare prudentă. Rezultate dispersate -> păstrează deschise mai multe posibilități.
Lipsa unei preferințe clare NU este un deficit. "Nicio preferință clară" înseamnă doar că acel criteriu nu diferențiază suficient opțiunile în acest moment.

CONVERGENȚE ȘI DIFERENȚE
Dacă două sau mai multe rezultate indică aceeași direcție, evidențiază convergența.
Dacă rezultatele aduc informații diferite, pune-le împreună fără să le numești automat contradicție.
Exemplu permis: "Îți place colaborarea, dar apare și o preferință pentru autonomie. Cele două pot coexista: poți aprecia să faci parte dintr-o echipă fără să îți dorești ca fiecare pas al muncii tale să fie decis împreună cu ceilalți."
Valoarea ta aici este tocmai identificarea și explicarea relațiilor dintre rezultatele celor trei instrumente.

LUNGIME
Nu scrie eseu și nu repeta feedbackurile individuale ale celor trei instrumente.

FORMAT DE RĂSPUNS PENTRU ACEASTĂ ETAPĂ:
{
  "profileLabel": null,
  "profileValue": null,
  "profileDescription": "2-4 propoziții — Ce iese în evidență",
  "items": [ { "title": "titlu scurt", "description": "2-4 propoziții", "level": null } ],
  "explorationAreas": ["Arie 1", "Arie 2"]
}
`;


/**
 * Module 1 is the only place where the person says, before any test, how
 * they see themselves. The journey reads as one story rather than five
 * tests in a row when the later syntheses come back to that starting
 * picture and show which measured results support it and which add a
 * nuance. Shared by the Module 5 synthesis and the final report; both
 * receive every answer tagged with its `moduleId`.
 */
const JOURNEY_THREAD_RULES = `
FIRUL PARCURSULUI (de la Modulul 1 la rezultatele de mai târziu):
- Fiecare răspuns are câmpul "moduleId". Răspunsurile din "module1" (de tip "text") sunt ce a spus utilizatorul spontan la începutul parcursului, înainte de orice test.
- Dacă în Modulul 1 apare o direcție (un domeniu, un rol, un tip de activitate, un context în care se vede), trateaz-o ca pe imaginea de pornire și urmărește-o prin rezultatele Modulelor 2-4: ce rezultate o susțin și prin ce anume, ce rezultate aduc o nuanță sau o tensiune.
- Numește concret rezultatele pe care te sprijini (de exemplu interesele vocaționale, un punct forte, stilul decizional, o preferință de mediu), nu scrie generic "rezultatele tale".
- Când rezultatele converg cu imaginea de pornire, spune-o clar. Când aduc altceva, prezintă diferența ca pe o nuanță care merită explorată, nu ca pe un verdict că imaginea de la început ar fi greșită, și nu o numi automat contradicție.
- Model de formulare: "La începutul parcursului te vedeai în... Pe parcurs, mai multe rezultate au susținut această imagine: ... În același timp, ... sugerează că..."
- Dacă răspunsurile din Modulul 1 nu conțin nicio direcție concretă, nu inventa una: spune pe scurt că parcursul a pornit deschis și arată ce direcții s-au conturat pe drum.
- Imaginea de pornire rămâne o direcție de explorat: nu o transforma în "profesia potrivită pentru tine" și nu promite reușita.
`;

const MODULE5_SYNTHESIS_RULES = `
REGULI SUPLIMENTARE PENTRU SINTEZA DIN MODULUL 5 ("Ce se vede când punem totul împreună"):
${JOURNEY_THREAD_RULES}
- "profileDescription" ("Pe scurt") începe cu acest fir, în 1-2 propoziții.
- Dacă Modulul 1 conține o direcție, primul element din "items" este dedicat firului (titlu scurt, de pildă "Imaginea de la început"); celelalte elemente acoperă restul reperelor. "level" este null.
`;

const SCOPE_HINTS = {
  module1: "Modulul 1 — trei răspunsuri deschise despre context, motivație și direcție. Nu există niciun test în spate: doar ce a scris el.",
  module2_stage1: "Modulul 2, Etapa 1 — preferințe: de unde își ia energia, cum adună informația, cum decide, cum își organizează viața.",
  module2_stage2: "Modulul 2, Etapa 2 — personalitate: deschidere, conștiinciozitate, extraversie, agreabilitate, stabilitate emoțională.",
  module2_stage3: "Modulul 2, Etapa 3 — stil cognitiv: cum învață, analizează și rezolvă probleme.",
  module2_stage4: "Modulul 2, Etapa 4 — stil decizional: ce îl ajută sau îl încurcă când ia decizii.",
  module2_stage5: "Modulul 2, Etapa 5 — tipare emoționale: cum reacționează sub presiune.",
  module2_stage6: "Modulul 2, Etapa 6 — control perceput: ce simte că poate influența.",
  module2_final: "Modulul 2 — sinteza celor 6 etape ale profilului psihologic.",
  module3_stage1: "Modulul 3, Etapa 1 — interese vocaționale: ce tipuri de activități și domenii îl atrag.",
  module3_stage2: "Modulul 3, Etapa 2 — preferințe de lucru: ritm, libertate, ghidaj.",
  module3_stage3: "Modulul 3, Etapa 3 — medii de lucru: în ce condiții îi place să lucreze (formal/informal, structurat/flexibil, competitiv/colaborativ, autonomie/supervizare, stabil/inovativ, predictibil/dinamic, ierarhic/egalitar).",
  module3_final: "Modulul 3 — sinteza celor trei instrumente: interese vocaționale, preferințe profesionale și medii de lucru. Primești doar rezultatele calculate și feedbackurile validate, nu răspunsurile brute.",
  module4_stage1: "Modulul 4, Etapa 1 — punctele forte: cele zece resurse scorate, din care ies în evidență cinci.",
  module4_stage2: "Modulul 4, Etapa 2 — aptitudini: cum se descurcă în diferite tipuri de sarcini.",
  module4_final: "Modulul 4 — sinteza punctelor forte și a aptitudinilor. Primești doar rezultatele calculate și feedbackurile validate, nu răspunsurile brute.",
  module5_synthesis: "Modulul 5 — sinteza întregului parcurs (Modulele 1-4): repere principale despre persoană și direcții de explorat.",
};

/** Per-scope rule packs appended to the shared insight system prompt. */
function insightSystemFor(scope) {
  if (scope === "module1") return `${INSIGHT_SYSTEM}\n${MODULE1_INSIGHT_RULES}`;
  if (scope === "module3_final") return `${INSIGHT_SYSTEM}\n${MODULE3_FINAL_RULES}`;
  if (scope === "module5_synthesis") return `${INSIGHT_SYSTEM}\n${MODULE5_SYNTHESIS_RULES}`;
  return INSIGHT_SYSTEM;
}

/**
 * JSON with object keys sorted at every level, so the same answers always
 * produce the same string — and the same hash — whatever order Firestore
 * happened to return a map's fields in.
 */
function canonicalJson(value) {
  if (Array.isArray(value)) return `[${value.map(canonicalJson).join(",")}]`;
  if (value && typeof value === "object") {
    return `{${Object.keys(value).sort().map((k) => `${JSON.stringify(k)}:${canonicalJson(value[k])}`).join(",")}}`;
  }
  return JSON.stringify(value);
}

/**
 * Where a generated insight is kept, keyed by everything that shaped it: the
 * model, the rules it was given, the scope and the exact answers. Same inputs, same document.
 *
 * Without this, every visit to a feedback screen asked the model again, and
 * identical answers could come back with a different conclusion each time —
 * relationships central in one run, autonomy in the next. A reader who sees
 * that trusts neither version, anyone can reload until they like the result,
 * and Module 5 and the report end up built on a version the user may never
 * have read. Now the first answer is the answer; only changed answers (a
 * retake, say) produce a new one.
 */
function insightCacheDoc(scope, answers) {
  const ordered = [...answers].sort((a, b) => String(a && a.questionKey).localeCompare(String(b && b.questionKey)));
  // The system prompt is part of the key: when the rules for a scope change,
  // feedback written under the old rules is not served again.
  const prompt = crypto.createHash("sha256").update(insightSystemFor(scope)).digest("hex");
  const hash = crypto.createHash("sha256").update(`${MODEL}:${prompt}:${scope}:${canonicalJson(ordered)}`).digest("hex");
  return db.collection("insightCache").doc(hash);
}

exports.generateInsight = region.runWith(RUNTIME).https.onCall(async (data, context) => {
  const scope = data && typeof data.scope === "string" ? data.scope : "";
  const answers = data && Array.isArray(data.answers) ? data.answers : [];
  if (!scope || answers.length === 0) {
    throw new functions.https.HttpsError("invalid-argument", "scope and non-empty answers are required.");
  }

  const cacheDoc = insightCacheDoc(scope, answers);
  const cached = await cacheDoc.get();
  if (cached.exists && cached.data().insight) return cached.data().insight;

  const hint = SCOPE_HINTS[scope] || scope;
  const userMsg = `Etapă: ${scope}\nContext: ${hint}\n\nRăspunsurile utilizatorului (JSON):\n${JSON.stringify(answers, null, 2)}`;

  let message;
  try {
    message = await client().messages.create({
      model: MODEL,
      max_tokens: 4000,
      thinking: { type: "adaptive" },
      system: insightSystemFor(scope),
      messages: [{ role: "user", content: userMsg }],
    });
  } catch (err) {
    throw new functions.https.HttpsError("internal", `Anthropic call failed: ${err.message}`);
  }
  await recordAiUsage(uidOf(context), anthropicUsage("generateInsight", scope, message));

  let parsed;
  try {
    parsed = parseJsonBlock(firstText(message));
  } catch (_) {
    throw new functions.https.HttpsError("internal", "Model output was not valid JSON.");
  }

  const items = Array.isArray(parsed.items) ? parsed.items : [];
  if (items.length === 0) {
    throw new functions.https.HttpsError("internal", "No insight items produced.");
  }

  // Module 1 has no scores and the Module 3 synthesis measures nothing, so
  // neither gets levels — enforced here as well as in the prompt, since a
  // single stray pill undoes the whole rule.
  const scored = scope !== "module1" && scope !== "module3_final";
  const allowed = scored ? new Set(["low", "medium", "high"]) : new Set();

  // Only the Module 3 synthesis has exploration areas, and 2-4 of them:
  // the spec is explicit that a fifth area would mean padding to a number.
  const areas = Array.isArray(parsed.explorationAreas)
    ? parsed.explorationAreas.map((a) => String(a || "").trim()).filter(Boolean).slice(0, 4)
    : [];
  if (scope === "module3_final" && areas.length < 2) {
    throw new functions.https.HttpsError("internal", "Module 3 synthesis needs 2-4 exploration areas.");
  }

  // Module 1 keeps its "profileValue" (a warm name for where the person is
  // right now); the Module 3 synthesis has no profile line at all.
  const noProfile = scope === "module3_final";

  const insight = {
    profileLabel: parsed.profileLabel == null || noProfile ? null : String(parsed.profileLabel),
    profileValue: parsed.profileValue == null || noProfile ? null : String(parsed.profileValue),
    profileDescription: parsed.profileDescription == null ? null : String(parsed.profileDescription),
    items: items.slice(0, 4).map((it) => ({
      title: String(it.title || ""),
      description: String(it.description || ""),
      level: allowed.has(it.level) ? it.level : null,
    })),
    explorationAreas: areas,
  };

  // Only a result that passed every check above is kept. A failed save is
  // not worth failing the request over: the user still gets this insight,
  // and the next visit simply generates and tries to keep one again.
  try {
    await cacheDoc.set({ scope, insight, createdAt: FieldValue.serverTimestamp() });
  } catch (err) {
    console.error("Could not cache insight", err);
  }
  return insight;
});

/**
 * Education advice depends on age: high-school profiles only make sense for
 * someone at the age of choosing a high school; older users get university,
 * vocational and alternative routes. Added to the user message of every
 * prompt that suggests studies or practical steps.
 */
function educationRulesFor(ageBracket) {
  const common = `TRASEU EDUCAȚIONAL ȘI PAȘI ADAPTAȚI VÂRSTEI:
- Pentru toți utilizatorii: prezinți facultățile, domeniile de studiu și formele de pregătire relevante pentru direcțiile profesionale.
- Recomandările educaționale sunt opțiuni, nu trasee obligatorii sau exclusive ("o variantă este...", "poți lua în calcul...").
- Pentru profesiile reglementate (de exemplu psiholog, medic, avocat, arhitect, profesor) precizezi cerințele obligatorii de calificare (diploma necesară, atestatul sau dreptul de liberă practică). Nu inventa detalii pe care nu le cunoști sigur.
- Pașii practici sunt adaptați vârstei: ce poate face concret, singur, cineva de vârsta lui.`;
  if (ageBracket === "14_15") {
    return `${common}
- Utilizatorul are 14-15 ani. Poți sugera și profiluri sau specializări de liceu potrivite direcțiilor, formulat condiționat ("dacă alegi liceul sau te gândești la profil..."), fără să presupui în ce clasă este sau ce nivel de studii are acum. Facultățile le prezinți ca orizont mai îndepărtat.`;
  }
  if (ageBracket === "16_17" || ageBracket === "18_plus") {
    return `${common}
- Utilizatorul are ${ageBracket === "16_17" ? "16-17 ani" : "18 ani sau peste"}. NU sugera profiluri sau specializări de liceu. Te concentrezi pe studii universitare, formare profesională (de exemplu școli postliceale), specializări, certificări și alternative de pregătire.`;
  }
  return `${common}
- Vârsta exactă nu este cunoscută: nu sugera profiluri de liceu; prezinți studii universitare, formare profesională și alternative, ca opțiuni.`;
}

async function ageBracketOf(uid) {
  if (!uid) return null;
  try {
    const snap = await db.collection("users").doc(uid).get();
    return snap.get("ageBracket") || null;
  } catch (_) {
    return null;
  }
}

const CAREER_PLAN_SYSTEM = `Ești consultant de orientare profesională pentru FutureMe, o aplicație de autocunoaștere în limba română pentru tineri (14-25 ani).

Primești rezultatele unui utilizator din Modulele 1-4: în "modulul1" ce a scris el la început, în "modulul2"-"modulul4" rezultatele calculate (profil psihologic, interese, puncte forte, aptitudini). Pe baza STRICTĂ a acestor răspunsuri, construiește o propunere de traseu profesional personalizată pentru Modulul 5.

Reguli:
- Limba română. Ton cald, orientativ ("poate avea sens", "merită explorat"). Nu inventa fapte despre utilizator dincolo de ce a scris.
${LANGUAGE_RULES}
- EXACT 5 direcții profesionale distincte în "directions".
  CUM LE ALEGI (criteriile rămân interne; utilizatorul nu vede nicio clasificare sau ierarhie):
  · fiecare direcție rezultă din analiza integrată a profilului, nu dintr-o listă generică: o susțin cel puțin două surse diferite (de exemplu interesele vocaționale, punctele forte sau aptitudinile, preferințele și mediile de lucru, profilul psihologic, imaginea din Modulul 1);
  · convergențele mai multor surse cântăresc mai mult decât un singur rezultat ridicat;
  · ține cont și de nepotriviri: nu propune o direcție pe care mai multe rezultate o contrazic clar;
  · cele 5 direcții sunt diferite între ele (nu variante ale aceleiași meserii) și acoperă combinațiile cele mai relevante din profil;
  · le ordonezi de la cea mai susținută de date la cea mai puțin susținută, dar nu exprimi această ordine în text.
  "description" spune concret din ce rezultate reiese direcția. NU scrie etichete de potrivire ("potrivire ridicată", "merită explorată", "de luat în calcul") nici în text, nici în alte câmpuri; la directions, "pillLabel" și "pillTone" sunt null.
- "aiImpact" are EXACT același număr de elemente ca "directions", în aceeași ordine, cu "title" identic cu direcția corespunzătoare. Prezinți AI-ul ca factor de transformare, nu ca amenințare inevitabilă.
  IMPACTUL SE JUDECĂ PE ACTIVITĂȚI CONCRETE, NU PE DENUMIREA DOMENIULUI:
  · în "description" numești activitățile concrete ale direcției care pot fi automatizate puternic (de exemplu producția de conținut standardizat, sortarea de date, redactarea de variante, prototipurile de rutină) și pe cele care rămân în principal umane (de exemplu strategia, înțelegerea publicului, relația cu oamenii, judecata, responsabilitatea editorială sau profesională, interpretarea în context);
  · "pillLabel" este EXACT una dintre: "Impact AI redus", "Impact AI moderat", "Impact AI ridicat", și urmează același criteriu la toate direcțiile: cât din munca de zi cu zi a direcției constă în activități ușor de automatizat. Ridicat = cea mai mare parte; moderat = o parte importantă, dar nucleul rămâne uman; redus = o parte mică. Eticheta trebuie să se vadă justificată de activitățile numite în descriere;
  · personalizare demonstrabilă: descrierea leagă impactul de profilul evaluat al persoanei, nu doar de domeniu — de exemplu ce punct forte, aptitudine, preferință sau interes al ei se află în partea care rămâne valoroasă sau ce ar merita dezvoltat. Numești concret rezultatul pe care te sprijini. O descriere care ar fi la fel pentru oricine este greșită;
  · "tags" ("Ce rămâne valoros"): 2-4 abilități care rămân valoroase în acea direcție, de preferință cele legate de profilul persoanei.
- 4-6 recomandări practice în "recommendations" despre cum să aleagă/testeze direcțiile. Fiecare are în "tags" 1-3 exemple concrete și scurte (2-5 cuvinte fiecare) de cum poate aplica recomandarea, legate de direcțiile lui (ex. "Un curs online de UX", "O discuție cu un psiholog școlar"). Niciodată o listă goală.
- EXACT 3 opțiuni în "training": una despre studii (după vârstă: profil de liceu și/sau facultate; vezi regulile despre vârstă din mesaj), una despre cursuri/certificări sau formare profesională, una despre experiență practică — personalizate pe direcțiile alese.
- NU construi planul în pași: utilizatorul alege mai întâi una dintre cele 5 direcții, iar planul se generează separat pentru ea.
- "pillTone" se completează automat; poți lăsa null.

Răspunde DOAR cu un obiect JSON valid, fără markdown și fără text în plus:
{
  "directions": [{ "title": "...", "description": "...", "pillLabel": null, "pillTone": null, "tags": ["...", "..."] }],
  "aiImpact": [{ "title": "...", "description": "...", "pillLabel": "Impact AI redus|Impact AI moderat|Impact AI ridicat", "pillTone": null, "tags": ["...", "..."] }],
  "recommendations": [{ "title": "...", "description": "...", "tags": ["...", "..."] }],
  "training": [{ "title": "...", "description": "...", "tags": ["...", "..."] }]
}`;

const ALLOWED_TONES = new Set(["primary", "warm", "subtle"]);

function cleanTaggedCard(raw) {
  return {
    title: String((raw && raw.title) || ""),
    description: String((raw && raw.description) || ""),
    pillLabel: raw && raw.pillLabel != null && raw.pillLabel !== "" ? String(raw.pillLabel) : null,
    pillTone: raw && ALLOWED_TONES.has(raw.pillTone) ? raw.pillTone : null,
    tags: raw && Array.isArray(raw.tags) ? raw.tags.map(String) : [],
  };
}

// Five directions with their AI impact, recommendations and training, plus
// the thinking before them, need room and time: the earlier 6000-token cap
// cut the answer off mid-JSON, and the app fell back to its example copy.
const CAREER_PLAN_RUNTIME = { secrets: ["ANTHROPIC_API_KEY"], timeoutSeconds: 300, memory: "1GB" };

exports.generateCareerPlan = region.runWith(CAREER_PLAN_RUNTIME).https.onCall(async (data, context) => {
  const uid = uidOf(context);
  // Signed in: the computed results read on the server, as for the final
  // report (Module 1's words, Module 2-4 results, never the raw items).
  // Otherwise the answers the app sent.
  let profile = null;
  let ageBracket = null;
  if (uid) {
    const collected = await collectReportData(uid);
    profile = collected.data;
    ageBracket = collected.ageBracket;
    delete profile.modulul5;
  }
  const answers = data && Array.isArray(data.answers) ? data.answers : [];
  if ((!profile || Object.keys(profile).length === 0) && answers.length === 0) {
    throw new functions.https.HttpsError("invalid-argument", "No results to build the plan from.");
  }
  const payload = profile && Object.keys(profile).length ? profile : answers;
  const userMsg = `${educationRulesFor(ageBracket)}\n\nRezultatele utilizatorului din Modulele 1-4 (JSON):\n${JSON.stringify(payload, null, 2)}`;

  let message;
  try {
    message = await client()
      .messages.stream({
        model: MODEL,
        max_tokens: 16000,
        thinking: { type: "adaptive" },
        system: CAREER_PLAN_SYSTEM,
        messages: [{ role: "user", content: userMsg }],
      })
      .finalMessage();
  } catch (err) {
    throw new functions.https.HttpsError("internal", `Anthropic call failed: ${err.message}`);
  }
  await recordAiUsage(uid, anthropicUsage("generateCareerPlan", null, message));
  if (message.stop_reason === "max_tokens") {
    console.error("Career plan cut off at max_tokens", message.usage);
    throw new functions.https.HttpsError("internal", "Career plan output was cut off.");
  }

  let parsed;
  try {
    parsed = parseJsonBlock(firstText(message));
  } catch (_) {
    throw new functions.https.HttpsError("internal", "Model output was not valid JSON.");
  }

  // No fit labels on the directions: the user can't see how a "high" or
  // "moderate" fit would be decided, so none is shown (the selection
  // criteria stay in the prompt). Exactly five, in the model's order.
  const directions = Array.isArray(parsed.directions)
    ? parsed.directions.slice(0, 5).map((d) => ({ ...cleanTaggedCard(d), pillLabel: null, pillTone: null }))
    : [];
  // One scale for every direction, and the colour follows the level, so a
  // label always means the same thing (the criterion is in the prompt).
  const AI_IMPACT_TONES = { "Impact AI redus": "primary", "Impact AI moderat": "warm", "Impact AI ridicat": "subtle" };
  const aiImpact = Array.isArray(parsed.aiImpact)
    ? parsed.aiImpact.slice(0, 5).map((raw) => {
        const card = cleanTaggedCard(raw);
        const label = card.pillLabel && AI_IMPACT_TONES[card.pillLabel.trim()] ? card.pillLabel.trim() : null;
        return { ...card, pillLabel: label, pillTone: label ? AI_IMPACT_TONES[label] : null };
      })
    : [];
  const recommendations = Array.isArray(parsed.recommendations)
    ? parsed.recommendations.map((r) => ({
        title: String((r && r.title) || ""),
        description: String((r && r.description) || ""),
        tags: r && Array.isArray(r.tags) ? r.tags.map(String).filter((t) => t.trim()) : [],
      }))
    : [];
  const training = Array.isArray(parsed.training) ? parsed.training.map(cleanTaggedCard) : [];

  if (
    directions.length !== 5 ||
    aiImpact.length < directions.length ||
    recommendations.length === 0 ||
    training.length !== 3
  ) {
    throw new functions.https.HttpsError("internal", "Career plan output did not match the expected shape.");
  }

  const result = {
    directions,
    aiImpact,
    recommendations,
    training,
    // Built afterwards, for the direction the user picks (generateDirectionPlan).
    plan: null,
  };

  // Kept so the final report builds on exactly what the user saw here. A
  // failed save doesn't fail the request: the report then picks its own
  // directions from the results.
  if (context && context.auth) {
    try {
      await db.collection("users").doc(context.auth.uid).collection("reports").doc("careerPlan")
        .set({ ...result, generatedAt: FieldValue.serverTimestamp() });
    } catch (err) {
      console.error("Could not save career plan", err);
    }
  }
  return result;
});

/**
 * The final report ("Raport personalizat de claritate profesională").
 *
 * Generated server-side from what is already stored — Module 1's own words,
 * the computed Module 2-4 results (never the raw answers) and the Module 5
 * career plan the user saw — and written to `users/{uid}/reports/finalReport`.
 * The app no longer has to wait on it: if the user leaves, the document
 * still reaches `status: 'ready'` and the Report tab picks it up.
 */
const REPORT_RUNTIME = { secrets: ["ANTHROPIC_API_KEY"], timeoutSeconds: 540, memory: "1GB" };

/** A 'generating' document older than this is a run that died; it may be restarted. */
const REPORT_STALE_MS = 10 * 60 * 1000;

/** Computed result documents per module, under neutral labels (no test names). */
const REPORT_RESULT_TYPES = {
  module2: {
    mbti_result: "preferinte_de_personalitate",
    big_five_result: "trasaturi_de_personalitate",
    cognitive_style_result: "stil_cognitiv",
    decision_style_result: "stil_decizional",
    emotional_patterns_result: "tipare_emotionale_sub_presiune",
    perceived_control_result: "control_perceput",
  },
  module3: {
    vocational_interests_result: "interese_vocationale",
    work_preferences_result: "preferinte_de_lucru",
    work_environments_result: "medii_de_lucru",
  },
  module4: {
    strengths_result: "puncte_forte_scorate",
    strengths_self_selection: "puncte_forte_in_care_se_recunoaste",
    aptitude_summary: "aptitudini",
  },
};

/** Raw answers, per-item data and bookkeeping — never sent to the model. */
const REPORT_DROP_KEYS = new Set([
  "answers", "recoded", "selected", "items", "displayOrder", "feedbackId", "feedbackIds",
  "version", "feedbackVersion", "scoringVersion", "totalSeconds", "timeLimitMinutes",
  "pilot", "finish", "tieBreak", "tieBreakChoices", "selfSelected",
]);

function stripForReport(value) {
  if (Array.isArray(value)) return value.map(stripForReport);
  if (value && typeof value === "object") {
    if (typeof value.toDate === "function") return undefined;
    const out = {};
    for (const [k, v] of Object.entries(value)) {
      if (REPORT_DROP_KEYS.has(k)) continue;
      const cleaned = stripForReport(v);
      if (cleaned !== undefined) out[k] = cleaned;
    }
    return out;
  }
  return value;
}

async function collectReportData(uid) {
  const userRef = db.collection("users").doc(uid);
  const progress = userRef.collection("moduleProgress");
  const [userSnap, planSnap, m1Snap] = await Promise.all([
    userRef.get(),
    userRef.collection("reports").doc("careerPlan").get(),
    progress.doc("module1").collection("answers").where("type", "==", "text").get(),
  ]);

  const data = {};
  const reflections = m1Snap.docs
    .map((d) => d.data())
    .filter((a) => typeof a.value === "string" && a.value.trim())
    .sort((a, b) => (a.questionNumber || 0) - (b.questionNumber || 0))
    .map((a) => ({ intrebarea: a.questionNumber || null, raspuns: a.value.trim() }));
  if (reflections.length) data.modulul1 = reflections;

  for (const [moduleId, types] of Object.entries(REPORT_RESULT_TYPES)) {
    const snap = await progress.doc(moduleId).collection("answers").where("type", "in", Object.keys(types)).get();
    const results = {};
    for (const doc of snap.docs) {
      const a = doc.data();
      results[types[a.type]] = stripForReport(a.value);
    }
    if (Object.keys(results).length) data[`modulul${moduleId.slice(-1)}`] = results;
  }

  const plan = planSnap.exists ? planSnap.data() : null;
  if (plan && Array.isArray(plan.directions) && plan.directions.length) {
    data.modulul5 = {
      directions: plan.directions.map((d) => ({ title: d.title, description: d.description, tags: d.tags })),
      aiImpact: plan.aiImpact,
      recommendations: plan.recommendations,
      training: plan.training,
      plan: plan.plan,
    };
  }

  const displayName = String(userSnap.get("displayName") || "").trim();
  return {
    data,
    displayName: displayName || null,
    firstName: displayName.split(/\s+/)[0] || null,
    ageBracket: userSnap.get("ageBracket") || null,
    planDirections: data.modulul5 ? data.modulul5.directions : null,
  };
}

/** Section order and headings, exactly as the report structure document (the audio section is left out for now). */
const REPORT_BLOCKS = [
  { key: "introduction", title: "Introducere", text: true },
  {
    key: "quickSummary",
    title: "Sinteză rapidă",
    items: [["who", "Cine ești profesional"], ["motivates", "Ce te motivează"], ["blocks", "Ce te blochează acum"], ["direction", "Direcția generală recomandată"]],
  },
  {
    key: "psychProfile",
    title: "Profil psihologic și decizional",
    items: [
      ["thinking", "Cum gândești și procesezi informația"],
      ["decisions", "Cum iei decizii"],
      ["pressure", "Cum reacționezi sub presiune"],
      ["control", "Relația ta cu controlul"],
      ["strengths", "Puncte forte psihologice"],
      ["sensitive", "Zone sensibile"],
    ],
  },
  {
    key: "interests",
    title: "Interese și vocație",
    items: [
      ["activities", "Tipuri de activități care ți se potrivesc"],
      ["authentic", "Ce te atrage autentic și ce poate fi condiționat"],
      ["compatible", "Medii de lucru compatibile"],
      ["draining", "Medii care te consumă"],
    ],
  },
  {
    key: "aptitudes",
    title: "Aptitudini și puncte forte",
    items: [["natural", "Aptitudini evidențiate în probe"], ["developed", "Competențe dezvoltate"], ["performance", "Zone de performanță"], ["burnout", "Riscuri de epuizare"]],
  },
  { key: "keyInsights", title: "5 lucruri importante de reținut despre tine", insights: true },
  { key: "directions", title: "Direcții profesionale recomandate", directions: true },
  {
    key: "aiImpact",
    title: "Impactul AI asupra direcțiilor tale",
    items: [["risk", "Nivel de risc"], ["adaptability", "Nivel de adaptabilitate"], ["futureProof", "Competențe „future-proof”"], ["stayRelevant", "Cum poți rămâne relevant"]],
  },
  {
    key: "training",
    title: "Opțiuni academice și de formare",
    items: [["studies", "Tipuri de studii potrivite"], ["certifications", "Mastere și certificări"], ["learningStyle", "Stil de învățare recomandat"], ["notSuitable", "Ce nu e potrivit pentru tine"]],
  },
  {
    key: "plan",
    title: "Planul tău de pași",
    items: [
      ["step1", "Pasul 1 · Claritate imediată"],
      ["step2", "Pasul 2 · Explorare"],
      ["step3", "Pasul 3 · Decizie"],
      ["step4", "Pasul 4 · Acțiune"],
      ["step5", "Pasul 5 · Ajustare"],
    ],
  },
  { key: "finalMessage", title: "Mesaj final", text: true },
];

const DIRECTION_POINTS = [["whyFits", "De ce ți se potrivește"], ["offers", "Ce îți oferă"], ["consider", "Ce să ai în vedere"]];

const REPORT_DISCLAIMER_TITLE = "Disclaimer profesional";
const REPORT_DISCLAIMER =
  "Acest raport este un instrument de orientare și autocunoaștere. Nu este un diagnostic psihologic și nu înlocuiește consilierea, psihoterapia sau evaluarea unui specialist. Rezultatele descriu tendințe și preferințe la momentul completării și se pot schimba în timp. Folosește-l ca punct de plecare pentru reflecție și discuții, nu ca verdict despre cine ești sau ce poți deveni.";

const FINAL_REPORT_SYSTEM = `Ești redactor de rapoarte pentru FutureMe, o aplicație de autocunoaștere în limba română pentru tineri (14-25 ani).

Scrii raportul final personalizat de claritate profesională: documentul pe care utilizatorul îl descarcă, îl păstrează și îl recitește. Primești:
- "modulul1": ce a scris utilizatorul spontan la începutul parcursului, înainte de orice test (răspunsuri deschise);
- "modulul2", "modulul3", "modulul4": rezultatele calculate ale etapelor, fără răspunsurile brute;
- "modulul5": direcțiile, impactul AI, recomandările, opțiunile de formare și planul pe care utilizatorul le-a văzut deja în Modulul 5 (poate lipsi).

Scrii STRICT pe baza acestor date. Nu inventa fapte despre persoană. Dacă datele nu acoperă un subpunct, spune asta pe scurt și onest (de exemplu că parcursul nu a măsurat direct acel aspect) și, dacă are sens, ce ar putea observa singur; nu umple golul cu presupuneri.

Ton: cald, uman, explicativ, non-clinic. Fără scoruri brute: nu scrie numere de scor, medii sau puncte, ci tradu-le în cuvinte. Fără diagnostice și fără etichete. Te adresezi direct, la persoana a doua singular. Dacă ai prenumele, îl poți folosi în introducere și în mesajul final, nu mai des.
${LANGUAGE_RULES}
${JOURNEY_THREAD_RULES}
În datele acestui raport, răspunsurile din Modulul 1 se află în "modulul1" (echivalentul lui "moduleId": "module1"). Firul apare pe scurt în "quickSummary.direction" și dezvoltat în "whyFits" al direcțiilor; celelalte secțiuni pot face trimiteri scurte la el, fără să repete aceeași idee.

CONSECVENȚA CU MODULUL 5 (obligatoriu când "modulul5" există):
- "directions" conține EXACT 5 direcții. Primele sunt direcțiile din "modulul5.directions", în aceeași ordine și cu "title" identic: le dezvolți, nu le schimbi și nu le reordonezi. Dacă "modulul5.directions" are mai puțin de 5, completezi până la 5 cu direcții care rezultă din aceleași date.
- "aiImpact" se sprijină pe "modulul5.aiImpact"; "training" pe "modulul5.training" și "modulul5.recommendations"; "plan" dezvoltă "modulul5.plan" (aceeași direcție de pornire și aceiași pași, repartizați pe cele 5 etape de mai jos). Nimic din raport nu contrazice ce a văzut deja.
Dacă "modulul5" lipsește, alegi singur 5 direcții flexibile, din date.

ROLUL TĂU: INTEGREZI, NU REINTERPRETEZI.
Regula supremă: nu spune din nou ce spun rezultatele; spune ce devine vizibil atunci când rezultatele sunt puse împreună.
- Instrumentele au măsurat și au interpretat deja. Tu le pui în relație, explici și transformi rezultatele în direcție. Nu construiești un profil paralel și nu reinterpretezi testele de la zero.
- Lanțul obligatoriu este: rezultat → convergență → explicație posibilă → lucru de verificat. Niciodată: rezultat → poveste despre persoană. Nu inventa psihologie între date.
- Convergențe: când aceeași caracteristică apare din surse diferite (de exemplu interese, puncte forte și preferințe de lucru), evidențiaz-o ca element important al profilului și numește sursele care o susțin; un singur scor nu ajunge pentru o concluzie importantă.
- Contradicții: nu le ascunde și nu decide arbitrar care rezultat este „adevărat”. Explică faptul că instrumentele pot surprinde aspecte diferite și transformă contradicția într-o întrebare utilă: ce merită observat în viața reală.
- Aptitudinile din Modulul 4 sunt măsurate prin performanță într-o probă: aduc alt tip de informație decât autoevaluarea („eu cred despre mine că…”), iar diferența trebuie să rămână vizibilă. Fiind o probă scurtă, este o observație, nu un verdict; iar o aptitudine bună nu devine automat o recomandare profesională.
- Imaginea de la început (Modulul 1) nu se pierde: confrunt-o cu ce a apărut ulterior în profil — unde există potrivire, unde există tensiune, ce merită explorat.
- Raportul trebuie să fie al acestei persoane: dacă textul ar funcționa la fel de bine și cu numele altcuiva, este prea generic. Fiecare afirmație importantă se sprijină pe rezultatele lui concrete.

FĂRĂ REPETIȚII.
Nu relua aceeași caracteristică în fiecare secțiune doar pentru că este relevantă. După ce ai explicat o trăsătură (de exemplu creativitatea), o reiei mai târziu doar dacă aduce o conexiune nouă: cu o aptitudine, cu un mediu de lucru, cu o direcție profesională sau cu o posibilă contradicție; atunci spune direct conexiunea, fără să reexplici trăsătura. Raportul trebuie să evolueze de la o secțiune la alta, nu să reformuleze aceeași informație.

STRUCTURA. Fiecare câmp este text simplu: fără markdown, fără liste cu liniuțe, fără titluri în text (titlurile sunt adăugate automat). Dacă nu e precizat altfel, 2-5 propoziții pe subpunct.
- "summary": 1-2 propoziții, rezumatul întregului raport.
- "introduction": un paragraf de 4-6 propoziții: bun venit personalizat; reafirmă că raportul nu este un diagnostic și nici o etichetă, ci un instrument de claritate.
- "quickSummary" (se citește în 2 minute): "who" cine ești profesional (3-4 rânduri); "motivates" ce te motivează; "blocks" ce te blochează acum, formulat blând; "direction" direcția generală recomandată.
- "psychProfile" (din Modulul 2; explicativ, uman): "thinking" cum gândești și procesezi informația; "decisions" cum iei decizii; "pressure" cum reacționezi sub presiune; "control" relația ta cu controlul; "strengths" puncte forte psihologice; "sensitive" zone sensibile, formulate blând, ca zone de atenție, nu ca defecte.
- "interests" (din Modulul 3; limbaj concret, nu teorie): "activities" tipuri de activități care ți se potrivesc; "authentic" ce te atrage autentic și ce poate fi mai degrabă condiționat (așteptări, presiuni, imagine); dacă datele nu permit distincția, spune ce ar merita observat; "compatible" medii de lucru compatibile; "draining" medii care te consumă.
- "aptitudes" (din Modulul 4; pentru alegeri realiste, nu idealizate): "natural" aptitudinile evidențiate în probele de aptitudini (performanța observată la anumite sarcini; nu afirma că ar fi înnăscute — probele nu stabilesc cât este înnăscut și cât este dobândit); "developed" competențe dezvoltate; "performance" zone de performanță; "burnout" riscuri de epuizare. Punctele forte vin din autoevaluare; aptitudinile vin din performanța într-o probă scurtă: spune explicit această diferență acolo unde contează, fără să transformi o aptitudine bună într-o recomandare de carieră.
- "keyInsights" („5 lucruri importante de reținut despre tine”, momentul de integrare de la finalul profilului): EXACT 5 obiecte { "title", "text" }. Fiecare răspunde la întrebarea: „După tot ce am parcurs, ce merită cu adevărat să înțeleg despre mine?” și spune ceva ce persoana probabil nu ar fi putut formula singură uitându-se separat la rezultate.
  "title" este concluzia însăși, într-o propoziție (de exemplu „Nu trebuie să alegi între oameni și gândirea analitică.”); "text" are 2-4 propoziții: din ce rezultate, combinate, reiese și ce înseamnă concret pentru alegerile lui (ce merită explorat, comparat sau verificat).
  Fiecare concluzie combină cel puțin două instrumente. NU sunt cele mai mari 5 scoruri și nici 5 trăsături izolate. Caută convergențe, contraste și combinații care spun ceva nou: la unul poate conta o contradicție, la altul o convergență între trei rezultate, o aptitudine neașteptată, diferența dintre ce își dorește și mediul în care funcționează, sau felul în care trece de la opțiune la decizie. Nu folosi aceeași schemă la toți utilizatorii.
  Aici ai voie să reiei trăsături din secțiunile anterioare, pentru că le combini într-o idee nouă; nu le reexplica.
- "directions": EXACT 5 obiecte { "title", "whyFits", "offers", "consider" }. Direcții flexibile, piste de explorat, nu verdicte și nici titluri rigide de job: nu scrie „aceasta este profesia ta”, ci de ce merită explorată și ce trebuie aflat înainte de a decide.
  "whyFits": de ce a apărut direcția și ce elemente concrete din profil o susțin. "offers": ce îi poate oferi. "consider": nepotrivirile și fricțiunile — ce rezultate nu o susțin sau o contrazic (de exemplu raționament spațial bun, dar interes tehnic scăzut) și ce trebuie verificat concret înainte de o decizie. Caută și argumentele contra, nu doar confirmări.
- "aiImpact": "risk" nivelul de risc (cum poate schimba AI aceste direcții, cu referire la ele); "adaptability" nivelul de adaptabilitate; "futureProof" competențele greu de înlocuit; "stayRelevant" cum poți rămâne relevant, concret.
- "training": "studies" tipuri de studii potrivite; "certifications" mastere și certificări; "learningStyle" stilul de învățare recomandat; "notSuitable" ce nu e potrivit pentru tine, formulat ca ce probabil te-ar consuma, nu ca interdicție.
- "plan": 5 pași realiști, etapizați, fără presiune, fiecare cu o perioadă orientativă în text: "step1" claritate imediată; "step2" explorare; "step3" decizie; "step4" acțiune; "step5" ajustare. Pașii rezultă din profilul lui, nu sunt un final generic: răspund la ce îl poate bloca (de exemplu, la cineva care tinde să amâne, explorarea are termene și o decizie provizorie). Raportul se termină în explorare și acțiune, nu în etichetare: persoana pleacă cu ceva de făcut, nu doar cu ceva de citit.
- "finalMessage": un paragraf de 4-6 propoziții de închidere: reafirmă resursele lui, normalizează incertitudinea, transmite încredere în proces. Fără promisiuni de reușită.
Nu scrie disclaimer: este adăugat automat.

Răspunde DOAR cu un obiect JSON valid, fără markdown și fără text în plus:
{
  "summary": "...",
  "introduction": "...",
  "quickSummary": { "who": "...", "motivates": "...", "blocks": "...", "direction": "..." },
  "psychProfile": { "thinking": "...", "decisions": "...", "pressure": "...", "control": "...", "strengths": "...", "sensitive": "..." },
  "interests": { "activities": "...", "authentic": "...", "compatible": "...", "draining": "..." },
  "aptitudes": { "natural": "...", "developed": "...", "performance": "...", "burnout": "..." },
  "keyInsights": [{ "title": "...", "text": "..." }],
  "directions": [{ "title": "...", "whyFits": "...", "offers": "...", "consider": "..." }],
  "aiImpact": { "risk": "...", "adaptability": "...", "futureProof": "...", "stayRelevant": "..." },
  "training": { "studies": "...", "certifications": "...", "learningStyle": "...", "notSuitable": "..." },
  "plan": { "step1": "...", "step2": "...", "step3": "...", "step4": "...", "step5": "..." },
  "finalMessage": "..."
}`;

function reportText(v) {
  return typeof v === "string" ? v.trim() : "";
}

/**
 * Turns the model's JSON into the stored blocks ({title, items:[{heading,
 * text, points}]}); throws if a section is missing or the directions drift
 * from the ones the user saw in Module 5.
 */
function assembleReport(parsed, planDirections) {
  const blocks = [];
  for (const def of REPORT_BLOCKS) {
    const raw = parsed[def.key];
    let items;
    if (def.text) {
      const text = reportText(raw);
      items = text ? [{ heading: null, text, points: [] }] : [];
    } else if (def.insights) {
      const list = Array.isArray(raw) ? raw : [];
      items = list
        .map((it) => ({ title: reportText(it && it.title), text: reportText(it && it.text) }))
        .filter((it) => it.title && it.text)
        .slice(0, 5)
        .map((it, i) => ({ heading: `${i + 1}. ${it.title}`, text: it.text, points: [] }));
      if (items.length < 5) throw new Error(`Expected 5 key insights, got ${items.length}.`);
    } else if (def.directions) {
      const list = Array.isArray(raw) ? raw : [];
      // Always five: the Module 5 directions first (their titles kept as the
      // user saw them), completed from the data when an older plan had fewer.
      if (list.length < 5) throw new Error(`Expected 5 directions, got ${list.length}.`);
      items = list.slice(0, 5).map((d, i) => ({
        heading: planDirections && planDirections[i] ? String(planDirections[i].title || "") : reportText(d && d.title),
        text: "",
        points: DIRECTION_POINTS.map(([k, label]) => ({ label, text: reportText(d && d[k]) })).filter((p) => p.text),
      }));
      if (items.some((it) => !it.heading || it.points.length === 0)) {
        throw new Error("Directions are incomplete.");
      }
    } else {
      items = def.items.map(([k, heading]) => ({ heading, text: reportText(raw && raw[k]), points: [] })).filter((it) => it.text);
      if (items.length < Math.ceil(def.items.length / 2)) throw new Error(`Section ${def.key} is incomplete.`);
    }
    if (items.length === 0) throw new Error(`Section ${def.key} is empty.`);
    blocks.push({ key: def.key, title: def.title, items });
  }
  blocks.push({ key: "disclaimer", title: REPORT_DISCLAIMER_TITLE, items: [{ heading: null, text: REPORT_DISCLAIMER, points: [] }] });
  return blocks;
}

/** The same blocks as plain {title, body} sections, for the in-app preview and the chat. */
function flattenReport(blocks) {
  return blocks.map((b) => ({
    title: b.title,
    body: b.items
      .map((it) => {
        const parts = [];
        if (it.heading) parts.push(it.heading);
        if (it.text) parts.push(it.text);
        for (const p of it.points) parts.push(`${p.label}: ${p.text}`);
        return parts.join("\n");
      })
      .join("\n\n"),
  }));
}

exports.generateFinalReport = region.runWith(REPORT_RUNTIME).https.onCall(async (_data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Sign in first.");
  }
  const uid = context.auth.uid;
  const userRef = db.collection("users").doc(uid);
  const reportRef = userRef.collection("reports").doc("finalReport");

  const m4 = await userRef.collection("moduleProgress").doc("module4").get();
  if (!m4.exists || m4.get("status") !== "completed") {
    throw new functions.https.HttpsError("failed-precondition", "Modules 1-4 must be completed first.");
  }

  // One run at a time: a second call while one is working just reports it.
  const started = await db.runTransaction(async (tx) => {
    const snap = await tx.get(reportRef);
    const current = snap.exists ? snap.data() : {};
    const startedAt = current.startedAt && typeof current.startedAt.toMillis === "function" ? current.startedAt.toMillis() : 0;
    if (current.status === "generating" && Date.now() - startedAt < REPORT_STALE_MS) return false;
    tx.set(reportRef, { status: "generating", startedAt: Timestamp.now() }, { merge: true });
    return true;
  });
  if (!started) return { status: "generating" };

  try {
    const { data, displayName, firstName, planDirections, ageBracket } = await collectReportData(uid);
    const userMsg = `Prenume: ${firstName || "necunoscut"}\n\n${educationRulesFor(ageBracket)}\n\nDatele parcursului (JSON):\n${JSON.stringify(data, null, 2)}`;

    const message = await client()
      .messages.stream({
        model: MODEL,
        max_tokens: 24000,
        thinking: { type: "adaptive" },
        system: FINAL_REPORT_SYSTEM,
        messages: [{ role: "user", content: userMsg }],
      })
      .finalMessage();
    await recordAiUsage(uid, anthropicUsage("generateFinalReport", null, message));

    const parsed = parseJsonBlock(firstText(message));
    const blocks = assembleReport(parsed, planDirections);
    const report = {
      userName: displayName,
      summary: reportText(parsed.summary) || null,
      sections: flattenReport(blocks),
      blocks,
    };

    await reportRef.set({
      status: "ready",
      ...report,
      usedCareerPlan: Boolean(planDirections),
      generatedAt: FieldValue.serverTimestamp(),
      completedAt: FieldValue.serverTimestamp(),
      error: FieldValue.delete(),
    }, { merge: true });

    return { status: "ready", ...report };
  } catch (err) {
    console.error("Final report generation failed", err);
    await reportRef.set({ status: "failed", error: String(err && err.message ? err.message : err).slice(0, 300) }, { merge: true });
    throw new functions.https.HttpsError("internal", "Final report generation failed.");
  }
});

/**
 * Module 5's plan, for the one direction the user chose among the five.
 *
 * Built from the same stored data as the final report (Module 1's words and
 * the computed Module 2-4 results) plus the chosen direction, and saved into
 * `reports/careerPlan` next to the directions, so the dashboard and the
 * final report use the plan the user saw.
 */
const DIRECTION_PLAN_SYSTEM = `Ești consultant de orientare profesională pentru FutureMe, o aplicație de autocunoaștere în limba română pentru tineri (14-25 ani).

Utilizatorul a ales o direcție profesională dintre cele propuse. Construiești planul lui de pași pentru ACEA direcție, pe baza profilului lui ("modulul1"-"modulul4") și a direcției alese.
${LANGUAGE_RULES}
REGULI:
- Planul este SPECIFIC PROFESIEI alese, nu un plan general de orientare. Fiecare acțiune trebuie să aibă sens doar pentru această direcție. Greșit: "Uită-te la proiecte reale", "Caută un curs introductiv". Corect pentru UX Design: "Alege o aplicație pe care o folosești zilnic, analizează un ecran care te încurcă și propune o variantă îmbunătățită".
- Acțiunile sunt exerciții concrete, realizabile de un tânăr de 14-25 de ani, cu resurse accesibile sau gratuite, fără să presupună bani, angajare sau acces la companii.
- Leagă acțiunile de profilul lui acolo unde datele permit: un punct forte sau o aptitudine pe care o poate folosi, o preferință de lucru de care să țină cont, ceva ce merită verificat. Numești concret rezultatul, fără să-l repeți pe larg.
- Ton cald, fără presiune: este un plan de explorare, nu un angajament.
- EXACT 3 pași în "steps", în această ordine, cu aceste titluri: "Explorează", "Testează", "Clarifică". Perioade realiste în "periodLabel" (de exemplu "2-4 săptămâni", "1-3 luni", "3-6 luni").
  "Explorează": cum arată munca reală în această profesie (activități, oameni, produse concrete ale domeniului).
  "Testează": cel puțin un exercițiu practic, un mini-proiect pe care îl face singur și care seamănă cu munca reală din domeniu.
  "Clarifică": cum își evaluează ce a observat (ce l-a energizat, ce l-a consumat, ce i-a ieșit) și ce decide mai departe.
  Fiecare pas: "description" de 1-2 propoziții și "checklist" cu 2-3 acțiuni concrete, scurte (cel mult 15 cuvinte fiecare).
- "directionDescription": 1-2 propoziții despre de ce această direcție are sens pentru el, din rezultatele lui concrete.
- "firstStepTitle" + "firstStepDescription": prima acțiune concretă pe care o poate face în următoarele 7 zile, specifică profesiei.

Răspunde DOAR cu un obiect JSON valid, fără markdown și fără text în plus:
{
  "directionDescription": "...",
  "firstStepTitle": "...",
  "firstStepDescription": "...",
  "steps": [{ "title": "Explorează", "periodLabel": "...", "description": "...", "checklist": ["...", "..."] }]
}`;

exports.generateDirectionPlan = region.runWith(CAREER_PLAN_RUNTIME).https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Sign in first.");
  }
  const uid = context.auth.uid;
  const directionTitle = String((data && data.directionTitle) || "").trim();
  if (!directionTitle || directionTitle.length > 200) {
    throw new functions.https.HttpsError("invalid-argument", "directionTitle is required.");
  }

  // A plan already built for this direction in this journey is reused:
  // coming back to the same direction must not produce a different plan.
  // (generateCareerPlan rewrites the document at the start of a journey,
  // which clears these.)
  const planRef = db.collection("users").doc(uid).collection("reports").doc("careerPlan");
  const planSnap = await planRef.get();
  const savedPlans = (planSnap.exists && planSnap.get("directionPlans")) || {};
  if (savedPlans[directionTitle]) {
    const saved = savedPlans[directionTitle];
    await planRef.set({ plan: saved, chosenDirection: directionTitle }, { merge: true });
    return saved;
  }

  const { data: profile, ageBracket } = await collectReportData(uid);
  const directions = (profile.modulul5 && profile.modulul5.directions) || [];
  const chosen = directions.find((d) => d.title === directionTitle) || { title: directionTitle };
  // The plan is built from the profile and the chosen direction only.
  delete profile.modulul5;

  const userMsg = `${educationRulesFor(ageBracket)}\n\nDirecția aleasă (JSON):\n${JSON.stringify(chosen, null, 2)}\n\nProfilul utilizatorului (JSON):\n${JSON.stringify(profile, null, 2)}`;

  let message;
  try {
    message = await client().messages.create({
      model: MODEL,
      max_tokens: 12000,
      thinking: { type: "adaptive" },
      system: DIRECTION_PLAN_SYSTEM,
      messages: [{ role: "user", content: userMsg }],
    });
  } catch (err) {
    throw new functions.https.HttpsError("internal", `Anthropic call failed: ${err.message}`);
  }
  await recordAiUsage(uid, anthropicUsage("generateDirectionPlan", null, message));
  if (message.stop_reason === "max_tokens") {
    throw new functions.https.HttpsError("internal", "Direction plan output was cut off.");
  }

  let parsed;
  try {
    parsed = parseJsonBlock(firstText(message));
  } catch (_) {
    throw new functions.https.HttpsError("internal", "Model output was not valid JSON.");
  }

  const STEP_TITLES = ["Explorează", "Testează", "Clarifică"];
  const rawSteps = Array.isArray(parsed.steps) ? parsed.steps.slice(0, 3) : [];
  const steps = rawSteps.map((s, i) => ({
    title: STEP_TITLES[i],
    periodLabel: String((s && s.periodLabel) || ""),
    description: String((s && s.description) || ""),
    checklist: s && Array.isArray(s.checklist) ? s.checklist.map(String).filter((c) => c.trim()).slice(0, 3) : [],
  }));
  if (steps.length !== 3 || steps.some((s) => !s.description || s.checklist.length < 2) || !parsed.firstStepDescription) {
    throw new functions.https.HttpsError("internal", "Direction plan output did not match the expected shape.");
  }

  const plan = {
    directionTitle: chosen.title,
    directionDescription: String(parsed.directionDescription || chosen.description || ""),
    firstStepTitle: String(parsed.firstStepTitle || "Primul pas"),
    firstStepDescription: String(parsed.firstStepDescription),
    steps,
  };

  try {
    await db.collection("users").doc(uid).collection("reports").doc("careerPlan")
      .set({ plan, chosenDirection: chosen.title, directionPlans: { [directionTitle]: plan }, planGeneratedAt: FieldValue.serverTimestamp() }, { merge: true });
  } catch (err) {
    console.error("Could not save direction plan", err);
  }
  return plan;
});

/**
 * The spoken summary of a result screen.
 *
 * The screens' written feedback is validated FutureMe copy and reading all
 * of it aloud runs long — a full result is several minutes of speech, and
 * by the third dimension nobody is still listening. So the model condenses
 * what the screen already decided to show into one paragraph written for
 * the ear, which is then spoken in the app's cloned voice.
 *
 * It receives the assembled feedback text, never the raw answers, and it
 * may not add, re-score or re-interpret anything: everything in the summary
 * has to be in the text it was given.
 *
 * Summaries are cached in Firestore by SHA-256 of that text, the same way
 * `synthesizeSpeech` caches its audio. Without it a second tap would
 * produce slightly different wording, miss the audio cache, and bill both
 * the model and the voice again for the same result.
 */
const SPOKEN_SUMMARY_SYSTEM = `Ești vocea aplicației FutureMe, o aplicație de autocunoaștere în limba română pentru tineri (14-25 ani).

Primești textul complet al unui ecran de rezultat — feedback deja validat de FutureMe. Scrii un REZUMAT VORBIT al acestui text, care va fi citit cu voce tare.

Reguli:
- Limba română. Te adresezi direct, cu "tu". Ton cald, firesc, fără jargon psihologic.
- 150-220 de cuvinte, adică circa un minut de vorbire.
- Un text curgător, de unul sau două paragrafe. Fără liste, fără titluri, fără enumerări cu bulină.
- Acoperi TOT textul: fiecare dimensiune, zonă sau secțiune din el apare în rezumat, cel puțin cu o propoziție scurtă, în ordinea din text. Nu te opri după primele părți. Apoi închei cu ideea principală care se desprinde din ansamblu.
- Rezumatul se termină cu o propoziție completă.
- REZUMI. Nu adaugi nimic: nicio interpretare nouă, nicio trăsătură, niciun sfat care nu se află deja în textul primit. Dacă o idee nu apare în text, nu o spui.
- Nu recalculezi și nu contrazici nimic din text. Păstrezi nuanțele lui: dacă textul spune "pare", spui și tu "pare".
- Nu numi niciodată testele sau modelele din spatele rezultatelor ("MBTI", "Big Five", "RIASEC" etc.), chiar dacă apar în text; vorbește despre preferințe, personalitate, interese.
- Textul va fi rostit, nu citit. Nu folosi cifre, scoruri, procente, simboluri, paranteze, prescurtări sau semne precum "+", "·", "/". Scrie totul în cuvinte.
- Nu începe cu "Iată un rezumat" sau formulări similare. Intri direct în conținut.
- Nu închei cu îndemnuri de tipul "apasă mai departe" sau "citește mai jos".

Răspunde DOAR cu textul rezumatului, fără ghilimele și fără markdown.`;

exports.generateSpokenSummary = region.runWith(RUNTIME).https.onCall(async (data, context) => {
  const scope = data && typeof data.scope === "string" ? data.scope : "";
  const text = data && typeof data.text === "string" ? data.text.trim() : "";
  if (!text) {
    throw new functions.https.HttpsError("invalid-argument", "text is required.");
  }
  if (text.length > 20000) {
    throw new functions.https.HttpsError("invalid-argument", "text exceeds 20000 characters.");
  }

  // "v2": summaries cached before this version could be cut off mid-word
  // (thinking used up the token budget); they are not reused.
  const hash = crypto.createHash("sha256").update(`v2:${MODEL}:${scope}:${text}`).digest("hex");
  const doc = db.collection("spokenSummaries").doc(hash);

  const cached = await doc.get();
  if (cached.exists && cached.data().summary) {
    return { summary: cached.data().summary };
  }

  const hint = SCOPE_HINTS[scope] || scope;
  const userMsg = `Ecran: ${scope}\nContext: ${hint}\n\nTextul integral al rezultatului:\n${text}`;

  let message;
  try {
    message = await client().messages.create({
      model: MODEL,
      // No extended thinking: a summary doesn't need it, it made the call too
      // slow for the app's wait, and it could use up the token budget so the
      // text came back cut off in the middle of a word.
      max_tokens: 1500,
      system: SPOKEN_SUMMARY_SYSTEM,
      messages: [{ role: "user", content: userMsg }],
    });
  } catch (err) {
    throw new functions.https.HttpsError("internal", `Anthropic call failed: ${err.message}`);
  }
  await recordAiUsage(uidOf(context), anthropicUsage("generateSpokenSummary", scope, message));

  const summary = firstText(message).trim();
  if (!summary) {
    throw new functions.https.HttpsError("internal", "Empty summary produced.");
  }
  // A summary that ran out of tokens ends mid-sentence; never keep or speak it.
  if (message.stop_reason === "max_tokens") {
    throw new functions.https.HttpsError("internal", "Summary was cut off.");
  }

  await doc.set({ scope, summary, createdAt: FieldValue.serverTimestamp() });
  return { summary };
});
