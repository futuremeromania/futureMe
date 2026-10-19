/**
 * FutureMe — server-trusted account mutations.
 *
 * `firestore.rules` denies client writes to the `subscription` and
 * `retakeUsage` fields on `users/{uid}` — a signed-in user can read their
 * own document but can no longer set "I'm subscribed" or reset their
 * retake quota by writing to it directly (e.g. via the Firestore console
 * or a raw SDK call). These callables are the only way those fields
 * change; Admin SDK writes from a Cloud Function bypass security rules
 * by design, which is the trust boundary this relies on.
 *
 * The Admin SDK is initialized once in platform.js before this
 * module is required.
 */

const functions = require("firebase-functions/v1");

const { db, region, auth, FieldValue } = require("./platform");

const MONTHLY_RETAKE_LIMIT = 3;

function currentMonthKey() {
  const now = new Date();
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, "0")}`;
}

/**
 * Callable. Body: { plan, verified }. Records the current user's
 * subscription selection. `verified` should be true once real purchases
 * are confirmed via RevenueCat; false for the pre-RevenueCat fallback
 * flow. The caller is always `context.auth.uid` — a user can only ever
 * confirm a subscription for themselves.
 */
exports.confirmSubscription = region.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Trebuie să fii autentificat.");
  }
  const plan = data && typeof data.plan === "string" ? data.plan : "monthly";
  const verified = !!(data && data.verified);
  const status = verified ? "active" : "active_unverified";

  await db.collection("users").doc(context.auth.uid).set(
    {
      subscription: {
        status,
        plan,
        [verified ? "purchasedAt" : "selectedAt"]: FieldValue.serverTimestamp(),
      },
    },
    { merge: true }
  );

  return { status };
});

/**
 * Callable. Increments the current user's retake usage for this month,
 * enforcing `MONTHLY_RETAKE_LIMIT` server-side (mirrors
 * `ModuleProgressRepository.monthlyRetakeLimit` on the client, which is
 * only a UI hint now). Throws `resource-exhausted` once the limit is hit.
 */
exports.useRetake = region.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Trebuie să fii autentificat.");
  }
  const docRef = db.collection("users").doc(context.auth.uid);

  return db.runTransaction(async (tx) => {
    const snap = await tx.get(docRef);
    const usage = snap.data() && snap.data().retakeUsage;
    const month = currentMonthKey();
    const used = usage && usage.month === month ? usage.count || 0 : 0;

    if (used >= MONTHLY_RETAKE_LIMIT) {
      throw new functions.https.HttpsError("resource-exhausted", "Ai folosit toate evaluările disponibile luna aceasta.");
    }

    const nextCount = used + 1;
    tx.set(docRef, { retakeUsage: { month, count: nextCount } }, { merge: true });
    return { retakesRemaining: MONTHLY_RETAKE_LIMIT - nextCount };
  });
});

/**
 * Callable. Permanently deletes the calling user's account and data:
 *   1. the parent-consent request and consent emails made for them;
 *   2. `users/{uid}` and everything under it — profile, module answers and
 *      results, final report, feedback;
 *   3. the Firebase Authentication user, last, so that a failure at any
 *      earlier step leaves the user signed in and able to simply retry.
 *
 * The chat server keeps its own copy of the conversation; the app asks it
 * to delete that before calling this (see account_deletion.dart).
 *
 * Records in `purchases` keep only the account id, platform and product,
 * and stay as the accounting record of the payment.
 *
 * Generated texts cached without a user id (`insightCache`,
 * `spokenSummaries`, the audio files) are shared by content, not owned by
 * a user, and are not touched.
 */
exports.deleteAccount = region
  .runWith({ timeoutSeconds: 120 })
  .https.onCall(async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError("unauthenticated", "Trebuie să fii autentificat.");
    }
    const uid = context.auth.uid;
    const userRef = db.collection("users").doc(uid);
    const profile = (await userRef.get()).data() || {};
    const consent = profile.consent || {};

    // 1. Consent request (by id when stored, otherwise by the parent's
    // address) and any consent email queued for that address.
    const refs = [];
    if (consent.requestId) {
      refs.push(db.collection("consentRequests").doc(String(consent.requestId)));
    } else if (consent.parentEmail) {
      const requests = await db.collection("consentRequests").where("parentEmail", "==", consent.parentEmail).get();
      requests.docs.forEach((doc) => refs.push(doc.ref));
    }
    if (consent.parentEmail) {
      const mails = await db.collection("mail").where("to", "==", consent.parentEmail).get();
      mails.docs.forEach((doc) => refs.push(doc.ref));
    }
    await Promise.all(refs.map((ref) => ref.delete()));

    // 2. The user's documents, subcollections included.
    await db.recursiveDelete(userRef);

    // 3. The account itself.
    try {
      await auth().deleteUser(uid);
    } catch (err) {
      if (!err || err.code !== "auth/user-not-found") throw err;
    }

    return { deleted: true };
  });
