import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

/// Where the app's backend lives — kept in the EU. Must match
/// functions/platform.js: the Cloud Functions region and the Firestore
/// database the functions read and write.
///
/// The project's "(default)" Firestore database is in the US (nam5) and a
/// database cannot change location, so the app uses the separate
/// "futureme-eu" database (eur3) instead. Always go through [appFirestore] and
/// [appFunctions]; `FirebaseFirestore.instance` and
/// `FirebaseFunctions.instance` would reach the US ones.
const String firebaseFunctionsRegion = 'europe-west1';
const String firestoreDatabaseId = 'futureme-eu';

FirebaseFirestore get appFirestore => FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: firestoreDatabaseId);

FirebaseFunctions get appFunctions => FirebaseFunctions.instanceFor(region: firebaseFunctionsRegion);
