/// The sixteen fixed MBTI profiles shown at the end of Module 2, Stage 1.
///
/// These are the counsellor's own texts, reproduced as written. Nothing here
/// is generated: the four letters computed in `mbti.dart` select one entry
/// and that entry is displayed verbatim, so two people with the same type
/// read the same profile. Personalisation happens later, when the final
/// report crosses this result with the other modules.
library;

class MbtiProfile {
  const MbtiProfile({
    required this.code,
    required this.title,
    required this.description,
    required this.watchOuts,
  });

  /// The four-letter type, e.g. "ESTP".
  final String code;

  /// The expanded form, e.g. "Extravertit, Senzorial, Gânditor, Perceptiv".
  final String title;

  /// The profile itself, one string per paragraph.
  final List<String> description;

  /// The "Posibile puncte nevralgice" section, one string per paragraph.
  final List<String> watchOuts;
}

const String mbtiWatchOutsHeading = "Posibile puncte nevralgice";

/// Keyed by the four-letter code produced by `scoreMbti`.
const Map<String, MbtiProfile> mbtiProfiles = {
  "ENFJ": MbtiProfile(
    code: "ENFJ",
    title: "Extravertit, Intuitiv, Afectiv, Judecător",
    description: [
      "ENFJ-ii sunt iubitori de oameni. Ei acordă cea mai mare importanță oamenilor și relațiilor, și sunt preocupați în mod firesc de soarta celorlalți. Privesc viața cu căldură și se simt conectați personal la toate lucrurile.",
      "Fiind niște idealiști care trăiesc conform propriilor valori, ENFJ-ii sunt foarte loiali oamenilor, cauzelor sau instituțiilor pe care le respectă și le admiră. Sunt energici și entuziaști, dar și responsabili, conștiincioși și perseverenți.",
      "ENFJ-ii au tendința înnăscută de a fi critici. Cu toate acestea, întrucât se simt responsabili pentru sentimentele altora, ei critică rareori în public. Sunt extrem de conștienți de ceea ce înseamnă (și ce nu înseamnă) un comportament corespunzător și sunt amabili, încântători, agreabili și dispuși spre socializare. Calmi și toleranți, ENFJ-ii sunt diplomați și se pricep să promoveze armonia în jur. Sunt conducători înnăscuți, populari și charismatici. De obicei, sunt buni comunicatori și își folosesc verbal darul exprimării.",
      "ENFJ-ii iau decizii bazându-se mai degrabă pe ceea ce simt despre o situație, decât pe realitatea acelei situații. Pe ei îi interesează posibilitățile ce există în spatele a ceea ce este deja evident, ca și modurile în care aceste posibilități îi pot afecta pe alții.",
      "Fiind ordonați prin natură, ENFJ-ii preferă o lume organizată și se așteaptă ca și ceilalți să fie la fel. Le place ca lucrurile să fie stabilite clar, chiar dacă altcineva ia deciziile.",
      "ENFJ-ii radiază simpatie și înțelegere, îi învață și-i sprijină pe alții. Îi descifrează bine pe oameni, sunt responsabili și grijulii. Fiind idealiști, în general caută binele în cei din jurul lor.",
    ],
    watchOuts: [
      "ENFJ-ii sunt atât de afectivi și de atenți față de oameni încât pot deveni excesiv de implicați în problemele sau în sentimentele altora. Uneori, ei aleg cauze ce nu merită timpul și energia pe care le cheltuiesc. Atunci când lucrurile nu merg bine, se pot simți copleșiți, pot deveni dezamăgiți sau deziluzionați. Acest lucru i-ar putea determina să se retragă, întrucât vor avea senzația că nu au fost apreciați. ENFJ-ii au nevoie să învețe să-și accepte propriile limite, dar și pe cele ale oamenilor la care țin. În plus, ei trebuie să învețe cum „să-și aleagă bătăliile” și cum să-și întrețină niște așteptări realiste.",
      "Din cauza puternicei lor dorințe de armonie, ENFJ-ii își pot neglija propriile trebuințe, ignorând problemele reale. Pentru a evita conflictele, ei mențin uneori relații nu tocmai oneste sau egale. ENFJ-ii sunt atât de preocupați de sentimentele altora încât pot fi orbi față de fapte importante, atunci când situația implică rănirea unor sentimente ori formularea de critici. Este important ca ENFJ-ii să învețe cum să accepte conflictele și cum să le abordeze, ca parte necesară a relațiilor.",
      "Întrucât sunt entuziaști și se grăbesc să atace următoarea provocare, ENFJ-ii fac uneori presupuneri incorecte, sau se pripesc în luarea deciziilor, fără să adune toate datele importante. Ei trebuie să reducă ritmul și să se preocupe de detaliile proiectelor lor. Așteptând până ce cunosc suficiente date, pot evita greșelile.",
      "ENFJ-ii se concentrează asupra sentimentelor în așa măsură încât pot să nu mai distingă consecințele logice ale acțiunilor lor. Ar fi util să se concentreze asupra faptelor implicate în deciziile lor, nu doar asupra oamenilor.",
      "ENFJ-ii sunt încântați de laude, dar criticile îi jignesc cu ușurință, ceea ce îi poate face să pară sensibili. Ei iau în nume personal cea mai inocentă sau mai bine intenționată critică, și adesea reacționează exagerat, devenind agitați, jigniți și furioși. Reacțiile lor pot fi ilogice, ajungând chiar să pară de-a dreptul iraționale. Este de preferat ca, înainte de a reacționa, ENFJ-ii să încerce să privească obiectiv situația. Dacă vor încerca să fie mai puțin sensibili, vor putea distinge informațiile importante și utile ce sunt conținute în criticile constructive.",
    ],
  ),
  "ENFP": MbtiProfile(
    code: "ENFP",
    title: "Extravertit, Intuitiv, Afectiv, Perceptiv",
    description: [
      "ENFP-ii sunt plini de entuziasm și de idei noi. Optimiști, spontani, creativi și încrezători, ei au minți originale și un simț puternic al posibilului. Pentru un ENFP, viața este un spectacol palpitant.",
      "Deoarece sunt atât de interesați de posibilități, ENFP-ii disting semnificații în toate lucrurile și preferă să păstreze deschise cât mai multe opțiuni. Sunt observatori perceptivi și ageri, care remarcă orice lucru deosebit. ENFP-ii sunt curioși; ei preferă mai degrabă să înțeleagă, decât să judece.",
      "Imaginativi, alerți și adaptabili, ENFP-ii apreciază mai mult decât orice inspirația și adesea sunt inventatori ingenioși. Uneori sunt nonconformiști și se pricep să întrezărească modalități noi de a realiza activitățile. ENFP-ii deschid noi direcții pentru gândire sau acțiune și le mențin deschise.",
      "În îndeplinirea ideilor lor novatoare, ENFP-ii se bizuie pe energia lor impulsivă. Au o mulțime de inițiative și găsesc problemele stimulatoare. De asemenea, ei primesc o infuzie de energie atunci când se află în prezența altor persoane și își pot combina, cu succes, talentele cu punctele tari ale celorlalți.",
      "ENFP-ii sunt încântători și plini de vitalitate. Ei tratează oamenii cu simpatie, blândețe și căldură și sunt gata să ajute pe oricine are probleme. Pot fi remarcabil de intuitivi și perceptivi, și adesea sunt interesați de dezvoltarea altora. ENFP-ii evită conflictele și preferă armonia. Ei utilizează mai multă energie în menținerea relațiilor personale decât în menținerea obiectelor, și le place să păstreze „în stare activă” o mare diversitate de relații.",
    ],
    watchOuts: [
      "Deoarece găsesc că este atât de ușor să genereze idei, ENFP-ii au dificultăți în a se concentra asupra unui singur lucru o dată și pot avea probleme în luarea deciziilor. Ei întrevăd atât de multe posibilități încât întâmpină dificultăți în selectarea celei mai bune activități sau a celui mai important interes. Uneori, fac alegeri mai puțin reușite sau se implică în prea multe lucruri simultan. Alegând cu atenție direcția în care trebuie să-și focalizeze energia, ENFP-ii pot evita pierderea timpului și irosirea considerabilelor lor talente.",
      "Pentru acești oameni, partea amuzantă a unui proiect este rezolvarea problemei inițiale și crearea a ceva nou. Le place să-și exercite inspirația asupra părților importante și provocatoare ale unei probleme. După ce depășesc etapa respectivă, ei își pierd adesea interesul pentru ceea ce fac; le lipsește autodisciplina necesară pentru a completa ceea ce au început. Obișnuiesc să înceapă multe proiecte, dar termină puține. ENFP-ii își demonstrează valoarea eforturilor atunci când parcurg părțile necesare, dar lungi și obositoare, ale unui proiect până la încheierea acestuia. Adesea, enumerarea în scris a factorilor sau a etapelor importante îi ajută să nu se abată din drum.",
      "În mod frecvent, ENFP-ii nu sunt indivizi foarte bine organizați. Ei pot beneficia de pe urma învățării și aplicării gestionării timpului și a capacităților personale de organizare. Se descurcă foarte bine atunci când fac echipă cu alte persoane, mai realiste și mai practice. Oricum, situația respectivă este una care le convine, fiindcă ENFP-ilor nu le place să lucreze singuri, mai ales pe perioade îndelungate. Ei consideră că lucrul alături de altcineva, chiar într-o etapă mai puțin interesantă a unui proiect, este preferabil lucrului de unul singur.",
      "ENFP-ii nu sunt prea interesați de amănunte. Deoarece sunt mai încântați să-și folosească imaginația și să creeze ceva original, este posibil să nu se deranjeze să culeagă toate informațiile de care au nevoie pentru a îndeplini o activitate anume. Uneori, ei improvizează pe moment, în loc să planifice și să se pregătească din timp. Deoarece consideră plictisitoare strângerea informațiilor, ENFP-ii se confruntă cu riscul de a nu depăși niciodată stadiul de „idee sclipitoare” sau, o dată porniți, de a nu mai termina. Întotdeauna în mișcare, ei preferă să amâne amănuntele enervante și să treacă la altceva nou sau neobișnuit. ENFP-ii sunt mai eficienți atunci când participă în mod conștient la lumea din jurul lor și culeg impresii mai realiste pentru a-și pune în funcțiune inovațiile.",
    ],
  ),
  "ENTJ": MbtiProfile(
    code: "ENTJ",
    title: "Extravertit, Intuitiv, Gânditor, Judecător",
    description: [
      "ENTJ-ii sunt conducători și factori de decizie. Ei văd cu ușurință posibilități în toate direcțiile și sunt fericiți să-i dirijeze pe alții în acțiunea de transformare a viziunilor lor în realitate. Sunt gânditori ingenioși și excelenți planificatori pe termen lung.",
      "Fiind atât de logici și analitici, ENTJ-ii se pricep de obicei la orice necesită raționament și inteligență. Impulsionați să atingă competența în tot ceea ce fac, sunt capabili să depisteze cu ușurință imperfecțiunile unei situații și modul cum acestea pot fi ameliorate. Ei năzuiesc spre perfecționarea sistemelor, nu spre simpla lor acceptare ca atare. ENTJ-ilor le place să rezolve probleme complexe, ei dând dovadă de o preocupare perpetuă de a stăpâni la perfecțiune tot ceea ce-i atrage. ENTJ-ii apreciază mai mult decât orice adevărul și sunt convinși doar de raționamentele logice.",
      "Doritori să-și sporească permanent fondul de cunoștințe, ENTJ-ii sunt sistematici în planificare și în cercetarea noutăților. Le place să lucreze cu probleme teoretice complexe și sunt mult mai interesați de consecințele viitoare ale acțiunilor decât de starea prezentă a lucrurilor.",
      "Lideri înnăscuți, cu un stil sincer și cordial, ENTJ-ii tind să preia conducerea oricărei situații în care se află. Sunt buni organizatori ai oamenilor, deoarece dețin capacitatea de anticipare și de comunicare a viziunilor lor. Manifestă predilecția să trăiască după un set destul de rigid de reguli și se așteaptă din partea altora la același lucru. Din acest motiv, tind să fie competitivi și-i impulsionează pe ceilalți la fel de tare cum fac cu ei înșiși.",
    ],
    watchOuts: [
      "Datorită dorinței permanente de a aborda următoarea provocare sau următorul obiectiv important, ENTJ-ii iau uneori decizii în pripă. Ocazionala încetinire a ritmului le va oferi posibilitatea să adune toate datele relevante și să analizeze laturile practice, dar și pe cele personale ale acțiunii. Orientarea lor spre acțiune îi împinge să treacă la fapte de îndată ce au luat decizii, fără să verifice încă o dată faptele și veridicitatea situației.",
      "Deoarece abordează viața din punctul de vedere al logicii, ENTJ-ii pot fi duri, obtuzi, nerăbdători și insensibili față de nevoile și sentimentele altora, atunci când nu văd logica respectivelor sentimente. Ei pot dispune de o sumedenie de argumente și pot fi dificil de abordat, și nu întotdeauna salută opiniile de bun simț ale altora. În loc să critice în mod automat, ei ar trebui să asculte informațiile sosite de la cei din jur și să-și exprime aprecierea pentru contribuția lor. ENTJ-ii trebuie să facă un efort conștient – ba chiar să-l transforme într-o regulă de comportament – să-i asculte și pe alții, înainte de a se năpusti asupra lor cu propriile idei, și să evite să acționeze dominator și dictatorial.",
      "Abordarea impersonală a vieții lasă prea puțin timp, prea puțină toleranță sau compasiune pentru sentimente, fie acestea chiar personale. Atunci când le permit sentimentelor proprii să treacă ignorate sau neexprimate, ENTJ-ii se pot trezi că reacționează exagerat de emoțional. Ei sunt mai cu seamă predispuși spre așa ceva dacă simt că cineva le contestă competența, mai ales dacă este o persoană pe care o respectă. ENTJ-ii pot reacționa exploziv față de situații aparent minore, și aceste răbufniri pot fi jignitoare pentru cei apropiați. ENTJ-ii sunt mai eficienți și mai fericiți atunci când analizează și înțeleg ce simt ei de fapt. Dacă le oferă propriilor sentimente posibilitatea unei exteriorizări constructive, în loc să le îngăduie să le influențeze personalitatea, vor putea să dețină un control mai mare, o poziție spre care năzuiesc și care le face plăcere. În mod surprinzător, ENTJ-ii pot fi, de fapt, mai puțin experimentați și competenți decât o indică stilul lor încrezător. Dacă își vor îngădui să accepte sfaturile rezonabile și valoroase ale altora, își vor spori puterea personală și succesul.",
    ],
  ),
  "ENTP": MbtiProfile(
    code: "ENTP",
    title: "Extravertit, Intuitiv, Gânditor, Perceptiv",
    description: [
      "ENTP-ii iubesc stimulii și provocările. Entuziaști și ingenioși, ei sunt vorbăreți, inteligenți, pricepuți la multe lucruri și caută permanent să-și sporească competența și puterea personală.",
      "ENTP-ii sunt născuți întreprinzători. Se arată fascinați de ideile noi și sunt atenți la toate posibilitățile. Au inițiative puternice și operează pe baza impulsurilor creative. ENTP-ii își apreciază în primul rând inspirația și se străduiesc să-și transforme ideile originale în realitate. Sunt curioși, flexibili, adaptabili și plini de resurse în rezolvarea problemelor provocatoare și teoretice.",
      "Atenți și sinceri, ENTP-ii pot distinge cu ușurință punctul nevralgic al oricărei poziții și adesea se amuză, susținând păreri diferite despre un subiect sau altul. Dețin excelente capacități analitice și sunt foarte buni gânditori strategici. Aproape întotdeauna pot găsi un motiv logic pentru lucrurile pe care le doresc.",
      "Celor mai mulți dintre ei le place să testeze limitele din jurul lor și consideră că majoritatea regulilor și regulamentelor sunt făcute pentru a fi ocolite, dacă nu chiar încălcate. Uneori, sunt neconvenționali în stilul de abordare și se simt bine ajutându-i pe alții să treacă dincolo de ceea ce este acceptat și așteptat. Adoră să trăiască liberi și caută amuzamentul și varietatea în situațiile zilnice.",
      "ENTP-ii abordează cu multă imaginație relațiile sociale și adesea au o mulțime de prieteni și de cunoștințe, extrem de diferiți. Pot dovedi un umor și un optimism deosebite. Pot reprezenta o companie încântătoare și stimulatoare, iar adesea îi inspiră pe alții să se implice în proiectele lor, grație entuziasmului molipsitor. ENTP-ii preferă să încerce să-i înțeleagă pe oameni și să se arate sensibili față de ei, nu să-i judece.",
    ],
    watchOuts: [
      "Deoarece apreciază în primul rând creativitatea și inovația, ENTP-ii ignoră uneori modalitățile standard de a face lucrurile, pur și simplu pentru că nu sunt originale. Disprețul lor intens pentru rutină și pentru lucrurile previzibile îi poate împiedica să remarce detaliile necesare. Uneori, ENTP-ii neglijează pregătirile necesare și, în dorința de a începe ceva nou, se năpustesc prea repede. O dată ce problemele majore au fost rezolvate, ei pornesc de multe ori spre următoarea aventură excitantă în loc să rămână pe loc pentru a vedea sfârșitul proiectului original. Trebuie să încerce să se dedice unui număr mai mic de proiecte, pentru a încheia mai multe din cele pe care le încep.",
      "Adesea, ENTP-ii vorbesc atât de repede și atât de mult încât nu le permit celorlalți să mai spună ceva. Sunt onești și obiectivi, dar pot fi totodată insensibili și lipsiți de tact, datorită permanentei lor atitudini critice față de alții. ENTP-ii trebuie să considere sentimentele altor indivizi ca fiind valide și importante, chiar dacă nu le împărtășesc. Deși pot fi încântători, amuzanți și plăcuți, ei pot fi și nesinceri. ENTP-ii trebuie să se împotrivească imboldului de a se adapta și de a juca teatru, înlocuindu-l cu sentimentele lor reale.",
      "Ezitarea lor de a se dedica unui singur lucru derivă din teama că pot scăpa alte oportunități, mai atrăgătoare. Dorința lor de a rămâne receptivi la noile provocări îi poate face nepăsători față de planurile și programele altora. Faptul de a se gândi la modul în care acțiunile lor îi afectează pe alții îi va ajuta să fie mai puțin capricioși.",
      "Rapiditatea lor înnăscută și capacitatea de a anticipa ce urmează îi determină, ocazional, pe ENTP-i să considere în mod eronat că știu ce va spune un anumit individ, astfel încât ei se grăbesc să termine fraza respectivului. Dacă vor fi mai atenți la ceea ce se petrece de fapt în lumea reală din jurul lor și vor asculta cu atenție informațiile primite din partea altora și vor observa reacțiile acestora, vor avea de câștigat, fără să mai pară grosolani și aroganți.",
    ],
  ),
  "ESFJ": MbtiProfile(
    code: "ESFJ",
    title: "Extravertit, Senzorial, Afectiv, Judecător",
    description: [
      "ESFJ-ii sunt motivați să ajute alți oameni în mod real, practic, prin acțiune și cooperare directă. Sunt responsabili, prietenoși și înțelegători.",
      "Deoarece acordă o importanță atât de mare relațiilor lor cu alți oameni, ESFJ-ii tind să fie populari, amabili, doritori să placă și vorbăreți. Au nevoie de relații armonioase cu alții și muncesc din greu pentru a le dobândi și a le menține. De fapt, obișnuiesc frecvent să idealizeze ceea ce admiră. ESFJ-ii au nevoie să fie apreciați pentru ei înșiși și pentru serviciile lor; de aceea, sunt foarte sensibili la indiferență sau la critici. De obicei, exprimă opinii ferme, sunt hotărâți și le place ca lucrurile să fie bine stabilite.",
      "Practici și realiști, ESFJ-ii sunt, în general, prozaici și organizați. Ei sunt atenți la fapte și detalii importante, și le reamintesc; totodată le place ca și ceilalți să fie siguri pe acțiunile proprii. Își bazează planurile și opiniile pe experiența personală, ori pe cea a unei persoane în care au încredere. Sunt conștienți de lumea materială din jur, se implică în ea și se simt bine când sunt activi și productivi.",
      "Conștiincioși și tradiționali, ESFJ-ii au un puternic simț al datoriei și al angajamentului. Cultivă instituțiile stabilite și tind să fie membri activi și cooperanți ai comitetelor și organizațiilor. Legăturile lor sociale sunt importante și bine menținute. Adesea, se străduiesc în mod deosebit să facă ceva util și plăcut pentru altcineva și le place mai ales să se implice total în momentele grele sau în cele festive.",
    ],
    watchOuts: [
      "Întrucât apreciază atât de mult armonia, ESFJ-ii preferă să evite conflictele, în loc să abordeze în mod direct unele probleme. Adesea, ei acordă prea multă importanță și valoare opiniilor și sentimentelor persoanelor la care țin. În momente încordate ori dificile, pot deveni orbi față de realitatea situației. Trebuie să învețe să abordeze imediat stările conflictuale, în mod deschis, încrezându-se în faptul că sensibilitatea lor înnăscută față de sentimentele altora le va oferi tactul necesar chiar și în situațiile cele mai dificile.",
      "Adesea, ESFJ-ii trec cu vederea propriile lor trebuințe, din cauza dorinței de a face plăcere altora sau de a-i ajuta pe aceștia. Le vine greu să spună nu, fiindcă nu vor să riște ofensând sau dezamăgind pe cineva. De obicei, au dificultăți în a face sau a accepta critici constructive, tocmai din cauză că iau lucrurile la modul foarte personal. Pot deveni pesimiști și posaci, atunci când nu întrevăd modalități de a opera schimbări în viața lor. Retragerea cu un pas din fața problemelor, în scopul obținerii unei imagini obiective, îi ajută, de obicei, să obțină un suflu nou.",
      "În eforturile lor de a-i ajuta pe alții, ESFJ-ii își exprimă uneori opiniile în modalități autoritare, dominatoare. Este preferabil să aștepte pentru a vedea dacă ajutorul sau sugestiile lor sunt realmente dorite, și abia apoi să le ofere.",
      "Frecvent, ESFJ-ii iau decizii prea rapid, înainte de a strânge toate faptele mai puțin evidente și de a se gândi la implicațiile acțiunilor lor. Nu obișnuiesc să caute modalități noi sau diferite de a face lucrurile, motiv pentru care pot părea rigizi. Amânarea judecăților, cu scopul de a rămâne deschiși față de abordări noi ale problemelor, le va oferi o bază mai bună de informații și-i va ajuta să ia hotărâri mai bune.",
    ],
  ),
  "ESFP": MbtiProfile(
    code: "ESFP",
    title: "Extravertit, Senzorial, Afectiv, Perceptiv",
    description: [
      "ESFP-ii iubesc oamenii și au un adevărat entuziasm față de viață. Sunt zburdalnici și plini de vervă, făcând ca totul să fie mai amuzant pentru ceilalți, grație bucuriei lor pure, fără oprelisti.",
      "Adaptabili și relaxați, ESFP-ii sunt calzi, prietenoși și generoși. Sunt extrem de sociabili și adesea „joacă” pentru alții. Entuziaști și cooperanți, se implică în diverse activități și jocuri și, de obicei, se ocupă de mai multe lucruri simultan.",
      "ESFP-ii sunt observatori realiști, care văd și acceptă lucrurile așa cum sunt ele. Tind să se încreadă în ceea ce pot auzi, mirosi, atinge și vedea, și nu în explicațiile teoretice. Întrucât le plac faptele concrete și au memoria amănuntelor, învață cel mai bine din experiența directă. Judecata lor sănătoasă le oferă capacități practice de abordare a oamenilor și lucrurilor. Preferă să acumuleze informații și să vadă ce soluții rezultă în mod firesc din acestea.",
      "Toleranți și acceptându-se pe sine și pe alții, ESFP-ii nu încearcă, în general, să-și impună voința asupra acestora. Plini de tact și înțelegători, ei sunt, de obicei, iubiți realmente de mulți oameni. În general, sunt capabili să-i convingă pe alții să le accepte sugestiile, de aceea se pricep să ajute la aplanarea unor conflicte între fracțiuni. Caută compania altor persoane. Le place să-i ajute pe alții, dar preferă să o facă în mod real, tangibil.",
      "Spontani și încântători, ESFP-ii sunt convingători. Le plac surprizele și posibilitatea de a găsi modalități care să-i încânte în mod neașteptat pe ceilalți.",
    ],
    watchOuts: [
      "Deoarece ESFP-ii acordă o însemnătate atât de mare trăirii din plin a vieții, bucurându-se de ea, e posibil ca alte responsabilități de-ale lor să sufere câteodată. Permanenta lor socializare le poate produce necazuri și, fiindcă sunt atât de ușor de ispitit, au dificultăți cu autodisciplina. Predilecția ESFP-ilor de a se lăsa distrași de la terminarea sarcinilor pe care le-au început îi poate împinge spre lene. Acționând în direcția alcătuirii unei liste de priorități și a găsirii unui echilibru între muncă și relaxare, ei vor dobândi o perspectivă mai vastă și o viziune pe termen mai lung asupra vieții lor. Folosirea de metode acceptate și încununate de succes pentru organizarea și gestionarea timpului îi ajută să-și învingă această predispoziție naturală.",
      "Viața lor activă îi ține atât de ocupați, încât nu izbutesc să-și traseze planuri de viitor. Aceasta îi împiedică să fie pregătiți pentru schimbările din viață, pe care le-ar aborda mai ușor, dacă semnele apropierii lor ar fi fost sesizate. ESFP-ii trebuie să încerce să anticipeze ceea ce se poate întâmpla și să dezvolte un plan alternativ, pentru cazul în care situația ar deveni neplăcută.",
      "De asemenea, ESFP-ii tind să ia decizii fără să analizeze consecințele logice ale acțiunilor lor. Se încred în propriile sentimente și le folosesc până aproape de excluderea datelor mai obiective. Își apreciază în așa măsură prietenii, încât tind să le vadă doar laturile pozitive. ESFP-ii trebuie să se retragă un pas, pentru a se gândi la cauzele și la efectele acțiunilor lor, și să încerce să devină mai puțin afectivi. Dacă o vor face, nu le va mai fi greu să refuze.",
    ],
  ),
  "ESTJ": MbtiProfile(
    code: "ESTJ",
    title: "Extravertit, Senzorial, Gânditor, Judecător",
    description: [
      "ESTJ-ii sunt persoane practice, realiste și hotărâte, orientate spre acțiune și spre obținerea unor rezultate concrete. Le place să știe clar ce trebuie făcut și sunt adesea gata să preia inițiativa atunci când o situație are nevoie de ordine, organizare sau decizii ferme.",
      "Atenți la realitatea imediată, ESTJ-ii se bazează în primul rând pe fapte, experiență și informații verificabile. Observă cu ușurință ceea ce este concret și practic și preferă metodele care și-au demonstrat deja eficiența. Au încredere în ceea ce cunosc din experiență și sunt mai puțin atrași de teorii sau posibilități care nu au încă o aplicabilitate evidentă.",
      "Logici și obiectivi, ESTJ-ii tind să ia decizii analizând faptele și consecințele practice ale acestora. Identifică rapid ceea ce nu funcționează și caută soluții clare și eficiente. Pot fi direcți în exprimarea opiniilor și apreciază competența, seriozitatea și responsabilitatea atât la ei înșiși, cât și la ceilalți.",
      "ESTJ-ilor le place ordinea. Preferă obiectivele bine definite, regulile clare și activitățile organizate. Sunt adesea buni planificatori și urmăresc îndeaproape ducerea sarcinilor la bun sfârșit. Respectă angajamentele asumate și se așteaptă ca și ceilalți să procedeze la fel. În situații de grup, pot prelua în mod firesc coordonarea, distribuind responsabilități și urmărind realizarea obiectivelor.",
      "Sociabili și activi, ESTJ-ii se implică ușor în lumea din jurul lor. Le place să participe, să organizeze și să contribuie concret. Pot fi persoane de încredere, consecvente și loiale oamenilor, grupurilor sau instituțiilor din care fac parte. Tradițiile, regulile și structurile cunoscute le pot oferi stabilitate și un cadru clar în care să acționeze.",
    ],
    watchOuts: [
      "Deoarece au încredere în experiență și în metodele care și-au dovedit eficiența, ESTJ-ii pot respinge prea repede ideile noi sau modalitățile neobișnuite de a face lucrurile. Atunci când o soluție nu are o utilitate imediat evidentă, pot considera că nu merită explorată. Ar avea de câștigat dacă, înainte de a respinge o posibilitate, și-ar acorda timp să analizeze ce avantaje ar putea aduce pe termen mai lung.",
      "Orientarea lor puternică spre logică și eficiență îi poate determina uneori să acorde prea puțină atenție sentimentelor celorlalți. Fiind direcți, pot părea critici, duri sau lipsiți de tact, chiar dacă intenția lor este doar de a rezolva problema. A lua în considerare felul în care mesajul lor este primit, nu numai corectitudinea lui, îi poate ajuta să comunice mai eficient.",
      "Nevoia de ordine și structură poate deveni rigiditate atunci când lucrurile nu se desfășoară conform planului. ESTJ-ii pot încerca să controleze prea multe aspecte ale unei situații sau să se aștepte ca ceilalți să lucreze în același mod ca ei. Acceptarea faptului că există mai multe căi corecte de a ajunge la același rezultat le poate oferi mai multă flexibilitate.",
      "Fiind responsabili și orientați spre realizarea sarcinilor, pot trece rapid de la un obiectiv la următorul, fără să se oprească suficient pentru a analiza imaginea de ansamblu. Uneori, concentrarea asupra detaliilor practice și a ceea ce trebuie făcut imediat îi poate împiedica să observe posibilități viitoare. Alternarea perioadelor de acțiune cu momente deliberate de reflecție îi poate ajuta să ia decizii mai complete.",
    ],
  ),
  "ESTP": MbtiProfile(
    code: "ESTP",
    title: "Extravertit, Senzorial, Gânditor, Perceptiv",
    description: [
      "ESTP-ii nu-și fac griji – ei sunt fericiți! Activi, veseli și spontani, preferă să se bucure de clipa prezentă, în loc să-și facă planuri de viitor.",
      "Extrem de realiști, ESTP-ii se bizuie pe ceea ce simțurile lor le comunică despre lume și au încredere în respectivele informații. Sunt curioși și fini observatori. Deoarece acceptă lucrurile așa cum sunt, tind să fie lipsiți de prejudecăți și toleranți față de alții și față de ei înșiși. ESTP-ilor le plac lucrurile reale, care pot fi manipulate, demontate și asamblate.",
      "Preferă acțiunea conversației și se simt bine abordând situațiile pe măsură ce apar. Sunt pricepuți la rezolvarea problemelor, pentru că pot absorbi informațiile necesare și apoi găsesc repede soluțiile logice și firești, fără să cheltuiască prea multă energie. ESTP-ii pot fi negociatori diplomați, încântați să încerce abordări neconvenționale, și, de obicei, sunt în stare să-i convingă pe alții să acorde o șansă compromisurilor lor. Sunt capabili să înțeleagă principiile fundamentale și să ia decizii bazate pe logică, nu pe sentiment. Ca atare, sunt pragmatici; de asemenea, pot fi duri, atunci când situația o cere.",
      "Prietenoși și încântători, ESTP-ii sunt populari și relaxați în majoritatea situațiilor mondene. Sunt amabili, flexibili și amuzanți, și pot deține o rezervă nesfârșită de glume și anecdote pentru orice situație în care s-ar găsi. Pot fi pricepuți la relaxarea unor situații tensionate, prin destinderea atmosferei și apropierea părților aflate în conflict.",
    ],
    watchOuts: [
      "Preferința ESTP-ilor pentru trăirea din plin a prezentului și adoptarea unui stil de „necesitate”, care să-i ajute să facă față unor crize neașteptate, poate duce la un mediu haotic pentru cei din jurul lor. Ei pot pierde unele oportunități, deoarece nu planifică lucrurile din vreme. Uneori, acceptă prea multe și se trezesc supraaglomerați și incapabili să-și respecte angajamentele. ESTP-ii trebuie să privească dincolo de clipa prezentă și de interesul lor față de lumea materială, pentru a încerca să anticipeze modalități de terminare la timp a sarcinilor.",
      "De asemenea, ESTP-ii tind să ignore sentimentele celorlalți și pot fi lipsiți de tact sau insensibili, în dorința lor de a fi onești, mai cu seamă atunci când trec în grabă de la o experiență la alta. Uneori, extravaganțele lor pot fi percepute ca vulgarități, acest lucru ajungând să-i îndepărteze chiar pe cei care au încercat să-i binedispună. ESTP-ii devin mult mai eficienți cu alții atunci când își direcționează puterile pătrunzătoare de observație asupra sentimentelor celor din jur. Ei sunt mult mai eficienți când își limitează cutezanța, energia și plăcerea de a se simți bine la un nivel la care și alții se simt confortabil.",
      "Interesați de rezolvarea rapidă a problemelor, ESTP-ii au predilecția de a sări direct la următoarea urgență, fără să parcurgă părțile mai puțin atrăgătoare ale proiectelor curente. Este recomandabil să învețe și să aplice gestionarea timpului și tehnicile de planificare pe termen lung, ce-i vor ajuta să se pregătească pentru responsabilități și să le rezolve. O reducere a ritmului personal, în scopul dezvoltării de norme pentru propriul comportament și pentru analiza urmărilor acțiunilor lor, le va spori eficiența.",
    ],
  ),
  "INFJ": MbtiProfile(
    code: "INFJ",
    title: "Introvertit, Intuitiv, Afectiv, Judecător",
    description: [
      "INFJ-ii trăiesc într-o lume a ideilor. Sunt gânditori independenți, originali, cu sentimente puternice, principii ferme și integritate personală.",
      "Chiar în fața scepticilor, ei se încred în ideile și în deciziile lor. Sunt motivați de o viziune interioară pe care o apreciază mai mult decât orice altceva, inclusiv opiniile majoritare sau cele aparținând unor autorități recunoscute. Adesea, INFJ-ii disting înțelesuri mai profunde și au intuiții revelatoare. Inspirațiile lor sunt importante și valide pentru ei, chiar dacă alții nu le împărtășesc entuziasmul.",
      "INFJ-ii sunt loiali, dedicați și idealiști. Ei caută, în mod discret, dar cu insistență, să impună acceptarea și aplicarea lor. Apreciază integritatea și pot fi deciși până la încăpățânare. Datorită tăriei convingerilor și a viziunii limpezi a ceea ce este cel mai bun pentru binele general, INFJ-ii pot fi excelenți conducători. Ei sunt adesea onorați sau respectați pentru contribuțiile aduse.",
      "Deoarece apreciază armonia și înțelegerea, INFJ-ilor le place să-i convingă pe alții de validitatea punctului lor de vedere. Ei obțin cooperarea altor indivizi, folosind laudele și aprobările, iar nu intimidările sau argumentele. INFJ-ii se vor strădui din răsputeri să promoveze camaraderia și să evite conflictele.",
      "Luând, în general, deciziile după o chibzuință atentă, INFJ-ii consideră că problemele sunt stimulatoare și obișnuiesc să reflecteze cu atenție înainte de a acționa. Ei preferă să se concentreze mai mult asupra câte unui lucru, pe rând, ceea ce poate duce la perioade de unidirecționalitate.",
      "Afectivi și grijulii, INFJ-ii au o dorință puternică de a contribui la bunăstarea altora. Ei sunt conștienți de sentimentele și interesele altor persoane, și adesea se descurcă bine cu indivizi complicați. INFJ-ii înșiși au, în general, personalități profunde, complexe, și pot fi atât sensibili, cât și vehemenți. Pot fi rezervați și greu de cunoscut, dar doritori să-și împartă frământările interioare cu cei în care au încredere. Obișnuiesc să aibă un grup restrâns de prieteni vechi, fiind capabili să genereze entuziasm și căldură personală în circumstanțele cuvenite.",
    ],
    watchOuts: [
      "Deoarece tind să fie atât de absorbiți de „idee”, INFJ-ii pot, uneori, să fie lipsiți de spirit practic și sunt în stare să neglijeze detalii de rutină, ce necesită atenție. Dacă vor deveni mai conștienți de ceea ce se petrece în jurul lor și dacă se vor bizui mai mult pe informațiile verificate, INFJ-ii își vor ancora ideile creative în lumea reală.",
      "INFJ-ii pot fi atât de dedicați principiilor personale, încât să-și dezvolte o viziune tip tunel. Ei pot fi încăpățânați în privința schimbărilor, ajungând chiar să se opună modificării unei decizii, după ce aceasta a fost luată. Uneori, trec cu vederea peste fapte importante ce nu le sprijină argumentele, sau se opun ideilor ce sunt în contradicție cu propriile lor valori. Este posibil să nu audă obiecțiile altora, fiindcă, pentru ei, poziția lor pare mai presus de orice dubii. INFJ-ii trebuie să încerce să se autoexamineze – pe ei, dar și munca lor – cu mai multă obiectivitate, așa cum o pot face alții.",
      "Deoarece sunt atât de protectori față de viziunea personală, INFJ-ii tind să exagereze cu reglementările. Adesea, sunt perfecționiști și se dovedesc hipersensibili la critici. Deși perseverenți, au dificultăți în rezolvarea conflictelor din cadrul relațiilor, și pot fi dezamăgiți sau deziluzionați dacă apar asemenea conflicte. Cu cât vor fi mai obiectivi în privința lor și a relațiilor lor, cu atât vor fi mai puțin vulnerabili în fața acestor situații.",
    ],
  ),
  "INFP": MbtiProfile(
    code: "INFP",
    title: "Introvertit, Intuitiv, Afectiv, Perceptiv",
    description: [
      "INFP-ii apreciază armonia interioară mai mult decât orice altceva. Sensibili, idealiști și loiali, ei au un puternic simț al onoarei în privința valorilor personale, și adesea sunt motivați de o profundă credință sau de devotamentul pentru o cauză pe care o consideră meritorie.",
      "INFP-ii sunt interesați de posibilitățile aflate dincolo de ceea ce este deja cunoscut și-și focalizează majoritatea energiilor asupra viselor și viziunilor lor. Extrem de receptivi, curioși și perceptivi, ei dețin adesea o excelentă perspectivă pe termen lung. În problemele cotidiene, sunt de obicei flexibili, toleranți și adaptabili, dar fermi în privința loialităților interioare și-și stabilesc standarde foarte înalte – practic, aproape imposibil de atins.",
      "INFP-ii au multe idealuri și loialități care-i țin ocupați. Sunt extrem de dedicați față de orice decid să realizeze – și tind să realizeze prea multe, însă, cumva, reușesc să facă totul.",
      "Deși în exterior se arată reci, rezervați, ei sunt foarte sensibili. Sunt compătimitori, plini de înțelegere și simțitori la sentimentele altora. Evită conflictele și nu-i interesează să-i impresioneze ori să-i domine pe alții, cu excepția cazurilor în care le sunt puse la îndoială valorile proprii. Adesea, preferă să-și comunice sentimentele în scris, nu verbal. Atunci când le vorbesc altora despre importanța idealurilor lor, INFP-ii pot fi extrem de convingători.",
      "INFP-ii își exprimă rareori intensitatea sentimentelor și par reticenți și detașați; cu toate acestea, după ce ajung să vă cunoască, devin entuziaști și calzi. INFP-ii sunt prietenoși, dar tind să evite socializarea superficială. Ei îi apreciază pe oamenii care își sacrifică timpul pentru a le înțelege obiectivele și valorile.",
    ],
    watchOuts: [
      "Deoarece logica nu constituie o prioritate pentru INFP-i, ei fac uneori greșeli și este posibil să nu-și dea seama că sunt ilogici. Atunci când visele lor se rup de realitate, alții îi pot considera schimbători și mistici. Este bine ca INFP-ii să ceară sfatul unor persoane mai practice, pentru a afla dacă ideile lor sunt aplicabile și utile în lumea reală.",
      "Fiind atât de dedicați propriilor idealuri, INFP-ii au tendința să nu țină seama de alte opinii și pot fi uneori rigizi. Nu sunt foarte interesați de lumea fizică înconjurătoare și, adesea, preocupările lor îi împiedică să observe ce se petrece în jur.",
      "INFP-ii pot reflecta asupra unei idei mai mult decât este cu adevărat necesar, pentru a începe un proiect. Tendințele lor perfecționiste îi pot conduce spre o rafinare și o lustruire atât de îndelungată a propriilor idei încât nu mai ajung să le împărtășească niciodată. Acest lucru este periculos, întrucât pentru ei este important să găsească modalități de exprimare a ideilor. Pentru a nu fi descurajați, ei trebuie să se străduiască să se orienteze mai mult spre acțiune.",
      "INFP-ii sunt atât de prinși emoțional în obligațiile lor, încât sunt foarte sensibili la critici. Complicând suplimentar lucrurile, ei au predilecția de a solicita prea mult de la propria persoană, pe măsură ce aspiră spre standardele lor inaccesibil de ridicate. Aceasta poate duce la sentimente de incompetență, deși ei sunt capabili de a reuși multe lucruri. Atunci când sunt dezamăgiți, INFP-ii tind să devină negativiști față de tot ceea ce-i înconjoară. Încercarea de a dezvolta mai multă obiectivitate față de proiecte îi va ajuta să fie mai puțin vulnerabili la critici și la dezamăgiri.",
      "Fiindcă tind să încerce să placă simultan mai multor oameni, pentru INFP-i poate fi greu să adopte o poziție nepopulară. Ei ezită să-i critice pe alții, și le vine greu să refuze. Atunci când nu-și exprimă opiniile negative despre idei sau planuri, îi pot induce în eroare pe cei din jur, făcându-i să creadă că ar fi de acord cu ei. INFP-ii trebuie să-și dezvolte mai multă asertivitate și pot beneficia din învățarea felului în care trebuie să-i critice în mod onest pe alții, atunci când este cazul.",
    ],
  ),
  "INTJ": MbtiProfile(
    code: "INTJ",
    title: "Introvertit, Intuitiv, Gânditor, Judecător",
    description: [
      "INTJ-ii sunt gânditori independenți, analitici și orientați spre viitor. Sunt atrași de idei complexe și de posibilitatea de a înțelege mecanismele aflate în spatele lucrurilor. Adesea, nu se mulțumesc să observe cum funcționează un sistem, ci încearcă să descopere cum ar putea funcționa mai bine.",
      "Intuitivi și imaginativi, INTJ-ii privesc dincolo de realitatea imediată. Identifică tipare, conexiuni și posibilități pe termen lung, fiind preocupați mai degrabă de imaginea generală decât de detaliile izolate. Pot dezvolta viziuni complexe despre ceea ce ar putea deveni un proiect, o idee sau o situație și sunt motivați să transforme aceste viziuni în planuri realizabile.",
      "INTJ-ii acordă o mare importanță logicii și competenței. Își analizează ideile critic și sunt rareori convinși numai de tradiție, autoritate sau opinia majorității. Preferă să ajungă singuri la concluzii, după ce au analizat informațiile disponibile. Atunci când descoperă o metodă mai eficientă, sunt dispuși să pună sub semnul întrebării modul în care lucrurile au fost făcute până atunci.",
      "Independenți și rezervați, INTJ-ii au nevoie de timp și spațiu pentru a gândi. Preferă adesea să lucreze singuri sau alături de persoane pe care le consideră competente. Nu simt nevoia să-și comunice permanent gândurile și pot părea distanți celor care nu îi cunosc bine. În relațiile apropiate, însă, pot fi loiali și consecvenți.",
      "Deși sunt orientați spre idei și posibilități, INTJ-ii nu se mulțumesc numai să imagineze. Le place să transforme conceptele în strategii și să organizeze pașii necesari pentru atingerea unui obiectiv. Sunt perseverenți atunci când consideră că un proiect merită efortul și își stabilesc adesea standarde înalte atât pentru ei înșiși, cât și pentru ceea ce fac.",
    ],
    watchOuts: [
      "Încrederea INTJ-ilor în propriile analize îi poate determina uneori să acorde prea puțină atenție opiniilor celorlalți. Atunci când sunt convinși că au identificat soluția logică a unei probleme, pot deveni nerăbdători cu persoanele care ajung la alte concluzii sau care au nevoie de mai mult timp pentru a le înțelege perspectiva. Ascultarea activă a argumentelor diferite îi poate ajuta să descopere informații pe care propria analiză le-a omis.",
      "Standardele lor ridicate pot deveni uneori perfecționism. INTJ-ii pot fi foarte critici cu propriile rezultate și cu munca altora și pot observa mai ușor ceea ce trebuie îmbunătățit decât ceea ce funcționează deja bine. Acceptarea faptului că nu toate situațiile necesită soluția optimă și că uneori o soluție suficient de bună este mai utilă decât una perfectă le poate crește eficiența.",
      "Fiind orientați spre logică, INTJ-ii pot subestima rolul emoțiilor în deciziile și comportamentul oamenilor. Pot considera că prezentarea unui argument corect este suficientă pentru a-i convinge pe ceilalți și pot fi surprinși atunci când acest lucru nu se întâmplă. O atenție mai mare acordată valorilor, nevoilor și reacțiilor emoționale ale celor din jur îi poate ajuta să-și comunice ideile mai eficient.",
      "Preocuparea pentru imaginea de ansamblu și pentru posibilitățile viitoare îi poate face uneori să treacă prea repede peste detalii practice. O idee excelentă poate avea nevoie de informații concrete, verificări și ajustări înainte de a putea fi pusă în practică. INTJ-ii beneficiază atunci când își verifică ipotezele în raport cu realitatea și lasă loc modificării planului atunci când apar date noi.",
      "Tendința de a analiza independent poate duce și la retragere excesivă. Uneori pot continua să lucreze singuri la o problemă mult timp înainte de a cere feedback sau ajutor. Împărtășirea ideilor într-o etapă mai timpurie le poate oferi perspective suplimentare și poate preveni investiția prea mare într-o direcție care necesită revizuire.",
    ],
  ),
  "INTP": MbtiProfile(
    code: "INTP",
    title: "Introvertit, Intuitiv, Gânditor, Perceptiv",
    description: [
      "INTP-ii soluționează probleme conceptuale. Sunt intelectuali și logici, cu străfulgerări de creativitate excepțională.",
      "Tăcuți, rezervați și detașați în exterior, INTP-ii sunt absorbiți în plan lăuntric de analiza problemelor. Sunt critici, preciși și sceptici. Ei încearcă să găsească și să utilizeze principii pentru a înțelege numeroasele lor idei. Le place ca discuțiile să fie logice și cu scop, și pot argumenta, despicând firul în patru, doar pentru amuzament. INTP-ii sunt convinși numai de raționamentele logice.",
      "De obicei, INTP-ii sunt gânditori ingenioși și originali. Își apreciază inteligența, manifestă o puternică pornire spre competența personală și sunt interesați să-i provoace pe alții să devină mai competenți. INTP-ii sunt în primul rând interesați de a întrezări posibilități dincolo de cele cunoscute, acceptate sau evidente în mod curent. Le place să dezvolte modele pentru îmbunătățirea felului în care se prezintă lucrurile sau pentru rezolvarea problemelor dificile. Gândesc într-o manieră extrem de complexă și sunt mai degrabă capabili să organizeze ideile și conceptele, decât să-i organizeze pe oameni. Ocazional, ideile lor sunt atât de complexe încât au dificultăți în a le comunica și a-i face pe alții să le înțeleagă.",
      "Extrem de independenți, INTP-ii sunt atrași de activitățile speculative și imaginative. Sunt flexibili și cu mintea deschisă, fiind mai interesați de găsirea unor soluții creative, dar corecte, decât de transpunerea acelor soluții în realitate.",
    ],
    watchOuts: [
      "Deoarece se bazează atât de mult pe analiza logică, INTP-ii pot trece cu vederea ceea ce contează pentru alții. Dacă ceva nu este logic, INTP-ii riscă să-l abandoneze, chiar dacă este important pentru ei. Dacă vor admite față de ei înșiși lucrurile care contează realmente pentru ei, vor reuși să rămână în contact cu adevăratele lor sentimente.",
      "Excelenți în detectarea punctelor slabe ale unei idei, INTP-ii sunt mai reticenți în a-și exprima aprecierile. Ei pot să facă o fixație pe o eroare minoră dintr-un plan și să stopeze întregul proiect, pentru că refuză menținerea unui aspect ilogic. Atunci când își îndreaptă foarte șlefuitele capacități de gândire critică asupra celor din jur, onestitatea lor poate îmbrăca forma unor jigniri neintenționate. Trebuie să li se spună și trebuie să învețe să întrebe ce anume este important, din punct de vedere emoțional, pentru alții.",
      "Fascinați de rezolvarea problemelor, INTP-ii tind să se plictisească de detaliile rutiniere și își pot pierde interesul față de un proiect, neterminându-l dacă necesită o muncă prea îndelungată sau dacă el conține prea multe detalii. Orientându-și energia spre exterior, vor putea câștiga suficiente cunoștințe practice pentru ca ideile lor să fie utile și acceptabile pentru ceilalți.",
      "Uneori, INTP-ii se simt neadecvați atunci când încearcă să trăiască conform propriilor lor standarde de perfecțiune. Dacă vor învăța să împartă sentimentele acelea cu altcineva, vor putea obține o imagine mai realistă și mai obiectivă a propriei persoane.",
    ],
  ),
  "ISFJ": MbtiProfile(
    code: "ISFJ",
    title: "Introvertit, Senzorial, Afectiv, Judecător",
    description: [
      "ISFJ-ii sunt loiali, devotați, plini de compasiune și receptivi față de sentimentele altora. Sunt conștiincioși și responsabili, și le place să fie solicitați.",
      "ISFJ-ii sunt indivizi realiști, cu picioarele pe pământ, care preferă persoanele liniștite și rezervate. Ei absorb un număr mare de fapte, pe care le folosesc cu plăcere. Având o memorie deosebită în privința detaliilor, sunt răbdători în etapa de derulare a sarcinilor. ISFJ-ilor le place ca lucrurile să fie clare și explicit prezentate.",
      "Deoarece au o etică a muncii, ei acceptă responsabilitatea pentru lucrurile ce trebuie făcute, dacă văd că acțiunile lor pot ajuta cu adevărat. Sunt extrem de meticuloși și sistematici în îndeplinirea sarcinilor. ISFJ-ii tind să fie conservatori, respectând valorile tradiționale. Ei folosesc judecata practică în luarea deciziilor și contribuie la stabilitate prin excelenta lor perspectivă asupra simțului realității.",
      "Tăcuți și modești, ISFJ-ii sunt serioși și muncitori. Sunt blânzi, simțitori și plini de tact, ajutându-și prietenii și colegii. Le place să aibă grijă de alții și preferă să ajute în mod practic, tangibil. Își folosesc căldura personală pentru a comunica și interacționează bine cu indivizi aflați în cumpănă. ISFJ-ii manifestă tendința de a nu-și etala sentimentele intime, dar au o reacție personală intensă față de cele mai multe situații și evenimente. Sunt protectori și devotați prietenilor lor, conștienți de importanța muncii depuse, preocupați de respectarea obligațiilor.",
    ],
    watchOuts: [
      "Deoarece trăiesc atât de total în clipa prezentă, ISFJ-ii au probleme în perceperea globală a evenimentelor sau în anticiparea posibilelor rezultate ale unei situații, mai cu seamă atunci când aceasta nu este familiară. Ei au nevoie de ajutor pentru a privi dincolo de prezent și a-și imagina ce s-ar putea întâmpla dacă lucrurile s-ar face în alt mod.",
      "ISFJ-ii se pot împotmoli în obstacolele cotidiene și în problemele fără sfârșit din jurul lor – atât cele personale, cât și ale altora, față de care ei se simt responsabili. Pot obosi cu ușurință, fiindcă fac totul singuri, ca să se asigure că sarcinile sunt îndeplinite în detaliu. Nefiind autoritari prin natură, nici duri, ei riscă să fie exploatați. Trebuie să-și exprime sentimentele, ori resentimentele, adesea zăgăzuite, pentru a nu ajunge în situația de a avea ei înșiși nevoie de ajutor. De asemenea, este necesar să-i lase pe alții să le cunoască trebuințele și realizările.",
      "Adesea, ISFJ-ii au nevoie de un timp mai îndelungat pentru a stăpâni problemele tehnice. Au predilecție pentru planificarea excesivă și trebuie să-și dezvolte strategii care să-i ajute să-și refocalizeze energia pe care o irosesc făcându-și griji inutile. ISFJ-ii trebuie să găsească modalități de a obține bucuria atât de necesară și relaxarea pe care o merită.",
    ],
  ),
  "ISFP": MbtiProfile(
    code: "ISFP",
    title: "Introvertit, Senzorial, Afectiv, Perceptiv",
    description: [
      "ISFP-ii sunt persoane blânde, sensibile și grijulii, care nu-și dezvăluie majoritatea idealurilor și valorilor lor, foarte personale. Adesea, își exprimă pasiunile profunde prin acțiuni, nu prin cuvinte.",
      "Modești și rezervați, ISFP-ii sunt în realitate extrem de calzi și entuziaști, dar tind să nu etaleze această latură decât față de anumite persoane, pe care le cunosc bine și în care se încred pe deplin. În general, ISFP-ii sunt înțeleși greșit, datorită tendinței de a nu se exprima pe ei înșiși în mod direct.",
      "ISFP-ii sunt răbdători, flexibili și se înțeleg ușor cu alți oameni; de obicei, nu sunt interesați să-i domine sau să-i controleze pe alții. Nu emit judecăți și acceptă cu nonșalanță comportamentul celorlalți. Observă cu atenție oamenii și lucrurile din jur și nu caută să găsească motivații sau înțelesuri.",
      "Deoarece trăiesc pe deplin în clipa prezentă, ISFP-ii nu tind să se pregătească sau să facă mai multe planuri decât este necesar. Buni planificatori pe termen scurt, ei își efectuează sarcinile relaxați, fiindcă se implică pe deplin în clipa și în locul prezente și le place să se bucure de experiența curentă, fără să se grăbească să treacă la următoarea.",
      "Interesați de ceea ce învață și simt direct din experiențele proprii și din ceea ce le comunică simțurile, ei sunt adesea firi artistice și estete, încercând să creeze pentru ei ambianțe frumoase, care să-i caracterizeze.",
      "Lipsiți de nevoia de a conduce, ISFP-ii sunt adesea executanți de încredere și buni membri de echipă. Deoarece se folosesc de valorile personale pentru a judeca totul în viață, le plac indivizii care își sacrifică timpul ca să ajungă să-i cunoască și să le înțeleagă loialitățile interioare. În esență încrezători și înțelegători, ei au nevoie în viață de relații armonioase și sunt sensibili față de conflicte și neînțelegeri.",
    ],
    watchOuts: [
      "Natura extrem de sensibilă a ISFP-ilor le permite să distingă în mod clar trebuințele altor persoane; uneori, ei se străduiesc în mod atât de excesiv să îndeplinească acele trebuințe încât ajung să se neglijeze. Aceasta poate determina îmbolnăviri în plan fizic, cauzate de epuizare. Trebuie să-și rezerve din timpul acordat altora pentru a se îngriji pe ei înșiși.",
      "Deoarece se focalizează atât de mult asupra experienței de moment, ei tind să nu privească dincolo de prezent și nu obișnuiesc să se pregătească din timp. Adesea, au dificultăți în a-și organiza timpul și resursele. Trebuie să se străduiască din răsputeri să-și domolească impulsul de a abandona totul și de a se bucura de un moment de liniște sau de a participa la o activitate favorită.",
      "ISFP-ii sunt vulnerabili la criticile altora, deoarece tind să interpreteze în mod personal orice formă de feedback, ajungând să se simtă jigniți și descurajați. Pot fi considerați naivi și excesiv de încrezători, pentru că acceptă oamenii și lucrurile așa cum sunt și nu se așteaptă la motive rele, sau nu descifrează nimic altceva din ele. Trebuie să dea mai multă importanță propriilor trebuințe și să analizeze implicațiile comportamentului celorlalți. Aplicând obiectivitate și scepticism analizelor lor, ei pot deveni mai buni judecători ai caracterului uman.",
    ],
  ),
  "ISTJ": MbtiProfile(
    code: "ISTJ",
    title: "Introvertit, Senzorial, Gânditor, Judecător",
    description: [
      "ISTJ-ii sunt oamenii serioși, responsabili și sensibili ai societății. În ei se poate avea încredere, întrucât își onorează angajamentele. Cuvântul lor este un legământ solemn.",
      "Practici și realiști, ISTJ-ii sunt prozaici și meticuloși. Ei sunt teribil de preciși și de metodici, cu mare putere de concentrare. Indiferent ce ar face, procedează cu acuratețe și cu temeinicie. Au idei de neclintit, bine elaborate și sunt greu de distras ori de descurajat, odată ce au pornit pe ceea ce consideră drept calea optimă de acțiune.",
      "În general tăcuți și muncitori, ISTJ-ii dețin o bună judecată practică și o bună memorie în privința detaliilor. Ei pot cita dovezi exacte în sprijinul opiniilor personale și aplică experiența trecută la deciziile prezente. Apreciază și utilizează logica și analiza impersonală, sunt organizați și sistematici în modul cum abordează lucrurile și le sfârșesc întotdeauna la timp. Urmează metodele și operațiile necesare și sunt nemulțumiți de cei care nu procedează la fel.",
      "ISTJ-ii sunt precauți și tradiționali. Sunt buni ascultători; totodată, le place ca lucrurile să fie bine și corect prezentate. Se afirmă despre ei că „spun ceea ce vor și vor ceea ce spun”. Retrași prin natură, ISTJ-ii par calmi chiar și în momentele de criză. Sunt fermi și se dedică total sarcinilor ce le revin, dar sub fațada lor calmă se pot ascunde sentimente puternice, deși rareori exprimate.",
    ],
    watchOuts: [
      "O problemă comună a ISTJ-ilor este tendința de a se pierde în detaliile și operațiunile cotidiene ale unui proiect. O dată afundați în acestea, ei pot deveni rigizi și nedoritori să se adapteze ori să accepte alt punct de vedere. Tind să fie sceptici în privința ideilor noi, dacă nu întrevăd aplicarea lor imediată. Trebuie să dedice mai mult timp analizării obiectivelor lor generale și să ia în considerare variante pe care poate le-au ignorat. Adunând un volum mai mare de informații și străduindu-se, în mod conștient, să anticipeze implicațiile viitoare ale comportamentului lor, își vor spori eficiența în toate domeniile.",
      "Uneori, ISTJ-ii au dificultăți să înțeleagă nevoile altora, mai cu seamă pe cele care diferă de ale lor. Deoarece nu-și exteriorizează sentimentele, pot lăsa impresia că sunt reci și insensibili. ISTJ-ii trebuie să-și exprime aprecierea față de alții în mod direct, nu s-o închidă în adâncul sufletului.",
      "Fiind logici, ISTJ-ii tind să se aștepte la același lucru și din partea celorlalți. Ei riscă să le impună altora propriile judecăți și să nu asculte părerile unor persoane mai puțin agresive.",
      "ISTJ-ii le pot cere celorlalți să se conformeze felului lor de a face lucrurile și să descurajeze abordări mai creative sau inovatoare. Rămânând deschiși față de metodele netestate sau neconvenționale, își vor dezvolta o toleranță mai mare față de diferențele dintre oameni, câștigând astfel variante și opțiuni mai eficiente.",
    ],
  ),
  "ISTP": MbtiProfile(
    code: "ISTP",
    title: "Introvertit, Senzorial, Gânditor, Perceptiv",
    description: [
      "Fiind analitici, ISTP-ii sunt extrem de interesați de principiile impersonale, esențiale. Ei dețin o cunoaștere înnăscută a felului în care funcționează obiectele mecanice și, de obicei, se pricep să utilizeze uneltele și să lucreze manual. Tind să ia decizii logice și private, afirmând lucrurile limpede și direct, exact așa cum le văd.",
      "Curioși și buni observatori, ISTP-ii se lasă de obicei convinși doar de faptele dovedite, demne de încredere. Ei au un mare respect față de fapte și pot fi veritabile depozite de informații despre lucrurile pe care le cunosc și le înțeleg bine. Fiind realiști, sunt capabili să valorifice resursele disponibile, ceea ce face din ei niște indivizi practici, cu un bun simț al momentelor optime.",
      "Tăcuți și rezervați, ISTP-ii tind să pară reci și nepăsători și sunt predispuși la timiditate, cu excepția momentelor când se găsesc printre prieteni buni. Ei își conduc singuri viața, sunt egalitariști și corecți. Au predilecția de a acționa în mod impulsiv, de aceea sunt destul de adaptabili și răspund la problemele și provocările imediate. Întrucât se bucură de senzații tari și de acțiune, le plac de obicei sporturile și viața în aer liber.",
    ],
    watchOuts: [
      "Deoarece judecățile lor sunt private, adesea ISTP-ii nu comunică nici subiectele cele mai importante, ceea ce le „ține în beznă” pe persoanele din viața lor. Au dificultăți în a împărți cu alții reacțiile, sentimentele și grijile, întrucât un asemenea lucru li se pare inutil. Ei trebuie să accepte faptul că alții doresc și au nevoie să știe ce se petrece în viața lor și să-și dea seama că sunt singurii care pot oferi o explicație exactă.",
      "ISTP-ii sunt atât de realiști încât, de obicei, pot întrezări modalități de reducere a eforturilor în aproape toate proiectele. Datorită dorinței lor de a beneficia de timp liber, adesea nu se pregătesc decât atât cât este strict necesar, sau nu mai duc un proiect până la capăt. Aceasta îi poate determina să fie neglijenți. Construirea unui plan complet, cu toate etapele și detaliile, îi va ajuta să-și controleze potențiala lipsă de inițiativă, reducându-le totodată aparenta indiferență.",
      "Deoarece ISTP-ii sunt atenți în permanență la noile informații senzoriale și preferă să-și păstreze deschise toate opțiunile, ei pot fi nehotărâți. Nevoia lor de stimulare îi poate face imprudenți, dar, în același timp, îi poate conduce cu ușurință la plictiseală. Stabilirea de obiective și angajamentele serioase față de persoane și de lucruri îi vor ajuta să evite dezamăgirile și pericolele obișnuite ale unui asemenea mod de viață potențial riscant.",
    ],
  ),
};
