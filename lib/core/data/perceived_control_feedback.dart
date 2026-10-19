// The twelve fixed perceived-control feedback texts — three bands for each
// of the four dimensions.
//
// These are FutureMe's own texts, reproduced as written, including the
// lower-case start of the help line: in the document it follows its heading
// on the same line ("Ce te poate ajuta: uită-te la..."), and the screen
// renders it that way, so the wording is never altered to fit a layout.
// The score selects one entry per dimension and it is displayed in full:
// nothing here is generated, rewritten or summarised by a model.
//
// No profession or career recommendation appears here by design — those
// belong to the final report, after every instrument has been integrated.

import 'package:futureme/core/data/perceived_control.dart';

class PerceivedControlFeedback {
  const PerceivedControlFeedback({
    required this.levelLabel,
    required this.headline,
    required this.body,
    required this.helpHeading,
    required this.help,
  });

  /// The band as the text words it, gendered per dimension — "Scăzută" for
  /// Internalitate, "Scăzut" for Noroc.
  final String levelLabel;

  /// The one-line reading, e.g. "Simți că ai un cuvânt important de spus".
  final String headline;

  /// The explanation.
  final String body;

  /// The heading of the practical part, which varies between entries:
  /// "Ce te poate ajuta", "Ce merită să păstrezi", "De ținut minte",
  /// "Întrebarea importantă".
  final String helpHeading;

  /// The practical part, continuing the heading's sentence.
  final String help;
}

/// Shown once, after all four dimensions — never after each one.
const String perceivedControlClosingNote =
    "Viitorul tău nu depinde numai de tine, dar nici nu se construiește fără tine.\n\n"
    "Vor exista oameni, oportunități și situații pe care nu le poți controla. Important este să recunoști partea care îți aparține: alegerile tale, efortul tău și pașii pe care îi faci de aici înainte.\n\n"
    "Indiferent de scor, controlul este o abilitate care poate fi antrenată. Ai mai multă putere decât crezi.";

const Map<PerceivedControlDimension, Map<PerceivedControlLevel, PerceivedControlFeedback>>
    perceivedControlFeedback = {
  PerceivedControlDimension.internality: {
    PerceivedControlLevel.low: PerceivedControlFeedback(
      levelLabel: "Scăzută",
      headline: "Simți mai puțin că depinde de tine",
      body:
          "Nu simți întotdeauna că ceea ce faci acum poate influența semnificativ ceea ce vei ajunge să faci mai târziu. Asta poate face ca unele alegeri sau eforturi să pară mai puțin importante decât sunt în realitate.",
      helpHeading: "Ce te poate ajuta",
      help:
          "uită-te la partea pe care o poți controla acum: ce înveți, ce explorezi, ce abilități îți dezvolți, ce întrebi și ce alegi să încerci.\n\n"
          "Nu trebuie să controlezi tot viitorul. Trebuie doar să poți influența următorul pas.",
    ),
    PerceivedControlLevel.moderate: PerceivedControlFeedback(
      levelLabel: "Moderată",
      headline: "Simți că o parte importantă depinde de tine",
      body:
          "Vezi legătura dintre ceea ce faci și ceea ce poți obține, dar recunoști și faptul că nu toate lucrurile sunt sub controlul tău. Este o perspectivă realistă: propriile alegeri contează, chiar dacă rezultatul depinde uneori și de context sau de oportunitățile care apar.",
      helpHeading: "Ce te poate ajuta",
      help:
          "când ai de luat o decizie, separă lucrurile în două: Ce depinde de mine? Ce nu depinde de mine? Apoi investește-ți energia în prima categorie.",
    ),
    PerceivedControlLevel.high: PerceivedControlFeedback(
      levelLabel: "Ridicată",
      headline: "Simți că ai un cuvânt important de spus",
      body:
          "Tinzi să vezi o legătură puternică între ceea ce faci și ceea ce vei obține. Efortul, pregătirea, alegerile și perseverența ta contează în felul în care îți imaginezi viitorul profesional.",
      helpHeading: "Ce merită să păstrezi",
      help:
          "convingerea că acțiunile tale contează.\n\n"
          "În același timp, amintește-ți că nu orice rezultat depinde exclusiv de tine. A avea control nu înseamnă să poți controla totul.",
    ),
  },
  PerceivedControlDimension.luck: {
    PerceivedControlLevel.low: PerceivedControlFeedback(
      levelLabel: "Scăzut",
      headline: "Nu te bazezi prea mult pe noroc",
      body:
          "Nu pari să crezi că viitorul tău profesional va fi decis în principal de întâmplare. Pentru tine, ceea ce faci pare să conteze mai mult decât simplul fapt de a avea noroc.",
      helpHeading: "De ținut minte",
      help:
          "planificarea și pregătirea contează, dar nu toate oportunitățile pot fi anticipate. Uneori apare o ușă la care nu te-ai gândit. Merită să o observi.",
    ),
    PerceivedControlLevel.moderate: PerceivedControlFeedback(
      levelLabel: "Moderat",
      headline: "Recunoști rolul șansei",
      body:
          "Știi că norocul, momentul potrivit sau o oportunitate neașteptată pot influența un drum profesional, fără să consideri neapărat că ele decid totul.",
      helpHeading: "Ce te poate ajuta",
      help:
          "pregătirea și oportunitatea funcționează foarte bine împreună.\n\n"
          "Nu controlezi întotdeauna ce oportunitate apare. Poți controla cât de pregătit ești când apare.",
    ),
    PerceivedControlLevel.high: PerceivedControlFeedback(
      levelLabel: "Ridicat",
      headline: "Norocul pare să conteze mult",
      body:
          "Tinzi să atribui șansei, momentului potrivit sau întâmplării un rol important în ceea ce vei ajunge să faci profesional. Oportunitățile chiar contează, dar dacă le atribuim prea multă putere, riscăm să vedem mai puțin ceea ce putem influența noi.",
      helpHeading: "Ce te poate ajuta",
      help:
          "când te surprinzi gândind „trebuie să am noroc”, adaugă o întrebare: „Ce pot face eu ca să-mi cresc șansele?”",
    ),
  },
  PerceivedControlDimension.helplessness: {
    PerceivedControlLevel.low: PerceivedControlFeedback(
      levelLabel: "Scăzută",
      headline: "Simți că poți face ceva",
      body:
          "Nu pari să pornești de la ideea că efortul tău este inutil. Chiar dacă nu poți controla toate rezultatele, vezi că există lucruri pe care le poți face atunci când vrei să schimbi o situație.",
      helpHeading: "Ce merită să păstrezi",
      help:
          "disponibilitatea de a căuta următorul pas.\n\n"
          "Nu orice rezultat depinde de tine. Dar faptul că nu controlezi totul nu înseamnă că nu controlezi nimic.",
    ),
    PerceivedControlLevel.moderate: PerceivedControlFeedback(
      levelLabel: "Moderată",
      headline: "Uneori simți că ai mai puțin control",
      body:
          "Există situații în care simți că ceea ce faci contează, dar și momente în care poți avea impresia că lucrurile sunt prea mult în afara controlului tău.",
      helpHeading: "Ce te poate ajuta",
      help:
          "în astfel de momente, nu încerca să rezolvi întregul viitor. Întreabă-te simplu:\n\n"
          "„Care este cel mai mic lucru pe care îl pot face acum?”\n\n"
          "Un pas mic readuce controlul în zona în care îl poți folosi.",
    ),
    PerceivedControlLevel.high: PerceivedControlFeedback(
      levelLabel: "Ridicată",
      headline: "Poți simți că prea puține depind de tine",
      body:
          "Uneori poți avea impresia că, indiferent cât te-ai strădui, rezultatul va fi decis de lucruri pe care nu le poți controla. Când această convingere devine puternică, există riscul să renunți înainte să afli cât de mult ai fi putut influența situația.",
      helpHeading: "Ce te poate ajuta",
      help:
          "nu încerca să controlezi rezultatul final. Caută următoarea acțiune care depinde de tine.\n\n"
          "Controlul începe adesea cu un pas foarte mic.",
    ),
  },
  PerceivedControlDimension.othersInfluence: {
    PerceivedControlLevel.low: PerceivedControlFeedback(
      levelLabel: "Scăzută",
      headline: "Decizia rămâne în mare parte la tine",
      body:
          "Nu simți că ceilalți trebuie să decidă în locul tău direcția profesională pe care o vei urma. Asta îți poate oferi autonomie în alegeri.",
      helpHeading: "De ținut minte",
      help:
          "autonomia nu înseamnă să faci totul singur. Oamenii potriviți îți pot oferi informații, experiență și oportunități fără să decidă în locul tău.",
    ),
    PerceivedControlLevel.moderate: PerceivedControlFeedback(
      levelLabel: "Moderată",
      headline: "Contează ce spun ceilalți, dar contează și ce vrei tu",
      body:
          "Părerile părinților, profesorilor sau ale altor persoane importante au un rol în felul în care te gândești la viitor. Asta este firesc. Oamenii care te cunosc pot vedea uneori lucruri pe care tu încă nu le-ai observat.",
      helpHeading: "Întrebarea importantă",
      help:
          "după ce îi asculți pe ceilalți, rămâne loc și pentru propria ta voce?\n\n"
          "Sfaturile sunt informații. Decizia despre propriul drum are nevoie și de tine.",
    ),
    PerceivedControlLevel.high: PerceivedControlFeedback(
      levelLabel: "Ridicată",
      headline: "Ceilalți au multă influență",
      body:
          "Părerea, așteptările sau deciziile altor persoane par să cântărească foarte mult atunci când te gândești la viitorul tău profesional. Sprijinul celorlalți este valoros, dar există o diferență între a primi ajutor și a lăsa pe altcineva să aleagă în locul tău.",
      helpHeading: "Ce te poate ajuta",
      help:
          "după ce ai ascultat toate părerile, întreabă-te: „Dacă nimeni nu ar fi dezamăgit de alegerea mea, eu ce aș alege?”\n\n"
          "Răspunsul merită măcar ascultat.",
    ),
  },
};

/// The fixed text selected by a dimension's band.
PerceivedControlFeedback perceivedControlFeedbackFor(PerceivedControlDimensionResult result) =>
    perceivedControlFeedback[result.dimension]![result.level]!;
