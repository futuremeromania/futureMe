/**
 * Read-only check that the "futureme-eu" database holds everything the
 * "(default)" database holds: every document of (default), subcollections
 * included, must exist in futureme-eu with the same data. Writes nothing.
 *
 * Usage (from the functions folder):
 *   GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json node scripts/verify-eu-copy.js
 */
const { initializeApp, getApp } = require("firebase-admin/app");
const { getFirestore, Timestamp, GeoPoint, DocumentReference } = require("firebase-admin/firestore");

initializeApp({ projectId: "futureme-a6ea7" });
const source = getFirestore(getApp());
const target = getFirestore(getApp(), "futureme-eu");

function canonical(value) {
  if (value instanceof Timestamp) return `ts:${value.seconds}.${value.nanoseconds}`;
  if (value instanceof GeoPoint) return `geo:${value.latitude},${value.longitude}`;
  if (value instanceof DocumentReference) return `ref:${value.path}`;
  if (Array.isArray(value)) return `[${value.map(canonical).join(",")}]`;
  if (value && typeof value === "object") {
    return `{${Object.keys(value).sort().map((k) => `${JSON.stringify(k)}:${canonical(value[k])}`).join(",")}}`;
  }
  return JSON.stringify(value);
}

let checked = 0;
const missing = [];
const different = [];

async function walk(collection) {
  for (const ref of await collection.listDocuments()) {
    const snapshot = await ref.get();
    if (snapshot.exists) {
      checked++;
      const copy = await target.doc(ref.path).get();
      if (!copy.exists) missing.push(ref.path);
      else if (canonical(snapshot.data()) !== canonical(copy.data())) different.push(ref.path);
    }
    for (const sub of await ref.listCollections()) await walk(sub);
  }
}

(async () => {
  for (const collection of await source.listCollections()) await walk(collection);
  console.log(`Checked ${checked} documents in (default).`);
  console.log(`Missing in futureme-eu: ${missing.length}`);
  missing.slice(0, 30).forEach((p) => console.log(`  - ${p}`));
  console.log(`Different in futureme-eu: ${different.length}`);
  different.slice(0, 30).forEach((p) => console.log(`  ~ ${p}`));
  console.log(missing.length === 0 ? "OK: every (default) document exists in futureme-eu." : "NOT OK: some documents exist only in (default).");
})().catch((err) => {
  console.error(err);
  process.exit(1);
});
