/**
 * One-off copy of FutureMe's Firestore data from the US to the EU: every
 * document of the "(default)" database (nam5, US), subcollections included,
 * into the "futureme-eu" database (eur3). The Storage audio cache needs no
 * copy: the default bucket is already in europe-central2.
 *
 * Nothing is deleted: the US copies stay until they are removed by hand.
 * Documents are written with set(), so running it twice copies the same
 * data again — but run it before the app and the functions switch to the
 * EU, never after, or newer EU data would be overwritten by the old copy.
 *
 * Usage (from the functions folder, with a service-account key downloaded
 * from Firebase Console → Project settings → Service accounts):
 *   GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json node scripts/migrate-to-eu.js --dry-run
 *   GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json node scripts/migrate-to-eu.js
 */
const { initializeApp, getApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");

const PROJECT_ID = "futureme-a6ea7";
const DATABASE_ID = "futureme-eu"; // same as platform.js
const DRY_RUN = process.argv.includes("--dry-run");

initializeApp({ projectId: PROJECT_ID });
const source = getFirestore(getApp());
const target = getFirestore(getApp(), DATABASE_ID);

let documents = 0;

async function copyCollection(sourceCollection, targetCollection, writer) {
  const refs = await sourceCollection.listDocuments();
  for (const ref of refs) {
    const snapshot = await ref.get();
    if (snapshot.exists) {
      documents++;
      if (!DRY_RUN) writer.set(targetCollection.doc(ref.id), snapshot.data());
    }
    for (const sub of await ref.listCollections()) {
      await copyCollection(sub, targetCollection.doc(ref.id).collection(sub.id), writer);
    }
  }
}

async function copyFirestore() {
  const writer = target.bulkWriter();
  for (const collection of await source.listCollections()) {
    const before = documents;
    await copyCollection(collection, target.collection(collection.id), writer);
    console.log(`  ${collection.id}: ${documents - before} documents`);
  }
  await writer.close();
}

(async () => {
  console.log(`${DRY_RUN ? "[dry run] " : ""}Firestore (default) → ${DATABASE_ID}`);
  await copyFirestore();
  console.log(`  total: ${documents} documents`);
  console.log(DRY_RUN ? "Dry run: nothing was written." : "Done.");
})().catch((err) => {
  console.error(err);
  process.exit(1);
});
