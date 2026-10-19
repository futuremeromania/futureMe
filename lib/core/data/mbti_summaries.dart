/// Short in-app versions of the sixteen MBTI profiles.
///
/// The full profiles in `mbti_profiles.dart` run to several pages each —
/// right for the final PDF, too much for a phone screen the user is
/// halfway through a module on. These are two or three sentences per type,
/// condensed from those same texts, shown on the Stage 1 result screen.
/// The full text is reserved for the report.
library;

/// Keyed by the four-letter code produced by `scoreMbti`.
const Map<String, String> mbtiSummaries = {
  "ENFJ":
      "ENFJ-ii acordă cea mai mare importanță oamenilor și relațiilor și se simt conectați personal la ceea ce fac. Sunt idealiști care trăiesc conform propriilor valori, buni comunicatori și conducători înnăscuți, care promovează armonia în jur. Iau decizii mai degrabă pe baza a ceea ce simt despre o situație și preferă o lume organizată, în care lucrurile sunt stabilite clar.",
  "ENFP":
      "ENFP-ii sunt plini de entuziasm și de idei noi, cu un simț puternic al posibilului. Preferă să păstreze deschise cât mai multe opțiuni, remarcă orice lucru deosebit și caută mai degrabă să înțeleagă decât să judece. Își iau energia din prezența celorlalți și își combină ușor talentele cu punctele tari ale oamenilor din jur.",
  "ENTJ":
      "ENTJ-ii sunt conducători și factori de decizie, care văd cu ușurință posibilități în toate direcțiile. Logici și analitici, depistează repede ce nu funcționează într-o situație și cum poate fi îmbunătățit, fiind convinși doar de raționamente logice. Sunt planificatori pe termen lung, mai interesați de consecințele viitoare ale acțiunilor decât de starea prezentă a lucrurilor.",
  "ENTP":
      "ENTP-ii iubesc stimulii și provocările. Fascinați de ideile noi, sunt curioși, flexibili și plini de resurse în rezolvarea problemelor teoretice, iar capacitățile lor analitice îi fac buni gânditori strategici. Le place să testeze limitele din jur, preferă să înțeleagă oamenii decât să-i judece și abordează relațiile sociale cu multă imaginație.",
  "ESFJ":
      "ESFJ-ii sunt motivați să ajute alți oameni în mod real, practic, prin acțiune și cooperare directă. Au nevoie de relații armonioase și muncesc din greu pentru a le menține, fiind sensibili la indiferență sau la critici. Practici și organizați, sunt atenți la faptele și detaliile importante și își bazează planurile pe experiența personală.",
  "ESFP":
      "ESFP-ii iubesc oamenii și au un adevărat entuziasm față de viață. Sunt observatori realiști, care acceptă lucrurile așa cum sunt și învață cel mai bine din experiența directă, având încredere în ceea ce pot vedea și atinge. Toleranți, plini de tact și spontani, preferă să-i ajute pe alții în mod concret, tangibil.",
  "ESTJ":
      "ESTJ-ii sunt persoane practice, realiste și hotărâte, orientate spre acțiune și spre rezultate concrete. Se bazează în primul rând pe fapte, experiență și metode care și-au dovedit deja eficiența, iar deciziile le iau analizând consecințele practice. Le place ordinea: preferă obiective bine definite, reguli clare și activități organizate, iar în grup preiau firesc coordonarea.",
  "ESTP":
      "ESTP-ii sunt activi, veseli și spontani, preferând să se bucure de clipa prezentă decât să facă planuri de viitor. Extrem de realiști, se bizuie pe ceea ce le comunică simțurile și rezolvă problemele repede, cu soluții logice și firești. Prietenoși și relaxați, se pricep să destindă situațiile tensionate și să apropie părțile aflate în conflict.",
  "INFJ":
      "INFJ-ii trăiesc într-o lume a ideilor, ca gânditori independenți, cu principii ferme și integritate personală. Sunt motivați de o viziune interioară pe care o apreciază mai mult decât opiniile majoritare și disting adesea înțelesuri mai profunde. Afectivi și grijulii, au o dorință puternică de a contribui la bunăstarea altora și obișnuiesc să se concentreze asupra câte unui lucru pe rând.",
  "INFP":
      "INFP-ii apreciază armonia interioară mai mult decât orice altceva și au un puternic simț al onoarei în privința valorilor personale. Își focalizează majoritatea energiilor asupra viselor și viziunilor lor, cu o excelentă perspectivă pe termen lung și standarde foarte înalte. Deși în exterior par rezervați, sunt foarte sensibili și simțitori la sentimentele altora.",
  "INTJ":
      "INTJ-ii sunt gânditori independenți, analitici și orientați spre viitor, atrași de ideile complexe și de mecanismele din spatele lucrurilor. Identifică tipare și posibilități pe termen lung și nu se mulțumesc să observe cum funcționează un sistem, ci caută cum ar putea funcționa mai bine. Acordă o mare importanță logicii și competenței și le place să transforme conceptele în strategii și pași concreți.",
  "INTP":
      "INTP-ii soluționează probleme conceptuale, fiind intelectuali și logici, cu străfulgerări de creativitate excepțională. Tăcuți și rezervați în exterior, sunt absorbiți în plan lăuntric de analiza problemelor și convinși numai de raționamente logice. Le place să dezvolte modele pentru a îmbunătăți felul în care se prezintă lucrurile sau pentru a rezolva probleme dificile.",
  "ISFJ":
      "ISFJ-ii sunt loiali, devotați, plini de compasiune și receptivi față de sentimentele altora. Realiști și cu picioarele pe pământ, au o memorie deosebită în privința detaliilor și sunt meticuloși și sistematici în îndeplinirea sarcinilor. Le place să aibă grijă de alții și preferă să ajute în mod practic, tangibil.",
  "ISFP":
      "ISFP-ii sunt persoane blânde, sensibile și grijulii, care își exprimă adesea pasiunile profunde prin acțiuni, nu prin cuvinte. Răbdători și flexibili, nu emit judecăți și nu sunt interesați să-i domine pe alții, trăind pe deplin în clipa prezentă. Sunt adesea firi artistice, atente la ceea ce învață direct din experiență, și au nevoie de relații armonioase.",
  "ISTJ":
      "ISTJ-ii sunt serioși, responsabili și demni de încredere, întrucât își onorează angajamentele. Practici și meticuloși, au o bună judecată practică și o bună memorie a detaliilor, aplicând experiența trecută la deciziile prezente. Sunt organizați și sistematici, își termină lucrurile la timp și par calmi chiar și în momentele de criză.",
  "ISTP":
      "ISTP-ii sunt analitici și interesați de principiile impersonale, esențiale, cu o cunoaștere înnăscută a felului în care funcționează lucrurile. Se lasă convinși doar de faptele dovedite și iau decizii logice, afirmând lucrurile limpede și direct, exact așa cum le văd. Tăcuți și rezervați, sunt adaptabili și răspund bine la problemele și provocările imediate.",
};