/**
 * FutureMe — where the backend runs.
 *
 * Everything that stores or processes user data on Google's side lives in
 * the EU:
 *   - Cloud Functions in europe-west1 (Belgium);
 *   - the Firestore database "futureme-eu", in the eur3 multi-region (Belgium and
 *     the Netherlands). The project's "(default)" database is in nam5 (US)
 *     and a Firestore database cannot change location, so the data was
 *     copied into this one (see scripts/migrate-to-eu.js);
 *   - the audio cache in the project's default Storage bucket, which was
 *     created in europe-central2 (Warsaw) and so is already in the EU.
 *
 * The app (lib/core/constants/backend.dart) points at the same region and
 * database; the two must be changed together.
 */
const functions = require("firebase-functions/v1");
const { initializeApp, getApps, getApp } = require("firebase-admin/app");
const { getAuth } = require("firebase-admin/auth");
const { getFirestore, FieldValue, Timestamp } = require("firebase-admin/firestore");
const { getStorage } = require("firebase-admin/storage");

// The modular Admin SDK (firebase-admin 13+); the namespaced `admin.*`
// API it replaced is gone from version 14.
if (!getApps().length) initializeApp();
const app = getApp();

const REGION = "europe-west1";
const DATABASE_ID = "futureme-eu";

const db = getFirestore(app, DATABASE_ID);
const region = functions.region(REGION);
const audioBucket = () => getStorage(app).bucket();
const auth = () => getAuth(app);

module.exports = { REGION, DATABASE_ID, db, region, audioBucket, auth, FieldValue, Timestamp };
