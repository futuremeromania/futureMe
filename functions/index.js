/**
 * FutureMe — parent/guardian consent flow (age 14–15).
 *
 * Replaces the previously-simulated "EmailConsent -> SendEmailConsent ->
 * ConfirmConsent" client flow, where no email was ever sent and "Verifică
 * acordul" always succeeded. Real flow:
 *
 *   1. App calls `requestConsent({ parentEmail })` — creates a
 *      `consentRequests/{id}` doc (status: 'pending') and sends the email
 *      directly via Gmail SMTP (nodemailer), containing a link to
 *      `confirmConsent`. (Previously this went through the Firestore
 *      "Trigger Email" extension, but that extension's Cloud Function is
 *      Eventarc-triggered and Eventarc Firestore triggers do not support
 *      this project's `nam5` multi-region database — trigger creation/
 *      update fails with "Database does not exist in region us-central1".
 *      Sending directly from this plain callable sidesteps that platform
 *      limitation entirely.)
 *   2. The parent opens that link in a browser (no app/account needed) —
 *      `confirmConsent` verifies the token and flips the doc to 'confirmed'.
 *   3. The app polls `checkConsentStatus({ requestId })` from the
 *      "Verifică acordul" button and only proceeds once status is
 *      'confirmed'.
 *
 * The client never has permission to write `consentRequests` directly
 * (firestore.rules denies it by default) — only these Admin-SDK functions
 * can create/read/confirm a request, so a user cannot self-approve consent.
 */

const functions = require("firebase-functions/v1");
const crypto = require("crypto");

const { db, region, REGION, FieldValue, Timestamp } = require("./platform");

// Claude-backed dynamic module content (see ai.js).
const ai = require("./ai");
exports.generateModule1Questions = ai.generateModule1Questions;
exports.generateInsight = ai.generateInsight;
exports.generateCareerPlan = ai.generateCareerPlan;
exports.generateDirectionPlan = ai.generateDirectionPlan;
exports.generateFinalReport = ai.generateFinalReport;
exports.generateSpokenSummary = ai.generateSpokenSummary;

// Server-trusted account mutations (see account.js) — subscription status
// and retake quota, which firestore.rules denies the client writing directly.
const account = require("./account");
exports.confirmSubscription = account.confirmSubscription;
exports.useRetake = account.useRetake;
exports.deleteAccount = account.deleteAccount;

// ElevenLabs speech synthesis with Storage caching (see tts.js) — the app's
// feedback cards play this instead of the device's robotic on-device voice.
const tts = require("./tts");
exports.synthesizeSpeech = tts.synthesizeSpeech;
// Cloud Functions v1 (used here) gets a predictable URL of the form
// https://<region>-<projectId>.cloudfunctions.net/<name>, so the confirm
// link can be built without waiting for a post-deploy URL. REGION comes
// from platform.js, the one place the functions' region is set.
const PROJECT_ID = "futureme-a6ea7";
const CONFIRM_URL = `https://${REGION}-${PROJECT_ID}.cloudfunctions.net/confirmConsent`;


// Consent emails go out through Resend rather than Gmail SMTP: a verified
// sending domain keeps them out of parents' spam folders, which a personal
// Gmail account could not reliably do. Set the key once with:
//   firebase functions:secrets:set RESEND_API_KEY
const FROM_ADDRESS = "Echipa FutureMe <no-reply@futuremeromania.ro>";

async function sendMail({ to, subject, html }) {
  const response = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${process.env.RESEND_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ from: FROM_ADDRESS, to, subject, html }),
  });

  if (!response.ok) {
    throw new Error(`Resend returned ${response.status}: ${await response.text()}`);
  }
}

const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

// Public pages the parent's confirmation page links to. Fill in before
// deploying; while one is empty its checkbox is shown without a link.
const TERMS_URL = "";
const PRIVACY_URL = "";

/**
 * What the parent or guardian is asked to confirm, by the minor's age.
 *
 * 14-15: the parent consents to the processing of the minor's data (art. 8
 * GDPR: under 16), accepts the Terms and approves the purchase.
 * 16-17: the teen has already consented to the data processing in the app,
 * which art. 8 allows from 16; as a minor with restricted legal capacity
 * (art. 41 Civil Code) the Terms and the purchase still need the parent's
 * approval. The minor makes the purchase in the app, with that approval.
 */
const CONSENT_ITEMS = {
  data: "Îmi dau acordul pentru prelucrarea datelor minorului aflat în responsabilitatea mea (răspunsurile din aplicație și rezultatele evaluării), în scopul experienței de autocunoaștere și al raportului FutureMe.",
  terms: "Am citit și accept Termenii și condițiile de utilizare FutureMe.",
  purchase: "Sunt de acord ca minorul aflat în responsabilitatea mea să achiziționeze accesul FutureMe.",
};
const SCOPE_BY_BRACKET = {
  "14_15": ["data", "terms", "purchase"],
  "16_17": ["terms", "purchase"],
};
const TOKEN_TTL_MS = 7 * 24 * 60 * 60 * 1000; // 7 days

function renderHtmlPage(title, body) {
  return `<!doctype html>
<html lang="ro">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${title}</title>
<style>
  body { font-family: -apple-system, Roboto, Helvetica, Arial, sans-serif; max-width: 480px;
         margin: 72px auto; padding: 0 24px; color: #2B0B78; text-align: center; }
  h1 { font-size: 22px; }
  p { font-size: 16px; line-height: 1.5; color: #333; }
</style>
</head>
<body>
  <h1>${title}</h1>
  <p>${body}</p>
</body>
</html>`;
}

/**
 * Callable. Body: { parentEmail }. Creates the consent request and sends
 * the real email. Returns { requestId }.
 */
exports.requestConsent = region.runWith({ secrets: ["RESEND_API_KEY"] }).https.onCall(async (data) => {
  const parentEmail = String((data && data.parentEmail) || "").trim();
  if (!EMAIL_RE.test(parentEmail)) {
    throw new functions.https.HttpsError("invalid-argument", "Adresa de email a părintelui nu este validă.");
  }
  // Older app versions don't send the bracket; they only asked for consent
  // at 14-15, so that is what a missing value means.
  const ageBracket = SCOPE_BY_BRACKET[data && data.ageBracket] ? data.ageBracket : "14_15";
  const scope = SCOPE_BY_BRACKET[ageBracket];

  const token = crypto.randomBytes(32).toString("hex");
  const tokenHash = crypto.createHash("sha256").update(token).digest("hex");
  const docRef = db.collection("consentRequests").doc();
  const now = Timestamp.now();

  await docRef.set({
    parentEmail,
    ageBracket,
    scope,
    status: "pending",
    tokenHash,
    createdAt: FieldValue.serverTimestamp(),
    confirmedAt: null,
    expiresAt: Timestamp.fromMillis(now.toMillis() + TOKEN_TTL_MS),
  });

  const confirmUrl = `${CONFIRM_URL}?id=${docRef.id}&token=${token}`;

  try {
        await sendMail({
      to: parentEmail,
      subject: "FutureMe – cerere de acord părinte/tutore",
      html: `
        <p>Bună,</p>
        <p>Copilul dumneavoastră dorește să folosească aplicația FutureMe, un ghid pas cu pas de autocunoaștere,
           și are nevoie de acordul unui părinte sau tutore legal pentru a continua.</p>
        <p><a href="${confirmUrl}">Deschide pagina de acord</a></p>
        <p>Pe pagină veți vedea exact la ce vă dați acordul și veți confirma printr-un buton; deschiderea linkului nu confirmă nimic.</p>
        <p>Dacă nu recunoști această cerere, poți ignora acest email — nu se va întâmpla nimic fără confirmarea ta.</p>
      `,
    });
  } catch (err) {
    console.error("Failed to send consent email", err);
    throw new functions.https.HttpsError("internal", "Nu am putut trimite emailul de confirmare. Încearcă din nou.");
  }

  return { requestId: docRef.id };
});

/**
 * Callable. Body: { requestId }. Returns { status, confirmedAt } where
 * status is 'pending' | 'confirmed' | 'not_found'.
 */
exports.checkConsentStatus = region.https.onCall(async (data) => {
  const requestId = String((data && data.requestId) || "");
  if (!requestId) {
    throw new functions.https.HttpsError("invalid-argument", "Lipsește requestId.");
  }

  const snap = await db.collection("consentRequests").doc(requestId).get();
  if (!snap.exists) {
    return { status: "not_found", confirmedAt: null };
  }

  const requestData = snap.data();
  return {
    status: requestData.status,
    confirmedAt: requestData.confirmedAt ? requestData.confirmedAt.toDate().toISOString() : null,
  };
});

/**
 * Public HTTP endpoint — opened directly in the parent's browser from the
 * email link. Not callable from the app; no auth, no Firebase SDK involved.
 */
exports.confirmConsent = region.https.onRequest(async (req, res) => {
  const source = req.method === "POST" ? req.body || {} : req.query;
  const { id, token } = source;

  if (!id || !token) {
    res.status(400).send(renderHtmlPage("Link invalid", "Acest link de confirmare nu este valid."));
    return;
  }

  const docRef = db.collection("consentRequests").doc(String(id));
  const snap = await docRef.get();

  if (!snap.exists) {
    res.status(404).send(renderHtmlPage("Link invalid", "Nu am găsit această cerere de acord."));
    return;
  }

  const requestData = snap.data();

  if (requestData.status === "confirmed") {
    res.status(200).send(
      renderHtmlPage("Acord deja confirmat", "Acordul a fost deja confirmat. Poți închide această pagină.")
    );
    return;
  }

  if (requestData.expiresAt && requestData.expiresAt.toMillis() < Date.now()) {
    res.status(410).send(
      renderHtmlPage("Link expirat", "Acest link a expirat. Cere copilului tău să trimită din nou cererea din aplicație.")
    );
    return;
  }

  const providedHash = crypto.createHash("sha256").update(String(token)).digest("hex");
  const expected = Buffer.from(requestData.tokenHash, "hex");
  const provided = Buffer.from(providedHash, "hex");
  const valid = expected.length === provided.length && crypto.timingSafeEqual(expected, provided);

  if (!valid) {
    res.status(403).send(renderHtmlPage("Link invalid", "Acest link de confirmare nu este valid."));
    return;
  }

  const scope = Array.isArray(requestData.scope) && requestData.scope.length ? requestData.scope : SCOPE_BY_BRACKET["14_15"];

  // Opening the link only shows the page: mail scanners and link previews
  // open links on their own, so only the parent's submitted form confirms.
  if (req.method !== "POST") {
    res.status(200).send(renderConsentForm(String(id), String(token), scope, requestData.ageBracket));
    return;
  }

  const body = req.body || {};
  const missing = scope.filter((item) => body[item] !== "on");
  if (missing.length) {
    res.status(400).send(renderConsentForm(String(id), String(token), scope, requestData.ageBracket, true));
    return;
  }

  await docRef.update({
    status: "confirmed",
    confirmedAt: FieldValue.serverTimestamp(),
    accepted: Object.fromEntries(scope.map((item) => [item, { text: CONSENT_ITEMS[item], at: Timestamp.now() }])),
  });

  res.status(200).send(
    renderHtmlPage("Acord confirmat", "Mulțumim! Acordul a fost confirmat cu succes. Poți închide această pagină.")
  );
});

function escapeHtml(value) {
  return String(value).replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[c]);
}

/** The parent's page: what FutureMe is, one checkbox per item in [scope], and the confirm button. */
function renderConsentForm(id, token, scope, ageBracket, showError = false) {
  const link = (text, url) => (url ? `<a href="${escapeHtml(url)}" target="_blank" rel="noopener">${text}</a>` : text);
  const labels = {
    data: CONSENT_ITEMS.data.replace("prelucrarea datelor", link("prelucrarea datelor", PRIVACY_URL)),
    terms: CONSENT_ITEMS.terms.replace("Termenii și condițiile", link("Termenii și condițiile", TERMS_URL)),
    purchase: CONSENT_ITEMS.purchase,
  };
  const intro =
    ageBracket === "16_17"
      ? "Adolescentul și-a dat singur acordul pentru prelucrarea datelor sale în aplicație, așa cum permite legea de la 16 ani. Fiind minor, are nevoie de încuviințarea dumneavoastră pentru Termenii de utilizare și pentru achiziționarea accesului."
      : "Pentru vârsta lui, adolescentul are nevoie de acordul dumneavoastră pentru prelucrarea datelor, pentru Termenii de utilizare și pentru achiziționarea accesului.";
  const boxes = scope
    .map(
      (item) => `
    <label class="item"><input type="checkbox" name="${item}" required><span>${labels[item]}</span></label>`
    )
    .join("");

  return `<!doctype html>
<html lang="ro">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Acord părinte/tutore – FutureMe</title>
<style>
  body { font-family: -apple-system, Roboto, Helvetica, Arial, sans-serif; max-width: 520px;
         margin: 48px auto; padding: 0 24px; color: #2A0E5D; }
  h1 { font-size: 22px; text-align: center; }
  p { font-size: 15px; line-height: 1.55; color: #333; }
  .item { display: flex; gap: 12px; align-items: flex-start; margin: 16px 0; font-size: 15px; line-height: 1.5; color: #211431; }
  .item input { width: 20px; height: 20px; margin-top: 2px; flex-shrink: 0; accent-color: #2B0B78; }
  a { color: #2B0B78; }
  .error { color: #9F3F63; font-size: 14px; }
  button { width: 100%; margin-top: 16px; padding: 14px; border: 0; border-radius: 100px;
           background: #2B0B78; color: #fff; font-size: 16px; font-weight: 600; }
</style>
</head>
<body>
  <h1>Acordul părintelui sau tutorelui</h1>
  <p>FutureMe este un ghid de autocunoaștere și orientare profesională pentru tineri. Nu este un diagnostic psihologic și nu înlocuiește consilierea.</p>
  <p>${intro}</p>
  ${showError ? '<p class="error">Pentru a confirma, bifați toate căsuțele de mai jos.</p>' : ""}
  <form method="POST" action="${CONFIRM_URL}">
    <input type="hidden" name="id" value="${escapeHtml(id)}">
    <input type="hidden" name="token" value="${escapeHtml(token)}">${boxes}
    <button type="submit">Confirmă</button>
  </form>
</body>
</html>`;
}
