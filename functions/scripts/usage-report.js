/**
 * Prints what the AI calls cost, per user and per function, from the
 * `users/{uid}/aiUsage` documents written by usage.js.
 *
 *   GOOGLE_APPLICATION_CREDENTIALS=~/Downloads/<key>.json node scripts/usage-report.js [uid]
 *
 * With a uid, only that user; without, every user who has usage. Optional
 * prices turn tokens into money (USD per million tokens / per 1000 chars):
 *
 *   INPUT_PRICE=5 OUTPUT_PRICE=25 CHAR_PRICE=0.3 node scripts/usage-report.js <uid>
 *
 * Read-only: it never writes anything.
 */
const { initializeApp, getApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");

initializeApp({ projectId: "futureme-a6ea7" });
const db = getFirestore(getApp(), "futureme-eu");

const INPUT_PRICE = Number(process.env.INPUT_PRICE || 0);
const OUTPUT_PRICE = Number(process.env.OUTPUT_PRICE || 0);
const CHAR_PRICE = Number(process.env.CHAR_PRICE || 0);

async function main() {
  const uid = process.argv[2];
  const snap = uid
    ? await db.collection("users").doc(uid).collection("aiUsage").get()
    : await db.collectionGroup("aiUsage").get();

  // user -> fn -> totals
  const users = new Map();
  for (const doc of snap.docs) {
    const owner = doc.ref.parent.parent ? doc.ref.parent.parent.id : "(fără utilizator)";
    const d = doc.data();
    const key = d.scope ? `${d.fn} · ${d.scope}` : d.fn;
    if (!users.has(owner)) users.set(owner, new Map());
    const fns = users.get(owner);
    const t = fns.get(key) || { calls: 0, input: 0, output: 0, cacheRead: 0, cacheWrite: 0, chars: 0 };
    t.calls += 1;
    t.input += d.inputTokens || 0;
    t.output += d.outputTokens || 0;
    t.cacheRead += d.cacheReadTokens || 0;
    t.cacheWrite += d.cacheCreationTokens || 0;
    t.chars += d.characters || 0;
    fns.set(key, t);
  }

  if (users.size === 0) {
    console.log("Nicio înregistrare de consum.");
    return;
  }

  for (const [owner, fns] of users) {
    console.log(`\nUtilizator ${owner}`);
    const total = { calls: 0, input: 0, output: 0, chars: 0 };
    const rows = [...fns.entries()].sort((a, b) => b[1].output - a[1].output);
    for (const [key, t] of rows) {
      const tokens = t.chars ? `${t.chars} caractere` : `${t.input} in / ${t.output} out`;
      console.log(`  ${key.padEnd(42)} ${String(t.calls).padStart(3)} apeluri   ${tokens}`);
      total.calls += t.calls;
      total.input += t.input + t.cacheWrite + t.cacheRead;
      total.output += t.output;
      total.chars += t.chars;
    }
    console.log(`  TOTAL: ${total.calls} apeluri, ${total.input} tokenuri intrare, ${total.output} tokenuri ieșire, ${total.chars} caractere voce`);
    if (INPUT_PRICE || OUTPUT_PRICE || CHAR_PRICE) {
      const cost = (total.input * INPUT_PRICE + total.output * OUTPUT_PRICE) / 1e6 + (total.chars * CHAR_PRICE) / 1000;
      console.log(`  COST ESTIMAT: $${cost.toFixed(4)}`);
    }
  }
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
